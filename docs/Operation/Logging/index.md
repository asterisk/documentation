---
title: Overview
pageid: 27200200
---

Logging in Asterisk is a powerful mechanism that can be utilized to extract vital information from a running system. Asterisk currently has the capability to log messages to a variety of places that include files, consoles, and the syslog facility. Logging in Asterisk is configured in the logger.conf file. See [Logging Configuration](/Configuration/Core-Configuration/Logging-Configuration) page for more information.

Along with the options defined in the logger configuration file, [commands are available at runtime](/Basic-Logging-Commands) that allow a user to manipulate and even override certain settings via the CLI. Additionally [flags are available](/Operation/Logging/Basic-Logging-Start-up-Options) with the Asterisk binary that allow similar configuration.

Most of the configuration for logging is concerning the activation or direction of various logging channels and their verbosity. It is important to note that the verbosity of logging messages is independent between root (or foreground) consoles and remote consoles. An example is provided in the [Verbosity in Core and Remote consoles sub-section](/Operation/Logging/Verbosity-in-Core-and-Remote-Consoles).

**Dialplan Logging Applications**
---------------------------------

Logging can also be done in the dialplan utilizing the following applications:

##### Log(<level>, <message>)

Send arbitrary text to a selected log level, which must be one of the following: ERROR, WARNING, NOTICE, DEBUG, or VERBOSE.

##### Verbose([<level>,] <message>)

Send arbitrary text to verbose output.  "Level" here is an optional integer value (defaults to 0) specifying the verbosity level at which to output the message. 

**Other Logging Resources**
---------------------------

For information about extensive and detailed tracing of queued calls see the [queue logs](/Queue-Logs) page.  For instructions on how to help administrators and support givers to more quickly understand problems that occur during the course of calls see [call identifier logging](/Call-Identifier-Logging) page.  Also, if a problem is suspected see [collecting debug information](/Collecting-Debug-Information) for help on how to collect debugging logs from an Asterisk machine (this can greatly help support and bug marshals).  For details about logging security specific events see the [asterisk security event logger](/Asterisk-Security-Event-Logger) page.  Lastly, for advice on logging event data that can be grouped together to form a billing record see the [channel event logging (CEL)](/Configuration/Reporting/Channel-Event-Logging-CEL) page.

