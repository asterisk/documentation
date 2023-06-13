---
title: Exchanging Device and Mailbox State Using PJSIP
pageid: 29393398
---

Background
----------

Asterisk has permitted the exchange of device and mailbox state for many versions. This has normally been accomplished using the res\_xmpp module for instances across networks or using res\_corosync for instances on the same network. This has required, in some cases, an extreme amount of work to setup. In the case of res\_xmpp this also adds another point of failure for the exchange in the form of the XMPP server itself. The res\_pjsip\_publish\_asterisk module on the other hand does not suffer from this.

Operation
---------

The res\_pjsip\_publish\_asterisk module establishes an optionally bidirectional or unidirectional relationship between Asterisk instances. When the device or mailbox state on one Asterisk changes it is sent to the other Asterisk instance using a PUBLISH message containing an Asterisk specific body. This body is comprised of JSON and contains the information required to reflect the remote state change. For situations where you may not want to expose all states or you may not want to allow all states to be received you can optionally filter using a regular expression. This limits the scope of traffic.

Configuration
-------------

Configuring things to exchange state requires a few different objects: endpoint, publish, asterisk-publication, and optionally auth. These all configure a specific part in the exchange. An endpoint must be configured as a fundamental part of PJSIP is that **all** incoming requests are associated with an endpoint. A publish object tells the res\_pjsip\_outbound\_publish where to send the PUBLISH and what type of PUBLISH message to send. An asterisk-publication object configures handling of PUBLISH messages, including whether they are permitted and from whom. Last you can optionally use authentication so that PUBLISH messages are challenged for credentials.

Example Configuration
---------------------

The below configuration is for two Asterisk instances sharing all device and mailbox state between them.

#### Instance #1 (IP Address: 172.16.10.1):

[instance2]
type=endpoint

[instance2-devicestate]
type=outbound-publish
server\_uri=sip:instance1@172.16.10.2
event=asterisk-devicestate

[instance2-mwi]
type=outbound-publish
server\_uri=sip:instance1@172.16.10.2
event=asterisk-mwi
 
[instance2]
type=inbound-publication
event\_asterisk-devicestate=instance2
event\_asterisk-mwi=instance2

[instance2]
type=asterisk-publication
devicestate\_publish=instance2-devicestate
mailboxstate\_publish=instance2-mwi
device\_state=yes
mailbox\_state=yesThis configures the first instance to publish device and mailbox state to 'instance 2' located at 172.16.10.2 using a resource name of 'instance1' without authentication. As no filters exist all state will be published. It also configures the first instance to accept all device and mailbox state messages published to a resource named 'instance2' from 'instance2'.

#### Instance #2 (IP Address: 172.16.10.2):

[instance1]
type=endpoint

[instance1-devicestate]
type=outbound-publish
server\_uri=sip:instance2@172.16.10.1
event=asterisk-devicestate
 
[instance1-mwi]
type=outbound-publish
server\_uri=sip:instance2@172.16.10.1
event=asterisk-mwi
 
[instance1]
type=inbound-publication
event\_asterisk-devicestate=instance1
event\_asterisk-mwi=instance1

[instance1]
type=asterisk-publication
devicestate\_publish=instance1-devicestate
mailboxstate\_publish=instance1-mwi
device\_state=yes
mailbox\_state=yesThis configures the second instance to publish device and mailbox state to 'instance 1' located at 172.16.10.1 using a resource name of 'instance2' without authentication. As no filters exist all state will be published. It also configures the second instance to accept all device and mailbox state messages published to a resource named 'instance1' from 'instance1'.

Filtering
---------

As previously mentioned state events can be filtered by the device or mailbox they relate to using a regular expression. This is configured on 'publish' types using '@device\_state\_filter' and '@mailbox\_state\_filter' and on 'asterisk-publication' types using 'device\_state\_filter' and 'mailbox\_state\_filter'. As each event is sent or received the device or mailbox is given to the regular expression and if it does not match the event is stopped.

#### Example

[instance1]
type=endpoint

[instance1-devicestate]
type=outbound-publish
server\_uri=sip:instance2@172.16.10.1
event=asterisk-devicestate

[instance1-mwi]
type=outbound-publish
server\_uri=sip:instance2@172.16.10.1
event=asterisk-mwi
 
[instance1]
type=inbound-publication
event\_asterisk-devicestate=instance1
event\_asterisk-mwi=instance1

[instance1]
type=asterisk-publication
devicestate\_publish=instance1-devicestate
mailboxstate\_publish=instance1-mwi
device\_state=yes
device\_state\_filter=^PJSIP/
mailbox\_state=yes
mailbox\_state\_filter=^1000
 This builds upon the initial configuration for instance #2 but adds filtering of received events. Only device state events relating to PJSIP endpoints will be accepted. As well only mailbox state events for mailboxes starting with 1000 will be accepted.

This configuration is not ideal as the publishing instance (instance #1) will still send state changes for devices and mailboxes that instance #2 does not care about, thus wasting bandwidth.

Fresh Startup
-------------

When the res\_pjsip\_publish\_asterisk module is loaded it will send its own current states for all applicable devices and mailboxes to all configured 'publish' types. Instances may optionally be configured to send a refresh request to 'publish' types as well by setting the 'devicestate\_publish' and/or 'mailboxstate\_publish' option in the 'asterisk-publication' type. This refresh request causes the remote instances to send current states for all applicable devices and mailboxes back, bringing the potentially newly started Asterisk up to date with its peers.

