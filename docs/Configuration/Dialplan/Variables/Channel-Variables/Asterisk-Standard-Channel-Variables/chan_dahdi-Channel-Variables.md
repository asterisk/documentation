---
title: chan_dahdi Channel Variables
pageid: 4620419
---

* ${ANI2} \* - The ANI2 Code provided by the network on the incoming call. (ie, Code 29 identifies call as a Prison/Inmate Call)
* ${CALLTYPE} \* - Type of call (Speech, Digital, etc)
* ${CALLEDTON} \* - Type of number for incoming PRI extension i.e. 0=unknown, 1=international, 2=domestic, 3=net\_specific, 4=subscriber, 6=abbreviated, 7=reserved
* ${CALLINGSUBADDR} \* - Caller's PRI Subaddress
* ${FAXEXTEN} \* - The extension called before being redirected to "fax"
* ${PRIREDIRECTREASON} \* - Reason for redirect, if a call was directed
* ${SMDI\_VM\_TYPE} \* - When an call is received with an SMDI message, the 'type' of message 'b' or 'u'


