---
title: CEL Specification
pageid: 25919712
---

# CEL Specification

## Introduction

Channel Event Logging (CEL) provides a series of records describing the state of channels in Asterisk to any of several [event recording back-ends](../CEL-Configuration-Examples). CEL records provide substantially more information than CDRs and thus allow an Asterisk User to construct their own more complex billing system.

As a result of the bridging work done for Asterisk 12, CEL behavior has changed for several events that occur in the system. The most significant changes are:

* AST\_CEL\_BRIDGE\_ENTER and AST\_CEL\_BRIDGE\_EXIT have been introduced to denote participant changes in bridges.
* AST\_CEL\_BRIDGE\_START and AST\_CEL\_BRIDGE\_END have been removed as they no longer applies to the new bridging framework.
* AST\_CEL\_BRIDGE\_UPDATE has been removed as it no longer applies to the new bridging framework.
* AST\_CEL\_LOCAL\_OPTIMIZE has been added to describe local channel optimizations that occur.
* All linkedid accounting and record generation is now handled within the CEL engine.
* The peer field is only used in BRIDGE\_ENTER and BRIDGE\_EXIT records.

## Scope

This CEL specification applies to Asterisk 12 and above. While some portions of this specification are applicable to prior versions of Asterisk, other portions are specific to Asterisk 12 and their counterparts in prior versions are not discussed.

## Terminology

| Term | Definition |
| --- | --- |
| CEL | Channel Event Logging. The focus of this documentation. |
| CEL record | An individual event record produced by the CEL engine. |
| CDR | Call Detail Record. An alternative method of extracting billing information from Asterisk. Simpler, but less flexible. |
| Stasis | The internal message bus in Asterisk that conveys state to the CEL engine. |
| Primary | The channel around which a CEL record is focused. |
| AMI | Asterisk Manager Interface |
| CSV | Comma Separated Values.  A format commonly used for tabular data when stored outside of a database. |

## CEL Overview

A CEL record contains information about a system event including a partial dump of the Primary's state and may contain data relevant to that specific record type such as channel names, bridge unique identifiers, channel variable values, or other miscellaneous information. The CEL engine tracks changes in individual channel state and guarantees ordering of records for a given Primary, but does not guarantee ordering of records in relation to other Primaries. The exception to this record ordering occurs with meta-records which occur adjacent to the events they describe. Applicable event ordering is provided in the descriptions below. CEL output does not describe interaction with MeetMe conferences other than MeetMe as an application.

## Record Types

The records produced by the CEL engine can be grouped in to three general categories.

* Stand-Alone Records
* Interaction Records
* Meta-Records

### Stand-Alone Records

These records convey a channel event on the channel that does not involve channels or bridges other than the Primary.

#### Channel Start

An AST\_CEL\_CHANNEL\_START record is generated when a channel is created. This record introduces a new Primary and is the first record available for all Primaries.

#### Channel End

An AST\_CEL\_CHAN\_END record is generated when a channel is destroyed. This record indicates that a Primary is going away and that there will be no further records for this Primary with the exception of AST\_CEL\_LINKEDID\_END.

#### Answer

An AST\_CEL\_ANSWER record is generated when a channel is answered. Depending on the state transitions that occur on a Primary, this record may not be generated.

#### Hangup

An AST\_CEL\_HANGUP record is generated when a channel is hung up. This record will occur on every Primary prior to channel destruction.

#### Application Start

An AST\_CEL\_APP\_START record is generated when a channel enters an application. This record will always be generated before its corresponding AST\_CEL\_APP\_END.

#### Application End

An AST\_CEL\_APP\_END record is generated when a channel exits an application. This record will be generated after its corresponding AST\_CEL\_APP\_START, but is not guaranteed to be generated on hangup.

#### User Defined

An AST\_CEL\_USER\_DEFINED record is generated when a channel enters the CELGenUserEvent application. The application sets the user defined name field and additional information in the extra field in the "extra" key.

#### Linked ID End

An AST\_CEL\_LINKEDID\_END record is generated when the last channel using the given linked ID is destroyed or the last instance of a linked ID is overwritten by a different linked ID. This is the only type of record that may occur after AST\_CEL\_CHANNEL\_END.

### Interaction Records

These records convey the Primary's interactions with other channels or bridges.

#### Bridge Enter

An AST\_CEL\_BRIDGE\_ENTER record is generated when a channel enters a bridge. The entering channel is the Primary for this event. Additional information is conveyed in the extra field under the "bridge\_id" key. The "bridge\_technology" key is available in Asterisk 13+. All other channels in the bridge at the time of entry are available in the peer field as a comma-separated list.

#### Bridge Exit

An AST\_CEL\_BRIDGE\_EXIT record is generated when a channel exits a bridge. The leaving channel is the Primary for this event. Additional information is conveyed in the extra field under the "bridge\_id" key. The "bridge\_technology" key is available in Asterisk 13+. All other channels in the bridge at the time of exit are available in the peer field as a comma-separated list.

#### Forward

An AST\_CEL\_FORWARD record is generated when a dialing channel is forwarded elsewhere by a dialed channel. The dialing channel is the Primary for this event. Additional information is conveyed in the extra field under the "forward" key.

#### Park Start

An AST\_CEL\_PARK\_START record is generated when a channel is parked. The parked channel is the Primary for this event. Additional information is conveyed in the extra field under the keys "parker\_dial\_string" and "parking\_lot".

#### Park End

An AST\_CEL\_PARK\_START record is generated when a channel is unparked. The unparked channel is the Primary for this event. Additional information is conveyed in the extra field under the "reason" key and the "retriever" key when available. This record always occurs after its corresponding AST\_CEL\_PARK\_START.

#### Pickup

An AST\_CEL\_PICKUP record is generated when a channel is picked up. The picked up channel (also known as the target) is the Primary for this record. The name of the channel that is picking up is conveyed in the extra field under the "pickup\_channel" key.

### Meta-Records

These records convey additional context relating to surrounding CEL records

#### Blind Transfer

An AST\_CEL\_BLINDTRANSFER record is generated when a blind transfer feature is activated on a bridge. The initiating channel is the Primary for this record. Additional information is conveyed in the extra field under the "extension", "context", and "bridge\_id" keys.

#### Attended Transfer

An AST\_CEL\_ATTENDEDTRANSFER record is generated when an attended transfer is successfully performed.

##### Bridge-Bridge Attended Transfers

This type of attended transfer occurs when both involved channels are bridged. The initiating channel is the Primary for this record. Additional information is conveyed in the extra field under the "bridge1\_id", "channel2\_name", "bridge2\_id", "transferee\_channel\_name", and "transfer\_target\_channel\_name" keys.

The records associated with this type of transfer will vary depending on the configuration of the bridges involved and the number of channels involved. Possible methods of accomplishing the transfer include (but are not limited to) channel swap, bridge merge, and bridge link via a local channel.

##### Bridge-App Attended Transfers

This type of attended transfer occurs when one involved channel is bridged while the other is running an application. The bridged channel is the Primary for this record. Additional information is conveyed in the extra field under the "bridge1\_id", "channel2\_name", and "app" keys.

##### App-App Attended Transfers

Attended transfers involving only channels that are running applications are not currently possible. This is not possible with internal transfers since there is no bridge involved to handle the feature codes and any externally initiated attended transfer that attempts to bridge two app-bound channels will fail.

#### Local Channel Optimization

An AST\_CEL\_LOCAL\_OPTIMIZE record is generated when a local channel optimization attempt completes successfully. The semi-one (local channel ending in ';1') channel is the Primary for this event. The name of the semi-two (local channel ending in ';2') channel is conveyed in the extra field under the "local\_two" key.

### Removed Records

The following record types are no longer available as of Asterisk 12:

* AST\_CEL\_BRIDGE\_START
* AST\_CEL\_BRIDGE\_END
* AST\_CEL\_CONF\_START
* AST\_CEL\_CONF\_END
* AST\_CEL\_CONF\_ENTER
* AST\_CEL\_CONF\_EXIT
* AST\_CEL\_HOOKFLASH
* AST\_CEL\_3WAY\_START
* AST\_CEL\_3WAY\_END
* AST\_CEL\_BRIDGE\_UPDATE
* AST\_CEL\_TRANSFER

## Record Fields

### Primary Fields

These fields are populated exclusively from their corresponding fields on the Primary in a consistent manner for every CEL record.

|Field|Description|
|---|---|
|CallerID Name|The name identifying the caller for this channel.|
|CallerID Number|The number identifying the caller for this channel.|
|CallerID ANI|Automatic Number Identification caller information provided for this channel.|
|CallerID RDNIS|Redirecting information for this channel.|
|CallerID DNID|Dialed Number Identification for this channel.|
|Extension|The extension in which this channel is currently executing.|
|Context|The context in which this channel is currently executing.|
|Channel Name|The name of this channel.|
|Application Name|The name of the application that this channel is currently executing.|
|Application Data|The data provided to the application being executed.|
|Account Code|The account code used for billing.|
|Peer Account Code|The peer channel's account code.|
|Unique ID|This channel's instance unique identifier.|
|Linked ID|This channel's current linked ID which is affected by bridging operations. This identifier starts as the channel's unique ID.|
|AMA Flags|This channel's Automated Message Accounting flags.|

### Record Type Specific Fields

These fields vary or may be blank depending on the CEL record type.

|Field|Description|
|---|---|
|User Defined Name|This field is only used for AST\_CEL\_USER\_DEFINED and conveys the user-specified event type.|
|Extra|This field contains a JSON blob describing additional record-type-specific information.|

## Logging Backends

CEL provides several methods of logging records to be processed at a later time. CEL only publishes record types to backends that are enabled in the general CEL configuration. Sample configurations are provided with the Asterisk 12 source for all of these backends.

### Custom

The Custom CEL output module provides logging capability to a CSV file in a format described in the configuration file. This module is configured in cel\_custom.conf.

### Manager

The manager CEL output module publishes records over AMI as CEL events with the record type published under the "EventName" key. This module is configured in cel.conf in the [manager] section.

### ODBC

The ODBC CEL output module provides logging capability to any ODBC-compatible database. This module is configured in cel\_odbc.conf.

### PGSQL

The PGSQL CEL output module provides logging capability to PostgreSQL databases when it is desirable to avoid the ODBC abstraction layer. This module is configured in cel\_pgsql.conf.

### RADIUS

The RADIUS CEL output module allows the CEL engine to publish records to a RADIUS server. This module is configured in cel.conf in the [radius] section.

### SQLite

The SQLite CEL output module provides logging capability to a SQLite3 database in a format described in its configuration file. This module is configured in cel\_sqlite3\_custom.conf.

### TDS

The TDS CEL output module provides logging capability to Sybase or Microsoft SQL Server databases when it is desirable to avoid the ODBC abstraction layer. This module is configured in cel\_tds.conf.

## Example Scenarios

For the following scenarios, assume the CEL engine is configured to generate the following record types:

* AST\_CEL\_CHANNEL\_START
* AST\_CEL\_CHAN\_END
* AST\_CEL\_BRIDGE\_ENTER
* AST\_CEL\_BRIDGE\_EXIT

### Two-Participant Bridge

The following scenario demonstrates channel creation, channel destruction, bridge start, and bridge end:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Bridge Link is created |  |  |  |
| Alice enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Alice | {"bridge\_id": "Link"} |
| Bob enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id": "Link"} |
| Bob exits bridge Link | AST\_CEL\_BRIDGE\_EXIT | Bob | {"bridge\_id": "Link"} |
| Bob is destroyed | AST\_CEL\_CHAN\_END | Bob |  |
| Alice exits bridge Link | AST\_CEL\_BRIDGE\_EXIT | Alice | {"bridge\_id": "Link"} |
| Alice is destroyed | AST\_CEL\_CHAN\_END | Alice |  |

### Multi-participant Conference

The following scenario demonstrates conversion of a bridge to a multi-participant conference:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Channel Charlie is created | AST\_CEL\_CHANNEL\_START | Charlie |  |
| Channel David is created | AST\_CEL\_CHANNEL\_START | David |  |
| Bridge Link is created |  |  |  |
| Alice enters bridge Link | AST\_CEL\_CONF\_ENTER | Alice | {"bridge\_id", "Link"} |
| Bob enters bridge Link | AST\_CEL\_CONF\_ENTER | Bob | {"bridge\_id", "Link"} |
| Charlie enters bridge Link | AST\_CEL\_CONF\_ENTER | Charlie | {"bridge\_id", "Link"} |
| David enters bridge Link | AST\_CEL\_CONF\_ENTER | David | {"bridge\_id", "Link"} |
| Alice exits bridge Link | AST\_CEL\_CONF\_EXIT | Alice | {"bridge\_id", "Link"} |
| Alice is destroyed | AST\_CEL\_CHAN\_END | Alice |  |
| Bob exits bridge Link | AST\_CEL\_CONF\_EXIT | Bob | {"bridge\_id", "Link"} |
| Bob is destroyed | AST\_CEL\_CHAN\_END | Bob |  |
| Charlie exits bridge Link | AST\_CEL\_CONF\_EXIT | Charlie | {"bridge\_id", "Link"} |
| Charlie is destroyed | AST\_CEL\_CHAN\_END | Charlie |  |
| David exits bridge Link | AST\_CEL\_CONF\_EXIT | David | {"bridge\_id", "Link"} |
| David is destroyed | AST\_CEL\_CHAN\_END | David |  |

### Dial Nominal

For this scenario, assume that AST\_CEL\_ANSWER, AST\_CEL\_HANGUP, AST\_CEL\_APP\_START, and AST\_CEL\_APP\_END are configured in addition to the aforementioned record types and that "Dial" is configured to be watched.

The following scenario demonstrates a Dial that results in an answer followed by bridging and hangup:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Alice executes Dial(SIP/Bob) | AST\_CEL\_APP\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Bob answers | AST\_CEL\_ANSWER | Bob |  |
| Alice answers | AST\_CEL\_ANSWER | Alice |  |
| Bridge Link is created |  |  |  |
| Alice enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Alice | {"bridge\_id": "Link"} |
| Bob enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id": "Link"} |
| Bob initiates hangup, exits bridge Link | AST\_CEL\_BRIDGE\_EXIT | Bob | {"bridge\_id": "Link"} |
| Bob completes hang up | AST\_CEL\_HANGUP | Bob | {"hangupcause":16,"dialstatus":"","hangupsource":"Bob"} |
| Bob is destroyed | AST\_CEL\_CHAN\_END | Bob |  |
| Alice exits bridge Link | AST\_CEL\_BRIDGE\_EXIT | Alice | {"bridge\_id": "Link"} |
| Alice is hung up | AST\_CEL\_HANGUP | Alice | {"hangupcause":16,"dialstatus":"ANSWER","hangupsource":""} |
| Alice is destroyed | AST\_CEL\_CHAN\_END | Alice |  |

### Dial Busy

For this scenario, assume that AST\_CEL\_ANSWER, AST\_CEL\_HANGUP, AST\_CEL\_APP\_START, and AST\_CEL\_APP\_END are configured in addition to the aforementioned record types and that "Dial" is configured to be watched. The following scenario demonstrates a Dial that results in a busy:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Alice executes Dial(SIP/Bob) | AST\_CEL\_APP\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Bob responds BUSY | AST\_CEL\_HANGUP | Bob |  {"hangupcause":21,"dialstatus":"","hangupsource":""} |
| Bob is destroyed | AST\_CEL\_CHAN\_END | Bob |  |
| Alice is hung up | AST\_CEL\_HANGUP | Alice | {"hangupcause":17,"dialstatus":"BUSY","hangupsource":""} |
| Alice is destroyed | AST\_CEL\_CHAN\_END | Alice |  |

### Blind Transfer

For this scenario, assume that AST\_CEL\_HANGUP is configured in addition to the aforementioned record types. The following scenario demonstrates a blind transfer:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Alice answers | AST\_CEL\_ANSWER | Alice |  |
| Bob answers | AST\_CEL\_ANSWER | Bob |  |
| Bridge Link is created |  |  |  |
| Bob enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id":"Link"} |
| Alice enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Alice | {"bridge\_id":"Link"} |
| Alice initiates a blind transfer to exten@context | AST\_CEL\_BLINDTRANSFER | Alice | {"bridge\_id":"Link","extension":"exten","context":"context"} |
| Alice exits bridge Link | AST\_CEL\_BRIDGE\_EXIT | Alice | {"bridge\_id":"Link"} |
| Alice is hung up | AST\_CEL\_HANGUP | Alice | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Alice is destroyed | AST\_CEL\_CHANNEL\_END | Alice |  |
| A local channel pair is created to handle dialplan | AST\_CEL\_CHANNEL\_START | Local1 |  |
|  | AST\_CEL\_CHANNEL\_START | Local2 |  |
| Local1 enters bridge Link | AST\_CEL\_BRIDGE\_ENTER | Local1 | {"bridge\_id":"Link"} |
| Local2 executes dialplan at exten@context |  |  |  |
| Local2 is eventually hung up by the dialplan | AST\_CEL\_HANGUP | Local2 | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Hangup is initiated on Local1, exiting bridge Link | AST\_CEL\_BRIDGE\_EXIT | Local1 | {"bridge\_id":"Link"} |
| Local1 is hung up | AST\_CEL\_HANGUP | Local1 | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Local1 is destroyed | AST\_CEL\_CHANNEL\_END | Local1 |  |
| Local2 is destroyed | AST\_CEL\_CHANNEL\_END | Local2 |  |
| Bob is the last channel and so is hung up | AST\_CEL\_HANGUP | Bob | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Bob is destroyed | AST\_CEL\_CHANNEL\_END | Bob |  |

### Attended Transfer

For this scenario, assume that AST\_CEL\_ANSWER and AST\_CEL\_HANGUP are configured in addition to the aforementioned record types. The following scenario demonstrates a channel-swapping attended transfer:

| Event | Record | Primary | Extra |
| --- | --- | --- | --- |
| Channel Alice is created | AST\_CEL\_CHANNEL\_START | Alice |  |
| Channel Bob is created | AST\_CEL\_CHANNEL\_START | Bob |  |
| Alice answers | AST\_CEL\_ANSWER | Alice |  |
| Bob answers | AST\_CEL\_ANSWER | Bob |  |
| Bridge Link1 is created |  |  |  |
| Bob enters bridge Link1 | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id":"Link1"} |
| Alice enters bridge Link1 | AST\_CEL\_BRIDGE\_ENTER | Alice | {"bridge\_id":"Link1"} |
| Channel Charlie is created | AST\_CEL\_CHANNEL\_START | Charlie |  |
| Channel David is created | AST\_CEL\_CHANNEL\_START | David |  |
| Charlie answers | AST\_CEL\_ANSWER | Charlie |  |
| David answers | AST\_CEL\_ANSWER | David |  |
| Bridge Link2 is created |  |  |  |
| David enters bridge Link2 | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id":"Link2"} |
| Charlie enters bridge Link2 | AST\_CEL\_BRIDGE\_ENTER | Alice | {"bridge\_id":"Link2"} |
| An attended transfer between Alice and David begins |  |  |  |
| Bob exits bridge Link1 | AST\_CEL\_BRIDGE\_EXIT | Bob | {"bridge\_id":"Link1"} |
| Bob enters bridge Link2 | AST\_CEL\_BRIDGE\_ENTER | Bob | {"bridge\_id":"Link2"} |
| David exits bridge Link2 | AST\_CEL\_BRIDGE\_EXIT | David | {"bridge\_id":"Link2"} |
| David is hung up | AST\_CEL\_HANGUP | David | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| David is destroyed | AST\_CEL\_CHANNEL\_END | David |  |
| Alice and David execute an attended transfer  | AST\_CEL\_ATTENDEDTRANSFER | Alice | {"bridge1\_id":"Link1","channel2\_name":"David","bridge2\_id":"Link2"} |
| Alice exits bridge Link1 | AST\_CEL\_BRIDGE\_EXIT | Alice | {"bridge\_id":"Link1"} |
| Alice is hung up | AST\_CEL\_HANGUP | Alice | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Alice is destroyed | AST\_CEL\_CHANNEL\_END | Alice |  |
| Bob exits bridge Link2 | AST\_CEL\_BRIDGE\_EXIT | Bob | {"bridge\_id":"Link2"} |
| Charlie exits bridge Link2 | AST\_CEL\_BRIDGE\_EXIT | Charlie | {"bridge\_id":"Link2"} |
| Bob is hung up | AST\_CEL\_HANGUP | Bob | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Bob is destroyed | AST\_CEL\_CHANNEL\_END | Bob |  |
| Charlie is hung up | AST\_CEL\_HANGUP | Charlie | {"hangupcause":16,"dialstatus":"","hangupsource":""} |
| Charlie is destroyed | AST\_CEL\_CHANNEL\_END | Charlie |  |

Note that the ATTENDEDTRANSFER event does not necessarily occur before or after the records it is related to.
