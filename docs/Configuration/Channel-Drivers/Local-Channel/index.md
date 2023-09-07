---
title: Overview
pageid: 4817170
---

## Overview

Most [Channel Drivers](/Configuration/Channel-Drivers) in Asterisk provide capability to connect Asterisk to external devices via specific protocols (e.g. [chan_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip)), whereas Local Channels provide a channel type for calling back into Asterisk itself.

That is, when dialing a Local Channel you are dialing within Asterisk into the Asterisk [dialplan](/Configuration/Dialplan).

Usage of Local Channels between other channel technologies can add additional programmatic flexibility, but of course at some level of performance cost. Local Channels are often used to execute dialplan logic from [Applications](/Configuration/Applications) that would expect to connect directly with a channel.

Two of the most common areas where Local channels are used include members configured for queues, and in use [with callfiles](/Configuration/Channel-Drivers/Local-Channel/Local-Channel-Examples/Using-Callfiles-and-Local-Channels). Another interesting case could be that you want to ring multiple destinations, but with different information for each call, such as different callerID for each outgoing request.

In this section you'll find [Local Channel Examples](Local-Channel-Examples) that illustrate usage plus details on [Local Channel Optimization](Local-Channel-Optimization) and a list of [Local Channel Modifiers](Local-Channel-Modifiers).

## The Local Channel in Asterisk Architecture

Previous to Asterisk 12, Local Channel functionality was provided by the **chan_local** module. In Asterisk 12, chan_local was moved into the Asterisk system core and is no longer a [loadable module](/Configuration/Core-Configuration/Configuring-the-Asterisk-Module-Loader).



