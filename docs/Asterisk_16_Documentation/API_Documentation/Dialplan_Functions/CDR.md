---
search:
  boost: 0.5
title: CDR
---

# CDR()

### Synopsis

Gets or sets a CDR variable.

### Description

All of the CDR field names are read-only, except for 'accountcode', 'userfield', and 'amaflags'. You may, however, supply a name not on the above list, and create your own variable, whose value can be changed with this function, and this variable will be stored on the CDR.<br>


/// note
CDRs can only be modified before the bridge between two channels is torn down. For example, CDRs may not be modified after the 'Dial' application has returned.
///

``` title="Example: Set the userfield"

exten => 1,1,Set(CDR(userfield)=test)


```

### Syntax


```

CDR(name[,options])
```
##### Arguments


* `name` - CDR field name:<br>

    * `clid` - Caller ID.<br>

    * `lastdata` - Last application arguments.<br>

    * `disposition` - The final state of the CDR.<br>

        * `0` - NO ANSWER<br>

        * `1` - NO ANSWER (NULL record)<br>

        * `2` - FAILED<br>

        * `4` - BUSY<br>

        * `8` - ANSWERED<br>

        * `16` - CONGESTION<br>

    * `src` - Source.<br>

    * `start` - Time the call started.<br>

    * `amaflags` - R/W the Automatic Message Accounting (AMA) flags on the channel. When read from a channel, the integer value will always be returned. When written to a channel, both the string format or integer value is accepted.<br>

        * `1` - OMIT<br>

        * `2` - BILLING<br>

        * `3` - DOCUMENTATION<br>

        /// warning
Accessing this setting is deprecated in CDR. Please use the CHANNEL function instead.
///


    * `dst` - Destination.<br>

    * `answer` - Time the call was answered.<br>

    * `accountcode` - The channel's account code.<br>

        /// warning
Accessing this setting is deprecated in CDR. Please use the CHANNEL function instead.
///


    * `dcontext` - Destination context.<br>

    * `end` - Time the call ended.<br>

    * `uniqueid` - The channel's unique id.<br>

    * `dstchannel` - Destination channel.<br>

    * `duration` - Duration of the call.<br>

    * `userfield` - The channel's user specified field.<br>

    * `lastapp` - Last application.<br>

    * `billsec` - Duration of the call once it was answered.<br>

    * `channel` - Channel name.<br>

    * `sequence` - CDR sequence number.<br>

* `options`

    * `f` - Returns billsec or duration fields as floating point values.<br>


    * `u` - Retrieves the raw, unprocessed value.<br>
For example, 'start', 'answer', and 'end' will be retrieved as epoch values, when the 'u' option is passed, but formatted as YYYY-MM-DD HH:MM:SS otherwise. Similarly, disposition and amaflags will return their raw integral values.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 