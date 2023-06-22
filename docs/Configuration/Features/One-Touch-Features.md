---
title: One-Touch Features
pageid: 32375822
---

Overview
========

Once configured these features can be activated with only a few or even one keypress on a user's phone. They are often called "one-touch" or "one-step" features.

All of the features are configured via options in the featuremap section of features.conf and require arguments to be passed to the applications invoking the target channel.

Available Features
==================

* **automon** - (One-touch Recording) Asterisk will invoke Monitor on the current channel.
* **automixmon** - (One-touch Recording) Has the same behavior as automon, but uses MixMonitor instead of Monitor.
* **disconnect** - (One-touch Disconnect) When this code is detected on a channel that channel will be immediately hung up.
* **parkcall** - (One-touch Parking) Sets a feature code for quickly parking a call.
	+ Most parking options and behavior are configured in res\_parking.conf in Asterisk 12 and newer.

Enabling the Features
=====================

Configuration of features.conf
------------------------------

The options are configured in features.conf in the featuremap section. They use typical Asterisk [configuration file syntax](/Fundamentals/Asterisk-Configuration/Asterisk-Configuration-Files/Config-File-Format).




---

  
features.conf  


```

 [featuremap]
automon = \*1
automixmon = \*3
disconnect = \*0
parkcall = #72

```


Assign each option the DTMF character string that you want users to enter for invoking the feature.

Dialplan application options
----------------------------

For each feature there are a pair of options that can be set in the [Dial](/Asterisk-13-Application_Dial) or [Queue](/Asterisk-13-Application_Queue) applications. The two options enable the feature on either the calling party channel or the called party channel.




!!! note 
    If neither option of a pair are set then you will not be able to use the related feature on the channel.

      
[//]: # (end-note)



**automon**

* W - Allow the calling party to enable recording of the call.
* w - Allow the called party to enable recording of the call.

**automixmon**

* X - Allow the calling party to enable recording of the call.
* x - Allow the called party to enable recording of the call.

**disconnect**

* H - Allow the calling party to hang up the channel.
* `h` - Allow the called party to hang up the channel.

**parkcall**

* `K` - Allow the calling party to enable parking of the call.
* `k` - Allow the called party to enable parking of the call.

### Example usage

Set the option as you would any [application](/Configuration/Applications) option.




---

  
extensions.conf  


```

exten = 101,1,Dial(PJSIP/ALICE,30,X)

```


This would allow the calling party, the party dialing PJSIP/ALICE, to invoke recording on the channel.

Using the Feature
=================

One you have configured features.conf and the options in the application then you only have to enter the feature code on your phone's keypad during a call!

