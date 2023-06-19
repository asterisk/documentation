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

As a gauge for how an SDP API should work, we can look at what is currently being done in the newest channel driver that uses SDP, chan\_pjsip. Let's examine the process based on our role during SDP negotiation. Apologies for the roughshod manner in which this is written.

As the answerer (UAS)
---------------------

A new INVITE arrives. We "handle" the incoming SDP first by calling the negotiate\_incoming\_sdp\_stream() callback on each media stream. This callback does the following:

* Basic validation: Ensure there is a port. Ensure that the session can handle this media type. Ensure that address provided is valid (i.e. an actual address)
* Create the RTP session (allocate, set ICE-related stuff, set NAT-related stuff, set qos)
* Set up encryption (SDES or DTLS if options are set for that)
* Set up format caps on the session (set\_caps). This does the following:
	+ Normally, gets configured codecs for endpoint.
	+ Iterate through SDP, retrieving the offered codecs.
	+ Translate the offered RTP codecs into format\_cap.
	+ Get the join capabilities between us and the peer.
	+ If there's a channel:
		- Removes all caps from the "caps" variable (our configured capabilities)
		- Appends channel native formats of all types to "caps"
		- Removes all formats of the type on this stream from "caps"
		- Appends joint capabilities to "caps"
		- Sets channel native formats to be "caps" (note: the gist of these previous steps was to add this particular type's joint capabilities to the channel native formats. Seems a bit long-winded?)
		- Sets read/write formats on channel if dealing with audio
		- Sets DTMF-related options on channel depending on some factors

Next, it calls create\_local\_sdp() This does the following:

* Sets SDP origin version, id, and user. Also sets SDP name.
* Calls handler's create\_outgoing\_sdp\_stream() for each stream. This does the following:
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

Nothing happens again until we answer the call. At that point, we get the on\_media\_update() callback from PJSIP, which will end up calling apply\_negotiated\_sdp\_stream() for each stream on the sdp. That does:

* Validation (Make sure we have a channel. Make sure that ports have been specified in both the local and remote SDP)
* Set up encryption
* Ensure remote stream has a connection address, and be sure we can resolve it
* set\_caps() (yes, again)
* set channel file descriptors
* process ICE attributes from remote stream
* Some hold logic (this is more a thing when this is called not during the initial offer/answer)
* Handle RTP keepalive and RTP timeout options

As the Offerer (UAC)
--------------------

During channel requestation, we get the joint caps based on the request caps and the configured formats on the endpoint.

When calling, we create a local SDP, much the same as was done in the Answerer-UAS scenario, and we create the RTP instance at this point.

When we receive an incoming SDP (such as 183, 200 response), we end up calling the apply\_negotiated\_sdp\_stream for each media stream. This is the same as in the answerer situation.

As an Offerer (UAS)
-------------------

This time when a new INVITE arrives, we don't call handle\_incoming\_sdp(). We instead create a local SDP offer, the same as if we were the offerer as a UAC.

We place the outgoing offer in the 200 OK.

When we receive an ACK, the on\_media\_update() callback is called just like the other offerer flow.

As an Answerer (UAC)
--------------------

This never happens, because we always will offer an SDP in our INVITE.

The takeaway:
-------------

There's actually pretty decent separation of concerns here, in that most of the SDP-related code is in its own module. The biggest violation is that within res\_pjsip\_session, a lot of the local SDP gets created there rather than elsewhere. This makes sense with the current model since res\_pjsip\_sdp\_rtp is concerned only with the RTP aspects of the SDP. Most of what would need to be done would be to move the work being done in res\_pjsip\_sdp\_rtp() to its own area and divorce it of any dependencies on PJMedia and res\_pjsip\_session-defined structures.

So structures like: ast\_sip\_session, ast\_sip\_session\_media, pjmedia\_sdp\_session, and pjmedia\_sdp\_media would need to be replaced at the API level.

A stab at an API
================

An SDP API should be dead simple. The basic operations on it should be:

* Please make me an SDP that I can send out, based on the world we know.
* Here is a remote SDP. Apply it to the world we know.
* I need information (joint formats, negotiated DTMF, etc.) so I can apply it to my channel.

The majority of the heavy lifting will be taken care of in the internals of the SDP API. The callers of the SDP API will not need to be concerned with whether they are an offerer or answerer, and they mostly won't need to be concerned about the current SDP state.

The SDP layer needs to provide similar functionality that res\_pjsip\_sdp\_rtp already provides, but with generic structures rather than ones specific to the chan\_pjsip channel driver.

 




---

  
  


```

/\*!
 \* \brief Forward declaration of an SDP options structure.
 \*
 \* SDP options will allow for the control of features such as:
 \* rtcpmux: is it enabled?
 \* BUNDLE: is it enabled? Do we require bundle-only?
 \* ICE: is it enabled? Is it standard or trickle-ICE?
 \* Telephone events: Are they enabled?
 \* In what format should SDPs be in when interacting with the SDP API user?
 \*/
struct ast\_sdp\_options; 

/\*!
 \* Simple allocation for SDP options.
 \* Initializes with sane defaults
 \*/
struct ast\_sdp\_options \*ast\_sdp\_options\_alloc(void);
 
/\*!
 \* \brief Free SDP options.
 \* 
 \* You'll only ever have to call this if an error occurs
 \* between allocating options and allocating the SDP state
 \* that uses these options. Otherwise, freeing the SDP state
 \* will free the SDP options it inherited.
 \*/
void ast\_sdp\_options\_free(struct ast\_sdp\_options \*options);
 
/\*!
 \* \brief General template for setting SDP options
 \* 
 \* The types are going to differ for each individual option, hence
 \* the "whatever" second parameter.
 \*/
int ast\_sdp\_options\_set\_<whatever>(struct ast\_sdp\_options \*sdp\_options, <whatever>);
 
/\*!
 \*\brief General template for retrieving SDP options
 \*
 \* The type being retrieved is going to be dependent on the option being retrieved,
 \* thus the return type of "whatever" here.
 \*/
<whatever> ast\_sdp\_options\_get\_<whatever>(struct ast\_sdp\_options \*sdp\_options);
 
/\*!
 \* \brief Allocate a new SDP state
 \* 
 \* SDP state keeps tabs on everything SDP-related for a media session.
 \* Most SDP operations will require the state to be provided.
 \* Ownership of the SDP options is taken on by the SDP state.
 \* A good strategy is to call this during session creation.
 \*/
struct ast\_sdp\_state\* ast\_sdp\_state\_alloc(struct ast\_stream\_topology \*streams, const struct ast\_sdp\_options \*options);
 
/\*!
 \* \brief Free the SDP state.
 \*
 \* A good strategy is to call this during session destruction
 \*/
void ast\_sdp\_state\_free(struct ast\_sdp\_state \*sdp\_state);
 
/\*!
 \* \brief Get the local SDP.
 \*
 \* If we have not received a remote SDP yet, this will be an SDP offer based on known streams and options
 \* If we have received a remote SDP, this will be the negotiated SDP based on the joint capabilities.
 \* The return type is a void pointer because the representation of the SDP is going to be determined based
 \* on the SDP options when allocating the SDP state.
 \* This function will allocate RTP instances if RTP instances have not already
 \* been allocated for the streams.
 \*
 \* The return here is const. The use case for this is so that a channel can add the SDP to an outgoing
 \* message. The API user should not attempt to modify the SDP. SDP modification should only be done through
 \* the API.
 \*/
const void \*ast\_sdp\_state\_get\_local(const struct ast\_sdp\_state \*sdp\_state);
 
/\*!
 \* \brief Set the remote SDP.
 \*
 \* This can be used for either a remote offer or answer.
 \* This can also be used whenever an UPDATE, re-INVITE, etc. arrives.
 \* The type of the "remote" parameter is dictated by whatever SDP representation
 \* was set in the ast\_sdp\_options used during ast\_sdp\_state allocation
 \*
 \* This function will allocate RTP instances if RTP instances have not already
 \* been allocated for the streams.
 \*/
int ast\_sdp\_state\_set\_remote(struct ast\_sdp\_state \*sdp, void \*remote);
 
/\*!
 \* \brief Reset the SDP state and stream capabilities as if the SDP state had just been allocated.
 \*
 \* This is most useful for when a channel driver is sending a session refresh message
 \* and needs to re-advertise its initial capabilities instead of the previously-negotiated
 \* joint capabilities.
 \*/
int ast\_sdp\_state\_reset(struct ast\_sdp\_state \*sdp);
 
/\*!
 \* \brief Get the associated RTP instance for a particular stream on the SDP state.
 \*
 \* Stream numbers correspond to the streams in the topology of the associated channel
 \*/
struct ast\_rtp\_instance \*ast\_sdp\_state\_get\_rtp\_instance(const struct ast\_sdp\_state \*sdp\_state, int stream\_index);

/\*!
 \* \brief Get the joint negotiated streams based on local and remote capabilities.
 \* If this is called prior to receiving a remote SDP, then this will just mirror the local configured endpoint capabilities.
 \*/
struct ast\_stream\_topology \*ast\_sdp\_state\_get\_joint\_topology(const struct ast\_sdp\_state \*sdp\_state);

/\*!
 \* \brief Update remote and local stream capabilities
 \*
 \* If something outside SDP negotiation updates channel capabilities, use this to make sure that
 \* any SDP we create will have the appropriate new capabilities present. Direct media is something
 \* that could cause capabilities to be altered, as an example.
 \*
 \* Retrieval of the local SDP after calling either of these functions will result in the appropriate
 \* joint stream capabilities being represented.
 \*/
int ast\_sdp\_state\_update\_local\_topology(struct ast\_sdp\_state \*state, struct ast\_stream\_topology \*new\_topology);
int ast\_sdp\_state\_update\_remote\_topology(struct ast\_sdp\_state \*state, struct ast\_stream\_topology \*new\_topology);

/\*
 \* Override the default connection address for SDP.
 \* This is useful for NAT operations and for direct media.
 \*/
int ast\_sdp\_state\_set\_connection\_address(struct ast\_sdp\_state \*state, struct ast\_sockaddr \*addr);

```



---


Let's talk about the API a bit. The API introduces two new structures: `ast_sdp_state`, and `ast_sdp_options`.

`ast_sdp_options`
-----------------

The first to talk about is `ast_sdp_options`. This is vaguely defined in the API above because there will likely be a lot of options, and trying to make sure all are covered at this point is futile. The options here will be used to influence behavior of the SDP layer. Have a look at the sample code sections to see some hypothetical uses of SDP options.




---

**Note:**  It may be a good idea to have some shortcut methods for options. For instance, have an `ast_sdp_options_set_webrtc()`, which will set up bundle, ICE, RTCP-mux, DTLS, and anything else that WebRTC requires.

  



---


`ast_sdp_state`
---------------

This structure is 100% opaque to callers, and basically is used as a way for the SDP API to understand the situation and respond appropriately to requests. Internally, this will keep track of things such as our role in SDP negotiation, progress of SDP negotiation, formats, and options. It's recommended that SDP-using channel drivers allocate this early during session allocation and free it when the session is freed.

A note from the API: notice that `ast_sdp_state_alloc()` gains ownership of the `ast_sdp_options` passed in. Also notice that there is no method of accessing the options from the state. This is on purpose, because SDP options become set in stone once they have been passed to the SDP state and cannot be changed. This is done for a few reasons:

* Declaring ownership this way prevents data races due to outside threads potentially trying to change options out from under the SDP state.
* SDP options are intended to be derived from endpoint configuration and not be based on dynamic changes that happen during a session. Anything that can change during a session should not be an SDP option.

Another note from the API: Notice that there is a function for retrieving the RTP instance. This is because the `ast_sdp_state` is responsible for allocating the RTP instance. Users of the SDP API should not allocate their own RTP instances, but rather retrieve them from the SDP state. This way, users can set RTP options directly, like RTP timeout, RTP keepalive, etc. RTP properties that are derived from the SDP should not be addressed by users of the SDP API. That's taken care of automatically.

ICE
---

ICE plays a vital role in WebRTC. Unfortunately, it's also a bit on the complicated side, especially with the interactions it has between RTP and SDP. It can be hard to divide the duties up so that the proper layer is in charge of what it should be. Realistically, ICE could exist as its own subsystem, separate from RTP. In Asterisk, the duties are a bit mixed; there's an ICE engine structure, but it's tied closely together with RTP instances. When RTP is allocated, if ICE is enabled, then the RTP layer will perform the necessary STUN requests in order to gather all ICE candidates before returning the allocated RTP instance. From here, the user of the RTP instance can call public functions that allow for iterating over the gathered candidates and adding those to the SDP as necessary.

For stage one of the SDP API, we will continue to operate this way. That is, if ICE is enabled, then the SDP layer can iterate over the gathered local ICE candidates and add them to the resultant SDP. Longer term, though, we want to support both standard ICE and trickle-ICE. With trickle-ICE, candidates are learned asynchronously. When we send out our initial SDP, we may not have learned of all server-reflexive, peer-reflexive, and relay candidates. As individual new ICE candidates are learned, the channel driver uses some protocol-dependent method to "trickle" out the new candidates. This means that the ICE layer needs to be able to send alerts to the channel driver to say when a new ICE candidate is learned. In addition, the SDP layer needs to know about the new candidate. This way, if Asterisk needs to generate a session refresh SDP, the ICE candidates can be advertised in the new SDP.

Being that we need to support such a thing, it may be beneficial to move towards a more unified model for determining ICE candidates. Instead of calling an ICE engine's get\_local\_candidates() callback to retrieve all candidates for a given instance, the ICE layer could always call back to interested parties each time that a new candidate is learned. If using standard ICE, the callbacks would be invoked while blocking on the call to allocate an RTP instance. If using Trickle-ICE, then the callbacks would be called as the candidates are learned. The SDP layer will react the same way no matter which type of ICE is in use: Add the newly-learned ICE candidate to the SDP. The channel driver, though, would only act on this callback if Trickle-ICE were in use. Otherwise, the callbacks will be ignored.

The callback would look something like the following:




---

  
  


```

/\*!
 \* \brief Callback type for discovery of new ICE candidates
 \*
 \* This will be called each time a new ICE candidate is discovered on an RTP instance.
 \* The opaque pointer is the same data that was passed in when registering the callback.
 \*/
typedef int (\*new\_candidate\_fn)(struct ast\_rtp\_instance \*rtp, struct ast\_rtp\_engine\_ice\_candidate \*candidate, void \*data);
 
/\*
 \* Indicate interest in being told of new ICE candidates.
 \* 
int ast\_rtp\_instance\_register\_ice\_new\_candidate\_cb(struct ast\_rtp\_instance \*rtp, new\_candidate\_fn cb, void \*data);

```



---


This way, an RTP instance can be told by interested parties to be alerted whenever a new ICE candidate is learned. The data parameter is a way to quickly associate the RTP instance with another piece of data the callback cares about (like an SDP state or a PJSIP session).

You may be saying to yourself that there's a possible race condition here. What happens if ICE candidates are discovered before someone registers their callback function? This API provides the guarantee that interested parties will be told of every ICE candidate. If candidates have been discovered prior to when the candidate callback is registered, those candidates will be presented in the callback immediately.

To reiterate, this ICE change would be saved for a milestone beyond the initial rollout of the SDP layer. For the initial rollout, the old method will still be used.

Code samples
============

Here is a hypothetical allocation of an `ast_sdp_state`.




---

  
  


```

int init\_session(struct my\_channel\_driver\_session \*session)
{
 struct ast\_sdp\_options \*sdp\_options;
 struct ast\_sdp\_state \*sdp\_state;

 sdp\_options = ast\_sdp\_options\_alloc();
 if (!sdp\_options) {
 return -1;
 }

 /\* Set us up so BUNDLE offers bundle-only \*/
 if (ast\_sdp\_options\_set\_bundle(sdp\_options, AST\_SDP\_BUNDLE\_ONLY)) {
 goto fail;
 }

 /\* Enable RTCPmux on all RTP instances allocated \*/
 if (ast\_sdp\_options\_set\_rtcpmux(sdp\_options, 1)) {
 goto fail;
 }

 /\* When setting/retrieving an SDP, represent it as a string \*/
 if (ast\_sdp\_options\_set\_repr(sdp\_options, AST\_SDP\_REPR\_STRING)) {
 goto fail;
 }

 sdp\_state = ast\_sdp\_state\_alloc(session->endpoint->stream\_topology, sdp\_options);
 if (!sdp\_state) {
 /\* ast\_sdp\_state\_alloc() will free the options on failure \*/
 return -1;
 }

 session->sdp\_state = sdp\_state;
 return 0;

fail:
 ast\_sdp\_options\_free(sdp\_options);
 return -1;
}

```



---


In this example, we enable several SDP options and then use those to allocate the SDP state. The SDP state is saved onto the session for future use.

Now let's make a call.




---

  
  


```

int make\_a\_call(struct my\_channel\_driver\_session \*session, char \*dest)
{
 struct my\_channel\_driver\_message \*message;

 message = make\_call\_message(dest);

 message->sdp = ast\_sdp\_state\_get\_local(session->sdp\_state);

 return send\_message(message);
}

```



---


When it comes time to make a call, all we have to do is request our local SDP, translate it into the appropriate representation, and then send our message out. The SDP that we retrieve in this case is based on the formats and options that we passed into SDP state creation.

Now what about receiving an incoming call.




---

  
  


```

int incoming\_call(struct my\_channel\_driver\_session \*session, struct my\_channel\_driver\_message \*message)
{ 
 struct my\_channel\_driver\_message \*response;

 if (message->sdp) {
 struct ast\_stream\_topology \*joint\_topology;
 struct ast\_stream\_topology \*old\_channel\_topology;
 struct ast\_stream\_topology \*channel\_topology;
 ast\_sdp\_state\_set\_remote(session->sdp\_state, message->sdp);
 joint\_topology = ast\_stream\_topology\_copy(ast\_sdp\_state\_get\_joint\_topology(session->sdp\_state));
  
 /\* Since we're receiving an initial offer, we can just modify the channel stream topology directly. \*/
 ast\_channel\_lock(session->channel);
 old\_channel\_topology = channel\_topology = ast\_channel\_stream\_topology\_get(session->channel));
 channel\_topology = joint\_topology;
 ast\_channel\_unlock(session->channel);
 
 ast\_stream\_topology\_destroy(old\_channel\_topology);
 }

 /\* Let's pretend that my\_channel\_driver requires us to send a provisional response immediately upon receipt \*/
 response = make\_provisional\_response(message);

 response->sdp = ast\_sdp\_state\_get\_local(session->sdp\_state);
 
 return send\_message(response);
}

```



---


This is very similar to what we did when creating an outgoing call. The interesting difference here is that we now potentially call `ast_sdp_state_set_remote()` if the incoming message has an SDP. This causes the subsequent call to `ast_sdp_state_get_local()` to behave differently. If the incoming message had an SDP, then `ast_sdp_state_get_local()` will return the negotiated SDP that we should use as an answer. If the incoming message had no SDP, then `ast_sdp_state_get_local()` will return the exact same SDP offer we use when making an outgoing call.

Now let's look at a hypothetical switchover to direct media.




---

  
  


```

int direct\_media\_enabled(struct my\_channel\_driver\_session \*session, struct ast\_stream\_topology \*peer\_topology, struct ast\_sockaddr \*peer\_addr)
{
 struct my\_channel\_driver\_message \*message;
 struct ast\_format\_cap \*joint\_topology;

 ast\_sdp\_state\_update\_local\_topology(session->sdp\_state, peer\_topology);
 joint\_topology = ast\_sdp\_state\_get\_joint\_topology(session->sdp\_state);
 ast\_channel\_stream\_topology\_request\_change(session->channel, join\_topology);
 
 ast\_sdp\_state\_set\_connection\_address(session->sdp\_state, peer\_addr);

 message = make\_media\_update\_message(session);
 
 message->sdp = ast\_sdp\_state\_get\_local(session->sdp\_state);

 return send\_message(message);
}

```



---


It may be a bit confusing what's going on with the format\_cap structures here. If we assume that Alice and Bob are going to be doing direct media, then let's pretend that this is the session with Alice. The peer\_topology is Bob's topology. By making Bob's topology our local topology, it results in the joint topology being that of Bob and Alice. We update the SDP state to use this joint topology. We then also update the connection address so we place the correct address in it place. The subsequent call to get the local SDP now will properly reflect the updated capabilities and peer address.

Lingering questions:
====================

1. Is anything critical missing from the API? Obviously, individual SDP options are ill-defined at this point, and it may be that we need a few more small functions here and there.
2. Similarly, is there anything defined in the API that we won't need? I was having trouble coming up with code snippets to get RTP options, for instance, but I didn't want to remove them.
3. Is the current idea for SDP representation a good one? Or should the API settle on a specific representation of SDPs for getting/setting, leaving conversion to channel drivers?
4. The API is ambiguous about when it allocates an RTP instance. My current thought is that this is on purpose since new features may require us to allocate the RTP session at a different time than we currently do. Should we be more explicit, though?
5. The ownership model of `ast_sdp_options` may be wasteful. Currently, you allocate the options each time you create a new SDP state, and the SDP state inherits ownership of the options. It may be more prudent to allocate SDP options at endpoint creation time. Then just pass the same SDP options structure into each allocation of an SDP state. Each SDP state would just gain a reference to the (immutable) SDP options.
