---
title: Media Format Rewrite
pageid: 27199677
---

History
=======

In the old times media formats were represented using a bit field. This was fast but had a few limitations. We were limited on how many there were and they also did not include any attribute information. It was strictly a "this is ulaw". This was changed and ast\_format was created, which is a structure that contains additional information. Additionally ast\_format\_cap was created to act as a container and another mechanism was added to allow logic to be registered which performed format negotiation. Everywhere throughout the codebase the code was changed to use this strategy but unfortunately this came at a cost.

Performance analysis and profiling has shown that we spend an inordinate amount of time comparing, copying, and generally manipulating formats and their related structures. Basic prototyping has shown that there is a reasonably large performance improvement to be made in this area - this project is to overhaul the media format architecture and its usage in Asterisk to improve performance.

Use Cases
=========

The following, for the most part, assumes that the channels use RTP for media and SIP for signalling. Most use cases, however, will translate to any VoIP channel driver. DAHDI, as always, is its own thing.




!!! note 
    The Offer/Answer use cases below only apply to `chan_pjsip`. `chan_sip`, for better or worse, has its own fun rules about what codecs are offered and when.
[//]: # (end-note)


  
  


```

/\* add\_sdp: \*/

 /\* Now, start adding audio codecs. These are added in this order:
 - First what was requested by the calling channel
 - Then preferences in order from sip.conf device config for this peer/user
 - Then other codecs in capabilities, including video
 \*/  



---


 

Changing `chan_sip` is fraught with peril. As such, we're going to try and give the power/flexibility of how things are offered/answered to where we can better maintain/control the behaviour, which means `chan_pjsip`.


```


General Rules
-------------

1. For an inbound channel with a set of format capabilities, Asterisk should respond to that set of formats with the intersection of the offered capabilities and what is configured for the endpoint for that channel. The format preference order should be based on the configuration of the endpoint.
	1. If the system should accept a different set of codecs, a dialplan function and/or channel variable can be used to set which formats (and their preference order) are accepted on the channel at run-time. This would have to occur before the inbound channel is answered (via the MASTER\_CHANNEL function and the U/M options in the dialplan).
	2. If the system would like to restrict in the device to a single format, a dialplan function and/or channel variable and/or configuration option can be set so that Asterisk will only ever respond with the preferred codec.
2. For an outbound channel, Asterisk should offer the formats that have been configured for that endpoint, with the format preference order based on the configuration of that channel's endpoint.
	1. If the system would like to restrict the outbound channel such that it only has a single format, a dialplan function/channel variable/configuration option can be used such that Asterisk only offers a single format.
3. Prior to entering a bridge, a dialplan function can be used to set whether or not that channel will attempt to make itself compatible with whatever is in the bridge with it. If a channel enters a bridge that has another channel in it with a format it supports, it will attempt to switch the channel to the bridged channel's format to facilitate native bridging. Note that this has no bearing in multi-party bridges, where everyone is transcoded.
4. At any point in time, a dialplan function can be used to set the allowed set of formats on the channel, with whatever ordering. These formats should be a subset of the allowed formats configured on that channel's endpoint. This will cause the channel to re-negotiate to the set of formats specified by the function.

The difference with this approach is that Asterisk will no longer always attempt to avoid transcoding. Instead, it will default to the rules configured in the `.conf` files, overriding as it can via the dialplan. Transcoding may be more likely in poorly configured systems, but it will also allow for much greater flexibility in the behaviour of Asterisk.

Single Channel
--------------

### Nominal Offer/Answer (Single Media Stream)




!!! info ""
    Each of the tests with a Single Media Stream should be repeated for each media stream that a channel driver supports, i.e., audio, video, RTT, etc.

      
[//]: # (end-info)



#### Offer Negotiation - Nominal

* Alice's phone offers some set of codecs in an INVITE request (example: ulaw,g729,ilbc), where all codecs are supported by Alice's endpoint
* Asterisk responds with an answer containing the codecs in the order specified by the offer




!!! tip 
    This should also verify various SDP offers:

    1. Lack of rtpmap attributes for specific codecs, e.g., 0 implies ulaw (See Table 2, RFC 1890)
    2. Non-standard rtpmap designations for codecs

    While these could be considered "off-nominal", they are allowed by the various RFCs and should be covered under a 'nominal negotiation', where the set of codecs offered match completely with what is configured in Asterisk

      
[//]: # (end-tip)



#### Offer Negotiation - Subset (Alice)

* Alice's phone offers a set of codecs in an INVITE request, where a subset of the codecs is supported by Alice's endpoint and some subset is not
* Asterisk modifies the origin line in the SDP, and responds with the set of codecs that are allowed based on the intersection of the offered codecs and the configured codecs for the endpoint

#### Offer Negotiation - Subset (Asterisk)

* Alice's phone offers a set of codecs in an INVITE request, where the codecs offered is a subset of the codecs supported by Alice's endpoint
* Asterisk responds with an answer containing the codecs in the order specified by the offer

#### Offer Negotiation - Preferred Codec Only (Alice's preference)

* Alice's phone offers a set of codecs in an INVITE request, where all codecs are supported by Alice's endpoint
* Asterisk modifies the origin line in the SDP, and responds with only the preferred codec in the offer

#### Offer Negotiation - Preferred Codec Only (Asterisk's preference)

* Alice's phone offers a set of codecs in an INVITE request, where all codecs are supported by Alice's endpoint
* Asterisk modifies the origin line in the SDP, and responds with only the preferred codec configured via the dialplan/configuration file

#### Offer Negotiation - Preferred Codec List

* Alice's phone offers a set of codecs in an INVITE request, where all codecs are supported by Alice's endpoint
* Asterisk modifies the origin line in the SDP, and responds with a subset of the codecs in the offer re-ordered per the preference order defined via the dialplan/configuration file

#### Offer Negotiation - packetization

* Alice's phone offers a set of codecs in an INVITE request, where the preferred codec has a ptime attribute indicating a different packetization
* Asterisk responds with the codecs in the offer, and sends RTP to the endpoint with the appropriate packetization

### Nominal Offer/Answer (Multiple Media Streams)

All use cases covered in Nominal Offer/Answer (Single Media Stream) apply here as well, save that there should be multiple streams of different types. Asterisk should treat the preferred codec offer in the same fashion for each stream independently; that is, if the preferred codec list is ulaw,g722,h261,h264, then the preferred audio codec is ulaw and the preferred video codec is h261.




!!! info ""
    Each of the following tests be repeated to include multiple media streams in various combinations:

    * Audio + Video
    * Video + Text
    * Audio + Text
    * Audio + Video + Text
      
[//]: # (end-info)



### Restricted Offer/Answer (Single Stream)

#### No codecs

* Alice's phone offers no codecs in an INVITE request with an SDP.
* Asterisk responds with an equivalent answer.

#### Restricted flow

* Alice's phone offers a set of codecs in an INVITE request, where the media is set to sendonly (phone => Asterisk)
* Asterisk responds with the codecs in the offer, where the media is set to recvonly.

### Restricted Offer/Answer (Multiple Streams)

Each scenario in Restricted Offer/Answer applies, only with both an audio stream as well as a video stream. Either or both stream can be indicated to be sendonly, or can be sent with no codecs.

### Invalid Format Offer/Answer (Single Stream)

#### Offer Invalid Codec (one)

* Alice's phone offers a set of codecs in an INVITE request, where at least one codec is not supported by Alice's endpoint
* Asterisk responds with the subset of the codecs that were offered that it does support, using the preference order of the offer

#### Offer Invalid Codec (all)

* Alice's phone offers a set of codecs in an INVITE request, where none of the codecs are supported by Alice's endpoint
* Asterisk responds with a 488.

#### Offer Invalid Attribute

* Alice's phone offers a set of codecs, where additional attributes are provided that are invalid:
	+ An invalid rtpmap attribute for an unknown media format
	+ An invalid attribute (or unknown attribute) for a known media format
	+ An improperly formatted media description line
* Asterisk responds with a 488.

### Invalid Format Offer/Answer (Multiple Stream)

All of the scenarios in Invalid Format Offer/Answer apply, only with a single audio and a single video stream. Streams can be declined, or the entire offer can be declined with a 488 as appropriate.

Multiple Channels
-----------------

### Nominal Offer/Answer

* Alice sends an INVITE request with an offer containing a set of codecs. The offer is a complete match with the set of codecs configured for Alice's endpoint.
* Asterisk dials Bob. Bob's endpoint is configured with the same set of codecs, in the same order.
* Bob's response to the INVITE request contains the same set of codecs as the offer. Asterisk responds to Alice with her set of configured codecs.
* Alice and Bob are bridged using the same formats, with the same priority order.

### Preferred codec only

#### Preferred codec only in outbound answer

* Alice sends an INVITE request with an offer containing a set of codecs. The offer is a complete match with the set of codecs configured for Alice's endpoint.
* Asterisk dials Bob with his endpoint's codecs.
* Bob's response contains only a single codec. Asterisk uses that format for Bob's channel.
* Alice's reply contains her codecs in the order specified by her endpoint.

#### Preferred codec only in inbound answer

* Alice sends an INVITE request with an offer containing a set of codecs configured for Alice's endpoint.
* The dialplan restricts Asterisk to responding only with Alice's preferred codec.
* Asterisk dials Bob with his endpoint's codecs.
* Bob responds with an acceptable set of codecs.
* Asterisk sends an answer to Alice's offer with only her endpoint's preferred codec.

### Transcoding

#### Acceptable translation path

* Alice sends an INVITE request with an offer containing a set of codecs configured for Alice's endpoint.
* Asterisk dials Bob with his endpoint's codecs, where the codecs for Bob's endpoint are not the same as Alice's but have an acceptable translation path.
* Bob answers with his endpoint's codecs.
* Asterisk sends an answer to Alice's offer with the codecs for her endpoint.
* Alice and Bob enter a bridge together and their media is transcoded based on the current formats sent by their endpoints.

#### Failed translation path (no path exists)

* Alice sends an INVITE request with an offer containing a set of codecs configured for Alice's endpoint.
* Asterisk determines that there is no translation path between the codecs configured for Alice and the codecs configured for Bob
* Alice's offer is rejected; Bob is not dialled.

#### Failed translation paths

* Alice sends an INVITE request with an offer containing a set of codecs configured for Alice's endpoint
* Asterisk dials Bob with his endpoint's codecs, where the codecs for Bob's endpoint are not the same as Alice's. For each codec that does not have a translation path to Alice's codecs, those codecs are not offered.
* Bob responds with one of this acceptable codecs. Asterisk responds to Alice with her codecs.
* Alice and Bob enter a bridge together and their media is transcoded based on the current formats sent by their endpoints.

### Re-Invite to Native Bridge

#### Nominal

* Alice sends an INVITE request with a different ordered set of codecs than Bob.
* Alice's channel is set to re-INVITE back to native bridging if possible.




!!! tip 
    Variants to test: Bob's channel being set to re-INVITE back to a native bridge, as well as both channels being set to re-INVITE.

      
[//]: # (end-tip)

* Asterisk dials Bob with his set of codecs in his endpoint's priority order.
* Bob responds back with a set of codecs. The set of codecs should have at least one format in common.
* Asterisk Answers Alice with her preferred codecs.
* Alice and Bob enter a bridge together. Asterisk sends a re-INVITE to Alice and to Bob with the formats that are in common.
* Alice and Bob respond to the re-INVITE with a 200 OK
* Asterisk switches to a native bridge

#### Failed re-INVITE

* Alice sends an INVITE request with a different ordered set of codecs than Bob.
* Alice's channel is set to re-INVITE back to native bridging if possible.
* Asterisk dials Bob with his set of codecs in his endpoint's priority order.
* Bob responds back with a set of codecs. The set of codecs should have at least one format in common.
* Asterisk Answers Alice with her preferred codecs.
* Alice and Bob enter a bridge together. Asterisk sends a re-INVITE to Alice and to Bob with the formats that are in common.
* Alice responds to the re-INVITE with a failure response (488)




!!! tip 
    Variants to test: Bob rejects the re-INVITE; both Alice and Bob reject the re-INVITE

      
[//]: # (end-tip)

* Asterisk sends an UPDATE request (if Alice/Bob support it) with the previous SDP (see RFC 6337, section 3.4)
* Asterisk transcodes media between Alice and Bob

### Modified outbound invite

* Alice sends an INVITE request with a set of codecs.
* Prior to dialling Bob, PJSIP\_MEDIA\_OFFER modifies which codecs will be offered. (Alternatively, the CHANNEL function in a pre-dial handler)
* Asterisk sends an INVITE request with the codecs specified, regardless of whether or not Bob's endpoint supports them.




!!! tip 
    This scenario should test sending Bob both acceptable codecs for his endpoint, as well as codecs that are unsupported.

      
[//]: # (end-tip)


### Modified inbound response

* Alice sends over an INVITE request with a set of codecs.
* Prior to being answered, the CHANNEL function changes what media formats are accepted. Note that this must be a subset of what Alice's endpoint accepts.
* Asterisk responds with the formats the CHANNEL function specified

 

### Modified codecs (chan\_sip)




!!! note 
    This needs to be populated with tests that exercise SIP\_CODEC

      
[//]: # (end-note)



 

Design
======

The Present
-----------

### struct ast\_format

Media formats in Asterisk are now represented using a large (~320 byte) sized data structure. This is done because the data structure itself is not a reference counted object and thus carries no guarantee that associated information attached to it will be disposed of. The large size of the data structure is due to needing additional space for optional media format attributes.

### ast\_format\_copy

Copying formats now requires copying this large amount of memory. While one would think this occurs infrequently in practice this can occur more than 5 times for a single frame passing through Asterisk.

### ast\_format\_cmp

Comparing formats is no longer cheap either. Each comparison requires doing a container lookup to see if any additional logic is registered to augment the comparison operation. As code within Asterisk needs to be aware of when formats change this can occur 4 or more times for a single frame passing through Asterisk.

### Container lookup using ast\_format as key

Since comparing formats are no longer cheap using the ast\_format as a container key is extremely expensive.

### Assumptions no longer true

There are assumptions throughout the tree that media format related operations are cheap when in reality they are anything but. An example would be reusable frames. Instead of setting the frames up with the information they require at initialization they are set each time the frame is returned.

The Future
----------

### Codecs

While past media work has provided us room to add codecs within the codebase there is no dynamic manner available of doing so. For efficient storage of media formats this will need to change. The ability to add codecs to the core will be made available, with the core adding the common codecs that Asterisk is already aware of. The RTP engine API will also be extended to allow SDP specific information to be added. This will provide a truly dynamic and flexible way of adding codecs, with the added benefit that the numerical values for codecs can be used as indexes into arrays.




---

  
  


```

struct ast\_codec {
 /\*! Unique identifier for this codec, starts at 1 \*/
 unsigned int id;
 /\*! Original Asterisk identifier, optional \*/
 uint64\_t original\_id;
 /\*! Name for this codec \*/
 const char \*name;
 /\*! Brief description \*/
 const char \*description;
 /\*! Type of media this codec is for \*/
 enum ast\_format\_type type;
 /\*! Number of samples carried \*/
 unsigned int samples;
 /\*! \brief Minimum length of media that can be carried (in milliseconds) \*/
 unsigned int minimum\_ms;
 /\*! \brief Maximum length of media that can be carried (in milliseconds) \*/
 unsigned int maximum\_ms;
 /\*! \brief The number of milliseconds the length can be incremented by \*/
 unsigned int increment\_ms;
 /\*! Default length of media carried (in milliseconds) \*/
 unsigned int default\_ms;
 /\*! Whether the media can be smoothed or not \*/
 unsigned int smooth;
 /\*! Callback function for getting the number of samples in a frame \*/
 int (\*get\_samples)(struct ast\_frame \*frame);
 /\*! Callback function for getting the length of media based on number of samples \*/
 int (\*get\_length)(int samples);
};

int ast\_codec\_register(struct ast\_codec \*codec);
 
struct ast\_codec \*ast\_codec\_get(const char \*name, enum ast\_format\_type type, unsigned int samples);

```


Codec structures will be immutable once registered and created only once. If a user of the API wants to retrieve a codec they will use ast\_codec\_get with the provided information.

### struct ast\_format

The ast\_format structure will become an astobj2 allocated object as follows:




---

  
  


```

struct ast\_format {
 struct ast\_codec \*codec;
 void \*attribute\_data;
 struct ast\_format\_attr\_interface \*interface;
};

```


Because it is astobj2 allocated additional information can be stored within it, such as a pointer to attribute information and a pointer to the attribute interface to use with it. This reduces the size of the structure by quite a lot and removes the need for container lookups on comparison.

This structure will also be immutable once exposed outside the scope of what has allocated it by any means (such as being stored in an ast\_format\_cap and then returned).

Another bonus is that for some cases the format structure can be reused, such as when parsing and interpreting "allow" or "disallow" options. This reduces memory usage some more.

Attribute information storage will be left up to the attribute interface implementation.

### struct ast\_format\_cap

The ast\_format\_cap structure currently internally uses an ao2 hash table to store formats. Leveraging the fact that codecs have a unique identifier we can turn this into a vector with the codec identifier as the index.




---

  
  


```

struct ast\_format\_cap {
 AST\_VECTOR(, struct ast\_format \*) formats;
 AST\_VECTOR(, int) framing;
 AST\_VECTOR(, int) preference;
};

```


This presents an easy mechanism to see if a format is present in the structure.

The framing and preference order is now also made available directly in the cap structure itself, allowing this information to persist in additional places.

### struct ast\_format\_pref

The ast\_format\_pref structure currently uses a fixed sized array of formats (not pointers). This structure is no longer required since the framing and preference order has now been moved into the cap structure directly.

### ast\_format\_copy

The ast\_format\_copy operation will simply be incrementing the reference count of the format and returning it.




!!! note 
    I don't foresee needing a function which does a deep copy. In practice you don't copy a media format and then modify it.

      
[//]: # (end-note)



### ast\_format\_cmp

Comparing formats is similar to the previous implementation except instead of doing a container lookup the pointer to the attribute interface is now directly on the structure.

### AST\_CONTROL\_FORMAT\_CHANGE

If media is received with a format that differs from previous frames an AST\_CONTROL\_FORMAT\_CHANGE control frame will be inserted ahead of the new frame at the ingress point. Any code which relies on the format will use this control frame to update themselves to the new format. No format comparisons should be used to determine this. The control frame should be used instead.

### RTP Engine API

The RTP engine API currently uses an AO2 container for storing payload mapping information. Since this mapping occurs frequently this comes at a cost.

For mapping from payload to format a fixed array with the payload as the index will be used.

For mapping from format to payload a vector with the format codec id as the index will be used.

### Format Usage

#### Creating a format

For cases where a format has to be created a new API call, ast\_format\_create, which takes in a codec will be made available.




---

  
  


```

struct ast\_format \*ast\_format\_create(struct ast\_codec \*codec);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_codec \*codec = ast\_codec\_get("ulaw", AST\_FORMAT\_TYPE\_AUDIO, 8000);
 struct ast\_format \*format;

 if (!codec) {
 return;
 }
 
 format = ast\_format\_create(codec);
 ao2\_ref(codec, -1);
 
 ao2\_cleanup(format);
}

```


 

#### Setting attributes

Attribute information can be set on a format by using the ast\_format\_attribute\_set function. To keep things dynamic it takes in both a string for attribute name and value.




---

  
  


```

int ast\_format\_attribute\_set(struct ast\_format \*format, const char \*attribute, const char \*value); 

```


 

Example:




---

  
  


```

static void test\_example(void)
{
 struct ast\_codec \*codec = ast\_codec\_get("silk", AST\_FORMAT\_TYPE\_AUDIO, 8000);
 struct ast\_format \*format;
 
 if (!codec) {
 return;
 }

 format = ast\_format\_create(codec);
 ao2\_ref(codec, -1);

 if (!format) {
 return;
 } 

 ast\_format\_attribute\_set(format, "rate", "24000");
 ast\_format\_attribute\_set(format, "rate", "16000");
 ast\_format\_attribute\_set(format, "rate", "12000");
 ast\_format\_attribute\_set(format, "rate", "8000");
 ao2\_ref(format, -1);
}

```




!!! note 
    Since format attributes are stored in an implementation specific manner there is no API for getting/retrieving/clearing/etc attributes.

      
[//]: # (end-note)



### Format Capabilities Usage

#### Creating and destroying format capabilities structure

The function to allocate a capabilities structure is unchanged but the format capabilities structure is now a reference counted object to reduce copying. As a result there is no explicit function to destroy a structure.




---

  
  


```

struct ast\_format\_cap \*ast\_format\_cap\_alloc(enum ast\_format\_cap\_flags flags);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_format\_cap \*caps = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 
 ao2\_ref(caps, -1);
}

```


#### Adding a format to the capabilities structure

This is slightly changed from the existing API in that the format passed in is not const. The implementation also increments the reference count of the format instead of copying it.




---

  
  


```

void ast\_format\_cap\_add(struct ast\_format\_cap \*cap, struct ast\_format \*format);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_codec \*codec = ast\_codec\_get("ulaw", AST\_FORMAT\_TYPE\_AUDIO, 8000);
 struct ast\_format \*format;
 struct ast\_format\_cap \*caps;
 
 if (!codec) {
 return;
 }
 
 format = ast\_format\_create(codec);
 ao2\_ref(codec, -1);
 
 if (!format) {
 return;
 }
 
 caps = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 if (!caps) {
 ao2\_ref(format, -1);
 return;
 }
 
 ast\_format\_cap\_add(caps, format);
 
 ao2\_ref(format, -1);
 ao2\_ref(caps, -1);
}
 

```




!!! note 
    Ordering of format additions to a capabilities structure is preserved and forms the format preference order.

      
[//]: # (end-note)



#### Capabilities structure manipulation

Numerous functions manipulate the capabilities structure itself. These are used to copy formats between structures, duplicate them, etc. These will go unchanged except internally they will no longer duplicate the format. Instead they will increment the reference count.




---

  
  


```

void ast\_format\_cap\_add\_all\_by\_type(struct ast\_format\_cap \*cap, enum ast\_format\_type type);
void ast\_format\_cap\_add\_all(struct ast\_format\_cap \*cap);
void ast\_format\_cap\_append(struct ast\_format\_cap \*dst, const struct ast\_format\_cap \*src);
void ast\_format\_cap\_copy(struct ast\_format\_cap \*dst, const struct ast\_format\_cap \*src);
struct ast\_format\_cap \*ast\_format\_cap\_dup(const struct ast\_format\_cap \*src);
int ast\_format\_cap\_is\_empty(const struct ast\_format\_cap \*cap);
int ast\_format\_cap\_remove(struct ast\_format\_cap \*cap, struct ast\_format \*format);
void ast\_format\_cap\_remove\_bytype(struct ast\_format\_cap \*cap, enum ast\_format\_type type);
void ast\_format\_cap\_remove\_all(struct ast\_format\_cap \*cap);

```


#### Capabilities structure iteration

As the capabilities structure is now stored using an array iteration will involve two functions, ast\_format\_cap\_count and ast\_format\_cap\_get, which returns the number of formats in the structure and gets a specific one based on index.




---

  
  


```

size\_t ast\_format\_cap\_count(const struct ast\_format\_cap \*cap);
struct ast\_format \*ast\_format\_cap\_get(const struct ast\_format\_cap \*cap, int index);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_format\_cap \*caps = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 size\_t count;
 int index;
 
 if (!caps) {
 return;
 }
 
 for (count = ast\_format\_cap\_count(caps), index = 0; index < count; index++) {
 struct ast\_format \*format = ast\_format\_cap\_get(caps, index);
 
 ao2\_ref(format, -1);
 }
 
 ao2\_ref(caps, -1);
}

```


#### Framing size

The framing size controls the length of media frames (in milliseconds). Previously this was stored in a separate structure but has now been rolled into ast\_format\_cap. To allow control two API calls will be added.




---

  
  


```

void ast\_format\_cap\_framing\_set(struct ast\_format\_cap \*cap, const struct ast\_format \*format, unsigned int framing);
unsigned int ast\_format\_cap\_framing\_get(const struct ast\_format\_cap \*cap, const struct ast\_format \*format);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_codec \*codec = ast\_codec\_get("ulaw", AST\_FORMAT\_TYPE\_AUDIO, 8000);
 struct ast\_format \*format;
 struct ast\_format\_cap \*caps;
 unsigned int framing;
 
 if (!codec) {
 return;
 }
 
 format = ast\_format\_create(codec);
 ao2\_ref(codec, -1);
 
 if (!format) {
 return;
 }
 
 caps = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 if (!caps) {
 ao2\_ref(format, -1);
 return;
 }
 
 ast\_format\_cap\_add(caps, format);
 ast\_format\_cap\_framing\_set(caps, format, 20);
 framing = ast\_format\_cap\_framing\_get(caps, format);
 
 ao2\_ref(format, -1);
 ao2\_ref(caps, -1);
}

```


#### Getting joint capabilities

Joint capabilities are the common compatible formats between two capabilities structure. These will be done using the existing API functions but will now take preference order into consideration. This will be done by using the order of the first capabilities structure passed in.




---

  
  


```

struct ast\_format\_cap \*ast\_format\_cap\_joint(const struct ast\_format\_cap \*cap\_preferred, const struct ast\_format\_cap \*cap\_secondary);
int ast\_format\_cap\_joint\_copy(const struct ast\_format\_cap \*cap1, const struct ast\_format\_cap \*cap2, struct ast\_format\_cap \*result);
int ast\_format\_cap\_joint\_append(const struct ast\_format\_cap \*cap1, const struct ast\_format\_cap \*cap2, struct ast\_format\_cap \*result);

```


 

Example:




---

  
  


```

static void example(void)
{
 struct ast\_codec \*codec = ast\_codec\_get("ulaw", AST\_FORMAT\_TYPE\_AUDIO, 8000);
 struct ast\_format \*format;
 struct ast\_format\_cap \*caps0, \*caps1, \*joint;
 
 if (!codec) {
 return;
 }
 
 format = ast\_format\_create(codec);
 ao2\_ref(codec, -1);
 
 if (!format) {
 return;
 }
 
 caps0 = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 if (!caps0) {
 ao2\_ref(format, -1);
 return;
 }
 
 ast\_format\_cap\_add(caps0, format);
 ao2\_ref(format, -1);
 
 caps1 = ast\_format\_cap\_alloc(AST\_FORMAT\_CAP\_FLAG\_NOLOCK);
 if (!caps1) {
 ao2\_ref(caps0, -1);
 return;
 }
 
 ast\_format\_cap\_copy(caps1, caps0);
 
 joint = ast\_format\_cap\_joint(caps0, caps1);
 
 ao2\_cleanup(joint);
 ao2\_ref(caps0, -1);
 ao2\_ref(caps1, -1);
}

```


