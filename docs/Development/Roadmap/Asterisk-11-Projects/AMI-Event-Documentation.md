---
title: AMI Event Documentation
pageid: 20185227
---


Overview
========


Asterisk 11 now supports the display of AMI event documentation. The documentation is handled in the same fashion as other portions of Asterisk, and is accessible via CLI commands.


Not all AMI events are documented in Asterisk 11, and the list of events available in Asterisk should not be considered a comprehensive list of all events. However, for any event that is listed in Asterisk, the documentation should be accurate and complete. This includes:


* When and why the event is raised
* Fields that are available in the event, both those that are always present as well as those that may be present
* Related information to that event


Building AMI Event Documentation
================================




!!! note 
    Building AMI Event documentation for Asterisk requires both libxml and python.

      
[//]: # (end-note)



Because AMI event documentation is handled in a slightly different fashion, a new build option 'make full' is required to generate the documentation from the Asterisk source.

```bash title=" " linenums="1"
# ./configure
# make full
# make install

```



!!! note 
    Because AMI event documentation must be pulled from a variety of locations in the Asterisk source, the time to generate AMI event documentation is noticeably longer then the time to generate other Asterisk documentation.

      
[//]: # (end-note)



CLI Commands
============


Two new CLI commands have been added:


* manager show events - list all documented AMI events
* manager show event [event name](/event-name) - provide detailed documentation on a single AMI event


Example output of both commands is shown below.

```

\*CLI> manager show events
Events:
 -------------------- -------------------- -------------------- 
 AgentCalled AgentComplete AgentConnect 
 AgentDump AgentRingNoAnswer ChanSpyStart 
 ChanSpyStop ConfbridgeEnd ConfbridgeJoin 
 ConfbridgeLeave ConfbridgeStart ConfbridgeTalking 
 Dial Join Leave 
 MeetmeEnd MeetmeJoin MeetmeLeave 
 MeetmeMute MeetmeTalkRequest MeetmeTalking 
 MessageWaiting QueueCallerAbandon QueueMemberAdded 
 QueueMemberPaused QueueMemberPenalty QueueMemberRemoved 
 QueueMemberRinginuse QueueMemberStatus UserEvent 

```
```

\*CLI> manager show event Dial
Event: Dial
[Synopsis]
Raised when a dial action has started.

[Syntax]
Event: Dial
SubEvent: <value>
Channel: <value>
Destination: <value>
CallerIDNum: <value>
CallerIDName: <value>
ConnectedLineNum: <value>
ConnectedLineName: <value>
UniqueID: <value>
DestUniqueID: <value>
Dialstring: <value>

[Arguments]
SubEvent
 Begin
 End
 A sub event type, specifying whether or not the dial action has begun
 or ended.

[Synopsis]
Raised when a dial action has ended.

[Syntax]
Event: Dial
DialStatus: <value>
SubEvent: <value>
Channel: <value>
UniqueID: <value>

[Arguments]
DialStatus
 The value of the ${DIALSTATUS} channel variable.
SubEvent
 Begin
 End
 A sub event type, specifying whether or not the dial action has begun
 or ended.

\*CLI> 

```



!!! note 
    The output shown above is subject to change

      
[//]: # (end-note)



Writing AMI Event Documentation
===============================


AMI Event documentation behaves a bit differently then other Asterisk documentation. A driving factor in the approach taken was to make documenting AMI events as simple and painless as possible, and leave the intricacies of tying instances of AMI events together to pre- and post-processing scripts. The following describes some of the differences between documenting AMI events and the normal approach for documenting items in Asterisk.


1. Event documentation can be built directly from the macros that raise the AMI events. This includes manager_event, ast_manager_event, and ast_manager_event_multichan. Because of this, AMI event documentation is typically co-located with the macro call that raises the event. Note that in the example below, only the DialStatus field is explicitly defined; however, the generated AMI event documentation will include all fields found in the ast_manager_event call.

```

 /*\*\* DOCUMENTATION
 <managerEventInstance>
 <synopsis>Raised when a dial action has ended.</synopsis>
 <syntax>
 <parameter name="DialStatus">
 <para>The value of the <variable>DIALSTATUS</variable> channel variable.</para>
 </parameter>
 </syntax>
 </managerEventInstance>
    * */
 ast_manager_event(src, EVENT_FLAG_CALL, "Dial",
 "SubEvent: End\r\n"
 "Channel: %s\r\n"
 "UniqueID: %s\r\n"
 "DialStatus: %s\r\n",
 ast_channel_name(src), ast_channel_uniqueid(src), dialstatus);

```
2. Each instance of an AMI event can be documented. This is particularly useful when the same event can have different fields, e.g., Dial, PeerStatus, etc. Even if the event has the same fields across all instances, it is also useful to document why the event is raised in the <synopsis/> tag. Because each instance of an AMI event should be documented, a post-processing script aggregates the various <managerEventInstance/> XML fragments that match the same event name under a single <managerEvent/> tag. Fields that are shared across instances of the same event are combined and only need to be documented a single time. In the example below, the SubEvent field is only documented once, but the full documentation for the field will be displayed for both instances of the Dial event, as both instances of the event contain that field. In contrast to that, only the second instance of the event contains the DialStatus field; hence, only that instance will contain that field.

```

 /*\*\* DOCUMENTATION
 <managerEventInstance>
 <synopsis>Raised when a dial action has started.</synopsis>
 <syntax>
 <parameter name="SubEvent">
 <enumlist>
 <enum name="Begin"/>
 <enum name="End"/>
 </enumlist>
 <para>A sub event type, specifying whether or not the dial action has begun or ended.</para>
 </parameter>
 </syntax>
 </managerEventInstance>
    * */
...
 /*\*\* DOCUMENTATION
 <managerEventInstance>
 <synopsis>Raised when a dial action has ended.</synopsis>
 <syntax>
 <parameter name="DialStatus">
 <para>The value of the <variable>DIALSTATUS</variable> channel variable.</para>
 </parameter>
 </syntax>
 </managerEventInstance>
    * */

```
3. In the same fashion as multiple instances of an AMI event in a single file, multiple instances of AMI events across implementation files are also combined.
4. Because pre- and post-processing scripts are involved, some burden on having a well-formed XML fragment is lifted from the documenter. Often, the fields in an event are self-explanatory, or are documented significantly in other AMI events. When that is the case, documentation for the event may only consist of a <synopsis/> field and one or two parameters - in which case, the <syntax/> element is inferred for the parameters.

```

 /*\*\* DOCUMENTATION
 <managerEventInstance>
 <synopsis>Raised when a dial action has ended.</synopsis>
 <syntax>
 <parameter name="DialStatus">
 <para>The value of the <variable>DIALSTATUS</variable> channel variable.</para>
 </parameter>
 </syntax>
 </managerEventInstance>
    * */

Is equivalent to:

 /*\*\* DOCUMENTATION
 <managerEventInstance>
 <synopsis>Raised when a dial action has ended.</synopsis>
 <parameter name="DialStatus">
 <para>The value of the <variable>DIALSTATUS</variable> channel variable.</para>
 </parameter>
 </managerEventInstance>
    * */

```

XML Schema
----------


The following are the changes to the XML DTD schema used to validate the generated XML documentation. An example of a generated XML fragment for the Dial event is also shown below.

```

 <!ELEMENT managerEvent (managerEventInstance+)>
 <!ATTLIST managerEvent name CDATA #REQUIRED>
 <!ATTLIST managerEvent language CDATA #REQUIRED>

 <!ELEMENT managerEventInstance (synopsis?,syntax?,description?,see-also?)\*>
 <!ATTLIST managerEventInstance class CDATA #REQUIRED>

```
```

<managerEvent language="en_US" name="Dial"><managerEventInstance class="EVENT_FLAG_CALL">
 <synopsis>Raised when a dial action has started.</synopsis>
 <syntax>
 <parameter name="SubEvent">
 <enumlist>
 <enum name="Begin"/>
 <enum name="End"/>
 </enumlist>
 <para>A sub event type, specifying whether or not the dial action has begun or ended.</para>
 </parameter>
 <parameter name="Channel"/>
 <parameter name="Destination"/>
 <parameter name="CallerIDNum"/>
 <parameter name="CallerIDName"/>
 <parameter name="ConnectedLineNum"/>
 <parameter name="ConnectedLineName"/>
 <parameter name="UniqueID"/>
 <parameter name="DestUniqueID"/>
 <parameter name="Dialstring"/>
 </syntax>
 </managerEventInstance>
 <managerEventInstance class="EVENT_FLAG_CALL">
 <synopsis>Raised when a dial action has ended.</synopsis>
 <syntax>
 <parameter name="DialStatus">
 <para>The value of the <variable>DIALSTATUS</variable> channel variable.</para>
 </parameter>
 <parameter name="SubEvent">
 <enumlist>
 <enum name="Begin"/>
 <enum name="End"/>
 </enumlist>
 <para>A sub event type, specifying whether or not the dial action has begun or ended.</para>
 </parameter>
 <parameter name="Channel"/>
 <parameter name="UniqueID"/>
 </syntax>
 </managerEventInstance>
</managerEvent>

```

Source Comments
---------------


* Event documentation **MUST** be within a documentation comment block (shown below), regardless of its location within an implementation file.

```

/*\*\* DOCUMENTATION
....
    * */

```
* If documentation is placed at the top of the header file, the documentation **MUST** be enclosed with the <managerEvent/> tag, as well as the <managerEventInstance/> tags that describe the event instances. The documentation is not modified by the pre-processing script, but will be modified by the post-processing script in that it will be combined with other <managerEventInstance/> tags for the same event.
* If documentation is placed within a source file co-located with AMI event call, the event documentation **MUST** be on the lines immediately preceding the AMI event call.
	+ The AMI event call **MUST** be one of the following three methods: ami_manager_event, manager_event, or ami_manager_event_multichan
	+ The AMI event call **MUST** contain the full manager event name with no format specifiers or ternary operations
	+ Only fields in the AMI event call that contain no format specifiers will be documented. If a field consists of a format specifier or contains some format specifier, it must be explicitly documented.
	+ Documentation co-located with an AMI event call may or may not contain a <syntax /> element. Parameter documentation will automatically be assumed to be children nodes of a <syntax/> element if one is not found.


