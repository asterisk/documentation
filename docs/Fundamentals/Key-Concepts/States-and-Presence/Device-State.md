---
title: Device State
pageid: 28934187
---

Devices
=======

Devices are discrete components of functionality within Asterisk that serve a particular task. A device may be a channel technology resource, such as SIP/<name> in the case of chan_sip.so or a feature resource of another module such as app_confbridge.so which provides devices like confbridge:<name>.

State information
-----------------

Asterisk devices make state information available to the Asterisk user, such that a user might make use of the information to affect call flow or behavior of the Asterisk system. The device state identifier for a particular device is typically very similar to the device name. For example the device state identifier for SIP/6001 would be SIP/6001, for confbridge 7777 it would be confbridge:7777. Device states have a one-to-one mapping to the device they represent. That is opposed to other state providers in Asterisk which may have one-to-many relationships, such as Extension State.

The [Querying and Manipulating State](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State) section covers how to access or manipulate device state as well as other states.

Common Device State Providers
=============================

*Device state providers* are the components of Asterisk that provide some state information for their resources. The device state providers available in Asterisk will depend on the version of Asterisk you are using, what modules you have installed and how those modules are configured. Here is a list of the common *device state identifiers* you will see and what Asterisk component provides the resources and state.

On this Page

| Device State Identifier | Device State Provider |
| --- | --- |
| PJSIP/<resource> | PJSIP SIP stack, res_pjsip.so, chan_pjsip.so. |
| SIP/<resource> | The older SIP channel driver, chan_sip.so. |
| DAHDI/<resource> | The popular telephony hardware interface driver, chan_dahdi.so. |
| IAX2/<resource> | Inter-Asterisk Exchange protocol! chan_iax2.so. |
| ConfBridge:<resource> | The conference bridge application, app_confbridge.so. |
| MeetMe:<resource> | The older conference bridging app, app_meetme.so. |
| Park:<resource> | The Asterisk core in versions up to 11.res_parking.so in versions 12 or greater. |
| Calendar:<resource> | res_calendar.so and related calendaring modules. |
| Custom:<resource> | Custom device state provided by the asterisk core. |

Note that we are not differentiating any device state providers based on what is on the far end. Depending on device state provider, the far end of signaling for state could be a physical device, or just a discrete feature resource inside of Asterisk.  In terms of understanding device state for use in Asterisk, it doesn't really matter. The device state represents the state of the Asterisk device as long as it is able to provide it regardless of what is on the far end of the communication path.

Custom Device States
--------------------

The Asterisk core provides a *Custom* device state provider (custom:<resource>) that allows you to define arbitrary device state resources. See the [Querying and Manipulating State](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State) section for more on using custom device state.

Possible Device States
======================

Here are the possible states that a device state may have.

* UNKNOWN
* NOT_INUSE
* INUSE
* BUSY
* INVALID
* UNAVAILABLE
* RINGING
* RINGINUSE
* ONHOLD

Though the label for each state carries a certain connotation, the actual meaning of each state is really up to the device state provider. That is, any particular state may mean something different across device state providers.

Module Specific Device State
============================

There is module specific configuration that you must be aware of to get optimal behavior with certain state providers.

For **chan_sip** see the [chan_sip State and Presence Options](/Configuration/Channel-Drivers/SIP/Configuring-chan_sip/chan_sip-State-and-Presence-Options) section.

For **res_pjsip** see the [Configuring res_pjsip for Presence Subscriptions](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Configuring-res_pjsip-for-Presence-Subscriptions) section.
