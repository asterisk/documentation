---
title: Message Waiting Indication
pageid: 27199807
---

What is MWI?
============

This page explains the resources available for Message Waiting Indicator(or Indication) functionality in Asterisk and how to configure.

**Documentation Under Construction**

Configuring MWI
===============

Here we talk about configuring Asterisk to provide MWI to endpoints or other systems.

Providing MWI to chan\_pjsip endpoints
--------------------------------------

Providing MWI to a chan\_pjsip endpoint requires configuring the "**mailboxes**" option in either the **endpoint** type config section, or the **aor** section.

See the descriptions linked below which explain when to use the option in each section.

[Description of "mailboxes" option for the Endpoint section](https://wiki.asterisk.org/wiki/display/AST/Asterisk+12+Configuration_res_pjsip#Asterisk12Configuration_res_pjsip-endpoint_mailboxes)

[Description of "mailboxes" option for the AOR section](https://wiki.asterisk.org/wiki/display/AST/Asterisk+12+Configuration_res_pjsip#Asterisk12Configuration_res_pjsip-aor_mailboxes).

Configuring External MWI
========================

Let's look at configuring Asterisk to receive MWI from other systems.

Depending on your Asterisk version and configuration, there are a few different ways to configure receiving MWI from external sources.

1. **chan\_sip**: outbound MWI subscriptions and receiving unsolicited MWI NOTIFY messages
2. **res\_external\_mwi**: A module providing an API for other systems to communicate MWI state to Asterisk
3. **chan\_pjsip**: Setting `incoming_mwi_mailbox` on an endpoint

 

**res\_pjsip**: The functionality for outbound SIP subscription is not available in res\_pjsip yet. Internal infrastructure is built that would allow it, so if this is something you want to work on, please contact the [Asterisk development community](http://www.asterisk.org/community/discuss).

Outbound MWI subscription with chan\_sip
----------------------------------------

Asterisk can subscribe to receive MWI from another SIP server and store it locally for retrieval by other phones. At this time, you can only subscribe using UDP as the transport. Format for the MWI register statement is:

;[general]
;mwi => user[:secret[:authuser]]@host[:port]/mailbox
;
; Examples:
;mwi => 1234:password@mysipprovider.example.com/1234
;mwi => 1234:password@myportprovider.example.com:6969/1234
;mwi => 1234:password:authuser@myauthprovider.example.com/1234
;mwi => 1234:password:authuser@myauthportprovider.example.com:6969/1234

MWI received will be stored in the 1234 mailbox of the SIP\_Remote context. It can be used by other phones by setting their SIP peers "mailbox" option to the <mailbox\_number>@SIP\_Remote. e.g. mailbox=1234@SIP\_Remote

Reception of unsolicited MWI NOTIFY with chan\_sip
--------------------------------------------------

A chan\_sip peer can be configured to receive unsolicited MWI NOTIFY messages and associate them with a particular mailbox.

;[somesippeer]
;unsolicited\_mailbox=123456789If the remote SIP server sends an unsolicited MWI NOTIFY message the new/old message count will be stored in the configured virtual mailbox. It can be used by any device supporting MWI by specifying mailbox=<configured value>@SIP\_Remote as the mailbox for the desired SIP peer.

res\_external\_mwi
------------------

External sources can use the API provided by res\_external\_mwi to communicate MWI and mailbox state.

**Documentation Under Construction**

res\_external\_mwi.so is mutually exclusive with app\_voicemail.so. You'll have to load only the one you want to use.

chan\_pjsip
-----------

The endpoint parameter `incoming_mwi_mailbox` (introduced in 13.18.0 and 14.7.0) takes a <`mailbox>@<context>` value.  When an unsolicited NOTIFY message is received ***from*** this endpoint with an event type of `message-summary` and the `incoming_mwi_mailbox` parameter is set, Asterisk will automatically publish the new/old message counts for the specified mailbox on the internal stasis bus for any other module to use.  For instance, if you have an analog phone and you specify `mailbox=userx@default` in chan\_dahdi.conf, when a NOTIFY comes in on a pjsip endpoint with `incoming_mwi_mailbox=userx@default`, chan\_dahdi will automatically pick that up and turn the MWI light on on the analog phone.

 

