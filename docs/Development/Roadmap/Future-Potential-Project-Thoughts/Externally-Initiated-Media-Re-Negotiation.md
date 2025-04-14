---
title: Externally Initiated Media Re-Negotiation
pageid: 44794087
---

Traditionally in Asterisk for the longest time media re-negotiation when initiated externally (for example a SIP endpoint performing a re-INVITE) has been between the endpoint and Asterisk. The support for this was limited to changing codecs. Adding streams was not really supported 'nor was removing streams. To that end it was expected when a call was established that all streams were already present. In a multistream world this isn't that ideal.

With multistream support control frames were added to provide notification and control over re-negotiation, opening the door to some cool things (such as the SFU). This was only partially implemented though with externally initiated re-negotiation not being completed. Recently (as of this writing) this was improved to provide notification to the current application handling the channel that re-negotiation from the endpoint has occurred. The application can then inspect and act on the new stream information.

This change only serves as notification though and does not provide end to end negotiation. That is: If I receive a re-INVITE adding video then it is automatically accepted, even if I am talking to another channel and they can't or won't accept the video. From a user experience perspective this is not as ideal as it could be. This wiki page serves as a spot for some of my thoughts on how this could be done.

On receipt of a re-INVITE the processing of the SDP should be delayed and a control frame raised. The new stream topology could be placed within the frame itself, or stored on the underlying channel. It needs to be made available to the application currently handling the channel in some manner so it can be acted on. Note that the SDP will need to be processed enough to construct a viable stream topology that accurately describes the re-INVITE. A timer should be started such that after a period of time if no accepted stream topology is provided to the channel that the re-INVITE is negotiated against the already negotiated stream topology, declining any newly added streams.

For the application handling the channel it should act on the control frame that has been raised indicating a re-negotiation request has been received. The application can convey to the channel what the result of the re-negotiation is using the ast_channel_stream_topology_changed function. This function invocation resumes processing of the SDP, and negotiates using the provided stream topology.

For bridging (bridge_simple and bridge_native_rtp) on receipt of a re-negotiation control frame a request is made to the opposite channel to re-negotiate using the provided stream topology. If this completes the result is provided to the initiator of the re-negotiation using the ast_channel_stream_topology_changed function.

Some concerns:

There is currently no place to store the pending requested topology. It could be stored on the frame, but proper management of the topology will need to be done when duping or freeing the frame.

The bridging API does not currently provide the pending requested topology to the bridging technology. The existing API callback will need to be extended or a new one added, unless the topology is stored on the channel.

The res_pjsip_sdp_rtp module does not have the logic broken apart for negotiating and applying negotiated SDP potentially enough to allow it to be deferred.
