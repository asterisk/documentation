---
title: Overview
pageid: 27200287
---

Overview
========

There are many ways to interface Asterisk with scripts, other applications or storage systems. From the very trivial, such as using Asterisk Call Files, to sophisticated APIs such as the Asterisk Rest Interface. The pages in this section cover many of Asterisk's built-in interfaces, all of which provide some aspect of control, monitoring or storage.

In this Section

| Interface | Description |
| --- | --- |
| Asterisk Call Files | Asterisk can initiate calls based on information provided via flat text files in a spool directory. Asterisk can operate on these as soon as the file is inside the directory, or in the future depending on the timestamp of the file. |
| Asterisk External Application Protocol | AEAP is an API, and protocol that is used to connect and communicate with an application external to Asterisk. Currently, it's used to implement a speech to text engine that connects to an external application. |
| Asterisk Gateway Interface | AGI provides an interface between the Asterisk dialplan and an external program (via pipes, stdin and stdout) that wants to manipulate a channel in the dialplan. |
| Asterisk Management Interface**\*** | AMI is intended for management type functions. The manager is a client/server model over TCP. With the AMI you'll be able to control the PBX, originate calls, check mailbox status, monitor channels and queues as well as execute Asterisk commands. |
| Asterisk REST Interface**\*** | ARI is an asynchronous API that allows developers to build communications applications by exposing the raw primitive objects in Asterisk - channels, bridges, endpoints, media, etc. - through an intuitive REST interface. The state of the objects being controlled by the user are conveyed via JSON events over a WebSocket. |
| Calendaring | Asterisk's calendaring module allows read and write communication with various standardized calendar technologies. Asterisk dialplan can make use of calendar event information. |
| Database Connectivity | Asterisk has core support for ODBC connectivity, and many Asterisk modules provide support for a variety of back-end database connectivity, such as for MySQL or PostgreSQL. |
| Distributed Device State | Asterisk provides a few ways of distributing the state of devices between multiple Asterisk instances, whether on the same system or multiple systems. |
| SNMP | Basic SNMP support is included with Asterisk. This allows monitoring of a variety of Asterisk activity. |
| Speech Recognition API | The dialplan speech recognition API is based around a single speech utilities application file, which exports many applications to be used for speech recognition. These include an application to prepare for speech recognition, activate a grammar, and play back a sound file while waiting for the person to speak. Using a combination of these applications you can easily make a dialplan use speech recognition without worrying about what speech recognition engine is being used. |
| StatsD | This StatsD application is a dialplan application that is used to send statistics automatically whenever a call is made to an extension that employs the application. The user must provide the arguments to the application in the dialplan, but after that, the application will send statistics to StatsD without requiring the user to perform anymore actions whenever a call comes through that extension. |

**\*** Event ordering is not guaranteed. Applications monitoring events from these interfaces should be aware that the order between received events is not assured unless otherwise, and elsewhere specified. For example, an event monitoring application may receive the following events: A->B->C. However, later it might receive those same events, but in a different order: B->A->C
