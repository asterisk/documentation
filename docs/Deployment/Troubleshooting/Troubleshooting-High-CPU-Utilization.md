# Troubleshooting High CPU Utilization

/// note
We'll cover high memory utilization in a separate document.
///

## What's "High"???

It sounds silly but if you can't define what "high" means to you then
how will you know when you've "fixed" it?

High CPU utilization isn't usually an issue by itself.  The real issue would be
the side effects like poor call quality or long call setup times, etc.
Understanding the issue you're tring to solve and what your goals are should
be the first step in any investigation.

## Understand the environment

The next step in the investigation should be understanding your environment thoroughly.
These are just a few things to keep in your mind: 

* Is Asterisk running in a virtual machine or a container?
    * What else is competing for resources?
    * Is the filesystem directly attached or remote via a SAN, etc.?
* What else is sharing the same CPU?
    * Databases
    * ARI/AMI/AGI applications
    * Unrelated applications or servers
* Are you using a realtime database?
    * Where is it hosted?
    * What else is using the same database instance?
* What's the network configuration?
    * Network interfaces.
    * Firewalls.
    * DNS infrastructure.
    * Proxies and session border controllers.

There's more but you get the idea.

## Identify the actors

Identifying _why_ you're seeing high CPU utilization can be complicated but let's start
with the _what_ first because it might not even be Asterisk itself.  The tool of choice
here is the venerable `top` or it's relatives `htop` and `btop`.

### Database

If the database has nothing to do with Asterisk itself then it probably shouln't be running
in the same OS instance.  If the database _is_ hosting your Asterisk configuration check where
you're storing your incoming PJSIP registrations (non permanent contacts).  The default is to
store them in the "astdb" (Sqlite3 database at `/var/lib/asterisk/astdb.sqlite3`) but some people
use sorcery.conf and extconfig.conf to move them to an external database believing it's "better".
Unless you need to expose the active registrations to another entity like Kamailio, leaving them
in the astdb is better for performance because the database is all in-memory.  

Another thing to investigate is
[Sorcery Caching](/Fundamentals/Asterisk-Configuration/Sorcery/Sorcery-Caching/).
If your expiration times are too low, you may be running more transactions to the database
than necessary.

Finally, consider moving the database to another OS instance, even if that other instance is
another container or virtual machine on the same physical host. Remember, database access is
usually limited to call setup but if Asterisk is processing the call media (which it usually is)
it's more important for it to have a higher CPU resource allocation priority.  Moving the database
someplace else gives you an opportunity to control that allocation.  Keep it local however and ideally
use a dedicated LAN segment with a 10G or greater rate.

### ARI/AMI/AGI Applications

Take a close look at what the applications are doing and try to streamline.  If you're using "classic"
AGI (`AGI(/path/to/script)`) switch to using [FastAGI](/Latest_API/API_Documentation/Dialplan_Applications/AGI/)
to avoid the overhead of spawning a new process for every call. As with a database, moving the applications to another OS instance can give you more control over resource allocation.

### Asterisk

#### Transcoding

The number one use of CPU resources by Asterisk is usually handling media.
Actually, simply forwarding media between two channels that use the same codec is pretty cheap.
Once you start transcoding however, the number of CPU cycles needed can increase drastically.

```
*CLI> core show translation
         Translation times between formats (in microseconds) for one second of data
          Source Format (Rows) Destination Format (Columns)

           ulaw  alaw   gsm slin8 slin16 slin32 slin48  g729  g722  opus
     ulaw     -  9150 15000  9000  17000  17000  17000 15000 17250 23000
     alaw  9150     - 15000  9000  17000  17000  17000 15000 17250 23000
      gsm 15000 15000     -  9000  17000  17000  17000 15000 17250 23000
    slin8  6000  6000  6000     -   8000   8000   8000  6000  8250 14000
   slin16 14500 14500 14500  8500      -   8000   8000 14500  6000 14000
   slin32 14500 14500 14500  8500   8500      -   8000 14500 14500 14000
   slin48 14500 14500 14500  8500   8500   8500      - 14500 14500  6000
     g729 15000 15000 15000  9000  17000  17000  17000     - 17250 23000
     g722 15600 15600 15600  9600   9000  17000  17000 15600     - 23000
     opus 23500 23500 23500 17500  17500  17500   9000 23500 23500     -
```

The absolute numbers are specific to the machine I ran the command on but look at the relative
differences, especially when opus is used on one channel and the other uses something
else.

Here's a different look at opus and what the path is between it and other codecs:

```
*CLI> core show translation paths opus
--- Translation paths SRC Codec "opus" sample rate 48000 ---
	opus:48000       To ulaw:8000       : (opus@48000)->(slin@48000)->(slin@8000)->(ulaw@8000)
	opus:48000       To alaw:8000       : (opus@48000)->(slin@48000)->(slin@8000)->(alaw@8000)
	opus:48000       To gsm:8000        : (opus@48000)->(slin@48000)->(slin@8000)->(gsm@8000)
	opus:48000       To slin:8000       : (opus@48000)->(slin@48000)->(slin@8000)
	opus:48000       To slin:16000      : (opus@48000)->(slin@48000)->(slin@16000)
	opus:48000       To slin:32000      : (opus@48000)->(slin@48000)->(slin@32000)
	opus:48000       To slin:48000      : (opus@48000)->(slin@48000)
	opus:48000       To g729:8000       : (opus@48000)->(slin@48000)->(slin@8000)->(g729@8000)
	opus:48000       To g722:16000      : (opus@48000)->(slin@48000)->(slin@16000)->(g722@16000)
*CLI>
```

The simple answer is "don't use opus" but of course that's not realistic especially
if you have WebRTC endpoints.  The more general answer is "don't use expensive codecs
if you don't need to".  A good example of this is when using chan_websocket on one leg
of a call to interact with an AI agent.  We've seen some folks using opus on the websocket
leg to the agent even when the incoming callers are all using ulaw or alaw and the agent
platform will happily accept 8K signed-linear.

#### Sounds, Music on Hold, Recording, Voicemail

The term "Transcoding" (and all that it implies) applies whenever you have to
convert between two codecs and that includes playing sounds, playing music-on-hold,
recording calls, saving and playing voicemails, etc.

For sounds and MOH, ensure you have files in the formats you most expect your caller
channels to be using.  When you have lots of different codecs in use and you're short
on disk space, having at least slin8 and slin16 versions of the files gives you the
least transcoding cost for everything except for opus.

For recording and voicemail, use the translation cost matrix to determine the most
efficient formats to save files in.

#### Logging

Logging is especially costly because it takes CPU cycles to create and manage the
messages plus I/O operations to write them out.

A performance analysis of Asterisk versions prior to 23.3.0, 22.9.0 and 20.19.0, showed
that almost 40% of the CPU instructions executed by the Asterisk process were attributed
to Channel Event Logging.  That was more than the instructions used to actually process
calls. We made significant CEL performance improvements in versions 23.3.0, 22.9.0 and 20.19.0
which brought that percentage to below 10% but if you don't need Channel Event logging
_turn it off_!.

Another culprit to watch out for is VERBOSE logging.  When VERBOSE logging is enabled,
a log message is generated for every line traversed in the dialplan.  On a busy system
this can result in hundreds of messages per second. Unless you have a good reason for
seeing all those messages, you should limit both console and file logging to NOTICE,
WARNING and ERROR.  As for DEBUG logging, well enabling debug messages on production
system is just silly unless you're actively trying to diagnose a specific issue.

## Still can't figure it out?

If you're still using more CPU than you think is necessary, you're going to have to
spend time doing some serious quantitative investigation.

* Create a test environment that mirrors your production environment.
* Use tools like [sipp](https://github.com/sipp/sipp) to simulate load.
* Get a baseline by starting with basic two-party calls (no recording, transcoding,
conferences, etc) and increasing volume until you get to a reasonable maximum
acceptable utilization.
* Now start over with a more "stressfull" of your typical call scenarios and
note the difference.
* Look for ways to simplify those call flows and/or the environment.

You can also ask for help on the [Asterisk Community Forums](https://community.asterisk.org)
but be prepared to provide as much detail as you can about your symptoms,
environment and expectations.

If you want to dive deeper into the internals of Asterisk, take a look at the
[Function Tracing](/Development/Debugging/Function-Tracing) 
page in the [Development/Debugging](/Development/Debugging) section.
