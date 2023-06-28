---
title: WebRTC User Experience Improvements
pageid: 40141090
---

Background
==========

The WebRTC support in Asterisk has evolved and improved over time (in particular with Asterisk 15) but has not yet fully ventured into the user experience area. The two most important areas of this are the handling of lost or out of order packets and bandwidth management.

Lost or out of order packets are important because they have a critical impact on video streams. The video decoder can stall and freeze if a constant stream of video frames is not provided. This means that if a single RTP packet is lost the video stream may be lost until a full frame is received (which by default we restrict requests for these to 1 ever 5 seconds) or the packet is received out of order.

Bandwidth management is important because it can lead to video stutters, stalls, and congestion.

This page documents the way that two solutions to this can be implemented to help the experience under both Chrome and Firefox. While the browsers support other options they only have a subset in common.

RTP Packet Retransmission
-------------------------

RFC: <https://tools.ietf.org/html/rfc4588>

[RFC:](https://tools.ietf.org/html/rfc4588)<https://tools.ietf.org/html/rfc4585>

Supported by: Chrome and Firefox (but not using RFC)

Firefox support tracked at: <https://bugzilla.mozilla.org/show_bug.cgi?id=1164187>

RTP packet retransmission allows a client to request retransmission of an RTP packet if they determine that it has been lost. It is up to their own logic to determine when they request this to be done. The request is done using a NACK RTCP feedback message. If the packet is in the history of the sender it is then resent. In the case of Chrome is is sent using RFC4588 (if negotiated) which encapsulates the retransmitted packet and sends it on a separate stream. In the case of Firefox the packet is resent as-is. To support this the res_rtp_asterisk will need to store a history of sent packets. This history will use a newly created API called data buffer:

### Data Buffer API

A data buffer acts as a ring buffer of data. It is given a fixed number of data packets to store (which may be dynamically changed). Given a number it will store a data packet at that position relative to the others. Given a number it will retrieve the given data packet if it is present. This is purposely a storage of arbitrary things so it can be used not just for RTP packets but also Asterisk frames in the future if needed. The given number when putting a data packet in must be within the data buffer size range.




!!! note 
    The API does not internally use a lock. It is up to the user of the API to properly protect the data buffer.

      
[//]: # (end-note)





---

  
  


```

/\*!
 \* \brief A callback function to free a data payload in a data buffer
 \*
 \* \param The data payload
 \*/
typedef void (\*ast_data_buffer_free_callback)(void \*data);
 
/\*!
 \* \brief Data buffer containing fixed number of data payloads
 \*/
struct ast_data_buffer {
 /\*! \brief Callback function to free a data payload \*/
 ast_data_buffer_free_callback free_fn;
 /\*! \brief Maximum number of data payloads in the buffer \*/
 size_t max;
};
 
/\*!
 \* \brief Allocate a data buffer
 \*
 \* \param free_fn Callback function to free a data payload
 \* \param size The maximum number of data payloads to contain in the data buffer
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast_data_buffer \*ast_data_buffer_alloc(ast_data_buffer_free_callback free_fn, size_t size);
 
/\*!
 \* \brief Resize a data buffer
 \*
 \* \param buffer The data buffer
 \* \param size The new maximum size of the data buffer
 \*
 \* \note If the data buffer is shrunk any old data payloads will be freed using the configured callback
 \*/
void ast_data_buffer_resize(struct ast_data_buffer \*buffer, size_t size);
 
/\*!
 \* \brief Place a data payload at a position in the data buffer
 \*
 \* \param buffer The data buffer
 \* \param pos The position of the data payload
 \* \param payload The data payload
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*
 \* \note It is up to the consumer of this API to ensure proper memory management of data payloads
 \*/
int ast_data_buffer_put(struct ast_data_buffer \*buffer, int pos, void \*payload);
 
/\*!
 \* \brief Retrieve a data payload from the data buffer
 \*
 \* \param buffer The data buffer
 \* \param pos The position of the data payload (-1 to get the HEAD data payload)
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*
 \* \note This does not remove the data payload from the data buffer. It will be removed when it is displaced.
 \*/
void \*ast_data_buffer_get(const struct ast_data_buffer \*buffer, int pos);
 
/\*!
 \* \brief Free a data buffer (and all held data payloads)
 \*
 \* \param buffer The data buffer
 \*/
void ast_data_buffer_free(struct ast_data_buffer \*buffer);

```


### chan_pjsip

To simplify configuration no new configuration options will be added to support RTP packet retransmission. The existing "webrtc" option will enable it using the underlying RTP engine API. Currently RTP packet retransmission is only supported in WebRTC clients for video stream types. We will mirror this and only enable it on the video stream types as well. We will enable support on both receiving and sending.

### res_pjsip_sdp_rtp

The res_pjsip_sdp_rtp module will need to place the nack rtcp-fb attributes into the SDP if enabled.

The res_pjsip_sdp_rtp module will need to place rtx into the SDP if configured on the RTP instance. This can use the existing codec method that is also used for telephone-event.

The module will also need to parse the "a=ssrc-group:FID 229172185 2616243815" attribute line which contains the SSRC used for RTX retransmission. We will also need to place our own in there with the respective SSRCs.

### rtp_engine

The RTP engine API will need to have two extended properties added:

1. Enable RTP packet retransmission support for packets we are receiving
2. Enable RTP packet retransmission support for packets we are sending

This will be passed through to the underlying RTP engine to enable or configure as it needs.

The RTP engine API also needs to have two API calls added:




---

  
  


```

/\*!
 \* \brief Retrieve the local RTP packet retransmission (RTX) SSRC value that we will be using
 \*
 \* \param rtp The RTP instance
 \* \return The SSRC value
 \*/
unsigned int ast_rtp_instance_get_rtx_ssrc(struct ast_rtp_instance \*rtp);

/\*!
 \* \brief Set the remote RTP packet retransmission (RTX) SSRC for an RTP instance
 \*
 \* \param rtp The RTP instance
 \* \param ssrc The remote RTX SSRC
 \*/
void ast_rtp_instance_set_remote_rtx_ssrc(struct ast_rtp_instance \*rtp, unsigned int ssrc);



```


Finally the "rtx" codec will need to be added as a valid option and enabled if RTP packet retransmission is enabled on the RTP instance.

### res_rtp_asterisk

The res_rtp_asterisk module will act on the extended properties that have been added to the RTP engine API.

If RTP packet retransmission support for packets we are receiving is enabled:

1. Allocate a data buffer and use it to store incoming packets based on RTP sequence number
2. If a retransmitted packet is received de-encapsulate it (if RTX is negotiated) and place it into the correct location in the data buffer
3. Place minor delay to allow reordering of packets (and retransmission) to occur
4. Take newest data payload from data buffer
5. If a sufficient (to be defined) gap is detected in stream of RTP packets send NACK to request retransmission of missing packets
6. Use RTCP information to adjust the data buffer size (nice to have)

If RTP packet retransmission support for packets we are sending is enabled:

1. Allocate a data buffer and use it to store outgoing packets based on RTP sequence number
2. If a NACK request is received get data payload from data buffer if possible and encapsulate it (if RTX is negotiated) and send on appropriate SSRC
3. Use RTCP information to adjust the data buffer size (nice to have)

Bandwidth Estimation and Control (RTCP Feedback)
------------------------------------------------

Specs: goog-remb, transport-cc, tmmbr

RFC: <https://tools.ietf.org/html/rfc5104>

RFC: <https://tools.ietf.org/html/draft-alvestrand-rmcat-remb-03>

RFC: <https://tools.ietf.org/html/draft-holmer-rmcat-transport-wide-cc-extensions-01>

Blog Info: <http://www.rtcbits.com/2017/01/bandwidth-estimation-in-webrtc-and-new.html>

Supported by: Chrome (goog-remb, transport-cc), Firefox (goog-remb, tmmbr but disabled)

Chrome support for tmmbr at: <https://bugs.chromium.org/p/webrtc/issues/detail?id=7103>

Firefox support for tmmbr preffing on at: <https://bugzilla.mozilla.org/show_bug.cgi?id=1270230>

This wiki page focuses solely on goog-remb. This is because this is common across all WebRTC clients with the only other option being transport-cc that is currently only supported by Chrome.

### chan_pjsip

The chan_pjsip module will not have any new configuration options added to it. Instead if the "webrtc" option is enabled we will place the "goog-remb" attribute into the SDP for each configure media format. It is not necessary to perform actual negotiation of the attribute. The remote WebRTC client should support goog-remb and if it does not it will discard any RTCP feedback messages we generate with it. The channel driver will also set the goog-remb extended property on any created video RTP instances if the "webrtc" option is enabled. Just like in the case of RTP packet retransmission the clients only enable goog-remb on video streams.

### rtp_engine

A new extended property should be added to enable support for goog-remb. This will be set by a channel driver that wants to enable support for it (such as chan_pjsip).

### res_rtp_asterisk

If the goog-remb extended property is not set then the below should not occur.

If an RTCP feedback message containing REMB Is received perform the following:

1. Place the REMB packet into an AST_FRAME_RTCP frame. The subclass of the frame should be the RTCP Feedback message format type.
2. Set the stream number on the AST_FRAME_RTCP frame to correspond to the stream the REMB packet is in regards to.
3. Modify the REMB packet to have a zero SSRC for both SSRCs.
4. Return the AST_FRAME_RTCP frame from res_rtp_asterisk.

If an RTCP feedback message containing REMB is provided to ast_rtp_instance_write:

1. Update the REMB packet to contain the correct SSRCs.
2. Send the REMB packet in an RTCP feedback message on the correct stream.

The abs-send-time specification (which is small) should be implemented according to the goog-remb draft.

If an RTP packet is sent:

1. Add abs-send-time information to the packet

### bridge_simple

If an AST_FRAME_RTCP frame is received from a channel:

1. Examine its stream identifier
2. Update the frame to the correct stream of the other party
3. Write the frame to the other party

### bridge_softmix

A new option will be added to conference bridges to enable goog-remb feedback support. If enabled the following behavior will occur:

1. Received goog-remb AST_FRAME_RTCP frames from each receiver of a stream are stored with the sending stream
2. Periodically all stored goog-remb AST_FRAME_RTCP frames are iterated and a combined goog-remb AST_FRAME_RTCP frame is created (behavior tbd - we will need to experiment and determine what percentage of reports to discard)
3. All stored goog-remb AST_FRAME_RTCP frames are discarded
4. The combined goog-remb AST_FRAME_RTCP frame is written to the sending stream

### channel

The ast_write_stream function will be extended to allow the writing of AST_FRAME_RTCP frames on a per-stream basis. Legacy usage of AST_FRAME_RTCP frames will not be supported.

The __ast_read function will be extended to allow reading of AST_FRAME_RTCP frames and returning them. To maintain backwards behavior only frames of a REMB subclass will be returned. All other types will be absorded as previously done.

