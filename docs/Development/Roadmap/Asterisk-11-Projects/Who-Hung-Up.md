---
title: Who Hung Up?
pageid: 20185363
---

Overview
========


Usage of SIP\_CAUSE has been known for a while now to impact performance in some situations due to the use of the MASTER\_CHANNEL dialplan function which must scan through the channel list. Another issue with SIP\_CAUSE is that it is too technology-specific. The HANGUPCAUSE function resolves these issues by passing this data and its AST\_CAUSE translation via control frames and creating a more generic mechanism that all channel technologies can share. This allows the techonology-specific and generic cause code information to move through Asterisk's core along with other control frames to the parent channel.


Differences in Usage
====================


HANGUPCAUSE may be used in any situation that calls for SIP\_CAUSE as a drop-in replacement if only SIP channels are being called. If used with non-SIP channels, dialplan code using HANGUPCAUSE must be able to handle non-SIP cause codes or be able to safely ignore them. A comma-separated list of channels for which information is available can be acquired using the HANGUPCAUSE\_KEYS function. SIP\_CAUSE has also been modified to use HANGUPCAUSE as its backend to take advantage of better performing code.


Example
=======



[foo]
exten => s,1,Dial(SIP/bar)

exten => h,1,noop()
exten => h,n,set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_KEYS()})
; start loop
exten => h,n(hu\_begin),noop()

; check exit condition (no more array to check)
exten => h,n,gotoif($[${LEN(${HANGUPCAUSE\_STRING})} = 0]?hu\_exit)

; pull the next item
exten => h,n,set(ARRAY(item)=${HANGUPCAUSE\_STRING})
exten => h,n,set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_STRING:${LEN(${item})}})

; display the channel ID and cause code
exten => h,n,noop(got channel ID ${item} with pvt cause ${HANGUPCAUSE(${item},tech)})

; check exit condition (no more array to check)
exten => h,n,gotoif($[${LEN(${HANGUPCAUSE\_STRING})} = 0]?hu\_exit)

; we still have entries to process, so strip the leading comma
exten => h,n,set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_STRING:1})
; go back to the beginning of the loop
exten => h,n,goto(hu\_begin)
exten => h,n(hu\_exit),noop(All HANGUPCAUSE entries processed)

Additional Usage
================


In addition to being available on the caller channel as a direct replacement for SIP\_CAUSE, HANGUPCAUSE can be used on callee channels in conjunction with pre-dial dialplan execution and hangup handlers so that hangup cause information may be evaluated on a one-to-one basis instead of a many-to-one basis as it is used on caller channels. The primary exception to this use case is Local channels. Local channels do not aggregate information from branched dials further down the chain and do not generate their own hangup cause information and thus they will never have hangup cause information attributed directly to them.


Support for Other Channel Drivers
=================================


The implementation that HANGUPCAUSE and the modified SIP\_CAUSE use is extensible to other channel technologies as well. The implementation for chan\_sip, chan\_iax2, and chan\_dahdi (analog, PRI, SS7, and MFC/R2) is complete and committed along with minimal support required in other channel drivers to keep them from breaking on the new frame.


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


Analog hangups will always present with AST\_CAUSE\_NORMAL\_CLEARING (Normal Clearing). There is no way to get additional information for these channels.


### MFC/R2


The mapping for MFC/R2 cause codes to Asterisk/ISDN cause codes can be found below.




| MFC/R2 Cause Code | Asterisk/ISDN Cause Code |
| --- | --- |
| OR2\_CAUSE\_BUSY\_NUMBER | AST\_CAUSE\_BUSY |
| OR2\_CAUSE\_NETWORK\_CONGESTION | AST\_CAUSE\_CONGESTION |
| OR2\_CAUSE\_OUT\_OF\_ORDER | AST\_CAUSE\_DESTINATION\_OUT\_OF\_ORDER |
| OR2\_CAUSE\_UNALLOCATED\_NUMBER | AST\_CAUSE\_UNREGISTERED |
| OR2\_CAUSE\_NO\_ANSWER | AST\_CAUSE\_NO\_ANSWER |
| OR2\_CAUSE\_NORMAL\_CLEARING | AST\_CAUSE\_NORMAL\_CLEARING |
| OR2\_CAUSE\_UNSPECIFIED | AST\_CAUSE\_NOTDEFINED |


SIP
---


The cause code translations for SIP are based in part on RFC3398. They can be found in the table below.




| SIP Response | Asterisk/ISDN Cause Code |
| --- | --- |
| 401 | AST\_CAUSE\_CALL\_REJECTED |
| 403 | AST\_CAUSE\_CALL\_REJECTED |
| 404 | AST\_CAUSE\_UNALLOCATED |
| 407 | AST\_CAUSE\_CALL\_REJECTED |
| 408 | AST\_CAUSE\_NO\_USER\_RESPONSE |
| 409 | AST\_CAUSE\_NORMAL\_TEMPORARY\_FAILURE |
| 410 | AST\_CAUSE\_NUMBER\_CHANGED |
| 420 | AST\_CAUSE\_NO\_ROUTE\_DESTINATION |
| 480 | AST\_CAUSE\_NO\_ANSWER |
| 483 | AST\_CAUSE\_NO\_ANSWER |
| 484 | AST\_CAUSE\_INVALID\_NUMBER\_FORMAT |
| 485 | AST\_CAUSE\_UNALLOCATED |
| 486 | AST\_CAUSE\_BUSY |
| 488 | AST\_CAUSE\_BEARERCAPABILITY\_NOTAVAIL |
| All Other 4xx | AST\_CAUSE\_INTERWORKING |
| 500 | AST\_CAUSE\_FAILURE |
| 501 | AST\_CAUSE\_FACILITY\_REJECTED |
| 502 | AST\_CAUSE\_DESTINATION\_OUT\_OF\_ORDER |
| 504 | AST\_CAUSE\_RECOVERY\_ON\_TIMER\_EXPIRE |
| 505 | AST\_CAUSE\_INTERWORKING |
| All Other 5xx | AST\_CAUSE\_CONGESTION |
| 600 | AST\_CAUSE\_USER\_BUSY |
| 603 | AST\_CAUSE\_CALL\_REJECTED |
| 604 | AST\_CAUSE\_UNALLOCATED |
| 606 | AST\_CAUSE\_BEARERCAPABILITY\_NOTAVAIL |
| All Other 6xx | AST\_CAUSE\_INTERWORKING |


