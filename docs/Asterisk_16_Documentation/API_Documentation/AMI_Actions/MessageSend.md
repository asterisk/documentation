---
search:
  boost: 0.5
title: MessageSend
---

# MessageSend

### Synopsis

Send an out of call message to an endpoint.

### Description

### Syntax


```


    Action: MessageSend
    ActionID: <value>
    [Destination:] <value>
    [To:] <value>
    From: <value>
    Body: <value>
    Base64Body: <value>
    Variable: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Destination` - A To URI for the message. If Destination is provided, the To parameter can also be supplied and may alter the message based on the specified message technology.<br>
For backwards compatibility, if Destination is not provided, the To parameter must be provided and will be used as the message destination.<br>

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

* `To` - A To URI for the message if needed for the message technology being used to send this message. This can be a SIP(S) URI, such as 'Alice <sip:alice@atlanta.com>', or a string in the format 'alice@atlanta.com'.<br>
This parameter is required if the Destination parameter is not provided.<br>

    * __Technology: PJSIP__<br>
The 'to' parameter is used to specity the 'To:' header in the outgoing SIP MESSAGE. It will override the value specified in MESSAGE(to) which itself will override any 'to' value from an incoming SIP MESSAGE.<br>
<br>

    * __Technology: SIP__<br>
Ignored<br>

    * __Technology: XMPP__<br>
Ignored<br>

* `From` - A From URI for the message if needed for the message technology being used to send this message.<br>

    * __Technology: PJSIP__<br>
The 'from' parameter is used to specity the 'From:' header in the outgoing SIP MESSAGE. It will override the value specified in MESSAGE(from) which itself will override any 'from' value from an incoming SIP MESSAGE.<br>
<br>

    * __Technology: SIP__<br>
The 'from' parameter can be a configured peer name or in the form of "display-name" <URI>.<br>

    * __Technology: XMPP__<br>
Specifying a prefix of 'xmpp:' will specify the account defined in 'xmpp.conf' to send the message from. Note that this field is required for XMPP messages.<br>

* `Body` - The message body text. This must not contain any newlines as that conflicts with the AMI protocol.<br>

* `Base64Body` - Text bodies requiring the use of newlines have to be base64 encoded in this field. Base64Body will be decoded before being sent out. Base64Body takes precedence over Body.<br>

* `Variable` - Message variable to set, multiple Variable: headers are allowed. The header value is a comma separated list of name=value pairs.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 