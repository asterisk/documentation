---
title: CEL Applications and Functions
pageid: 5242939
---

Applications
============

The [CELGenUserEvent](/Asterisk-13-Application_CELGenUserEvent) application allows you to instruct Asterisk to generate a user defined event with custom type name.

The event triggered is the **`USER_DEFINED`** event as listed in the [Asterisk 12 CEL Specification](/Asterisk-12-CEL-Specification). The **`eventtype`** and **`userdeftype`** fields will be populated with data passed through the respective arguments provided to the CELGenUserEvent application.




!!! warning 
    Please note that there is no restrictions on the name supplied. If it happens to match a standard CEL event name, it will look like that event was generated. This could be a blessing or a curse!

      
[//]: # (end-warning)



 

Functions
=========

Most CEL fields are populated by common channel data, so a unique function is not required to read or write that data on the channel. That channel data is already available via the [CHANNEL function](/Asterisk-13-Function_CHANNEL) in currently supported versions of Asterisk.

Older versions of Asterisk had a unique CEL function. You can run "core show function CEL" to see if you have this function and display the help text.

 

