---
search:
  boost: 0.5
title: PJSIPHangup
---

# PJSIPHangup

### Synopsis

Hangup an incoming PJSIP channel with a SIP response code

### Description

Hangs up an incoming PJSIP channel and returns the specified SIP response code in the final response to the caller.<br>

<br>


/// warning
This function must be called BEFORE anything that might cause any other final (non 1XX) response to be sent. For example calling 'Answer()' or 'Playback' without the 'noanswer' option will cause the call to be answered and a final 200 response to be sent.
///

<br>

The cause code set on the channel will be translated to a standard ISDN cause code using the table defined in ast\_sip\_hangup\_sip2cause() in res\_pjsip.c<br>

<br>

``` title="Example: Terminate call with 437 response code"

Action: PJSIPHangup
ActionID: 12345678
Channel: PJSIP/alice-00000002
Cause: 437

			
```
``` title="Example: Terminate call with 437 response code using the response code name"

Action: PJSIPHangup
ActionID: 12345678
Channel: PJSIP/alice-00000002
Cause: UNSUPPORTED_CERTIFICATE

		
```

### Syntax


```


Action: PJSIPHangup
ActionID: <value>
Channel: <value>
Cause: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The exact channel name to be hungup, or to use a regular expression, set this parameter to: /regex/<br>
Example exact channel: SIP/provider-0000012a<br>
Example regular expression: /\^SIP/provider-.*$/<br>

* `Cause` - May be one of...<br>

    * `Response code` - A numeric response code in the range 400 ->699<br>

    * `Response code name` - A response code name from 'third-party/pjproject/source/pjsip/include/pjsip/sip\_msg.h' such as 'USE\_IDENTITY\_HEADER' or 'PJSIP\_SC\_USE\_IDENTITY\_HEADER'<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 