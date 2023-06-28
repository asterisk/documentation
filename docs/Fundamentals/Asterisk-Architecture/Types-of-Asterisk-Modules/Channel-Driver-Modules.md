---
title: Channel Driver Modules
pageid: 4817483
---

All calls from the outside of Asterisk go through a channel driver before reaching the core, and all outbound calls go through a channel driver on their way to the external device.

The PJSIP channel driver (chan_pjsip), for example, communicates with external devices using the SIP protocol. It translates the SIP signaling into the core. This means that the core of Asterisk is signaling agnostic. Therefore, Asterisk isn't just a SIP or VOIP communications engine, it's a multi-protocol engine.

For more information on the various channel drivers, see the configuration section for [Channel Drivers](/Configuration/Channel-Drivers).

All channel drivers have a file name that look like **chan_xxxxx.so**, such as **chan_pjsip.so** or **chan_dahdi.so**. 

