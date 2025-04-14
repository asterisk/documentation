---
title: Mobile Channel Features
pageid: 4817194
---

* Multiple Bluetooth Adapters supported.
* Multiple phones can be connected.
* Multiple headsets can be connected.
* Asterisk automatically connects to each configured mobile phone / headset when it comes in range.
* CLI command to discover bluetooth devices.
* Inbound calls on the mobile network to the mobile phones are handled by Asterisk, just like inbound calls on a Zap channel.
* CLI passed through on inbound calls.
* Dial outbound on a mobile phone using Dial(Mobile/device/nnnnnnn) in the dialplan.
* Dial a headset using Dial(Mobile/device) in the dialplan.
* Application MobileStatus can be used in the dialplan to see if a mobile phone / headset is connected.
* Supports devicestate for dialplan hinting.
* Supports Inbound and Outbound SMS.
* Supports 'channel' groups for implementing 'GSM Gateways'
