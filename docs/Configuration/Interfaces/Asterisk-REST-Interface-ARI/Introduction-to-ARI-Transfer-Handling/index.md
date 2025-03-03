# Transfer Handling

## Introduction

Transfer is a telephony feature. There are two types of transfer, attended and blind. These names may differ depending on the system you are looking on, or what background you have.

The ARI transfer handling is supposed to be used in an ARI only environment to control a traditional channel or bridge with ARI is not possible. Please refer to "how to use ARI" for more information. For this scenario all channels and bridges need to be placed into an ARI context.

### Attended transfer
Attended transfer happens, if a call on hold and an active call are connected on request of the user. The user can talk to both parties before connecting them. This is also called a consultative transfer.

### Blind transfer
Blind transfer happens, if the user transfers the active call to a destination, not knowing the state or reachability of the destination. The user does not talk to the destination before the transfer. Blind transfer is also called a cold transfer. 

## Transfer handling in SIP

In SIP there is a method called `REFER`. This method, if triggered by the user, contains all the known information by the telephone about what calls shall be connected. The SIP Server sends back a direct response to the user. The response in case the PBX will try to handle the REFER is an 202 Accepted. After that the PBX will notify the user by using the `Notify` method about the current state of the transfer.

## Transfer handling in ARI

Asterisk handles the REFER without any config changes by itself. To have ARI handle the transfer you need to change a setting so the ARI events are generated. If done, the `channelTransferEvent` will be generated in case a `REFER` is received. The `channelTransferEvent` contains the information about the transfer. The `channelTransferEvent` is generated for both, blind and attended transfer.

### Information within the `channelTransferEvent`

#### Attended transfer

Asterisk will try to get as much information as possible about the transfer. The `REFER` does only contain the corresponding SIP-Call ID. With this SIP-Call ID, Asterisk try to resolve the channel-ID used by ARI for the channel.

During a transfer scenario there are a lot of moving parts involved. A typical setup for an attended transfer looks like this:

Call schema 1
```
channel A --- bridge 1 -X- channel B

channel C --- bridge 2 --- channel D
```

Where the channel marked with an "X" is set on hold, channel A should receive MOH but this is not necessary.
Depending on the used telephone a SIP REFER is send to the channel B or D. Either way, Asterisk tries to resolve all the channel information involved.
the `channelTransferEvent` contains both `refer_to` and `referred_by` information.
The `refer_to` sections will always contain information about the SIP-Call ID in the field `requested-destination`. This is the information we receive from the telephone.
In addition, the `refer_to` does contain, as far as the Asterisk could resolve it, the information about the own `channel-id` the `bridge-id` the channel is connected to and the connected `channel-id`. Relating to the schema above the `refer_to` would contain channel B, bridge 1 and channel A, if the REFER is received on channel D. 

Corresponding to the `refer_to` the `referred_by` section contains the information about the channel and bridge the REFER was received on. Related to the schema above it would contain channel D, bridge 2 and channel C.

#### Blind transfer

Here the information `refer_to` contains the destination to where the call should be placed. This information is dialed by the user and most likely follows the dial schema the user is used to. In most cases the user dialed a telephone number.

The `referred_by` section does contain exactly what it does for the attended transfer.

The call scenario would look like:

Call schema 2
```
channel A --- bridge 1 -X- channel B
```

Where the channel marked with the "X" might be placed on hold, or not.

### Actions after the event is received

#### Attended transfer
The ARI application MUST take some action in order to handle the REFER. The Asterisk will not do anything by itself. The first thing to do when received an SIP REFER is acknowledge it. This is done by the Asterisk, as well as the first `NOTIFY` telling the telephone an `100 Trying` SIP frag. After that, the telephon waits for a `Notify` containing a SIP frag  with `200 OK`. This has to be sent by the ARI application manually.

Actions that should be taken by the ARI application in the scenario described in call schema 1:

* Remove channel C from bridge 2
* Remove channel B from bridge 1
* Add channel C to bridge 1
* Delete bridge 2
* Send a `200 OK` to the telephone
* Delete channel B
* Delete channel D (if not done by telephone)

There is a REST route to transmit the necessary information to the telephone.

`/ari/channels/<channel_id>/transfer_progress` where the body does contain the information. 
To transmit the successful transfer to the telephone the body must contain `{"states":"channel_answered"}`
There are different options to transmit the current state:

* channel_progress
* channel_answered
* channel_unavailable
* channel_declined

these will result in the corresponding SIP frag status codes being transmit via SIP notify to the telephone. `channel_progress` will do nothing but tell the telephone to hold on. This is done by Asterisk itself but can be repeated. The other responses will terminate the REFER process in the one or the other way. Using `answered` the telephone will most likely hangup the active channel and will wait for the hangup of the other one.

#### Blind transfer

Here the scenario is much simpler. In order to complete the transfer, the ARI application needs to place a new call to the destination, requested within the `refer_to`section of the `channelTransferEvent`.

Actions that should be taken by the ARI application in the scenario described in call schema 2:

* remove channel B from bridge 1
* Create and dial a new channel to the destination
* Add the new channel into the bridge 1

## Transfer handling for multi Asterisk setups

There are installations where the Asterisk is used like a media server and surrounded by SIP proxy or SBC like Kamailio or OpenSips. In these cases the Asterisk is not used as a traditional PBX and it is not the entry point for calls from telephones. In these scenarios it might happen, the Asterisk does not know all related channels.

A scenario could look like this:


```
telePhone A --- Kamailio --- Asterisk 1 --- Kamailio -
                                                  \
                                                    >--- telePhone B
                                                  /
telePhone C --- Kamailio --- Asterisk 2 --- Kamailio -

```
Each Asterisk (1 and 2)  is involved but cannot know the other Call ID or Channel.
The ARI application must be the central point in this case.
```
telePhone A --- Kamailio --- Asterisk 1 --- Kamailio ----
                            \                         \
                              >-- ARI application       >--- telePhone B
                            /                          /
telePhone C --- Kamailio --- Asterisk 2 --- Kamailio -----

```
Both channels to telephone B are placed by the same ARI application (or they share the same knowledge about ongoing calls).

If an SIP `REFER` reaches one Asterisk instance, the Asterisk will publish the `channelTransferEvent` without any destination channel ID or bridge ID but the SIP call ID. The ARI application is now able to establish a new call between the Asterisk instances to complete the transfer. The Scenario after the transfer would look like this:



```
telePhone A --- Kamailio --- Asterisk 1  --------------
                            \                       \
                              >-- ARI Application    | SIP Channel
                            /                       /
telePhone C --- Kamailio --- Asterisk 2  --------------

```
