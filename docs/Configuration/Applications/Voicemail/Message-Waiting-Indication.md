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

Providing MWI to chan_pjsip endpoints
--------------------------------------

Providing MWI to a chan_pjsip endpoint requires configuring the "**mailboxes**" option in either the **endpoint** type config section, or the **aor** section.

See the descriptions linked below which explain when to use the option in each section.

[Description of "mailboxes" option for the Endpoint section](/Latest_API/API_Documentation/Module_Configuration/res_pjsip#mailboxes)

[Description of "mailboxes" option for the AOR section](/Latest_API/API_Documentation/Module_Configuration/res_pjsip#mailboxes_1).

Configuring External MWI
========================

Let's look at configuring Asterisk to receive MWI from other systems.

Depending on your Asterisk version and configuration, there are a few different ways to configure receiving MWI from external sources.

1. **chan_sip**: outbound MWI subscriptions and receiving unsolicited MWI NOTIFY messages
2. **res_external_mwi**: A module providing an API for other systems to communicate MWI state to Asterisk
3. **chan_pjsip**: Setting `incoming_mwi_mailbox` on an endpoint






!!! note **  **res_pjsip
    : The functionality for outbound SIP subscription is not available in res_pjsip yet. Internal infrastructure is built that would allow it, so if this is something you want to work on, please contact the [Asterisk development community](http://www.asterisk.org/community/discuss).

      
[//]: # (end-note)



Outbound MWI subscription with chan_sip
----------------------------------------

Asterisk can subscribe to receive MWI from another SIP server and store it locally for retrieval by other phones. At this time, you can only subscribe using UDP as the transport. Format for the MWI register statement is:

```
;[general]
;mwi => user[:secret[:authuser]]@host[:port]/mailbox
;
; Examples:
;mwi => 1234:password@mysipprovider.example.com/1234
;mwi => 1234:password@myportprovider.example.com:6969/1234
;mwi => 1234:password:authuser@myauthprovider.example.com/1234
;mwi => 1234:password:authuser@myauthportprovider.example.com:6969/1234

```

MWI received will be stored in the 1234 mailbox of the SIP_Remote context. It can be used by other phones by setting their SIP peers "mailbox" option to the <mailbox_number>@SIP_Remote. e.g. mailbox=1234@SIP_Remote

Reception of unsolicited MWI NOTIFY with chan_sip
--------------------------------------------------

A chan_sip peer can be configured to receive unsolicited MWI NOTIFY messages and associate them with a particular mailbox.

```
;[somesippeer]
;unsolicited_mailbox=123456789

```

If the remote SIP server sends an unsolicited MWI NOTIFY message the new/old message count will be stored in the configured virtual mailbox. It can be used by any device supporting MWI by specifying mailbox=<configured value>@SIP_Remote as the mailbox for the desired SIP peer.

res_external_mwi
------------------

External sources can use the API provided by res_external_mwi to communicate MWI and mailbox state.

**Documentation Under Construction**

[Asterisk 12 Configuration_res_mwi_external](/Latest_API/API_Documentation/Module_Configuration/res_mwi_external)




!!! warning 
    res_external_mwi.so is mutually exclusive with app_voicemail.so. You'll have to load only the one you want to use.

      
[//]: # (end-warning)



chan_pjsip
-----------

The endpoint parameter `incoming_mwi_mailbox` (introduced in 13.18.0 and 14.7.0) takes a <`mailbox>@<context>` value.  When an unsolicited NOTIFY message is received ***from*** this endpoint with an event type of `message-summary` and the `incoming_mwi_mailbox` parameter is set, Asterisk will automatically publish the new/old message counts for the specified mailbox on the internal stasis bus for any other module to use.  For instance, if you have an analog phone and you specify `mailbox=userx@default` in chan_dahdi.conf, when a NOTIFY comes in on a pjsip endpoint with `incoming_mwi_mailbox=userx@default`, chan_dahdi will automatically pick that up and turn the MWI light on on the analog phone.



