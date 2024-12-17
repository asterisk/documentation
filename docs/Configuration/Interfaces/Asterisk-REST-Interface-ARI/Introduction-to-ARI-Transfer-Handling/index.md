---
title: Overview
pageid: 29396202
---

# Transfer Handling

## Introduction

Transfer is a telephony feature. There are two types of transfer, attendant and blind. These names may differ depending on the system you are looking on, or what background you have.

The ARI transfer handling is supposed to be used in an ARI only environment. Using ARI for ARI Controlled and non ARI controlled Channels is not possible. 

### Attendant Transfer
Attendant transfer happens, if a call on hold and an active call are connected on request of the user. The user can talk to both parties before connecting them. This is also called a consultative transfer.

### Blind Transfer
Blind transfer happens, if the user transfer the active call to a destination, not knowing the state or reachability of the destination. The user does not talk to the destination before the transfer.Bild transfer is also called a cold transfer. 

## Transfer handling in SIP

In SIP there is a method called `REFER`. This method, if triggered by the user contains all the known information by the phone about what calls shall be connected. The SIP Server send back a direct response to the user. The Response in case the PBX will try to handle the REFER is an 202 Accepted. After that the PBX will Notify the user by `Notify` method about the current state of the transfer.

## Transfer handling in ARI

Asterisk handles the REFER without any config changes by itself. To have ARI handle the transfer you need to change a setting so the ARI events are generated. If done, the `channelTransferEvent` will be generated in case a `REFER` is received. The `channelTransferEvent` contains the information about the transfer. The `channelTransferEvent` is generated for both, blind and attendant transfer.

### Information within the `channelTransferEvent`

Asterisk try to get as much information as possible about the transfer. The `REFER` does only contain the corresponding SIP-Call ID. With this SIP-Call ID, asterisk try to resolve the Channel-ID used by ARI for the Channel.

During a Transfer Scenario there are a lot of moving parts involved. A Typical Setup for an attendant transfer lokks like this:

Channel A --- Bridge 1 -X- Channel B

Channel C --- Bridge 2 --- Channel D

Where the Channel marked with an "X" ist set on hold Channel A should receive MOH but this is not necessary.
Depending on the used Phone a SIP REFER is send to the Channel B or D. Either way, Asterisk tries to resolve all the channel information involved.
the `channelTransferEvent` contains both `refere-to` and `refered-by` information.
The `refere-to` sections will always contain information about the SIP-Call ID in the field `requested-destination`. This is the information we receive from the phone.
In addition, the `refere-to` does contain, as far as the Asterisk could resolve it, the information about the own `channel-id` the `bridge-id` the channel is connected to and the connected `channel-id`. Relating to the schema above the `refere-to` would contain Channel B, Bridge 1 and Channel A, if the REFER is received on Channel D. 

If the Asterisk is not able to resolve the Channel and Bridge IDs the SIP Call ID is transmitted anyhow. If the asterisk is running in a larger environment and cannot resolve the Call ID by itself, the ARI Application MUST keep track of all ongoing SIP Calls and it MUST resolve the corresponding Channel IDs and Bridges by itself.

Corresponding to the `refere-to` the `refered-by` section contains the information about the Channel and Bridge the REFER was received on. Related to the schema above it would contain Channel D, Bridge 2 and Channel C.

### Actions after the Event is received

The ARI application MUST take some action in order to handle the REFER. The Asterisk will not do anything by itself.  The First thing to do when received an SIP REFER is acknowledge it. This is done by the Asterisk As well as the first `NOTIFY` telling the Phone an `100 Trying`. After that, the telefon waits for an Notify containing a SIP Frag  with `200 OK`. This has to be send by ARI Application manually.

Actions what needs to be done by ARI Application for the schema above:

* Remove Channel C from Bridge 2
* Remove Channel B from Bridge 1
* Add Channel C to Bridge 1
* Delete Bridge 2
* Send a `200 OK` to the Phone
* Delete Channel B
* Delete Channel D (if not done by phone)


there is a REST Route to transmit the necessary information to the phone

`/ari/channels/<channel_id>/transfer_progress` where the body does contain the information. 

to transmit the successful transfer to the phone the body must contain `{"states":"channel_answered"}`

there are different options to transmit the current state:

* channel_progress
* channel_answered
* channel_unavailable
* channel_declined

these will result in the corresponding SIP  Frag Status Codes tramit via SIP Notify to the phone. `channel_progress` will do nothing but tell the phone to hold on. This is donw by asterisk itself but can be repeated. The other responses will terminate the REFER process in the on or the other way. Using `answered` the phone will most likeley hangup the active channel and will wait for the hangup of the other one.


