---
title: SDP Work
pageid: 36800311
---

Asterisk currently has at least 3 channel drivers that make use of SDP in order to determine properties of RTP. Currently, each has independent code for parsing, negotiating, and applying the negotiated SDP to the resultant RTP session. The core Asterisk team is currently moving towards a goal of providing a better video experience in the upcoming releases of Asterisk. The new video work that we're planning to do involves SDP in a few ways:

* We're going to be supporting a bunch of new SDP parameters. For the most part, channel drivers should not care about understanding these.
* The most common targets for video are WebRTC endpoints. Despite their differences in signaling, they all use SDP.

To this end, separating SDP processing from channel drivers would make a ton of sense. Instead, we want to provide an SDP API. This API would allow for channel drivers to no longer be responsible for:

* SDP parsing
* SDP generation
* SDP negotiation
* RTP session creation
* RTP session modification

How things work right now (PJSIP)
=================================

As a gauge for how an SDP API should work, we can look at what is currently being done in the newest channel driver that uses SDP, chan_pjsip. Let's examine the process based on our role during SDP negotiation. Apologies for the roughshod manner in which this is written.

As the answerer (UAS)
---------------------

A new INVITE arrives. We "handle" the incoming SDP first by calling the negotiate_incoming_sdp_stream() callback on each media stream. This callback does the following:

* Basic validation: Ensure there is a port. Ensure that the session can handle this media type. Ensure that address provided is valid (i.e. an actual address)
* Create the RTP session (allocate, set ICE-related stuff, set NAT-related stuff, set qos)
* Set up encryption (SDES or DTLS if options are set for that)
* Set up format caps on the session (set_caps). This does the following:
	+ Normally, gets configured codecs for endpoint.
	+ Iterate through SDP, retrieving the offered codecs.
	+ Translate the offered RTP codecs into format_cap.
	+ Get the join capabilities between us and the peer.
	+ If there's a channel:
		- Removes all caps from the "caps" variable (our configured capabilities)
		- Appends channel native formats of all types to "caps"
		- Removes all formats of the type on this stream from "caps"
		- Appends joint capabilities to "caps"
		- Sets channel native formats to be "caps" (note: the gist of these previous steps was to add this particular type's joint capabilities to the channel native formats. Seems a bit long-winded?)
		- Sets read/write formats on channel if dealing with audio
		- Sets DTMF-related options on channel depending on some factors

Next, it calls create_local_sdp() This does the following:

* Sets SDP origin version, id, and user. Also sets SDP name.
* Calls handler's create_outgoing_sdp_stream() for each stream. This does the following:
	+ Some validation (making sure that we actually want to add a stream of this type)
	+ Add crypto stuff to the stream if configured for it
	+ Construct the media line: type, transport; and connection line: IP address
	+ Add ice attributes and candidates
	+ Create list of format caps. In this circumstance, it's the joint capabilities, since we've already had an incoming request.
	+ Add attributes for each format (payload number, fmtp, framing)
	+ Generate non-format RTP attributes (e.g. RFC 3766 DTMF)
	+ Add ptime if configured
	+ Add sendrecv/sendonly
* Use connection details from top stream for the global settings (connection, origin address)

Nothing happens again until we answer the call. At that point, we get the on_media_update() callback from PJSIP, which will end up calling apply_negotiated_sdp_stream() for each stream on the sdp. That does:

* Validation (Make sure we have a channel. Make sure that ports have been specified in both the local and remote SDP)
* Set up encryption
* Ensure remote stream has a connection address, and be sure we can resolve it
* set_caps() (yes, again)
* set channel file descriptors
* process ICE attributes from remote stream
* Some hold logic (this is more a thing when this is called not during the initial offer/answer)
* Handle RTP keepalive and RTP timeout options

As the Offerer (UAC)
--------------------

During channel requestation, we get the joint caps based on the request caps and the configured formats on the endpoint.

When calling, we create a local SDP, much the same as was done in the Answerer-UAS scenario, and we create the RTP instance at this point.

When we receive an incoming SDP (such as 183, 200 response), we end up calling the apply_negotiated_sdp_stream for each media stream. This is the same as in the answerer situation.

As an Offerer (UAS)
-------------------

This time when a new INVITE arrives, we don't call handle_incoming_sdp(). We instead create a local SDP offer, the same as if we were the offerer as a UAC.

We place the outgoing offer in the 200 OK.

When we receive an ACK, the on_media_update() callback is called just like the other offerer flow.

As an Answerer (UAC)
--------------------

This never happens, because we always will offer an SDP in our INVITE.

The takeaway:
-------------

There's actually pretty decent separation of concerns here, in that most of the SDP-related code is in its own module. The biggest violation is that within res_pjsip_session, a lot of the local SDP gets created there rather than elsewhere. This makes sense with the current model since res_pjsip_sdp_rtp is concerned only with the RTP aspects of the SDP. Most of what would need to be done would be to move the work being done in res_pjsip_sdp_rtp() to its own area and divorce it of any dependencies on PJMedia and res_pjsip_session-defined structures.

So structures like: ast_sip_session, ast_sip_session_media, pjmedia_sdp_session, and pjmedia_sdp_media would need to be replaced at the API level.

A stab at an API
================

An SDP API should be dead simple. The basic operations on it should be:

* Please make me an SDP that I can send out, based on the world we know.
* Here is a remote SDP. Apply it to the world we know.
* I need information (joint formats, negotiated DTMF, etc.) so I can apply it to my channel.

The majority of the heavy lifting will be taken care of in the internals of the SDP API. The callers of the SDP API will not need to be concerned with whether they are an offerer or answerer, and they mostly won't need to be concerned about the current SDP state.

The SDP layer needs to provide similar functionality that res_pjsip_sdp_rtp already provides, but with generic structures rather than ones specific to the chan_pjsip channel driver.

```
/*!
 * \brief Forward declaration of an SDP options structure.
 *
 * SDP options will allow for the control of features such as:
 * rtcpmux: is it enabled?
 * BUNDLE: is it enabled? Do we require bundle-only?
 * ICE: is it enabled? Is it standard or trickle-ICE?
 * Telephone events: Are they enabled?
 * In what format should SDPs be in when interacting with the SDP API user?
 */
struct ast_sdp_options;

/*!
 * Simple allocation for SDP options.
 * Initializes with sane defaults
 */
struct ast_sdp_options \*ast_sdp_options_alloc(void);

/*!
 * \brief Free SDP options.
 *
 * You'll only ever have to call this if an error occurs
 * between allocating options and allocating the SDP state
 * that uses these options. Otherwise, freeing the SDP state
 * will free the SDP options it inherited.
 */
void ast_sdp_options_free(struct ast_sdp_options \*options);

/*!
 * \brief General template for setting SDP options
 *
 * The types are going to differ for each individual option, hence
 * the "whatever" second parameter.
 */
int ast_sdp_options_set_<whatever>(struct ast_sdp_options \*sdp_options, <whatever>);

/*!
 *\brief General template for retrieving SDP options
 *
 * The type being retrieved is going to be dependent on the option being retrieved,
 * thus the return type of "whatever" here.
 */
<whatever> ast_sdp_options_get_<whatever>(struct ast_sdp_options \*sdp_options);

/*!
 * \brief Allocate a new SDP state
 *
 * SDP state keeps tabs on everything SDP-related for a media session.
 * Most SDP operations will require the state to be provided.
 * Ownership of the SDP options is taken on by the SDP state.
 * A good strategy is to call this during session creation.
 */
struct ast_sdp_state\* ast_sdp_state_alloc(struct ast_stream_topology \*streams, const struct ast_sdp_options \*options);

/*!
 * \brief Free the SDP state.
 *
 * A good strategy is to call this during session destruction
 */
void ast_sdp_state_free(struct ast_sdp_state \*sdp_state);

/*!
 * \brief Get the local SDP.
 *
 * If we have not received a remote SDP yet, this will be an SDP offer based on known streams and options
 * If we have received a remote SDP, this will be the negotiated SDP based on the joint capabilities.
 * The return type is a void pointer because the representation of the SDP is going to be determined based
 * on the SDP options when allocating the SDP state.
 * This function will allocate RTP instances if RTP instances have not already
 * been allocated for the streams.
 *
 * The return here is const. The use case for this is so that a channel can add the SDP to an outgoing
 * message. The API user should not attempt to modify the SDP. SDP modification should only be done through
 * the API.
 */
const void \*ast_sdp_state_get_local(const struct ast_sdp_state \*sdp_state);

/*!
 * \brief Set the remote SDP.
 *
 * This can be used for either a remote offer or answer.
 * This can also be used whenever an UPDATE, re-INVITE, etc. arrives.
 * The type of the "remote" parameter is dictated by whatever SDP representation
 * was set in the ast_sdp_options used during ast_sdp_state allocation
 *
 * This function will allocate RTP instances if RTP instances have not already
 * been allocated for the streams.
 */
int ast_sdp_state_set_remote(struct ast_sdp_state \*sdp, void \*remote);

/*!
 * \brief Reset the SDP state and stream capabilities as if the SDP state had just been allocated.
 *
 * This is most useful for when a channel driver is sending a session refresh message
 * and needs to re-advertise its initial capabilities instead of the previously-negotiated
 * joint capabilities.
 */
int ast_sdp_state_reset(struct ast_sdp_state \*sdp);

/*!
 * \brief Get the associated RTP instance for a particular stream on the SDP state.
 *
 * Stream numbers correspond to the streams in the topology of the associated channel
 */
struct ast_rtp_instance \*ast_sdp_state_get_rtp_instance(const struct ast_sdp_state \*sdp_state, int stream_index);

/*!
 * \brief Get the joint negotiated streams based on local and remote capabilities.
 * If this is called prior to receiving a remote SDP, then this will just mirror the local configured endpoint capabilities.
 */
struct ast_stream_topology \*ast_sdp_state_get_joint_topology(const struct ast_sdp_state \*sdp_state);

/*!
 * \brief Update remote and local stream capabilities
 *
 * If something outside SDP negotiation updates channel capabilities, use this to make sure that
 * any SDP we create will have the appropriate new capabilities present. Direct media is something
 * that could cause capabilities to be altered, as an example.
 *
 * Retrieval of the local SDP after calling either of these functions will result in the appropriate
 * joint stream capabilities being represented.
 */
int ast_sdp_state_update_local_topology(struct ast_sdp_state \*state, struct ast_stream_topology \*new_topology);
int ast_sdp_state_update_remote_topology(struct ast_sdp_state \*state, struct ast_stream_topology \*new_topology);

/*
 * Override the default connection address for SDP.
 * This is useful for NAT operations and for direct media.
 */
int ast_sdp_state_set_connection_address(struct ast_sdp_state \*state, struct ast_sockaddr \*addr);

```

Let's talk about the API a bit. The API introduces two new structures: `ast_sdp_state`, and `ast_sdp_options`.

`ast_sdp_options`
-----------------

The first to talk about is `ast_sdp_options`. This is vaguely defined in the API above because there will likely be a lot of options, and trying to make sure all are covered at this point is futile. The options here will be used to influence behavior of the SDP layer. Have a look at the sample code sections to see some hypothetical uses of SDP options.




!!! note 
    It may be a good idea to have some shortcut methods for options. For instance, have an `ast_sdp_options_set_webrtc()`, which will set up bundle, ICE, RTCP-mux, DTLS, and anything else that WebRTC requires.

      
[//]: # (end-note)



`ast_sdp_state`
---------------

This structure is 100% opaque to callers, and basically is used as a way for the SDP API to understand the situation and respond appropriately to requests. Internally, this will keep track of things such as our role in SDP negotiation, progress of SDP negotiation, formats, and options. It's recommended that SDP-using channel drivers allocate this early during session allocation and free it when the session is freed.

A note from the API: notice that `ast_sdp_state_alloc()` gains ownership of the `ast_sdp_options` passed in. Also notice that there is no method of accessing the options from the state. This is on purpose, because SDP options become set in stone once they have been passed to the SDP state and cannot be changed. This is done for a few reasons:

* Declaring ownership this way prevents data races due to outside threads potentially trying to change options out from under the SDP state.
* SDP options are intended to be derived from endpoint configuration and not be based on dynamic changes that happen during a session. Anything that can change during a session should not be an SDP option.

Another note from the API: Notice that there is a function for retrieving the RTP instance. This is because the `ast_sdp_state` is responsible for allocating the RTP instance. Users of the SDP API should not allocate their own RTP instances, but rather retrieve them from the SDP state. This way, users can set RTP options directly, like RTP timeout, RTP keepalive, etc. RTP properties that are derived from the SDP should not be addressed by users of the SDP API. That's taken care of automatically.

ICE
---

ICE plays a vital role in WebRTC. Unfortunately, it's also a bit on the complicated side, especially with the interactions it has between RTP and SDP. It can be hard to divide the duties up so that the proper layer is in charge of what it should be. Realistically, ICE could exist as its own subsystem, separate from RTP. In Asterisk, the duties are a bit mixed; there's an ICE engine structure, but it's tied closely together with RTP instances. When RTP is allocated, if ICE is enabled, then the RTP layer will perform the necessary STUN requests in order to gather all ICE candidates before returning the allocated RTP instance. From here, the user of the RTP instance can call public functions that allow for iterating over the gathered candidates and adding those to the SDP as necessary.

For stage one of the SDP API, we will continue to operate this way. That is, if ICE is enabled, then the SDP layer can iterate over the gathered local ICE candidates and add them to the resultant SDP. Longer term, though, we want to support both standard ICE and trickle-ICE. With trickle-ICE, candidates are learned asynchronously. When we send out our initial SDP, we may not have learned of all server-reflexive, peer-reflexive, and relay candidates. As individual new ICE candidates are learned, the channel driver uses some protocol-dependent method to "trickle" out the new candidates. This means that the ICE layer needs to be able to send alerts to the channel driver to say when a new ICE candidate is learned. In addition, the SDP layer needs to know about the new candidate. This way, if Asterisk needs to generate a session refresh SDP, the ICE candidates can be advertised in the new SDP.

Being that we need to support such a thing, it may be beneficial to move towards a more unified model for determining ICE candidates. Instead of calling an ICE engine's get_local_candidates() callback to retrieve all candidates for a given instance, the ICE layer could always call back to interested parties each time that a new candidate is learned. If using standard ICE, the callbacks would be invoked while blocking on the call to allocate an RTP instance. If using Trickle-ICE, then the callbacks would be called as the candidates are learned. The SDP layer will react the same way no matter which type of ICE is in use: Add the newly-learned ICE candidate to the SDP. The channel driver, though, would only act on this callback if Trickle-ICE were in use. Otherwise, the callbacks will be ignored.

The callback would look something like the following:

```
/*!
 * \brief Callback type for discovery of new ICE candidates
 *
 * This will be called each time a new ICE candidate is discovered on an RTP instance.
 * The opaque pointer is the same data that was passed in when registering the callback.
 */
typedef int (\*new_candidate_fn)(struct ast_rtp_instance \*rtp, struct ast_rtp_engine_ice_candidate \*candidate, void \*data);

/*
 * Indicate interest in being told of new ICE candidates.
 * 
int ast_rtp_instance_register_ice_new_candidate_cb(struct ast_rtp_instance \*rtp, new_candidate_fn cb, void \*data);

```

This way, an RTP instance can be told by interested parties to be alerted whenever a new ICE candidate is learned. The data parameter is a way to quickly associate the RTP instance with another piece of data the callback cares about (like an SDP state or a PJSIP session).

You may be saying to yourself that there's a possible race condition here. What happens if ICE candidates are discovered before someone registers their callback function? This API provides the guarantee that interested parties will be told of every ICE candidate. If candidates have been discovered prior to when the candidate callback is registered, those candidates will be presented in the callback immediately.

To reiterate, this ICE change would be saved for a milestone beyond the initial rollout of the SDP layer. For the initial rollout, the old method will still be used.

Code samples
============

Here is a hypothetical allocation of an `ast_sdp_state`.

```
int init_session(struct my_channel_driver_session \*session)
{
 struct ast_sdp_options \*sdp_options;
 struct ast_sdp_state \*sdp_state;

 sdp_options = ast_sdp_options_alloc();
 if (!sdp_options) {
 return -1;
 }

 /* Set us up so BUNDLE offers bundle-onl */
 if (ast_sdp_options_set_bundle(sdp_options, AST_SDP_BUNDLE_ONLY)) {
 goto fail;
 }

 /* Enable RTCPmux on all RTP instances allocate */
 if (ast_sdp_options_set_rtcpmux(sdp_options, 1)) {
 goto fail;
 }

 /* When setting/retrieving an SDP, represent it as a strin */
 if (ast_sdp_options_set_repr(sdp_options, AST_SDP_REPR_STRING)) {
 goto fail;
 }

 sdp_state = ast_sdp_state_alloc(session->endpoint->stream_topology, sdp_options);
 if (!sdp_state) {
 /* ast_sdp_state_alloc() will free the options on failur */
 return -1;
 }

 session->sdp_state = sdp_state;
 return 0;

fail:
 ast_sdp_options_free(sdp_options);
 return -1;
}

```

In this example, we enable several SDP options and then use those to allocate the SDP state. The SDP state is saved onto the session for future use.

Now let's make a call.

```
int make_a_call(struct my_channel_driver_session \*session, char \*dest)
{
 struct my_channel_driver_message \*message;

 message = make_call_message(dest);

 message->sdp = ast_sdp_state_get_local(session->sdp_state);

 return send_message(message);
}

```

When it comes time to make a call, all we have to do is request our local SDP, translate it into the appropriate representation, and then send our message out. The SDP that we retrieve in this case is based on the formats and options that we passed into SDP state creation.

Now what about receiving an incoming call.

```
int incoming_call(struct my_channel_driver_session \*session, struct my_channel_driver_message \*message)
{ 
 struct my_channel_driver_message \*response;

 if (message->sdp) {
 struct ast_stream_topology \*joint_topology;
 struct ast_stream_topology \*old_channel_topology;
 struct ast_stream_topology \*channel_topology;
 ast_sdp_state_set_remote(session->sdp_state, message->sdp);
 joint_topology = ast_stream_topology_copy(ast_sdp_state_get_joint_topology(session->sdp_state));
 
 /* Since we're receiving an initial offer, we can just modify the channel stream topology directly */
 ast_channel_lock(session->channel);
 old_channel_topology = channel_topology = ast_channel_stream_topology_get(session->channel));
 channel_topology = joint_topology;
 ast_channel_unlock(session->channel);

 ast_stream_topology_destroy(old_channel_topology);
 }

 /* Let's pretend that my_channel_driver requires us to send a provisional response immediately upon receip */
 response = make_provisional_response(message);

 response->sdp = ast_sdp_state_get_local(session->sdp_state);
 
 return send_message(response);
}

```

This is very similar to what we did when creating an outgoing call. The interesting difference here is that we now potentially call `ast_sdp_state_set_remote()` if the incoming message has an SDP. This causes the subsequent call to `ast_sdp_state_get_local()` to behave differently. If the incoming message had an SDP, then `ast_sdp_state_get_local()` will return the negotiated SDP that we should use as an answer. If the incoming message had no SDP, then `ast_sdp_state_get_local()` will return the exact same SDP offer we use when making an outgoing call.

Now let's look at a hypothetical switchover to direct media.

```
int direct_media_enabled(struct my_channel_driver_session \*session, struct ast_stream_topology \*peer_topology, struct ast_sockaddr \*peer_addr)
{
 struct my_channel_driver_message \*message;
 struct ast_format_cap \*joint_topology;

 ast_sdp_state_update_local_topology(session->sdp_state, peer_topology);
 joint_topology = ast_sdp_state_get_joint_topology(session->sdp_state);
 ast_channel_stream_topology_request_change(session->channel, join_topology);

 ast_sdp_state_set_connection_address(session->sdp_state, peer_addr);

 message = make_media_update_message(session);
 
 message->sdp = ast_sdp_state_get_local(session->sdp_state);

 return send_message(message);
}

```

It may be a bit confusing what's going on with the format_cap structures here. If we assume that Alice and Bob are going to be doing direct media, then let's pretend that this is the session with Alice. The peer_topology is Bob's topology. By making Bob's topology our local topology, it results in the joint topology being that of Bob and Alice. We update the SDP state to use this joint topology. We then also update the connection address so we place the correct address in it place. The subsequent call to get the local SDP now will properly reflect the updated capabilities and peer address.

Lingering questions:
====================

1. Is anything critical missing from the API? Obviously, individual SDP options are ill-defined at this point, and it may be that we need a few more small functions here and there.
2. Similarly, is there anything defined in the API that we won't need? I was having trouble coming up with code snippets to get RTP options, for instance, but I didn't want to remove them.
3. Is the current idea for SDP representation a good one? Or should the API settle on a specific representation of SDPs for getting/setting, leaving conversion to channel drivers?
4. The API is ambiguous about when it allocates an RTP instance. My current thought is that this is on purpose since new features may require us to allocate the RTP session at a different time than we currently do. Should we be more explicit, though?
5. The ownership model of `ast_sdp_options` may be wasteful. Currently, you allocate the options each time you create a new SDP state, and the SDP state inherits ownership of the options. It may be more prudent to allocate SDP options at endpoint creation time. Then just pass the same SDP options structure into each allocation of an SDP state. Each SDP state would just gain a reference to the (immutable) SDP options.
