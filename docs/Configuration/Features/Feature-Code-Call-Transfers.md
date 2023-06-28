---
title: Feature Code Call Transfers
pageid: 32375739
---

Overview of Feature Code Call Transfers
=======================================

A call transfer is when one party of a call directs Asterisk to connect the other party to a new location on the system.

Transfer types supported by the Asterisk core:

* Blind transfer
* Attended transfer
	+ Variations on attended transfer behavior

Transfer features provided by the Asterisk core are configured in features.conf and accessed with feature codes.

Channel driver technologies such as chan_sip and chan_pjsip have native capability for various transfer types. That native transfer functionality is independent of this core transfer functionality. The core feature code transfer functionality is channel agnostic.

On this Page


Blind transfer
--------------

A blind or unsupervised transfer is where the initiating party is blind to what is happening after initiating the transfer. They are removed from the process as soon as they initiate the transfer. It is a sort of "fire and forget" transfer.

Attended transfer
-----------------

An attended or supervised transfer happens when one party transfers another party to a new location by first dialing the transfer destination and only completing the transfer when ready. The initiating party is attending or supervising the transfer process by contacting the destination before completing the transfer. This is helpful if the transfer initiator wants to make sure someone answers or is ready at the destination.

Configuring Transfer Features
=============================

There are three primary requirements for the use of core transfer functionality.

* The transfer type must be enabled and assigned a DTMF digit string in features.conf or per channel - see (((Dynamic DTMF Features)))
* The channel must allow the type of transfer attempted. This can be configured via the Application invoking the channel such as Dial or Queue.
* The channels involved must be answered and bridged.

Enabling blind or attended transfers
------------------------------------

In features.conf you must configure the blindxfer or atxfer options in the featuremap section. The options are configured with the DTMF character string you want to use for accessing the feature.




---

  
  


```

[featuremap]
blindxfer = #1
atxfer = \*2

```


Now that you have the feature enabled you need to configure the dialplan such that a particular channel will be allowed to use the feature.

As an example if you want to allow transfers via the [Dial](/Asterisk-13-Application_Dial) application you can use two options, "t" or "T".

* t - Allow the called party to transfer the calling party by sending the DTMF sequence defined in features.conf. This setting does not perform policy enforcement on transfers initiated by other methods
* T - Allow the calling party to transfer the called party by sending the DTMF sequence defined in features.conf. This setting does not perform policy enforcement on transfers initiated by other methods.

Setting these options for Dial in extensions.conf would look similar to the following:




---

  
  


```

exten = 102,1,Dial(PJSIP/BOB,30,T)

```


Asterisk should be restarted or relevant modules should be reloaded for changes to take effect.




!!! tip 
    The same arguments ("t" and "T") work for the [Queue](/Asterisk-13-Application_Queue) and [Dial](/Asterisk-13-Application_Dial) applications!

      
[//]: # (end-tip)



Feature codes for attended transfer control
-------------------------------------------

There are a few additional feature codes related to attended transfers. These features allow you to vary the behavior of an attended transfer on command. They are all configured in the 'general' section of features.conf

### Aborting an attended transfer

Dialing the **atxferabort** code aborts an attended transfer. Otherwise there is no way to abort an attended transfer.

### Completing an attended transfer

Dialing the **atxfercomplete** code completes an attended transfer and drops out of the call without having to hang up.

### Completing an attended transfer as a three-way bridge

Dialing the **atxferthreeway** code completes an attended transfer and enters a bridge with both of the other parties.

### Swapping between the transferee and destination

Dialing the **atxferswap** code swaps you between bridges with either party before the transfer is complete. This allows you to talk to either party one at a time before finalizing the attended transfer.

### Example configuration




---

  
  


```

[general]
atxferabort = \*3
atxfercomplete = \*4
atxferthreeway = \*5
atxferswap = \*6

```


Configuring attended transfer callbacks
---------------------------------------

By default Asterisk will call back the initiator of the transfer if they hang up before the target answers and the answer timeout is reached. There are a few options for configuring this behavior.

### No answer timeout

**atxfernoanswertimeout** allows you to define the timeout for attended transfers. This is the amount of time (in seconds) Asterisk will attempt to ring the target before giving up.

### Dropped call behavior

**atxferdropcall** allows you to change the default callback behavior. The default is 'no' which results in Asterisk calling back the initiator of a transfer when they hang up early and the attended transfer times out. If set to 'yes' then the transfer target channel will be immediately transferred to the channel being transferred as soon as the initiator hangs up.

### Loop delay timing

**atxferloopdelay** sets the number of seconds to wait between callback retries. This option is only relevant when atxferdropcall=no (or is undefined).

### Number of retries for callbacks

**atxfercallbackretries** sets the number of times Asterisk will try to send a failed attended transfer back to the initiator. The default is 2.

### Example Configuration




---

  
  


```

[general]
atxfernoanswertimeout = 15 
atxferdropcall = no 
atxferloopdelay = 10 
atxfercallbackretries = 2

```


Behavior Options
================

These options are configured in the "[general]" section of features.conf

### General transfer options




---

  
  


```

;transferdigittimeout = 3 ; Number of seconds to wait between digits when transferring a call
; (default is 3 seconds)

```


### Attended transfer options




---

  
  


```

;xfersound = beep ; to indicate an attended transfer is complete
;xferfailsound = beeperr ; to indicate a failed transfer
;transferdialattempts = 3 ; Number of times that a transferer may attempt to dial an extension before
; being kicked back to the original call.
;transferretrysound = "beep" ; Sound to play when a transferer fails to dial a valid extension.
;transferinvalidsound = "beeperr" ; Sound to play when a transferer fails to dial a valid extension and is out of retries.


```


Basic Transfer Examples
=======================

In the previous section we configured #1 and \*2 as our features codes. We also passed the "T" argument in the Dial application at 102 to allow transfers by the calling party.

Our hypothetical example includes a few devices:

* PJSIP/ALICE at extension 101
* PJSIP/BOB at extension 102
* PJSIP/CATHY at extension 103

Making a blind transfer
-----------------------

For blind transfers we configured the #1 feature code.

An example call flow:

* ALICE dials extension 102 to call BOB
* ALICE decides to transfer BOB to extension 103, so she dials #1. Asterisk will play the audio prompt "transfer".
* ALICE enters the digits 103 for the destination extension.
* Asterisk immediately hangs up the channel between ALICE and BOB. Asterisk creates a new channel for BOB that is dialing extension 103.

Making an attended transfer
---------------------------

For attended transfers we configured \*2 as our feature code.

An example call flow:

* ALICE dials extension 102 to call BOB and BOB answers.
* ALICE decides to transfer BOB to extension 103, so she dials \*2. Asterisk plays the audio prompt "transfer".
* ALICE enters the digits 103 for the destination extension. Asterisk places BOB on hold and creates a channel for ALICE to dial CATHY.
* CATHY answers - ALICE and CATHY talk. ALICE decides to complete the transfer and hangs up the phone.
* Asterisk immediately hangs up the channel between ALICE and BOB. Asterisk plays a short beep tone to CATHY and then bridges the channels for BOB and CATHY.

  
