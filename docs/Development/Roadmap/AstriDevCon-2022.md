---
title: AstriDevCon 2022
pageid: 50924837
---

AstriDevCon
-----------

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon. The AstriDevCon event will occur virtually on October 24th. Details for participation will be sent by email to registered participants.

### Event day schedule

  
AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future.

**Starting at [10AM EDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=AstriDevCon+2021&iso=20211102T10&p1=179&ah=6).**

Break 11:30 EDT

Lunch 12:10 EDT

Break 2:30 EDT

**Event ends at 4PM EDT or until completion.**

Agenda

* Talks
	+ Yearly Update - Joshua Colp
	+ Video Handling - Florian/Maximilian
		- Developing cloud voice/video solution, not typical telephony aspect, use Asterisk as media engine
		- Intercom company
		- Using Kamailio + Asterisk in the cloud, Kamailio as registrar/SBC/LB, Asterisk as media/call engine, using chan\_pjsip
		- Using early video
		- Dialplan + func\_curl currently
		- ARI based implementation in early dev
		- Physical, mobile, web client
		- Moh\_passthrough enabled, SDP offers get confused/incorrect
		- Have patch to do early media video
* Other Discussion
	+ Mailing Lists - Joshua Colp  
	
		- Some people still using mailing lists
		- Fine with moving to alternate solution
	+ ARI Usage - Joshua Colp
		- Joran struggling with missing small things, needs better documentation in some areas
		- Joran uncertain regarding transfers in ARI
		- Joran not all creation of objects accepts application, resulting in subscription not occurring so events can be missed
		- Ron issues with push configuration, identify with hostname resolving to multiple, match is reserved name in newer MySQL
		- Pascal set variable and get variable documentation may not mention dialplan functions (yay documentation is actually correct)
		- Yitzchak Pachtman would like to see a SIP NOTIFY mechanism in ARI
		- Mark Petersen AMI SIP NOTIFY issues with PJSIP, specifically custom text
		- Tone functionality not a huge item currently
	+ Confbridge Audio Quality Issues - Michael Cargile / Sylvain Boily
		- Only a few clients tested ConfBridge with Vicidial, not fully vetted, few clients that have tested, recordings/client fine, to carrier only every third word, may be load related, packet capture shows certain RTP packets aren't being sent
		- Experienced with Echo dialplan application
		- Local channels are involved
		- Some are virtualized, some physical
		- No packet loss concealment in bridges - Sylvain / Pascal, tried opus (multiple codec implementations) and no luck, packet loss results in large quality degradation, blocked on this issue
		- Sample configuration files value are good to test
		- AGI launching can take time, cause timing issues - Josh
		- Mixing bridge does not allow much configurability in ARI when creating bridge - Johan
		- Freeswitch with bridge + PLC handles packet loss best - Sylvain
	+ Codec Translation (from 18) - Mark Petersen
		- I hope to slot in more media stuff here
		- G729 as open source
		- It would be nice to have generic configuration to allow passthrough codecs to be easily added
		- codec\_opus and FEC? no change currently
		- Alternate g729 codec modules exist
	+ Meetme vs ConfBridge - Michael Cargile
		- Does mixing happen in the dahdi driver? Yes
		- Is it possible to do this same thing in ConfBridge? Yes, but no module written for it
	+ MS Teams/AMR - Alexandro Picolini
		- Some people using MS Teams, but outside of Asterisk - Johan
	+ WebRTC Better Logging - Yitzchak Pachtman
		- Logging hard to understand, could be better, HTTPS / Websockets
		- fail2ban in FreePBX not triggering on WebRTC, lack of X-Forwarded-For / X-Real-IP
	+ Logging for taskprocessors when an overload or issue occurs is insufficient and can be confusing out of the box
	+ More prometheus logging and support in general - Mark Petersen
		- Counter for how many error / warning log notices have occurred, can provide insight when things happen
		- Joran using another tool (<https://vector.dev>) that looks at logs and pushes counters via prometheus for this, uses it for log aggregation to central server
	+ PJSIP Path - Sylvain Boily
		- Issues present on issue tracker from other reporters
		- Using Kamailio workaround of encoding in Contact the required information
		- Using Kamailio for Websocket SIP socket, using rtpengine for media, easier to scale
	+ Geoloc - Sylvain
		- Working very well
		- Encountered crash, double free, will put fix up, will be creating issue
		- Proof of concept to evaluate, not in production as of yet
	+ Usage of Debian with Asterisk has been fine - Sylvain, Joran, and Florian
	+ Queues - Pitzkey
	
		- Periodic announcements don't trigger on initial, FreePBX using chanspy which can go over MOH, would be better if it could be done initially
		- ARI makes it considerably easier+ Joran has higher level interface, users don't worry about scaling/SIP/Asterisk/etc
	+ Testsuite
		- Mark Petersen runs entire testsuite when doing changes, using Docker
		- Wazo not using Asterisk testsuite, have their own
	+ The Future - Joshua Colp
		- No concerns re: Github
		- STIR/SHAKEN
		- Media Experience Score
			* Accessibility via ARI would be nice
		- Media negotiation answer forwarding
	+ What would be nice
		- PLC for bridges, audio quality improvements, 1 to 1 is fine - Sylvain
		- Bridge module for mixing using DAHDI - Michael Cargile
		- Crash recovery - Pitzkey
		- Jitterbuffer settings in PJSIP configuration file (possible using dialplan functions and
### Attendees

Joshua Colp

Ben Ford

George Joseph

Mike White

Mike Bradeen

Lorenzo Emilitri

Michael Cargile

Lorne Gaetz

Elvita Crespo

Maximilian Fridrich

Pascal Cadotte Michaud

Joran Vinzens

Ron Lockard

Yitzchak Pachtman

Florian Floimair

Sylvain Boily

Mark Petersen

Alexandro Picolino

David Lee

Shloime Rosenblum

### Group Photo

### Recording

Recordings are available [here](https://downloads.asterisk.org/astridevcon/2022/).

### Previous AstriDevCon events

See the below sections for notes and content from previous AstriDevCon events.

* [AstriDevCon 2021](https://wiki.asterisk.org/wiki/display/AST/AstriDevCon+2021)
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
