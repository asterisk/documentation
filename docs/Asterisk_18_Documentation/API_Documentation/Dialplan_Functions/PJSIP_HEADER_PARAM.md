---
search:
  boost: 0.5
title: PJSIP_HEADER_PARAM
---

# PJSIP_HEADER_PARAM()

### Synopsis

Get or set header/URI parameters on a PJSIP channel.

### Description

PJSIP\_HEADER\_PARAM allows you to read or set parameters in a SIP header on a PJSIP channel.<br>

Both URI parameters and header parameters can be read and set using this function. URI parameters appear in the URI (inside the <> in the header) while header parameters appear afterwards.<br>


/// note
If you call PJSIP\_HEADER\_PARAM in a normal dialplan context you'll be operating on the *caller's (incoming)* channel which may not be what you want. To operate on the *callee's (outgoing)* channel call PJSIP\_HEADER\_PARAM in a pre-dial handler.
///

``` title="Example: Set URI parameter in From header on outbound channel"

[handler]
exten => addheader,1,Set(PJSIP_HEADER_PARAM(From,uri,isup-oli)=27)
same => n,Return()
[somecontext]
exten => 1,1,Dial(PJSIP/${EXTEN},,b(handler^addheader^1))


```
``` title="Example: Read URI parameter in From header on inbound channel"

same => n,Set(value=${PJSIP_HEADER_PARAM(From,uri,isup-oli)})


```

### Syntax


```

PJSIP_HEADER_PARAM(header_name,parameter_type,parameter_name)
```
##### Arguments


* `header_name` - Header in which parameter should be read or set.<br>
Currently, the only supported header is 'From'.<br>

* `parameter_type` - The type of parameter to get or set.<br>
Default is header parameter.<br>

    * `header` - Header parameter.<br>

    * `uri` - URI parameter.<br>

* `parameter_name` - Name of parameter.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 