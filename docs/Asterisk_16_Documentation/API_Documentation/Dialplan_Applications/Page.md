---
search:
  boost: 0.5
title: Page
---

# Page()

### Synopsis

Page series of phones

### Description

Places outbound calls to the given _technology_/_resource_ and dumps them into a conference bridge as muted participants. The original caller is dumped into the conference as a speaker and the room is destroyed when the original caller leaves.<br>


### Syntax


```

Page(Technology/Resource&[Technology2/Resource2[&...]],[options,[timeout]]])
```
##### Arguments


* `Technology/Resource`

    * `Technology/Resource` **required** - Specification of the device(s) to dial. These must be in the format of 'Technology/Resource', where _Technology_ represents a particular channel driver, and _Resource_ represents a resource available to that particular channel driver.<br>

    * `Technology2/Resource2[,Technology2/Resource2...]` - Optional extra devices to dial in parallel<br>
If you need more than one, enter them as Technology2/Resource2& Technology3/Resource3&.....<br>

* `options`

    * `b(context^exten^priority)` - Before initiating an outgoing call, Gosub to the specified location using the newly created channel. The Gosub will be executed for each destination channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `B(context^exten^priority)` - Before initiating the outgoing call(s), Gosub to the specified location using the current channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `d` - Full duplex audio<br>


    * `i` - Ignore attempts to forward the call<br>


    * `q` - Quiet, do not play beep to caller<br>


    * `r` - Record the page into a file ( 'CONFBRIDGE(bridge,record\_conference)')<br>


    * `s` - Only dial a channel if its device state says that it is 'NOT\_INUSE'<br>


    * `A(x)` - Play an announcement to all paged participants<br>

        * `x` **required** - The announcement to playback to all devices<br>


    * `n` - Do not play announcement to caller (alters 'A(x)' behavior)<br>


* `timeout` - Specify the length of time that the system will attempt to connect a call. After this duration, any page calls that have not been answered will be hung up by the system.<br>

### See Also

* [Dialplan Applications ConfBridge](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ConfBridge)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 