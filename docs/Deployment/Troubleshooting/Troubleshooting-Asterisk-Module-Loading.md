---
title: Troubleshooting Asterisk Module Loading
pageid: 30278184
---

Symptoms
========

* Specific Asterisk functionality is no longer available or completely non-functioning, but other Asterisk features and modules continue to function.
* Specific Asterisk CLI commands are no longer available.

Example`:`

No such command 'sip show peers'We can presume that something is wrong with **chan\_sip** module since we know it provides the 'sip' commands and sub-commands.

Problem
=======

Asterisk has started successfully and the module providing the missing functionality either didn't load at all, or it loaded but isn't running.

The reason for the failure to load or run is typically invalid configuration or a failure to parse the configuration for the module.

On this Page2

Solution
========

Identify the state of the module. If the module is loaded but not running, or not loaded at all, then resolve file format, configuration syntax issues or unwanted modules.conf configuration  for the specific module. Restart Asterisk.

Troubleshooting
===============

Check Module Loaded and Running States
--------------------------------------

From the Asterisk CLI you can use the 'module show' commands to identify the state of a module.

Previous to Asterisk 12, you could only see if the module is loaded. However it may not actually be running (usable).

\*CLI> module show like chan\_sip.so 
Module Description Use Count 
chan\_sip.so Session Initiation Protocol (SIP) 0 
1 modules loadedIn Asterisk 12 and beyond you can quickly see if a module is loaded and whether it is running or not.

\*CLI> module show like chan\_sip.so 
Module Description Use Count Status
chan\_sip.so Session Initiation Protocol (SIP) 0 Not Running
1 modules loadedMake sure Asterisk is configured to load the module
---------------------------------------------------

Modules.conf is a core configuration file that includes parameters affecting module loading and loading order. There are a few items to check.

Verify that **autoload=yes** is enabled if you are intending to load modules from the Asterisk modules directory automatically.

Verify that there is **not** a '**noload'** line for the module that is failing to load. That is, if we had a line as follows:

noload => chan\_sip.soThat would tell Asterisk to not load chan\_sip.so.

If you are not using **autoload**, then be sure you have a **load** line for the module you desire to load.

load => chan\_sip.soCheck For Module Loading Issues on Asterisk Startup
---------------------------------------------------

Now that we know the suspect module should be loading, we can look at some logs that may tell us what is happening.

### Stop Asterisk

Be sure Asterisk is stopped to avoid issues with making the logs confusing.

asterisk -rx "core stop now"or

service asterisk stop### Enable logging channels

You can read in detail about Logging facilities on the wiki. In short, for this example, make sure you have the following lines uncommented in your logger.conf file.

[logfiles]
full => notice,warning,error,debug,verbose### Clear out old logs

You don't want to mistakenly look at an older log where Asterisk was loading appropriately.

Remove the most recent log file, or else move it somewhere you want to keep it.

# rm /var/log/asterisk/full### Start Asterisk with appropriate log levels

It is important to start Asterisk with log levels that will provide us enough information.

# asterisk -cvvvvvdddYou'll see a lot of information output in the terminal as Asterisk loads.

### Stop Asterisk after it has finished loading

After the output calms down and Asterisk has finished loading, go ahead and stop Asterisk. The logs should have already been recorded.

\*CLI> core stop now### Search logs for lines related to suspect module

Search the log file using keywords based on the specific module that appeared to be failing to load or run.

/var/log/asterisk# grep -i chan\_sip full
[Oct 9 14:54:43] VERBOSE[21809] chan\_sip.c: SIP channel loading...
[Oct 9 14:54:43] ERROR[21809] chan\_sip.c: Contents of sip.conf are invalid and cannot be parsed

/var/log/asterisk# grep -i sip.conf full
[Oct 9 14:54:43] DEBUG[21809] config.c: Parsing /etc/asterisk/sip.conf
[Oct 9 14:54:43] VERBOSE[21809] config.c: == Parsing '/etc/asterisk/sip.conf': Found
[Oct 9 14:54:43] WARNING[21809] config.c: parse error: No category context for line 1 of /etc/asterisk/sip.conf
[Oct 9 14:54:43] ERROR[21809] chan\_sip.c: Contents of sip.conf are invalid and cannot be parsed
[Oct 9 14:54:55] DEBUG[21809] config.c: Parsing /etc/asterisk/sip.conf
[Oct 9 14:54:55] VERBOSE[21809] config.c: == Parsing '/etc/asterisk/sip.conf': Found
[Oct 9 14:54:55] WARNING[21809] config.c: parse error: No category context for line 1 of /etc/asterisk/sip.confBased on the lines found, you can then use an editor like VIM to view the full log and jump to where the relevant messages are.

[Oct 9 14:54:43] VERBOSE[21809] chan\_sip.c: SIP channel loading...
[Oct 9 14:54:43] DEBUG[21809] config.c: Parsing /etc/asterisk/sip.conf
[Oct 9 14:54:43] VERBOSE[21809] config.c: == Parsing '/etc/asterisk/sip.conf': Found
[Oct 9 14:54:43] WARNING[21809] config.c: parse error: No category context for line 1 of /etc/asterisk/sip.conf
[Oct 9 14:54:43] ERROR[21809] chan\_sip.c: Contents of sip.conf are invalid and cannot be parsedIn this case, not much more is revealed past what we saw with grep. You can see that Asterisk tries to load and run chan\_sip, it fails because the contents of sip.conf are invalid and cannot be parsed. The most specific clue is the WARNING:

WARNING[21809] config.c: parse error: No category context for line 1 of /etc/asterisk/sip.conf### Edit the related config file to resolve the issue

If we look at line 1 of sip.conf we'll spot the root problem.

general]
context=public
allowoverlap=noFor our example, a square bracket is missing from the context definition! Fix this issue, restart Asterisk and things should work assuming I don't have any other syntax errors.

