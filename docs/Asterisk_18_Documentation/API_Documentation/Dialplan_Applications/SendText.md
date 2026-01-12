---
search:
  boost: 0.5
title: SendText
---

# SendText()

### Synopsis

Send a Text Message on a channel.

### Description

Sends _text_ to the current channel.<br>


/// note
current channel could be the caller or callee depending on the context in which this application is called.
///

<br>

The following variables can be set:<br>


* `SENDTEXT_FROM_DISPLAYNAME` - If set and this channel supports enhanced messaging, this value will be used as the 'From' display name.<br>

* `SENDTEXT_TO_DISPLAYNAME` - If set and this channel supports enhanced messaging, this value will be used as the 'To' display name.<br>

* `SENDTEXT_CONTENT_TYPE` - If set and this channel supports enhanced messaging, this value will be used as the message 'Content-Type'. If not specified, the default of 'text/plain' will be used.<br>
Warning: Messages of types other than text/* cannot be sent via channel drivers that do not support Enhanced Messaging. An attempt to do so will be ignored and will result in the SENDTEXTSTATUS variable being set to UNSUPPORTED.<br>

* `SENDTEXT_BODY` - If set this value will be used as the message body and any text supplied as a function parameter will be ignored.<br>
<br>

Result of transmission will be stored in the following variables:<br>


* `SENDTEXTTYPE`

    * `NONE` - No message sent.

    * `BASIC` - Message body sent without attributes because the channel driver doesn't support enhanced messaging.

    * `ENHANCED` - The message was sent using enhanced messaging.

* `SENDTEXTSTATUS`

    * `SUCCESS` - Transmission succeeded.

    * `FAILURE` - Transmission failed.

    * `UNSUPPORTED` - Text transmission not supported by channel.
<br>


/// note
The text encoding and transmission method is completely at the discretion of the channel driver. chan\_pjsip will use in-dialog SIP MESSAGE messages always. chan\_sip will use T.140 via RTP if a text media type was negotiated and in-dialog SIP MESSAGE messages otherwise.
///

<br>

Examples:<br>

``` title="Example: Send a simple message"

same => n,SendText(Your Text Here)


```
If the channel driver supports enhanced messaging (currently only chan\_pjsip), you can set additional variables:<br>

``` title="Example: Alter the From display name"

same => n,Set(SENDTEXT_FROM_DISPLAYNAME=Really From Bob)
same => n,SendText(Your Text Here)


```
``` title="Example: Send a JSON String"

same => n,Set(SENDTEXT_CONTENT_TYPE=text/json)
same => n,SendText({"foo":a, "bar":23})


```
``` title="Example: Send a JSON String (alternate)"

same => n,Set(SENDTEXT_CONTENT_TYPE=text/json)
same => n,Set(SENDTEXT_BODY={"foo":a, "bar":23})
same => n,SendText()


```

### Syntax


```

SendText([text])
```
##### Arguments


* `text`

### See Also

* [Dialplan Applications SendImage](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendImage)
* [Dialplan Applications SendURL](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendURL)
* [Dialplan Applications ReceiveText](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ReceiveText)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 