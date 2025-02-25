---
search:
  boost: 0.5
title: PJSIP_HEADER
---

# PJSIP_HEADER()

### Synopsis

Gets headers from an inbound PJSIP channel. Adds, updates or removes the specified SIP header from an outbound PJSIP channel.

### Description

PJSIP\_HEADER allows you to read specific SIP headers from the inbound PJSIP channel as well as write(add, update, remove) headers on the outbound channel. One exception is that you can read headers that you have already added on the outbound channel.<br>

Examples:<br>

``` title="Example: Set somevar to the value of the From header"

exten => 1,1,Set(somevar=${PJSIP_HEADER(read,From)})


```
``` title="Example: Set via2 to the value of the 2nd Via header"

exten => 1,1,Set(via2=${PJSIP_HEADER(read,Via,2)})


```
``` title="Example: Set xhdr to the value of the 1st X-header"

exten => 1,1,Set(xhdr=${PJSIP_HEADER(read,X-*,1)})


```
``` title="Example: Add an X-Myheader header with the value of myvalue"

exten => 1,1,Set(PJSIP_HEADER(add,X-MyHeader)=myvalue)


```
``` title="Example: Add an X-Myheader header with an empty value"

exten => 1,1,Set(PJSIP_HEADER(add,X-MyHeader)=)


```
``` title="Example: Update the value of the header named X-Myheader to newvalue"

; 'X-Myheader' must already exist or the call will fail.
exten => 1,1,Set(PJSIP_HEADER(update,X-MyHeader)=newvalue)


```
``` title="Example: Remove all headers whose names exactly match X-MyHeader"

exten => 1,1,Set(PJSIP_HEADER(remove,X-MyHeader)=)


```
``` title="Example: Remove all headers that begin with X-My"

exten => 1,1,Set(PJSIP_HEADER(remove,X-My*)=)


```
``` title="Example: Remove all previously added headers"

exten => 1,1,Set(PJSIP_HEADER(remove,*)=)


```

/// note
The 'remove' action can be called by reading *or* writing PJSIP\_HEADER.
///

``` title="Example: Display the number of headers removed"

exten => 1,1,Verbose( Removed ${PJSIP_HEADER(remove,X-MyHeader)} headers)


```
``` title="Example: Set a variable to the number of headers removed"

exten => 1,1,Set(count=${PJSIP_HEADER(remove,X-MyHeader)})


```
``` title="Example: Just remove them ignoring any count"

exten => 1,1,Set(=${PJSIP_HEADER(remove,X-MyHeader)})
exten => 1,1,Set(PJSIP_HEADER(remove,X-MyHeader)=)



```

/// note
If you call PJSIP\_HEADER in a normal dialplan context you'll be operating on the *caller's (incoming)* channel which may not be what you want. To operate on the *callee's (outgoing)* channel call PJSIP\_HEADER in a pre-dial handler.
///

``` title="Example: Set headers on callee channel"

[handler]
exten => addheader,1,Set(PJSIP_HEADER(add,X-MyHeader)=myvalue)
exten => addheader,2,Set(PJSIP_HEADER(add,X-MyHeader2)=myvalue2)

[somecontext]
exten => 1,1,Dial(PJSIP/${EXTEN},,b(handler^addheader^1))


```

### Syntax


```

PJSIP_HEADER(action,name[,number])
```
##### Arguments


* `action`

    * `read` - Returns instance _number_ of header _name_. A '*' may be appended to _name_ to iterate over all headers *beginning with* _name_.<br>

    * `add` - Adds a new header _name_ to this session.<br>

    * `update` - Updates instance _number_ of header _name_ to a new value. The header must already exist.<br>

    * `remove` - Removes all instances of previously added headers whose names match _name_. A '*' may be appended to _name_ to remove all headers *beginning with* _name_. _name_ may be set to a single '*' to clear *all* previously added headers. In all cases, the number of headers actually removed is returned.<br>

* `name` - The name of the header.<br>

* `number` - If there's more than 1 header with the same name, this specifies which header to read or update. If not specified, defaults to '1' meaning the first matching header. Not valid for 'add' or 'remove'.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 