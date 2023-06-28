---
title: Call Pickup
pageid: 21463197
---




!!! info ""
    Call pickup support added in Asterisk 11

      
[//]: # (end-info)



Overview
========

Call pickup allows you to answer a call while it is ringing another phone or group of phones(other than the phone you are sitting at).

Requesting to pickup a call is done by two basic methods.

1. by [dialplan](/Configuration/Dialplan) using the Pickup or PickupChan applications.
2. by dialing the extension defined for pickupexten configured in features.conf.

Which calls can be picked up is determined by configuration and dialplan.

Dialplan Applications and Functions
===================================

Pickup Application
------------------

The [Pickup application](/Asterisk-13-Application_Pickup) has three ways to select calls for pickup.

PickupChan Application
----------------------

The [PickupChan application](/Asterisk-13-Application_PickupChan) tries to pickup the specified channels given to it.

CHANNEL Function
----------------

The [CHANNEL function](/Asterisk-13-Function_CHANNEL) allows the pickup groups set on a channel to be changed from the defaults set by the channel driver when the channel was created.

### callgroup/namedcallgroup

The CHANNEL(callgroup) option specifies which numeric pickup groups that this channel is a member.




---

  
  


```

same => n,Set(CHANNEL(callgroup)=1,5-7)

```


The CHANNEL(namedcallgroup) option specifies which named pickup groups that this channel is a member.




---

  
  


```

same => n,Set(CHANNEL(namedcallgroup)=engineering,sales)

```




!!! note 
    For this option to be effective, you must set it on the outgoing channel. There are a couple of ways:

    * You can use the setvar option available with several channel driver configuration files to set the pickup groups.
    * You can use a pre-dial handler.
      
[//]: # (end-note)



### pickupgroup/namedpickupgroup

The CHANNEL(pickupgroup) option specifies which numeric pickup groups this channel can pickup.




---

  
  


```

same => n,Set(CHANNEL(pickupgroup)=1,6-8)

```


The CHANNEL(namedpickupgroup) option specifies which named pickup groups this channel can pickup.




---

  
  


```

same => n,Set(CHANNEL(namedpickupgroup)=engineering,sales)

```




!!! note 
    For this option to be effective, you must set it on the channel before executing the Pickup application or calling the pickupexten.

    * You can use the setvar option available with several channel driver configuration files to set the pickup groups.
      
[//]: # (end-note)



Configuration Options
---------------------

The pickupexten request method selects calls using the numeric and named call groups. The ringing channels have the callgroup assigned when the channel is created by the channel driver or set by the CHANNEL(callgroup) or CHANNEL(namedcallgroup) dialplan function.

Calls picked up using pickupexten can hear an optional sound file for success and failure.




!!! note 
    The current channel drivers that support calling the pickupexten to pickup a call are: chan_dahdi/analog, chan_mgcp, chan_misdn, chan_sip, chan_unistim and chan_pjsip.

      
[//]: # (end-note)





---

  
features.conf  


```

pickupexten = \*8 ; Configure the pickup extension. (default is \*8)
pickupsound = beep ; to indicate a successful pickup (default: no sound)
pickupfailsound = beeperr ; to indicate that the pickup failed (default: no sound)

```


### Numeric call pickup groups

A numeric callgroup and pickupgroup can be set to a comma separated list of ranges (e.g., 1-4) or numbers that can have a value of 0 to 63. There can be a maximum of 64 numeric groups.




---

  
SYNTAX  


```

callgroup=[number[-number][,number[-number][,...]]]
pickupgroup=[number[-number][,number[-number][,...]]]

```


* callgroup - specifies which numeric pickup groups that this channel is a member.
* pickupgroup - specifies which numeric pickup groups this channel can pickup.




---

  
Configuration example  


```

callgroup=1,5-7
pickupgroup=1

```


Configuration should be supported in several channel drivers, including:

* chan_dahdi.conf
* misdn.conf
* mgcp.conf
* sip.conf
* unistim.conf
* pjsip.conf

pjsip.conf uses snake case:




---

  
Configuration in pjsip.conf  


```

call_group=1,5-7
pickup_group=1

```


### Named call pickup groups

A named callgroup and pickupgroup can be set to a comma separated list of case sensitive name strings. The number of named groups is unlimited. The number of named groups you can specify at once is limited by the line length supported.




---

  
SYNTAX  


```

namedcallgroup=[name[,name[,...]]]
namedpickupgroup=[name[,name[,...]]]

```


* namedcallgroup - specifies which named pickup groups that this channel is a member.
* namedpickupgroup - specifies which named pickup groups this channel can pickup.




---

  
Configuration Example  


```

namedcallgroup=engineering,sales,netgroup,protgroup
namedpickupgroup=sales

```


Configuration should be supported in several channel drivers, including:

* chan_dahdi.conf
* misdn.conf
* sip.conf
* pjsip.conf

pjsip.conf uses snake case:




---

  
  


```

named_call_group=engineering,sales,netgroup,protgroup
named_pickup_group=sales

```




!!! note 
    You can use named pickup groups in parallel with numeric pickup groups. For example, the named pickup group '4' is not the same as the numeric pickup group '4'.

    Named pickup groups are new with Asterisk 11.

      
[//]: # (end-note)



 

 

