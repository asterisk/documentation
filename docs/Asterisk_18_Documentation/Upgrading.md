---
title: Upgrading to Asterisk 18
---

### The following lists the breaking change to be aware of when upgrading from Asterisk 17 to Asterisk 18:

* Applications:
	+ app\_mixmonitor  
	------------------  
	 \* In Asterisk 13.29, a new option flag was added to MixMonitor (the 'S'  
	 option) that when combined with the r() or t() options would inject  
	 silence into these files if audio was going to be written to one and  
	 not that other. This allowed the files specified by r() and t() to  
	 subsequently be mixed outside of Asterisk and be appropriately  
	 synchronized. This behavior is now the default, and a new option has  
	 been added to disable this behavior if desired (the 'n' option).
	+ app\_queue  
	------------------  
	 \* The 'Reason' header in the QueueMemberPause AMI Event has been  
	 removed. The 'PausedReason' header should be used instead.

	\* If they are not specified in [general], "shared\_lastcall" and "autofill"  
	 now always default to OFF. Before this version, they would be off ('no') if  
	 queues.conf did not have a [general] section, but on ('yes') if it did.
	+ app\_voicemail  
	------------------  
	 \* The MessageExists dialplan application and the MESSAGE\_EXISTS dialplan  
	 function were removed. The were deprecated in Asterisk 1.6.0 and  
	 Asterisk 11.0.0 respectively. The VM\_INFO() dialplan function is the  
	 supported mechanism to query the status of a given mailbox.
* AMI
	+ \* The AMI Originate action, which optionally takes a dialplan application as  
	 an argument, no longer accepts "Originate" as the application due to  
	 security concerns.
* ARI
	+ \* The "TextMessageReceived" event used to include a list of "TextMessageVariable"  
	 objects as part of its output. Due to a couple of bugs in Asterisk a list of  
	 received variables was never included even if ones were available. However,  
	 variables set to send would be (which they should have not been), but would  
	 fail validation due to the bad formatting.

	So basically there was no way to get a "TextMessageReceived" event with  
	 variables. Due to this the API has changed. The "TextMessageVariable" object  
	 no longer exists. "TextMessageReceived" now returns a JSON object of key/value  
	 pairs. So for instance instead of a list of "TextMessageVariable" objects:

	[ TextMessageVariable, TextMessageVariable, TextMessageVariable]

	where a TextMessageVariable was supposed to be:

	{ "key": "<var name>", "value":, "<var value>" }

	The output is now just:

	{ "<var name>": "<var value>" }

	This aligns more with how variables are specified when sending a message, as  
	 well as other variable lists in ARI.

For a complete list of upgrade notes please see the included [UPGRADE.txt document](https://raw.githubusercontent.com/asterisk/asterisk/18/UPGRADE.txt).
