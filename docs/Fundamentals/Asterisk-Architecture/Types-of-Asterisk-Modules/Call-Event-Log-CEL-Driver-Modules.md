---
title: Channel Event Log (CEL) Driver Modules
pageid: 4817498
---

Channel Event Logs record the various actions that happen on a call. As such, they are typically more detailed that call detail records. For example, a call event log might show that Alice called Bob, that Bob's phone rang for twenty seconds, then Bob's mobile phone rang for fifteen seconds, the call then went to Bob's voice mail, where Alice left a twenty-five second voicemail and hung up the call. The system also allows for custom events to be logged as well.

For more information about Channel Event Logging, see [Channel Event Logging](/Configuration/Reporting/Channel-Event-Logging-CEL).

Channel event logging modules have file names that look like **cel_xxxxx.so**, such as **cel_custom.so** and **cel_adaptive_odbc.so**.
