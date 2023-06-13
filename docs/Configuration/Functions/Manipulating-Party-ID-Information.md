---
title: Manipulating Party ID Information
pageid: 5243183
---

listtrue

Introduction
============

This chapter aims to explain how to use some of the features available to manipulate party ID information. It will not delve into specific channel configuration options described in the respective sample configuration files. The party ID information can consist of Caller ID, Connected Line ID, redirecting to party ID information, and redirecting from party ID information. Meticulous control is needed particularly when interoperating between different channel technologies.

* Caller ID: The Caller ID information describes who is originating a call.
* Connected Line ID: The Connected Line ID information describes who is connected to the other end of a call while a call is established. Unlike Caller ID, the connected line information can change over the life of a call when call transfers are performed. The connected line information can also change in either direction because either end could transfer the call. For ISDN it is known as Connected Line Identification Presentation (COLP), Connected Line Identification Restriction (COLR), and Explicit Call Transfer (ECT). For SIP it is known either as P-Asserted-Identity or Remote-Party-Id.
* Redirecting information: When a call is forwarded, the call originator is informed that the call is redirecting-to a new destination. The new destination is also informed that the incoming call is redirecting-from the forwarding party. A call can be forwarded repeatedly until a new destination answers it or a forwarding limit is reached.

Tools available
===============

Asterisk contains several tools for manipulating the party ID information for a call. Additional information can be found by using the 'core show function' or 'core show application' console commands at the Asterisk CLI. The following list identifies some of the more common tools for manipulating the party ID information:

* `CALLERID(datatype,caller-id)`
* `CONNECTEDLINE(datatype,i)`
* `REDIRECTING(datatype,i)`
* `Dial()` and `Queue()` dialplan application 'I' option
* Interception macros
* Channel driver specific configuration options.

### CALLERID dialplan function

The CALLERID function has been around for quite a while and its use is straightforward. It is used to examine and alter the caller information that came into the dialplan with the call. Then the call with it's caller information passes on to the destination using the Dial() or Queue() application.

The CALLERID information is passed during the initial call setup. However, depending on the channel technology, the caller name may be delayed. Q.SIG is an example where the caller name may be delayed so your dialplan may need to wait for it.

### CONNECTEDLINE dialplan function

The CONNECTEDLINE function does the opposite of the CALLERID function. CONNECTEDLINE can be used to setup connected line information to be sent when the call is answered. You can use it to send new connected line information to the remote party on the channel when a call is transferred. The CONNECTEDLINE information is passed when the call is answered and when the call is transferred.

It is up to the channel technology to determine when to act upon connected line updates before the call is answered. ISDN will just store the updated information until the call is answered. SIP could immediately update the caller with a provisional response or wait for some other event to notify the caller.

Since the connected line information can be sent while a call is connected, you may need to prevent the channel driver from acting on a **partial** update. The 'i' option is used to inhibit the channel driver from sending the changed information immediately.

### REDIRECTING dialplan function

The REDIRECTING function allows you to report information about forwarded/deflected calls to the caller and to the new destination. The use of the REDIRECTING function is the most complicated of the party information functions.

The REDIRECTING information is passed during the initial call setup and while the call is being routed through the network. Since the redirecting information is sent before a call is answered, you need to prevent the channel driver from acting on a partial update. The 'i' option is used to inhibit the channel driver from sending the changed information immediately.

The incoming call may have already been redirected. An incoming call has already been redirected if the REDIRECTING(count) is not zero. (Alternate indications are if the REDIRECTING(from-num-valid) is non-zero or if the REDIRECTING(from-num) is not empty.)

There are several things to do when a call is forwarded by the dialplan:

* Setup the REDIRECTING(to-xxx) values to be sent to the caller.
* Setup the REDIRECTING(from-xxx) values to be sent to the new destination.
* Increment the REDIRECTING(count).
* Set the REDIRECTING(reason).
* Dial() the new destination.

##### Special REDIRECTING considerations for ISDN

Special considerations for Q.SIG and ISDN point-to-point links are needed to make the DivertingLegInformation1, DivertingLegInformation2, and DivertingLegInformation3 messages operate properly.

You should manually send the COLR of the redirected-to party for an incoming redirected call if the incoming call could experience further redirects. For chan\_misdn, just set the REDIRECTING(to-num,i) = ${EXTEN} and set the REDIRECTING(to-num-pres) to the COLR. For chan\_dahdi, just set the REDIRECTING(to-num,i) = CALLERID(dnid) and set the REDIRECTING(to-num-pres) to the COLR. (Setting the REDIRECTING(to-num,i) value may not be necessary since the channel driver has already attempted to preset that value for automatic generation of the needed DivertingLegInformation3 message.)

For redirected calls out a trunk line, you need to use the 'i' option on all of the REDIRECTING statements before dialing the redirected-to party. The call will update the redirecting-to presentation (COLR) when it becomes available.

### Dial() and Queue() dialplan application 'I' option

In the dialplan applications Dial() and Queue(), the 'I' option is a brute force option to block connected line and redirecting information updates while the application is running. Blocking the updates prevents the update from overwriting any CONNECTEDLINE or REDIRECTING values you may have setup before running the application.

The option blocks all redirecting updates since they should only happen before a call is answered. The option only blocks the connected line update from the initial answer. Connected line updates resulting from call transfers happen after the application has completed. Better control of connected line and redirecting information is obtained using the interception macros.

### Party ID Interception Macros and Routines

You can find detailed information in the  section.

Manipulation examples
=====================

The following examples show several common scenarios in which you may need to manipulate party ID information from the dialplan.

### Simple recording playback

exten => 1000,1,NoOp
; The CONNECTEDLINE information is sent when the call is answered.
exten => 1000,n,Set(CONNECTEDLINE(name,i)=Company Name)
exten => 1000,n,Set(CONNECTEDLINE(name-pres,i)=allowed)
exten => 1000,n,Set(CONNECTEDLINE(num,i)=5551212)
exten => 1000,n,Set(CONNECTEDLINE(num-pres)=allowed)
exten => 1000,n,Answer
exten => 1000,n,Playback(tt-weasels)
exten => 1000,n,Hangup
### Straightforward dial through

exten => 1000,1,NoOp
; The CONNECTEDLINE information is sent when the call is answered.
exten => 1000,n,Set(CONNECTEDLINE(name,i)=Company Name)
exten => 1000,n,Set(CONNECTEDLINE(name-pres,i)=allowed)
exten => 1000,n,Set(CONNECTEDLINE(num,i)=5551212)
exten => 1000,n,Set(CONNECTEDLINE(num-pres)=allowed)
; The I option prevents overwriting the CONNECTEDLINE information
; set above when the call is answered.
exten => 1000,n,Dial(SIP/1000,20,I)
exten => 1000,n,Hangup
### Use of interception macro

[macro-add\_pfx]
; ARG1 is the prefix to add.
; ARG2 is the number of digits at the end to add the prefix to.
; When the macro ends the CONNECTEDLINE data is passed to the
; channel driver.
exten => s,1,NoOp(Add prefix to connected line)
exten => s,n,Set(NOPREFIX=${CONNECTEDLINE(number):-${ARG2}})
exten => s,n,Set(CONNECTEDLINE(num,i)=${ARG1}${NOPREFIX})
exten => s,n,MacroExit

exten => 1000,1,NoOp
exten => 1000,n,Set(\_\_CONNECTED\_LINE\_CALLER\_SEND\_MACRO=add\_pfx)
exten => 1000,n,Set(\_\_CONNECTED\_LINE\_CALLER\_SEND\_MACRO\_ARGS=45,4)
exten => 1000,n,Dial(SIP/1000,20)
exten => 1000,n,Hangup
### Simple redirection

exten => 1000,1,NoOp
; For Q.SIG or ISDN point-to-point we should determine the COLR for this
; extension and send it if the call was redirected here.
exten => 1000,n,GotoIf($[${REDIRECTING(count)}>0]?redirected:notredirected)
exten => 1000,n(redirected),Set(REDIRECTING(to-num,i)=${CALLERID(dnid)})
exten => 1000,n,Set(REDIRECTING(to-num-pres)=allowed)
exten => 1000,n(notredirected),NoOp
; Determine that the destination has forwarded the call.
; ...
exten => 1000,n,Set(REDIRECTING(from-num,i)=1000)
exten => 1000,n,Set(REDIRECTING(from-num-pres,i)=allowed)
exten => 1000,n,Set(REDIRECTING(to-num,i)=2000)
; The DivertingLegInformation3 message is needed because at this point
; we do not know the presentation (COLR) setting of the redirecting-to
; party.
exten => 1000,n,Set(REDIRECTING(count,i)=$[${REDIRECTING(count)} + 1])
exten => 1000,n,Set(REDIRECTING(reason,i)=cfu)
; The call will update the redirecting-to presentation (COLR) when it
; becomes available with a redirecting update.
exten => 1000,n,Dial(DAHDI/g1/2000,20)
exten => 1000,n,Hangup
Party ID propagation
====================

For normal operations where Party A calls Party B this is what the relationship between CALLERID/CONNECTEDLINE information looks like:

 Channel A Channel B
 Incoming channel --- bridge --- Outgoing channel
Party A \_\_\_ CALLERID() -------------------> CONNECTEDLINE() \_\_\_ Party B
 CONNECTEDLINE() <-------------- CALLERID()
The CALLERID() information is the party identification of the remote party. For Channel A that is Party A. For Channel B that is Party B.

The CONNECTEDLINE() information is the party identification of the party connected across the bridge. For Channel A that is Party B. For Channel B that is Party A.

Local channels behave in a similar way because there is an implicit two party bridge between the channels. For normal call setups, Local;1 is an outgoing channel and Local;2 is an incoming channel.

Local;1 Local;2
Outgoing channel --- Incoming channel
CONNECTEDLINE() ---> CALLERID()
CALLERID() <-------- CONNECTEDLINE()
A normal call where Party A calls Party B with a local channel in the chain.

 Channel A Local;1 Local;2 Channel B
 Incoming channel --- bridge --- Outgoing channel --- Incoming channel --- bridge --- Outgoing channel
Party A \_\_\_ CALLERID() -------------------> CONNECTEDLINE() ---> CALLERID() -------------------> CONNECTEDLINE() \_\_\_ Party B
 CONNECTEDLINE() <-------------- CALLERID() <-------- CONNECTEDLINE() <-------------- CALLERID()
Originated calls make the incoming and outgoing labels a bit confusing because both channels start off as outgoing. Once the originated channel answers it becomes an "incoming" channel to run dialplan. A better way is to just distinguish which channel is running dialplan. For consistency, I'll continue using the incoming and outgoing labels.

An example of originating a normal channel (Channel A) to a dialplan exten.  
 1) Channel A dials Party A  
 2) Party A answers  
 3) The CONNECTEDLINE update from Channel A triggered by the answer is discarded because it has nowhere to go.  
 4) Channel A becomes an incoming channel to run dialplan to dial Party B.

 Channel A Channel B
 Incoming channel --- bridge --- Outgoing channel
Party A \_\_\_ CALLERID() -------------------> CONNECTEDLINE() \_\_\_ Party B
 CONNECTEDLINE() <-------------- CALLERID()
An example of originating a local channel (which will always be a Local;1) to a dialplan exten.  
 1) Local;1 makes Local;2 run dialplan to call Party A  
 2) Party A answers  
 3) The CONNECTEDLINE update from Channel A triggered by the answer propagates to Local;1 if not blocked by the Dial 'I' option on Local;2.  
 4) Local;1 becomes an incoming channel to run dialplan to dial Party B.

 Channel A Local;2 Local;1 Channel B
 Outgoing channel --- bridge --- Incoming channel --- Incoming channel --- bridge --- Outgoing channel
Party A \_\_\_ CALLERID() -------------------> CONNECTEDLINE() ---> CALLERID() -------------------> CONNECTEDLINE() \_\_\_ Party B
 CONNECTEDLINE() <-------------- CALLERID() <-------- CONNECTEDLINE() <-------------- CALLERID()
Ideas for usage
===============

The following is a list of ideas in which the manipulation of party ID information would be beneficial.

* IVR that updates connected name on each selection made.
* Disguise the true number of an individual with a generic company number.
* Use interception macros to make outbound connected number E.164 formatted.
* You can do a lot more in an interception macro than just manipulate party information...

Troubleshooting tips
====================

* For CONNECTEDLINE and REDIRECTING, check the usage of the 'i' option.
* Check channel configuration settings. The default settings may not be what you want or expect.
* Check packet captures. Your equipment may not support what Asterisk sends.

For further reading...
======================

* Relevant ETSI ISDN redirecting specification: EN 300 207-1
* Relevant ETSI ISDN COLP specification: EN 300 097-1
* Relevant ETSI ISDN ECT specification: EN 300 369-1
* Relevant Q.SIG ISDN redirecting specification: ECMA-174
* Relevant Q.SIG ISDN COLP specification: ECMA-148
* Relevant Q.SIG ISDN ECT specification: ECMA-178
* Relevant SIP RFC for P-Asserted-Id: RFC3325
* The expired draft (draft-ietf-sip-privacy-04.txt) defines Remote-Party-Id. Since Remote-Party-Id has not made it into an RFC at this time, its use is non-standard by definition.
