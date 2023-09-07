---
title: Hangup Cause
---

Overview
--------

The Hangup Cause family of functions and dialplan applications allow for inspection of the hangup cause codes for each channel involved in a call. This allows a dialplan writer to determine, for each channel, who hung up and for what reason(s). Note that this extends the functionality available in the HANGUPCAUSE channel variable, by allowing a calling channel to inspect all called channel's hangup causes in a variety of dialling situations.

Note that this feature replaces the technology specific mechanism of using the MASTER\_CHANNEL function to access a SIP channel's SIP\_CAUSE, as well as extends similar functionality to a variety of other channel drivers.

Dialplan Functions and Applications
-----------------------------------

### HANGUPCAUSE\_KEYS

Used to obtain a comma separated list of all channels for which hangup causes are available.

#### Example

The following example shows one way of accessing the channels that have hangup cause related information after a Dial has completed. In this particular example, a parallel dial occurs to both *SIP/foo* and *SIP/bar*. A hangup handler has been attached to the calling channel, which executes the subroutine at **handler,s,1** when the channel is hung up. This queries the HANGUPCAUSE\_KEYS function for the channels with hangup cause information and prints the information as a Verbose message. On the CLI, this would look something like:

Channels with hangup cause information: SIP/bar-00000002,SIP/foo-00000001
[default]

exten => s,1,NoOp()
 same => n,Set(CHANNEL(hangup\_handler\_push)=handler,s,1)
 same => n,Dial(SIP/foo&SIP/bar,10)
 same => n,Hangup()

[handler]

exten => s,1,NoOp()
 same => n,Set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_KEYS()})
 same => n,Verbose(0, Channels with hangup cause information: ${HANGUPCAUSE\_STRING})
 same => n,Return()
### HANGUPCAUSE

Used to obtain hangup cause information for a specific channel. For a given channel, there are two sources of hangup cause information:

1. The channel technology specific hangup cause information
2. A text description of the Asterisk specific hangup cause

Note that in some cases, the hangup causes returned may not be reflected in . For example, if a Dial to a SIP UA is cancelled by Asterisk, the SIP UA may not have returned any final responses to Asterisk. In these cases, the last known technology code will be returned by the function.

#### Example

This example illustrates obtaining hangup cause information for a parallel dial to *SIP/foo* and *SIP/bar*. A hangup handler has been attached to the calling channel, which executes the subroutine at **handler,s,1** when the channel is hung up. This queries the hangup cause information using the HANGUPCAUSE\_KEYS function and the HANGUPCAUSE function. The channels returned from HANGUPCAUSE\_KEYS are parsed out, and each is queried for their hangup cause information. The technology specific cause code as well as the Asterisk cause code are printed to the CLI.

[default]

exten => s,1,NoOp()
 same => n,Set(CHANNEL(hangup\_handler\_push)=handler,s,1)
 same => n,Dial(SIP/foo&SIP/bar,10)
 same => n,Hangup()

[handler]

exten => s,1,NoOp()

same => n,Set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_KEYS()})

; start loop
same => n(hu\_begin),NoOp()

; check exit condition (no more array to check)
same => n,GotoIf($[${LEN(${HANGUPCAUSE\_STRING})}=0]?hu\_exit)

; pull the next item
same => n,Set(ARRAY(item)=${HANGUPCAUSE\_STRING})
same => n,Set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_STRING:${LEN(${item})}})

; display the channel name and cause codes
same => n,Verbose(0, Got Channel ID ${item} with Technology Cause Code ${HANGUPCAUSE(${item},tech)}, Asterisk Cause Code ${HANGUPCAUSE(${item},ast)})

; check exit condition (no more array to check)
same => n,GotoIf($[${LEN(${HANGUPCAUSE\_STRING})}=0]?hu\_exit)

; we still have entries to process, so strip the leading comma
same => n,Set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_STRING:1})

; go back to the beginning of the loop
same => n,Goto(hu\_begin)

same => n(hu\_exit),NoOp()
same => n,Return()

### HangupCauseClear

Used to remove all hangup cause information currently stored.

#### Example

The following example clears the hangup cause information from the channel if *SIP/foo* fails to answer and execution continues in the dialplan. The hangup handler attached to the channel will thus only report the the name of the last channel dialled.

exten => s,1,NoOp()
 same => n,Set(CHANNEL(hangup\_handler\_push)=handler,s,1)
 same => n,Dial(SIP/foo,10)
 same => n,HangupCauseClear()
 same => n,Dial(SIP/bar,10)
 same => n,Hangup()

[handler]

exten => s,1,NoOp()
 same => n,Set(HANGUPCAUSE\_STRING=${HANGUPCAUSE\_KEYS()})
 same => n,Verbose(0, Channels with hangup cause information: ${HANGUPCAUSE\_STRING})
 same => n,Return()
