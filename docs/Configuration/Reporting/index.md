---
title: Overview
pageid: 27200283
---

Asterisk has two reporting systems. **Call Detail Records (CDR)** and **Channel Event Logging (CEL)**. Both of these systems log specific events that occur on calls and individual channels. The events and their details are provided in a machine readable format separate from Asterisk's standard logging and debug facilities. Both systems provide at least CSV output and utilize other modules to output through a variety of back-end interfaces.

In This Section[Call Detail Records](/Configuration/Reporting/Call-Detail-Records-CDR) is the older system that provides one or more records for each call depending on what version of Asterisk you are using and what is happening in the call. It is useful for administrators who need a simple way to track what calls have taken place on the Asterisk system. It isn't recommended for generating billing data.

[Channel Event Logging](/Configuration/Reporting/Channel-Event-Logging-CEL) is the newer system that provides much more detail than CDR. CEL is designed to excel where CDR fails and this is noticed first in the amount of detail that CEL provides. For any given calling scenario CDR may produce one or two simple records compared to dozens of records for CEL. If you want very precise data on every call happening in Asterisk then you should use CEL. Hence, CEL is the recommended reporting system to use for generating billing data.

If you are looking for logging, debugging or Application Programming Interfaces then you should check out the following resources:

* [Asterisk Logging](/Logging) and [Asterisk Logging Configuration](/Configuration/Core-Configuration/Logging-Configuration)
* [Asterisk Interfaces](/Configuration/Interfaces)
