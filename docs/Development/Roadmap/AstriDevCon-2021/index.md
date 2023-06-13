---
title: Overview
pageid: 44797356
---

AstriDevCon 2021
----------------

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon. The AstriDevCon event will occur virtually on November 2nd. Details for participation will be sent by email to registered participants. [Meeting Minutes](https://wiki.asterisk.org/wiki/display/AST/Astricon+2021+Minutes).

### Event day schedule

  
AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future.

**Starting at [10AM EDT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=AstriDevCon+2021&iso=20211102T10&p1=179&ah=6).**

Lunch 12:30 EDT

**Event ends at 4PM EDT or until completion.**

We'll build a rough agenda together in the morning.

### Agenda

* Talks:
	+ Project Policy Update - Josh Colp
* Other Discussion:
	+ Talk about releases and number in flight - George Joseph
		- Should we skip Asterisk 20/21 and go directly to Asterisk 22 (to match the year it's released in)?
		- Should we continue to have LTS 4/1 and Standard 1/1 releases?
	+ codec handling - and where things landed. - Joran
	+ Photo
	+ Challenges with audio quality with confbridge - Pascal
	+ Talk about moving away from Atlassian for Asterisk's community infrastructure and bug tracker - Josh Colp
	
	
		- Anybody have feelings about github as a potential alternative?
		- wiki transition is something that we may need to do some research on.
		- CLAs - making sure that we can handle them properly.
		- Do we port tickets over? Can we create a static-ish website that allows legacy ticket lookup?
		- Should we port over open tickets or leave them as is?
		- Is this just JIRA or is it also community, gerrit, crowd, etc?
	+ Being a better participant in a cloud environment - Josh
		- Provisioning?
		- Monitoring?  
		
			* Maybe adding additional metrics to prometheus
				+ Good questions to ask for monitoring (asterisk specific):
					- How many channels are active?
					- How many ARI bridges are up?
					- sip peers online
					- taskprocessor queue levels
					- Open files used by Asterisk
					- Open ports used by Asterisk
					- Number of error messages in the error log over time.
		- Storage of stateful data? (voicemails, recordings...)?  
		
			* S3 backending of stateful data
			* Can Playback from URL
			* Can't Record to a URL
			* Maybe add hooks when a voicemail storage completes (externnotify)
		- IP address configuration/management?
		- Aggregated threat handling:
			* How do providers handle this?
			* How do individual instances of Asterisk handle it (can potentially be different)
				+ fail2ban is one way that people handle it.
					- Need way to limit access to a single SIP account versus an entire IP address (can be a problem for accidentally blocking lots of devices behind an IP address, like a call center).
				+ Is there additional integration we could do on the Asterisk side with API ban or a similar technical approach
	+ New E911 requirements and impacts to Asterisk - Mike Bradeen
		- Nice to have dialplan function that can display the source IP of a SIP message
	+ Potentially making inbound/outbound channels match media direction - Florian
	+ Discussion around multiple entities subscribing to an ARI application - Joran
	+ Dynamic features in parked calls. - Yitzchak
	+ Controlling another channel's MOH from the dialplan or AMI - Yitzchak
	+ Timeouts on a stasis application - Joran
		- If ARI application does not perform an action on the channel (or ping, or something) within timeout then it automatically hangs the channel up (in the case that the ARI application itself might be stuck).
	+ DDOS - let's talk about the problem and potential improvements that may impact Asterisk - Josh
	+ Asterisk 20: What could it look like? - Sylvain
	+ Pre-join warning to conference participants prior to adding a new channel (confbridge) - Michael Cargile
	+ Adding a custom MIME body to PJSIP separate from SDP - Torrey

 

 

### Location

AstriDevCon will be held virtually with participation details to be sent by email to registered participants.

Registering for AstriDevCon
---------------------------

**[Fill out the registration form!](https://forms.gle/jeYBFt7Q76AgCUaM7)**

Registration will be required for participation. If you don't register you will not be able to receive the participation details.

Additional Information
----------------------

### IRC Channel

We'll be using IRC during the AstriDevCon for out of band discussion.

irc.libera.chat, #asterisk-dev (Unlike previous years where #astridevcon was used instead)

### Attendees

Ben Ford

BJ Weschke

Daniel Collins

Franck Danard

Florian Floimair

George Joseph

Igor Goncharovsky

James Finstrom

Jared Smith

Jöran Vinzens

Joshua Colp

JP Loh

Kevin Harwell

Lorenzo Emilitri

Lorne Gaetz

Malcolm Davenport

Mark Petersen

Matt Brooks

Matthew Fredrickson

Michael Bradeen

Michael Cargile

Michael Young

Pascal Cadotte

Sylvain Boily

Torrey Searle

Walter Moon

Yitzchak Pachtman

 

### Recording

Separate recordings of the morning and afternoon are available [here](https://downloads.asterisk.org/astridevcon/2021/).

### Previous AstriDevCon events

See the below sections for notes and content from previous AstriDevCon events.

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
* AstriDevCon 2010
