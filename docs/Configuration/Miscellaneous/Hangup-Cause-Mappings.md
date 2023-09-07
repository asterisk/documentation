---
title: Hangup Cause Mappings
---

Asterisk Hangup Cause Code Mappings
-----------------------------------



| Asterisk Value | ISDN Cause codes (Q.850 & Q.931 unless specified) | MFC/R2 | SIP/PJSIP | Motif |
| --- | --- | --- | --- | --- |
| AST\_CAUSE\_NOT\_DEFINED | Cause not defined | OR2\_CAUSE\_UNSPECIFIED |   |   |
| AST\_CAUSE\_UNALLOCATED | 1. Unallocated (unassigned) number
 |   | 404, 485, 604 |   |
| AST\_CAUSE\_NO\_ROUTE\_TRANSIT\_NET | 2. No route to specified transmit network |   |   |   |
| AST\_CAUSE\_NO\_ROUTE\_DESTINATION | 3. No route to destination |   | 420 |   |
| AST\_CAUSE\_MISDIALLED\_TRUNK\_PREFIX | 5. Misdialled trunk prefix (national use) |   |   |   |
| AST\_CAUSE\_CHANNEL\_UNACCEPTABLE | 6. Channel unacceptable |   |   |   |
| AST\_CAUSE\_CALL\_AWARDED\_DELIVERED | 7. Call awarded and being delivered in an established channel |   |   |   |
| AST\_CAUSE\_PRE\_EMPTED | ISUP - 8. Preemption |   |   |   |
| AST\_CAUSE\_NUMBER\_PORTED\_NOT\_HERE | 14. QoR: ported number |   |   |   |
| AST\_CAUSE\_NORMAL\_CLEARING | 16. Normal Clearing | OR2\_CAUSE\_NORMAL\_CLEARING |   | gone, success |
| AST\_CAUSE\_USER\_BUSY | 17. User busy | OR2\_CAUSE\_BUSY\_NUMBER | 486, 600 | busy |
| AST\_CAUSE\_NO\_USER\_RESPONSE | 18. No user responding |   | 408 | expired |
| AST\_CAUSE\_NO\_ANSWER | 19. No answer from user (user alerted) | OR2\_CAUSE\_NO\_ANSWER | 480, 483 |   |
| AST\_CAUSE\_SUBSCRIBER\_ABSENT | 20. Subscriber absent | OR2\_CAUSE\_UNALLOCATED\_NUMBER |   |   |
| AST\_CAUSE\_CALL\_REJECTED | 21. Call Rejected |   | 401, 403, 407, 603 | cancel, decline |
| AST\_CAUSE\_NUMBER\_CHANGED | 22. Number changed |   | 410 |   |
| AST\_CAUSE\_REDIRECTED\_TO\_NEW\_DESTINATION | 23. Redirected to new destination |   |   |   |
| AST\_CAUSE\_ANSWERED\_ELSEWHERE | 26. Non-selected user clearing(ASTERISK-15057) |   |   |   |
| AST\_CAUSE\_DESTINATION\_OUT\_OF\_ORDER | 27. Destination out of order | OR2\_CAUSE\_OUT\_OF\_ORDER | 502 |   |
| AST\_CAUSE\_INVALID\_NUMBER\_FORMAT | 28. Invalid number format |   | 484 |   |
| AST\_CAUSE\_FACILITY\_REJECTED | 29. Facility rejected |   | 501 |   |
| AST\_CAUSE\_RESPONSE\_TO\_STATUS\_ENQUIRY | 30. Response to STATUS ENQUIRY |   |   |   |
| AST\_CAUSE\_NORMAL\_UNSPECIFIED | 31. Normal, unspecified |   |   |   |
| AST\_CAUSE\_NORMAL\_CIRCUIT\_CONGESTION | 34. No circuit/channel available(Note that we've called this "Circuit/channel congestion" for a while which can cause confusion with code 42) | OR2\_CAUSE\_NETWORK\_CONGESTION |   | general-error |
| AST\_CAUSE\_NETWORK\_OUT\_OF\_ORDER | 38. Network out of order |   | 500 |   |
| AST\_CAUSE\_NORMAL\_TEMPORARY\_FAILURE | 41. Temporary failure |   | 409 |   |
| AST\_CAUSE\_SWITCH\_CONGESTION | 42. Switching equipment congestion |   | 5xx | failed-application |
| AST\_CAUSE\_ACCESS\_INFO\_DISCARDED | 43. Access information discarded |   |   |   |
| AST\_CAUSE\_REQUESTED\_CHAN\_UNAVAIL | 44. Requested circuit/channel not available |   |   |   |
| AST\_CAUSE\_FACILITY\_NOT\_SUBSCRIBED | 50. Requested facility not subscribed |   |   |   |
| AST\_CAUSE\_OUTGOING\_CALL\_BARRED | 52. Outgoing call barred |   |   |   |
| AST\_CAUSE\_INCOMING\_CALL\_BARRED | 54. Incoming call barred |   |   |   |
| AST\_CAUSE\_BEARERCAPABILITY\_NOTAUTH | 57. Bearer capability not authorized |   |   |   |
| AST\_CAUSE\_BEARERCAPABILITY\_NOTAVAIL | 58. Bearer capability not presently available |   | 488, 606 | incompatible-parameters, media-error, unsupported-applications |
| AST\_CAUSE\_BEARERCAPABILITY\_NOTIMPL | 65. Bearer capability not implemented |   |   |   |
| AST\_CAUSE\_CHAN\_NOT\_IMPLEMENTED | 66. Channel type not implemented |   |   |   |
| AST\_CAUSE\_FACILITY\_NOT\_IMPLEMENTED | 69. Requested facility not implemented |   |   | unsupported-transports |
| AST\_CAUSE\_INVALID\_CALL\_REFERENCE | 81. Invalid call reference value |   |   |   |
| AST\_CAUSE\_INCOMPATIBLE\_DESTINATION | 88. Incompatible destination |   |   |   |
| AST\_CAUSE\_INVALID\_MSG\_UNSPECIFIED | 95. Invalid message unspecified |   |   |   |
| AST\_CAUSE\_MANDATORY\_IE\_MISSING | 96. Mandatory information element is missing |   |   |   |
| AST\_CAUSE\_MESSAGE\_TYPE\_NONEXIST | 97. Message type non-existent or not implemented |   |   |   |
| AST\_CAUSE\_WRONG\_MESSAGE | 98. Message not compatible with call state or message type non-existent or not implemented |   |   |   |
| AST\_CAUSE\_IE\_NONEXIST | 99. Information element nonexistent or not implemented |   |   |   |
| AST\_CAUSE\_INVALID\_IE\_CONTENTS | 100. Invalid information element contents |   |   |   |
| AST\_CAUSE\_WRONG\_CALL\_STATE | 101. Message not compatible with call state |   |   |   |
| AST\_CAUSE\_RECOVERY\_ON\_TIMER\_EXPIRE | 102. Recover on timer expiry |   | 504 | timeout |
| AST\_CAUSE\_MANDATORY\_IE\_LENGTH\_ERROR | ? Mandatory IE length error |   |   |   |
| AST\_CAUSE\_PROTOCOL\_ERROR | 111. Protocol error, unspecified |   |   | failed-transport, security-error |
| AST\_CAUSE\_INTERWORKING | 127. Interworking, unspecified |   | 4xx, 505, 6xx | connectivity-error |

#### Notes

* The hangup cause AST\_CAUSE\_NOT\_DEFINED is not actually a Q.931 cause code, and is used to capture hangup causes that do not map cleanly to a Q.931 cause code.
* IAX2, ISDN, and SS7 are all subsets of the cause codes listed above.
* Analog will always have a hangup cause code of AST\_CAUSE\_NORMAL\_CLEARING.
* SIP causes of 4xx, 5xx, and 6xx correspond to all 400, 500, and 600 response codes not explicitly listed in the table above.
* AST\_CAUSE\_UNREGISTERED maps to AST\_CAUSE\_SUBSCRIBER\_ABSENT. This error condition is raised when the endpoint is known but has unregistered itself somehow from Asterisk, e.g., a SIP peer has not registered or sent a REGISTER request with an expiration of 0.
