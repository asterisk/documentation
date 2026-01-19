---
search:
  boost: 0.5
title: MessageSend
---

# MessageSend()

### Synopsis

Send a text message.

### Description

Send a text message. The body of the message that will be sent is what is currently set to 'MESSAGE(body)'. This may he come from an incoming message. The technology chosen for sending the message is determined based on a prefix to the 'destination' parameter.<br>

This application sets the following channel variables:<br>


* `MESSAGE_SEND_STATUS` - This is the message delivery status returned by this application.<br>

    * `INVALID\_PROTOCOL` - No handler for the technology part of the URI was found.

    * `INVALID\_URI` - The protocol handler reported that the URI was not valid.

    * `SUCCESS` - Successfully passed on to the protocol handler, but delivery has not necessarily been guaranteed.

    * `FAILURE` - The protocol handler reported that it was unabled to deliver the message for some reason.

### Syntax


```

MessageSend(destination,[from,[to]])
```
##### Arguments


* `destination` - A To URI for the message.<br>

    * __Technology: PJSIP__<br>
The 'destination' parameter is used to construct the Request URI for an outgoing message. It can be in one of the following formats, all prefixed with the 'pjsip:' message tech.<br>
<br>

        * `endpoint` - Request URI comes from the endpoint's default aor and contact.<br>

        * `endpoint/aor` - Request URI comes from the specific aor/contact.<br>

        * `endpoint@domain` - Request URI from the endpoint's default aor and contact. The domain is discarded.<br>
<br>
These all use the endpoint to send the message with the specified URI:<br>
<br>

        * `endpoint/<sip[s]:host>>`

        * `endpoint/<sip[s]:user@host>`

        * `endpoint/"display name" <sip[s]:host>`

        * `endpoint/"display name" <sip[s]:user@host>`

        * `endpoint/sip[s]:host`

        * `endpoint/sip[s]:user@host`

        * `endpoint/host`

        * `endpoint/user@host`
<br>
These all use the default endpoint to send the message with the specified URI:<br>
<br>

        * `<sip[s]:host>`

        * `<sip[s]:user@host>`

        * `"display name" <sip[s]:host>`

        * `"display name" <sip[s]:user@host>`

        * `sip[s]:host`

        * `sip[s]:user@host`
<br>
These use the default endpoint to send the message with the specified host:<br>
<br>

        * `host`

        * `user@host`
<br>
This form is similar to a dialstring:<br>
<br>

        * `PJSIP/user@endpoint`
<br>
You still need to prefix the destination with the 'pjsip:' message technology prefix. For example: 'pjsip:PJSIP/8005551212@myprovider'. The endpoint contact's URI will have the 'user' inserted into it and will become the Request URI. If the contact URI already has a user specified, it will be replaced.<br>
<br>

    * __Technology: SIP__<br>
Specifying a prefix of 'sip:' will send the message as a SIP MESSAGE request.<br>

    * __Technology: XMPP__<br>
Specifying a prefix of 'xmpp:' will send the message as an XMPP chat message.<br>

* `from` - A From URI for the message if needed for the message technology being used to send this message. This can be a SIP(S) URI, such as 'Alice <sip:alice@atlanta.com>', or a string in the format 'alice@atlanta.com'. This will override a 'from' specified using the MESSAGE dialplan function or the 'from' that may have been on an incoming message.<br>

    * __Technology: PJSIP__<br>
The 'from' parameter is used to specity the 'From:' header in the outgoing SIP MESSAGE. It will override the value specified in MESSAGE(from) which itself will override any 'from' value from an incoming SIP MESSAGE.<br>
<br>

    * __Technology: SIP__<br>
The 'from' parameter can be a configured peer name or in the form of "display-name" <URI>.<br>

    * __Technology: XMPP__<br>
Specifying a prefix of 'xmpp:' will specify the account defined in 'xmpp.conf' to send the message from. Note that this field is required for XMPP messages.<br>

* `to` - A To URI for the message if needed for the message technology being used to send this message. This should be a SIP(S) URI, such as 'Alice <sip:alice@atlanta.com>'. This will override a 'to' specified using the MESSAGE dialplan function or the 'to' that may have been on an incoming message.<br>

    * __Technology: PJSIP__<br>
The 'to' parameter is used to specity the 'To:' header in the outgoing SIP MESSAGE. It will override the value specified in MESSAGE(to) which itself will override any 'to' value from an incoming SIP MESSAGE.<br>
<br>

    * __Technology: SIP__<br>
Ignored<br>

    * __Technology: XMPP__<br>
Ignored<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 