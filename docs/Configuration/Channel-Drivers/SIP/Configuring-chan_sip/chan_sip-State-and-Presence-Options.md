---
title: chan_sip State and Presence Options
pageid: 28934285
---

Device State
============

There are a few configuration options for chan\_sip that affect [Device State](/Fundamentals/Key-Concepts/States-and-Presence/Device-State) behavior.

callcounter
-----------

The **callcounter** option in sip.conf **must be enabled** for SIP devices (e.g. SIP/Alice) to provide advanced [device state](/Fundamentals/Key-Concepts/States-and-Presence/Device-State). Without it you may see some state, such as unavailable or idle, but not much more.

The option can be set in the general context, or on a per-peer basis.

Default: no




---

  
  


```

[general]
callcounter=yes

```


busylevel
---------

The **busylevel** option only works if call counters are enabled via the above option. If call counters are enabled, then busylevel allows you to set a threshold for when to consider this device busy. If busylevel is set to 2, then only at 2 or more calls will the device state report BUSY. The busylevel option can only be set for peers.

Default: 0




---

  
  


```

[6001]
type=friend
busylevel=2

```


notifyhold
----------

The **notifyhold** option, when enabled, adds the ONHOLD device state to the range of possible device states that chan\_sip will use.

This option can only be set in the general section.

Default: yes




---

  
  


```

[general]
notifyhold=no

```


 

Extension State, Hints, Subscriptions
=====================================

Extension State and subscriptions tend to go hand in hand. That is, if you are using Extension State, you probably have SIP user agents subscribing to those extensions/hints. These options all affect that behavior.

allowsubscribe
--------------

The **allowsubscribe** option enables or disables support for any kind of subscriptions. You can set allowsubscribe per-peer or in the general section.

Default: yes




---

  
  


```

[6001]
type=friend
allowsubscribe=no

```


subscribecontext
----------------

**subscribecontext** sets a specific context to be used for subscriptions. That means, if SIP user agent subscribes to this peer, Asterisk will search for an associated hint mapping in the context specified.

This option can be set per-peer or in the general section.

Default: null (by default Asterisk will use the context specified with the "context" option)




---

  
  


```

[6001]
type=friend
context=internal
subscribecontext=myhints

```


notifyringing
-------------

**notifyringing** enables or disables notifications for the RINGING state when an extension is already INUSE. Only affects subscriptions using the **dialog-info** event package. Option can be configured in the general section only. It cannot be set per-peer.

Default: yes




---

  
  


```

[general]
notifyringing=no

```


notifycid
---------

**notifycid** some nuance and may only be relevant to SNOM phones or others that support dialog-info+xml notifications. Below are the notes from the sample sip.conf.

Default: no




---

  
  


```

;notifycid = yes ; Control whether caller ID information is sent along with
 ; dialog-info+xml notifications (supported by snom phones).
 ; Note that this feature will only work properly when the
 ; incoming call is using the same extension and context that
 ; is being used as the hint for the called extension. This means
 ; that it won't work when using subscribecontext for your sip
 ; user or peer (if subscribecontext is different than context).
 ; This is also limited to a single caller, meaning that if an
 ; extension is ringing because multiple calls are incoming,
 ; only one will be used as the source of caller ID. Specify
 ; 'ignore-context' to ignore the called context when looking
 ; for the caller's channel. The default value is 'no.' Setting
 ; notifycid to 'ignore-context' also causes call-pickups attempted
 ; via SNOM's NOTIFY mechanism to set the context for the call pickup
 ; to PICKUPMARK.

```


 

 

 

