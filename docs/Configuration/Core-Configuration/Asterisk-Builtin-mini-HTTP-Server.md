---
title: Asterisk Builtin mini-HTTP Server
pageid: 28315001
---

Overview
========

The core of Asterisk provides a basic HTTP/HTTPS server.

Certain Asterisk modules may make use of the HTTP service, such as the [Asterisk Manager Interface](/Asterisk-Manager-Interface--AMI-) over HTTP, the [Asterisk Restful Interface](/Getting-Started-with-ARI) or WebSocket transports for modules that support that, like chan\_sip or chan\_pjsip.

Configuration
=============

The configuration sample file is [by default](/Directory-and-File-Structure) located at /etc/asterisk/http.conf

A very basic configuration of http.conf could be as follows:




---

  
  


```

[general]
enabled=yes
bindaddr=0.0.0.0
bindport=8088

```



---


That configuration would enable the HTTP server and have it bind to all available network interfaces on port 8088.

Configuration Options
=====================

See the sample file in your version of Asterisk for detail on the various configuration options, as this information is not yet automatically pushed to the wiki.  


