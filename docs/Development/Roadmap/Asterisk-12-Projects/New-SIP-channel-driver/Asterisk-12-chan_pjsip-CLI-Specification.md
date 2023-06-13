---
title: Asterisk 12 chan_pjsip CLI Specification
pageid: 26478200
---

This is a draft under construction.

Asterisk 12 chan\_pjsip CLI Specification
=========================================

Here we are specifying what the use and output of each command should look like.

### General formatting guidelines:

These are guidelines meant to help readability of the output.

* 1 blank line before output and after output to separate the output from the prompt (output must begin and end with newlines)
* 2 spaces before each line of output to separate the output from the left side of terminal
* For tabulated content there should be 2 spaces between the longest lines in each column.
* For <option> = <value> , vertically oriented lists of two column tables, the right-hand column containing values should be at least 2 spaces out from the longest option name.
* When listing <option>'s we should use the actual option name when possible, rather than an expanded English version. As when you expand it, you'll run into situations where it is not clear to a user which configuration option that listing relates to.
* For listings with more than one column, column names using more than a single word should have no whitespace and use camel case, (e.g. "LastRegTime") for reading clarity.
	+ An exception may be made where additional information needs to be expressed. As in "AORs/Contacts" or "Expiry(sec)". We should avoid this where possible.

The general formatting guidelines should override any discrepancies with the mock up output examples.

CLI Command Specifications
==========================

pjsip show endpoints
--------------------



---

#### DESCRIPTION:

Shows a tabulated list of all endpoints, with each row displaying attributes related to an endpoint that may be commonly referenced or helpful when administering a system.The output should be displayed as a tabulated listing of columns and rows, with each row holding information about an individual endpoint, or else additional information about the last endpoint listed.In the mock up below, we see:* content relative to endpoint 6001 listed in a single line.
* content relative to endpoint 6002 listed in multiple lines, where the two additional lines contain two contact listings in the 7999 AOR which is associated with endpoint 6002.
* The list ends with a summary of how many Endpoints exist, and then how many are considered online or offline via Qualify responses

 

#### Mock Up Output

Name AuthUsername DevState HintExt AORs/Contacts Qualify ActiveChannels
6001 6001 NOT\_INUSE 6001 6001/sip:6001@192.0.2.1:5060 35ms 
6002 6002 RINGING 6002 6002/sip:6002@192.0.2.2:5060 32ms <channel name>
 7999/sip:7999@192.0.2.3:5060 34ms
 7999/sip:7999@192.0.2.4:5060 35ms
2 Endpoints [Monitored: 2 online, 0 offline Unmonitored: 0 online, 0 offline] 

#### COLUMNS:

We can only fit so much information here, and there is lots to choose from. This information was selected while thinking about items that you might check while troubleshooting and want to see all in one place.* Name - Endpoint section name
* AuthUsername - username from associated auth  (how should we differ outbound vs inbound?)
* DevState - Device state of Endpoint
* HintExt - List of hint extensions that this Endpoint is mapped to
* AORs/Contacts - List of contacts for each AOR associated with the Endpoint   (how to indicate static vs dynamic/registered?)
* Qualify - Response time for each contact, or N/A
* ActiveChannels - List of active channels associated to this endpoint

 

**Ideas for future commands:**"pjsip show endpoints <comma-delimited list of endpoint names>"  (show specified endpoints only, rather than all endpoints, useful for systems with 100's of endpoints)pjsip show endpoint
-------------------



---

#### DESCRIPTION:

In the mock up below, you'll see:* Alphabetically sorted list of miscellaneous options and their current values
* Separate sections below the misc option list for showing info related to other objects associated to the Endpoint. Such as:  

	+ transport
	+ auth
	+ aor
	+ identify
* Each separate section should contain a list of options and their related values.
* Some sections should contain additional information, not represented as "<option> = <value>". This would primarily information that changes during run-time.   

	+ Examples would be:
	+ Static and Registered Contacts for the associated AOR objects (static contacts shouldn't be changing, but it makes sense to display them consistently with a list of registered contacts)
	+ The representation of this kind of information would really have to be determined on a case by case basis.
* "<option> = <value>"  Is used to demonstrate where additional options and values relevant to that section would go.
#### Mock Up Output

Endpoint Settings
----------------
Name Value
------ -------
allowsubscribe = yes 
allowtransfer = yes
aors = 6002,7999
auth = auth1
callerid = Rusty Newtron <123-456-7890>
callerid\_privacy = allowed
<option> = <value>


Associated auth Settings
--------------
AUTH: 6002

auth\_type = userpass
username = somename
password = 123456789
<option> = <value>

Associated aor Settings
--------------
AOR: 6002

<option> = <value>
Static Contacts:
 N/A
Registered Contacts:
 sip:6002:@1.2.3.4.com:5060

AOR: 7999

qualify\_frequency = 60
<option> = <value>
Static Contacts:
 sip:7999@1.2.3.4.com:5060
Registered Contacts:
 N/A 

 

### pjsip show registrations



---

#### DESCRIPTION:

A tabulated listing of all registrations configured in pjsip, where each row shows a single registration and various attributes about that registration.

* Note that the list ends with a summary of how many total registrations exist, and how many are registered vs not registered.

#### Mock Up Output

Name AuthUsername Host Expiry(sec) State LastRegTime InOut
mytrunk1 123456789 gw1.example.us:5060 3600 Registered Wed, 18 Sep 2013 21:59:17 Outbound
mytrunk2 123456789 gw2.example.us:5060 3600 Registered Wed, 18 Sep 2013 21:59:16 Outbound
6001 6001 192.168.0.5 3600 Not Registered Inbound

3 SIP registrations [2 Registered, 1 Not Registered]#### COLUMNS:

* Name - Name of the registration section
* AuthUsername - Username from associated auth configuration
* Host -  Host address, IP or Domain of the system we are registering to
* Expiry(sec) -  Seconds configured for registration expiry
* State - Registered, Registering, Not Registered
* LastRegTime - When the last registration happened for this registration
* InOut -  Inbound (registrations to aor objects) or Outbound (registration objects)

 

### pjsip show subscriptions



---

#### DESCRIPTION:

Tabulated list showing all subscriptions, with columns displaying attributes of each subscription.

* Note that the list ends with a summary of how many total subscriptions exist, and a distribution of types.

#### Mock Up Output:

Endpoint AOR Contact CallID Extension LastState Type Mailbox Expiry(sec) InOut
6001 6001 6001@192.168.0.5 <Call ID goes here> 6001@internal Idle pidf+xml <none> 600 Inbound
6001 6001 6001@192.168.0.5 <Call ID goes here> <none> <none> mwi 6001 3600 Inbound

2 active SIP subscriptions[ 1 of type "pidf+xml", 1 of type "mwi"]#### COLUMNS:

* Endpoint - What endpoint is subscribing
* AOR - What AOR the contact is associated with
* Contact - What contact is specifically responsible for the subscription
* Call ID - The SIP Call ID
* Extension - For subscription types, such as presence, this shows the associated dialplan extension.
* LastState - For subscription types with a state, show the last state.
* Type - The type of subscription
* Mailbox - For MWI subscription type, the associated mailbox
* Expiry(sec) - Subscription expiration time in seconds
* InOut -  Inbound or Outbound

### pjsip show settings



---

#### DESCRIPTION:

 List of all pjsip global and system wide settings configured. Includes ACLs since they apply to all PJSIP traffic.

 

In the mock up below, you'll see:* Separate sections showing settings from objects that have a "global" effect in terms of PJSIP.  

	+ global
	+ system
	+ acl
* Each section should contain a list of options and their related values.
* "<option> = <value>"  Is used to demonstrate where additional options and values relevant to that section would go.
* ACL settings are displayed since they affect all PJSIP traffic.

#### Mock Up Ouput:

Global Settings
-----------------
maxforwards = 70
useragent = Asterisk SVN-branch-12-r399268
<option> = <value>

System Settings
-----------------
timert1 = 500
timerb = 3200 
compactheaders = no 
threadpool\_initial\_size = 0
threadpool\_auto\_increment = 5
threadpool\_idle\_timeout = 60
threadpool\_max\_size = 0
<option> = <value>

Access Control List Settings
----------------------------
ACL: example\_named\_acl1

 0: deny - 0.0.0.0/0.0.0.0
 1: allow - 209.16.236.0/255.255.255.255
 2: allow - 209.16.236.1/255.255.255.255

ACL: example\_named\_acl2

 0: allow - 0.0.0.0/0.0.0.0
 1: deny - 10.24.20.171/255.255.255.255
 2: deny - 10.24.20.103/255.255.255.255
 3: deny - 209.16.236.1/255.255.255.255

