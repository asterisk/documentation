---
title: Asterisk Architecture, The Big Picture
pageid: 4817479
---

Before we dive too far into the various types of modules, let's first take a step back and look at the overall architecture of Asterisk.

Asterisk a big program with many components, with complex relationships. To be able to use it, you don't have to know how everything relates in extreme detail. Below is a simplified diagram intended to illustrate the relationships of some major components to each other and to entities outside Asterisk. It is useful to understand how a component may relate to things outside Asterisk as Asterisk is not typically operating without some connectivity or interaction with other network devices or files on the local system.

An Asterisk System
==================

![](AsteriskArchitecture.png)

Remember this is not an exhaustive diagram. It covers only a few of the common relationships between certain components.

Asterisk Architecture
=====================

![](bigpicture.png)

Asterisk has a **core** that can interact with many **modules**. Modules called channel drivers provide **channels** that follow Asterisk **dialplan** to execute programmed behavior and facilitate communication between devices or programs outside Asterisk. Channels often use **bridging** infrastructure to interact with other channels. We'll describe some of these concepts in brief below.

The Core
--------

The heart of any Asterisk system is the **core**. The PBX core is the essential component that provides a lot of infrastructure. Among many functions it reads the configuration files, including dialplan and loads all the other **modules**, distinct components that provide more functionality.

The core loads and builds the dialplan, which is the logic of any Asterisk system. The [dialplan](/Configuration/Dialplan) contains a list of instructions that Asterisk should follow to know how to handle incoming and outgoing **calls** on the system.

Modules
-------

Other than functionality provided by the core of Asterisk, modules provide all other functionality. The source for many modules is distributed with Asterisk, though other modules may be available from community members or even businesses that make commercial modules. The modules distributed with Asterisk can be o[ptionally be built](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) when Asterisk is built.

Modules are not only optionally built, but you can affect at load-time whether they will be loaded at all, the loading order or even unload/load them during run-time. Most modules are independently configurable and have their own [configuration](/Configuration) files. Some modules have support for configuration to be read statically or dynamically(realtime) from database backends.

From a logistical standpoint, these modules are typically files with a **.so** file extension, which live in the Asterisk [modules directory](/Fundamentals/Directory-and-File-Structure) (which is typically  */usr/lib/asterisk/modules**). When [Asterisk starts up](/Operation/Running-Asterisk), it loads these files and adds their functionality to the system.

Asterisk modules which are part of the core have a file name that look like **pbx_xxxxx.so**. All of the modules types are discussed in the section [Types of Asterisk Modules](/Fundamentals/Asterisk-Architecture/Types-of-Asterisk-Modules).




!!! tip A Plethora of Modules
    Take just a minute and go look at the Asterisk modules directory on your system. You should find a wide variety of modules. A default installation of Asterisk has over one hundred fifty different modules!  
[//]: # (end-tip)



### A Few Module Examples

* **chan_pjsip** uses **res_pjsip** and many other res_pjsip modules to provide a SIP stack for SIP devices to interact with Asterisk and with each other through Asterisk.
* **app_voicemail** provides traditional PBX-type voicemail features.
* **app_confbridge** provides conference bridges with many optional features.
* **res_agi** provides the Asterisk Gateway Interface, an API that allows call control from external scripts and programs.

Calls and Channels
------------------

The primary purpose of Asterisk is being an engine for building Real Time Communication systems and applications.

In most but not all cases this means you'll deal with the concept of "calls". Calls in telephony terminology typically refer to one phone communicating with (calling) another phone over a medium, such as a [PSTN](http://en.wikipedia.org/wiki/Public_switched_telephone_network) line. However in the case of Asterisk a call typically references one or more [**channels**](/Fundamentals/Key-Concepts/Channels) existing in Asterisk.

Here are some example "calls".

* A phone calling another phone through Asterisk.
* A phone calling many phones at once (for example, paging) through Asterisk.
* A phone calls an application or the reverse happens. e.g., app_voicemail or app_queue
* A local channel is created and interacts with an application or another channel.

Note that I primarily use phones as an example, however you could refer to any channel or group of channels as a call. It doesn't matter if the devices are phones or something else, like an alarm system sensor or garage door opener.

### Channels

[Channels](/Fundamentals/Key-Concepts/Channels) are created by Asterisk using [Channel Drivers](/Configuration/Channel-Drivers). They can utilize other resources in the Asterisk system to facilitate various types of communication between one or more devices. Channels can be **bridged** to other channels and be affected by [**applications**](/Configuration/Applications) and [**functions**](/Configuration/Functions). Channels can make use of many other resources provided by other modules or external libraries. For example SIP channels when passing audio will make use of the **codec** and **format** modules. Channels may interact with many different modules at once.

Dialplan
--------

Dialplan is the one main method of directing Asterisk behavior. Dialplan exists as text files (for example extensions.conf) either in the built-in dialplan scripting language, AEL or LUA formats. Alternatively dialplan could be read from a [database](/Fundamentals/Asterisk-Configuration/Database-Support-Configuration), along with other module configuration. When writing dialplan, you will make heavy use of **applications** and **functions**to affect channels, configuration and features.

Dialplan can also call out through other interfaces such as [AGI](/Latest_API/API_Documentation/Dialplan_Applications/AGI) to receive call control instruction from external scripts and programs. The [Dialplan](/Configuration/Dialplan) section of the wiki goes into detail on the usage of dialplan.  

