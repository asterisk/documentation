---
title: Overview
pageid: 32375228
---

Conferencing with Asterisk
==========================

Up until about Asterisk 1.6; app_meetme was the main application providing conferencing style features. In Asterisk 1.6.2 the ConfBridge module was added and then rewritten in Asterisk 10.

Both MeetMe and ConfBridge still exist in the latest Asterisk versions and provide different feature sets, but with plenty of overlap. Development attention is primarily given to ConfBridge these days and it is the recommended option for modern deployments when using a pre-built application.

There is a detailed [description of ConfBridge functionality](/ConfBridge) on the wiki as well as [MeetMe application](/Asterisk-13-Application_MeetMe) usage notes.

Building your own conferencing application
------------------------------------------

Conferencing needs can be very specific to your business application. The conferencing applications included with Asterisk provide basic features that will work for many users.

If the included applications don't work for you then you might consider building your own application using the [Asterisk REST Interface](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Getting-Started-with-ARI). This will give you access to all the communication primitives needed and then you can write the logic you need in a language you are comfortable with.

