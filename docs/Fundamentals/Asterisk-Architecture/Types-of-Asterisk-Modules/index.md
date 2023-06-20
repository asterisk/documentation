---
title: Overview
pageid: 4817485
---

There are many different types of modules, each providing their own functionality and capabilities to Asterisk. Configuration of loading is described in [Configuring the Asterisk Module Loader](/Configuration/Core-Configuration/Configuring-the-Asterisk-Module-Loader).




---

**Tip:**  Use the [CLI](/Operation/Asterisk-Command-Line-Interface) command **module show** to see all the loaded modules in your Asterisk system. See the command usage for details on how to filter the results shown with a pattern.

Click here for example "module show" output...


---

  
  


```

mypbx\*CLI> module show 
Module Description Use Count Status Support Level
app\_adsiprog.so Asterisk ADSI Programming Application 0 Running extended
app\_agent\_pool.so Call center agent pool applications 0 Running core
app\_alarmreceiver.so Alarm Receiver for Asterisk 0 Running extended
app\_amd.so Answering Machine Detection Application 0 Running extended
app\_authenticate.so Authentication Application 0 Running core  



---



```




---


Various Module Types
====================

* **Channel Drivers**

Channel drivers communicate with devices outside of Asterisk, and translate that particular signaling or protocol to the core.

* **Dialplan Applications**

Applications provide call functionality to the system. An application might answer a call, play a sound prompt, hang up a call or provide more complex behavior such as queuing, voicemail or conferencing feature sets.

* **Dialplan Functions**

Functions are used to retrieve, set or manipulate various settings on a call. A function might be used to set the Caller ID on an outbound call, for example.

* **Resources**

As the name suggests, resources provide resources to Asterisk and its modules. Common examples of resources include music on hold and call parking.

* **CODECs**

A CODEC (which is an acronym for COder/DECoder) is a module for encoding or decoding audio or video. Typically codecs are used to encode media so that it takes less bandwidth. These are essential to translating audio between the audio codecs and payload types used by different devices.

* **File Format Drivers**

File format drivers are used to save media to disk in a particular file format, and to convert those files back to media streams on the network.

* **Call Detail Record (CDR) Drivers**

CDR drivers write call logs to a disk or to a database.

* **Call Event Log (CEL) Drivers**

Call event logs are similar to call detail records, but record more detail about what happened inside of Asterisk during a particular call.

* **Bridge Drivers**

Bridge drivers are used by the bridging architecture in Asterisk, and provide various methods of bridging call media between participants in a call.

 

The next sub-sections will include detail on each of the module types.

