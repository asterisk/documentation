---
search:
  boost: 0.5
title: PJSIP_RESPONSE_HEADER
---

# PJSIP_RESPONSE_HEADER()

### Synopsis

Gets headers of 200 response from an outbound PJSIP channel.

### Description

PJSIP\_RESPONSE\_HEADER allows you to read specific SIP headers of 200 response from the outbound PJSIP channel.<br>

Examples:<br>

``` title="Example: Set 'somevar' to the value of the 'From' header"

exten => 1,1,Set(somevar=${PJSIP_RESPONSE_HEADER(read,From)})


```
``` title="Example: Set 'via2' to the value of the 2nd 'Via' header"

exten => 1,1,Set(via2=${PJSIP_RESPONSE_HEADER(read,Via,2)})


```
``` title="Example: Set 'xhdr' to the value of the 1sx X-header"

exten => 1,1,Set(xhdr=${PJSIP_RESPONSE_HEADER(read,X-*,1)})



```

/// note
If you call PJSIP\_RESPONSE\_HEADER in a normal dialplan context you'll be operating on the *caller's (incoming)* channel which may not be what you want. To operate on the *callee's (outgoing)* channel call PJSIP\_RESPONSE\_HEADER in a pre-connect handler.
///

``` title="Example: Usage on pre-connect handler"

[handler]
exten => readheader,1,NoOp(PJSIP_RESPONSE_HEADER(read,X-MyHeader))
[somecontext]
exten => 1,1,Dial(PJSIP/${EXTEN},,U(handler^readheader^1))


```

### Syntax


```

PJSIP_RESPONSE_HEADER(action,name[,number])
```
##### Arguments


* `action`

    * `read` - Returns instance _number_ of response header _name_.<br>

* `name` - The _name_ of the response header. A '*' can be appended to the _name_ to iterate over all response headers *beginning with* _name_.<br>

* `number` - If there's more than 1 header with the same name, this specifies which header to read. If not specified, defaults to '1' meaning the first matching header.<br>

### See Also

* [Dialplan Functions PJSIP_RESPONSE_HEADERS](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/PJSIP_RESPONSE_HEADERS)
* [Dialplan Functions PJSIP_HEADER](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/PJSIP_HEADER)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 