---
search:
  boost: 0.5
title: PRESENCE_STATE
---

# PRESENCE_STATE()

### Synopsis

Get or Set a presence state.

### Description

The PRESENCE\_STATE function can be used to retrieve the presence from any presence provider. For example:<br>

NoOp(SIP/mypeer has presence $\{PRESENCE\_STATE(SIP/mypeer,value)\})<br>

NoOp(Conference number 1234 has presence message $\{PRESENCE\_STATE(MeetMe:1234,message)\})<br>

The PRESENCE\_STATE function can also be used to set custom presence state from the dialplan. The 'CustomPresence:' prefix must be used. For example:<br>

Set(PRESENCE\_STATE(CustomPresence:lamp1)=away,temporary,Out to lunch)<br>

Set(PRESENCE\_STATE(CustomPresence:lamp2)=dnd,,Trying to get work done)<br>

Set(PRESENCE\_STATE(CustomPresence:lamp3)=xa,T24gdmFjYXRpb24=,,e)<br>

Set(BASE64\_LAMP3\_PRESENCE=$\{PRESENCE\_STATE(CustomPresence:lamp3,subtype,e)\})<br>

You can subscribe to the status of a custom presence state using a hint in the dialplan:<br>

exten => 1234,hint,,CustomPresence:lamp1<br>

The possible values for both uses of this function are:<br>

not\_set | unavailable | available | away | xa | chat | dnd<br>


### Syntax


```

PRESENCE_STATE(provider,field[,options])
```
##### Arguments


* `provider` - The provider of the presence, such as 'CustomPresence'<br>

* `field` - Which field of the presence state information is wanted.<br>

    * `value` - The current presence, such as 'away'<br>


    * `subtype` - Further information about the current presence<br>


    * `message` - A custom message that may indicate further details about the presence<br>


* `options`

    * `e` - On Write - Use this option when the subtype and message provided are Base64 encoded. The values will be stored encoded within Asterisk, but all consumers of the presence state (e.g. the SIP presence event package) will receive decoded values.<br>
On Read - Retrieves unencoded message/subtype in Base64 encoded form.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 