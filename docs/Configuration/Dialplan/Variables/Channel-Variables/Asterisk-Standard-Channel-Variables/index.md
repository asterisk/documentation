---
title: Overview
pageid: 4620398
---

There are a number of variables that are defined or read by Asterisk. Here is a listing of them. More information is available in each application's help text. All these variables are in UPPER CASE only.

Variables marked with a \* are builtin functions and can't be set, only read in the dialplan. Writes to such variables are silently ignored.

### Variables present in Asterisk 1.8 and forward:

* ${CDR(accountcode)} \* - Account code (if specified)
* ${BLINDTRANSFER} - The name of the channel on the other side of a blind transfer
* ${BRIDGEPEER} - Bridged peer
* ${BRIDGEPVTCALLID} - Bridged peer PVT call ID (SIP Call ID if a SIP call)
* ${CALLERID(ani)} \* - Caller ANI (PRI channels)
* ${CALLERID(ani2)} \* - ANI2 (Info digits) also called Originating line information or OLI
* ${CALLERID(all)} - Caller ID
* ${CALLERID(dnid)} \* - Dialed Number Identifier
* ${CALLERID(name)} - Caller ID Name only
* ${CALLERID(num)} - Caller ID Number only
* ${CALLERID(rdnis)} \* - Redirected Dial Number ID Service
* ${CALLINGANI2} \* - Caller ANI2 (PRI channels)
* ${CALLINGPRES} \* - Caller ID presentation for incoming calls (PRI channels)
* ${CALLINGTNS} \* - Transit Network Selector (PRI channels)
* ${CALLINGTON} \* - Caller Type of Number (PRI channels)
* ${CHANNEL} \* - Current channel name
* ${CONTEXT} \* - Current context
* ${DATETIME} \* - Current date time in the format: DDMMYYYY-HH:MM:SS (Deprecated; use ${STRFTIME(${EPOCH},,%d%m%Y-%H:%M:%S)})
* ${DB_RESULT} - Result value of DB_EXISTS() dial plan function
* ${EPOCH} \* - Current unix style epoch
* ${EXTEN} \* - Current extension
* ${ENV(VAR)} - Environmental variable VAR
* ${GOTO_ON_BLINDXFR} - Transfer to the specified context/extension/priority after a blind transfer (use ^ characters in place of | to separate context/extension/priority when setting this variable from the dialplan)
* ${HANGUPCAUSE} \* - Asterisk cause of hangup (inbound/outbound)
* ${HINT} \* - Channel hints for this extension
* ${HINTNAME} \* - Suggested Caller\*ID name for this extension
* ${INVALID_EXTEN} - The invalid called extension (used in the "i" extension)
* ${LANGUAGE} \* - Current language (Deprecated; use ${CHANNEL(language)})
* ${LEN(VAR)} - String length of VAR (integer)
* ${PRIORITY} \* - Current priority in the dialplan
* ${PRIREDIRECTREASON} - Reason for redirect on PRI, if a call was directed
* ${TIMESTAMP} \* - Current date time in the format: YYYYMMDD-HHMMSS (Deprecated; use ${STRFTIME(${EPOCH},,%Y%m%d-%H%M%S)})
* ${TRANSFER_CONTEXT} - Context for transferred calls
* ${FORWARD_CONTEXT} - Context for forwarded calls
* ${DYNAMIC_PEERNAME} - The name of the channel on the other side when a dynamic feature is used (removed)
* ${DYNAMIC_FEATURENAME} - The name of the last triggered dynamic feature
* ${DYNAMIC_WHO_ACTIVATED} - Gives the channel name that activated the dynamic feature
* ${UNIQUEID} \* - Current call unique identifier
* ${SYSTEMNAME} \* - value of the systemname option of asterisk.conf
* ${ENTITYID} \* - Global Entity ID set automatically, or from asterisk.conf

### Variables present in Asterisk 11 and forward:

* ${AGIEXITONHANGUP} - set to `1` to force the behavior of a call to AGI to behave as it did in 1.4, where the AGI script would exit immediately on detecting a channel hangup
* ${CALENDAR_SUCCESS} \* - Status of the [CALENDAR_WRITE](/Asterisk-11-Function_CALENDAR_WRITE) function. Set to `1` if the function completed successfully; `0` otherwise.
* ${SIP_RECVADDR} \* - the address a SIP MESSAGE request was received from
* ${VOICEMAIL_PLAYBACKSTATUS} \* - Status of the [VoiceMailPlayMsg](/Asterisk-11-Application_VoiceMailPlayMsg) application. `SUCCESS` if the voicemail was played back successfully, {{FAILED} otherwise
