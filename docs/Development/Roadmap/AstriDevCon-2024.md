# AstriDevCon 2024

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon.

## Event day schedule

AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future. You can also attend remotely via Sangoma Meet.

State of the Project presentation by Josh

Should We Switch / Expand to a New Language by George

Break 11:30 EDT

Lunch 12:10 EDT

Break 1:50 EDT

Notes

* Josh's State of the Project presentation
	+ Moved to GitHub in 2023
	+ Issue archive: https://issues-archive.asterisk.org
	+ Contributer License Agreement (CLA) is now instant
	+ Documentation moved and was updated: https://docs.asterisk.org
	+ New mailing list: groups.io/g/asterisk-dev
	+ CommUnity integration
		- AMI and CLI actions / commands to manipulate voicemail mailboxes
	+ Media Experience Score (MES) now fully integrated
	+ STIR/SHAKEN rewrite
		- Uses libjwt
		- Refactored tons of code for optimization
		- Large amount of new code to account for new and updated specs
	+ Lots of miscellaneous fixes and additions - the usual
	+ Not on presentation - PJSIP hangup with specific response codes
		- Went out in last release, and there's an AMI action for it
		- Separate from the normal Hangup application
		- changes.md file should have notes on this
	+ Asterisk 16 and 19 are end of life
	+ chan_sip officially gone in Asterisk 21
* George's Switching from C talk
	+ C++ has some nice things like built-in data structures
	+ Linux / posix support is a key factor - some languages might not be that great for it
	+ Investigate doing new module in C++ (possibly PJSIP?)
	+ extern c wrap header files since several don't have this
		- Make it happen Josh :)
	+ See if there's already a build dependency for C++
* ARI, outgoing connections, https requests over websocket, media over websocket
	+ Remote transfer, refers, and NOTIFYs
	+ Mailing list to propose an idea for how to handle this and put up a pull request
* Advanced Codec Negotation
	+ It would be beneficial to have other people test this
	+ https://github.com/asterisk/asterisk/pull/285
* Multi-tenant, subscribing to BLF with a custom context messes up after a couple days on latest 18
	+ Like a custom device state
	+ After a couple days, the state doesn't change anymore
	+ pjsip show inbound subscriptions shows that there is an active subscription, but NOTIFY does not get sent to endpoint
	+ Any non-default context
	+ core show hints shows correct values
	+ Get a debug log!
	+ Handlers in PJSIP that deal with NOTIFYs is a good place to look
* Multi-Asterisk queueing
	+ CommUnity is experimenting with this, but is not currently used
	+ It's easier to do this in ARI
	+ Switchvox uses ARI (node.js)
* Blind transfer CDR
	+ Consult CDR spec on docs site
	+ If the behavior is not matching the spec, file an issue so we can fix it
	+ Recommended to use CELs to derive your own CDRs
* ARI SDP channel driver for things like WebRTC applications
	+ whip specification
	+ Light SDP exchange protocol
* Conference rooms across multiple boxes
	+ Having different conference rooms linked together
	+ Boxes can talk to each other without double audio and without dropping audio
	+ If host goes down or problems occur, how do we handle this?
	+ Surprise - ARI is the answer!
	+ Have calls between everything with it muted
	+ If instance goes down, you can unmute another route
	+ Putting the logic in Asterisk itself is difficult, but using outside libraries via ARI simplifies this
* Speech AI engine improvements
	+ Locked to one engine at a time
	+ If that engine is down or returning erroneous results, you can't really do anything about it easily
	+ Loop through engines and feed frames to the engines needs improvement
	+ This is in reference to the dialplan function that allows you to specify an engine, so you would be able to pass multiple engines to it and do detection on them simultaneously
	+ With the partial option, you can get the result from whichever is fastest
	+ This is aimed at doing it purely through dialplan, as opposed to writing an external application to handle it
	+ Could this functionality itself be a speech engine? Could it be configured to behave in different ways? Have it do everything behind the scenes and return the unified result
* Separators for things in dialplan (pipes, carrots, etc.)
	+ Pipes? Used to separate arguments in dialplan until later changed to commas
	+ There are situations where arguments are mixed and use another kind of separator to denote that
	+ For example, a pull request for app_dial that uses pipes as a separator, possibly due to age of the application itself and trying to follow how it already handles that situation
* Pause music on hold (MOH) and play announcement (queue callbacks)
	+ Having a caller in queue and then attempting to pause the mnusic on hold and play an announcement
	+ Originated as a FreePBX issue
	+ Manipulate gives you access to the entire frame that's going through
	+ Would probably want a separate dialplan application to do this
	+ This does not currently exist today
	+ Periodic announce is similar to this
	+ Depending on where the channel audio is muted, it MIGHT be possible to mute it and whisper in, but this is just speculation
* System metrics for load and things like RTCP, average frame latency
	+ Time for a frame to be read and for a frame to be routed back
	+ A measure of delay, potential to find problems locally
	+ Frame transit probably most optimized, but there could be scheduler backup causing latency issues
	+ Things like DNS query times could be good
	+ MES has osme of this already
* say.conf for sounds and different languages
	+ Digits, numbers, and possibly dates

## Photos

![](AstriDevCon-2024-1.jpg)
![](AstriDevCon-2024-2.jpg)
![](AstriDevCon-2024-3.jpg)

## Recording

There is no recording available this year. We've made it a priority to provide this for future events and to improve quality as much as possible.

## Previous AstriDevCon events

See the below sections for notes and content from previous AstriDevCon events.

* [AstriDevCon 2022](/Development/Roadmap/AstriDevCon-2022)
* [AstriDevCon 2021](/Development/Roadmap/AstriDevCon-2021)
* [AstriDevCon 2020](/Development/Roadmap/AstriDevCon-2020)
* [AstriDevCon 2019](/Development/Roadmap/AstriDevCon-2019)
* [AstriDevCon 2018](/Development/Roadmap/AstriDevCon-2018)
* [AstriDevCon 2017](/Development/Roadmap/AstriDevCon-2017)
* [AstriDevCon 2016](/Development/Roadmap/AstriDevCon-2016)
* [AstriDevCon 2015](/Development/Roadmap/AstriDevCon-2015)
* [AstriDevCon 2014](/Development/Roadmap/AstriDevCon-2014)
* [AstriDevCon 2013](/Development/Roadmap/AstriDevCon-2013)
* [AstriDevCon 2012](/Development/Roadmap/AstriDevCon-2012)
* [AstriDevCon 2011](/Development/Roadmap/AstriDevCon-2011)
* [AstriDevCon 2010](/Development/Roadmap/AstriDevCon-2010)
