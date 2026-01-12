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

;<br>

; Set 'somevar' to the value of the 'From' header.<br>

exten => 1,1,Set(somevar=$\{PJSIP\_HEADER(read,From)\})<br>

;<br>

; Set 'via2' to the value of the 2nd 'Via' header.<br>

exten => 1,1,Set(via2=$\{PJSIP\_HEADER(read,Via,2)\})<br>

;<br>

; Set 'xhdr' to the value of the 1sx X-header.<br>

exten => 1,1,Set(xhdr=$\{PJSIP\_HEADER(read,X-*,1)\})<br>

;<br>

; Add an 'X-Myheader' header with the value of 'myvalue'.<br>

exten => 1,1,Set(PJSIP\_HEADER(add,X-MyHeader)=myvalue)<br>

;<br>

; Add an 'X-Myheader' header with an empty value.<br>

exten => 1,1,Set(PJSIP\_HEADER(add,X-MyHeader)=)<br>

;<br>

; Update the value of the header named 'X-Myheader' to 'newvalue'.<br>

; 'X-Myheader' must already exist or the call will fail.<br>

exten => 1,1,Set(PJSIP\_HEADER(update,X-MyHeader)=newvalue)<br>

;<br>

; Remove all headers whose names exactly match 'X-MyHeader'.<br>

exten => 1,1,Set(PJSIP\_HEADER(remove,X-MyHeader)=)<br>

;<br>

; Remove all headers that begin with 'X-My'.<br>

exten => 1,1,Set(PJSIP\_HEADER(remove,X-My*)=)<br>

;<br>

; Remove all previously added headers.<br>

exten => 1,1,Set(PJSIP\_HEADER(remove,*)=)<br>

;<br>


/// note
The 'remove' action can be called by reading *or* writing PJSIP\_HEADER. ; ; Display the number of headers removed exten => 1,1,Verbose( Removed $\{PJSIP\_HEADER(remove,X-MyHeader)\} headers) ; ; Set a variable to the number of headers removed exten => 1,1,Set(count=$\{PJSIP\_HEADER(remove,X-MyHeader)\}) ; ; Just remove them ignoring any count exten => 1,1,Set(=$\{PJSIP\_HEADER(remove,X-MyHeader)\}) exten => 1,1,Set(PJSIP\_HEADER(remove,X-MyHeader)=) ;
///


/// note
If you call PJSIP\_HEADER in a normal dialplan context you'll be operating on the *caller's (incoming)* channel which may not be what you want. To operate on the *callee's (outgoing)* channel call PJSIP\_HEADER in a pre-dial handler. Example: ; \[handler\] exten => addheader,1,Set(PJSIP\_HEADER(add,X-MyHeader)=myvalue) exten => addheader,2,Set(PJSIP\_HEADER(add,X-MyHeader2)=myvalue2) ; \[somecontext\] exten => 1,1,Dial(PJSIP/$\{EXTEN\},,b(handler\^addheader\^1)) ;
///


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

This documentation was generated from Asterisk branch certified/18.9 using version GIT 