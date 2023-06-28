---
title: Who Hung Up?
pageid: 20185363
---

Overview
========


Usage of SIP_CAUSE has been known for a while now to impact performance in some situations due to the use of the MASTER_CHANNEL dialplan function which must scan through the channel list. Another issue with SIP_CAUSE is that it is too technology-specific. The HANGUPCAUSE function resolves these issues by passing this data and its AST_CAUSE translation via control frames and creating a more generic mechanism that all channel technologies can share. This allows the techonology-specific and generic cause code information to move through Asterisk's core along with other control frames to the parent channel.


Differences in Usage
====================


HANGUPCAUSE may be used in any situation that calls for SIP_CAUSE as a drop-in replacement if only SIP channels are being called. If used with non-SIP channels, dialplan code using HANGUPCAUSE must be able to handle non-SIP cause codes or be able to safely ignore them. A comma-separated list of channels for which information is available can be acquired using the HANGUPCAUSE_KEYS function. SIP_CAUSE has also been modified to use HANGUPCAUSE as its backend to take advantage of better performing code.


Example
=======




---

  
  


```


[foo]
exten => s,1,Dial(SIP/bar)

exten => h,1,noop()
exten => h,n,set(HANGUPCAUSE_STRING=${HANGUPCAUSE_KEYS()})
; start loop
exten => h,n(hu_begin),noop()

; check exit condition (no more array to check)
exten => h,n,gotoif($[${LEN(${HANGUPCAUSE_STRING})} = 0]?hu_exit)

; pull the next item
exten => h,n,set(ARRAY(item)=${HANGUPCAUSE_STRING})
exten => h,n,set(HANGUPCAUSE_STRING=${HANGUPCAUSE_STRING:${LEN(${item})}})

; display the channel ID and cause code
exten => h,n,noop(got channel ID ${item} with pvt cause ${HANGUPCAUSE(${item},tech)})

; check exit condition (no more array to check)
exten => h,n,gotoif($[${LEN(${HANGUPCAUSE_STRING})} = 0]?hu_exit)

; we still have entries to process, so strip the leading comma
exten => h,n,set(HANGUPCAUSE_STRING=${HANGUPCAUSE_STRING:1})
; go back to the beginning of the loop
exten => h,n,goto(hu_begin)
exten => h,n(hu_exit),noop(All HANGUPCAUSE entries processed)


```


Additional Usage
================


In addition to being available on the caller channel as a direct replacement for SIP_CAUSE, HANGUPCAUSE can be used on callee channels in conjunction with pre-dial dialplan execution and hangup handlers so that hangup cause information may be evaluated on a one-to-one basis instead of a many-to-one basis as it is used on caller channels. The primary exception to this use case is Local channels. Local channels do not aggregate information from branched dials further down the chain and do not generate their own hangup cause information and thus they will never have hangup cause information attributed directly to them.


Support for Other Channel Drivers
=================================


The implementation that HANGUPCAUSE and the modified SIP_CAUSE use is extensible to other channel technologies as well. The implementation for chan_sip, chan_iax2, and chan_dahdi (analog, PRI, SS7, and MFC/R2) is complete and committed along with minimal support required in other channel drivers to keep them from breaking on the new frame.


Understanding the Information Provided
======================================


In an effort to allow consumers of this information to better understand what is available, translation facilities are provided that allow access to Asterisk/ISDN cause code equivalents. This information can be accessed by using "ast" as the second parameter of the HANGUPCAUSE function instead of using "tech". This work is committed.


IAX2
----


IAX2 already uses Asterisk/ISDN cause codes, so these are provided as-is.


DAHDI
-----


### ISDN


Asterisk cause codes are a superset of ISDN cause codes. These are left unmodified.


### SS7


Asterisk cause codes are a superset of ISDN cause codes (which SS7 uses). These are left unmodified.


### Analog


Analog hangups will always present with AST_CAUSE_NORMAL_CLEARING (Normal Clearing). There is no way to get additional information for these channels.


### MFC/R2


The mapping for MFC/R2 cause codes to Asterisk/ISDN cause codes can be found below.




| MFC/R2 Cause Code | Asterisk/ISDN Cause Code |
| --- | --- |
| OR2_CAUSE_BUSY_NUMBER | AST_CAUSE_BUSY |
| OR2_CAUSE_NETWORK_CONGESTION | AST_CAUSE_CONGESTION |
| OR2_CAUSE_OUT_OF_ORDER | AST_CAUSE_DESTINATION_OUT_OF_ORDER |
| OR2_CAUSE_UNALLOCATED_NUMBER | AST_CAUSE_UNREGISTERED |
| OR2_CAUSE_NO_ANSWER | AST_CAUSE_NO_ANSWER |
| OR2_CAUSE_NORMAL_CLEARING | AST_CAUSE_NORMAL_CLEARING |
| OR2_CAUSE_UNSPECIFIED | AST_CAUSE_NOTDEFINED |


SIP
---


The cause code translations for SIP are based in part on RFC3398. They can be found in the table below.




| SIP Response | Asterisk/ISDN Cause Code |
| --- | --- |
| 401 | AST_CAUSE_CALL_REJECTED |
| 403 | AST_CAUSE_CALL_REJECTED |
| 404 | AST_CAUSE_UNALLOCATED |
| 407 | AST_CAUSE_CALL_REJECTED |
| 408 | AST_CAUSE_NO_USER_RESPONSE |
| 409 | AST_CAUSE_NORMAL_TEMPORARY_FAILURE |
| 410 | AST_CAUSE_NUMBER_CHANGED |
| 420 | AST_CAUSE_NO_ROUTE_DESTINATION |
| 480 | AST_CAUSE_NO_ANSWER |
| 483 | AST_CAUSE_NO_ANSWER |
| 484 | AST_CAUSE_INVALID_NUMBER_FORMAT |
| 485 | AST_CAUSE_UNALLOCATED |
| 486 | AST_CAUSE_BUSY |
| 488 | AST_CAUSE_BEARERCAPABILITY_NOTAVAIL |
| All Other 4xx | AST_CAUSE_INTERWORKING |
| 500 | AST_CAUSE_FAILURE |
| 501 | AST_CAUSE_FACILITY_REJECTED |
| 502 | AST_CAUSE_DESTINATION_OUT_OF_ORDER |
| 504 | AST_CAUSE_RECOVERY_ON_TIMER_EXPIRE |
| 505 | AST_CAUSE_INTERWORKING |
| All Other 5xx | AST_CAUSE_CONGESTION |
| 600 | AST_CAUSE_USER_BUSY |
| 603 | AST_CAUSE_CALL_REJECTED |
| 604 | AST_CAUSE_UNALLOCATED |
| 606 | AST_CAUSE_BEARERCAPABILITY_NOTAVAIL |
| All Other 6xx | AST_CAUSE_INTERWORKING |


