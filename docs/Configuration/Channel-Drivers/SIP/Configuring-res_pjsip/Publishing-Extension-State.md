---
title: Publishing Extension State
pageid: 35226132
---

Background
----------

Functionality exists within PJSIP, as of Asterisk 14, that allows extension state to be published to another entity, commonly referred to as an event state compositor. Instead of each device subscribing to Asterisk and receiving a NOTIFY as extension state changes, PJSIP can be configured to send a single PUBLISH request for each extension state change to the other entity. These PUBLISH requests are triggered based on extension state changes made to hints in the dialplan.

![](Publishing.png)

Why Do It
---------

Publishing extension state allows the SUBSCRIBE and NOTIFY functionality to be handled by the other entity. Each device subscribes to the event state compositor and receives NOTIFY messages from it instead. This can scale further as less state is present in Asterisk, and also allows multiple Asterisk instances to be used while still making extension state available to everyone from the central event state compositor.

![](Publishing-Full.png)

What Can Be Published?
----------------------

PJSIP has a pluggable body type system.  Any type that can be subscribed to for extension state can be published. As of this writing the available body types are:

* application/dialog-info+xml
* application/pidf+xml
* application/xpidf+xml
* application/cpim-pidf+xml

The PUBLISH request will contain the same body that a NOTIFY request would.

Configuration
-------------

The publishing of extension state is configured by specifying an **outbound publish** in the pjsip.conf configuration file. This tells PJSIP how to publish to another entity and gives it information about what to publish. The outbound publishing of extension state has some additional arguments, though, which allow more control.

 

The **@body** option specifies what body type to publish. This is a required option.

The **@context** option specifies a filter for context. This is a regular expression and is optional.

The **@exten** option specifies a filter for extensions. This is a regular expression and is optional.

An additional option which is required on the outbound publish is the **multi_user**option. This enables support in the outbound publish module for publishing to different users. This is needed for extension state publishing so the specific extension can be published to. Without this option enabled all PUBLISH requests would go to the same user.

Example Configuration
---------------------

#### This configuration would limit outbound publish to only extension state changes as a result of a hint named "1000" in the context "users".




---

  
  


```

[test-esc]
type=outbound-publish
server_uri=sip:172.16.0.100
from_uri=sip:172.16.0.100
event=dialog
multi_user=yes
@body=application/dialog-info+xml
@context=^users
@exten=^1000

```


#### This configuration would limit outbound publish to all extension state changes a result of hints in the context "users".




---

  
  


```

[test-esc]
type=outbound-publish
server_uri=sip:172.16.0.100
from_uri=sip:172.16.0.100
event=dialog
multi_user=yes
@body=application/dialog-info+xml
@context=^users

```


You are also not limited to a single configured outbound publish. You can have as many as you want, provided they have different names. Each one can go to the same server with a different body type, or to different servers.

What About Making It More Dynamic?
----------------------------------

As part of the work to implement the publishing of extension state, the concept of **autohints** were also created. Autohints are created automatically as a result of a device state change. The extension name used is the name of the device, without the technology. They can be enabled by setting "autohints=yes" in a context in extensions.conf like so:




---

  
  


```

[users]
autohints=yes


```


For example, once enabled, if a device state change occurs for "PJSIP/alice" and no hint named "alice" exists, then one will be automatically created in lieu of explicit definition of the following:




---

  
  


```

exten => alice,hint,PJSIP/alice

```


Despite being added after startup, this hint will still be given to the extension state publishing for publishing.

The Other Entity
----------------

Throughout this page, I've mentioned another entity; but what can you use? Kamailio! Kamailio has event state compositor support available using the [presence module](http://kamailio.org/docs/modules/4.4.x/modules/presence.html). It can be configured to accept SUBSCRIBE and PUBLISH requests, persist information in a database, and to then send NOTIFY messages to each subscribed device. The module exports the handle_publish and handle_subscribe functions for handling each.  


