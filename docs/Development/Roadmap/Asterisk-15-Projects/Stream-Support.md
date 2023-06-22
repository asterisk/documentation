---
title: Stream Support
pageid: 36800306
---

Streams! ALL THE STREAMS!
=========================

Let's start with talking about what streams are. Streams at their core are a flow of media. They can be unidirectional or bidirectional and are comprised of media formats. The media formats also contain a type. To simplify things streams only carry a single type of media. Streams can also carry an identifier in the form of a name.

Asterisk currently has no explicit interface for streams and simply has a single pipe that frames are written to and read from. The negotiated formats are scoped to the entire channel as a result. Interfaces that need to manipulate media have injected themselves into this single pipe and have to take special care to not manipulate frames they do not need to. This pipe also carries control frames and other signaling related operations. This means that there is a single very loose stream for each type of media.

So what do we need to be able to do for streams?
================================================

* We need to be able to know what streams are present
* We need to be able to know the details about the streams
* We need to be able to add, remove, and change a stream (or streams)
* We need to be able to know that a frame has come from a specific stream
* We need to be able to send a frame and have it go out a specific stream
* We need to be able to negotiate two streams
* We need to be able to exchange media between two streams

All of this needs to be present and existing functionality needs to continue to work as expected.

But what about all the media stuff that exists now?
===================================================

This is the complicated part. Let's take a look at impacted functionality.

Audiohooks
----------

As they exist now audiohooks hook themselves into every audio frame that is passing through a channel. This works since there is only ever a single 'virtual' stream.

#### Initial Support

Audiohooks will only hook themselves into the first audio stream on a channel.

#### Long Term

Audiohooks will be expanded to allow selecting the stream that it is to be placed on. If no stream is specified it will select the first.

Framehooks
----------

Framehooks currently are invoked for every frame passing through a channel.

#### Initial Support

Framehooks will only hook themselves into control frames and the first stream of each type. This mirrors the current behavior.

#### Long Term

Framehooks will allow specifying what streams are to be hooked into. The callback will provide information about what stream a frame is in relation to.

Translation
-----------

Translation currently only reliably creates a translation path for the audio portion of a channel.

#### Initial Support

The code will only create a translation path for the first audio stream.

#### Middle Term

Each audio stream will create an appropriate translation path.

File Playback/Recording
-----------------------

The file API is one of the oldest things in Asterisk. Given a set of formats on the channel it will decide what file (without a container) will be played.

#### Initial Support

The code will use the formats on the first audio and video stream to determine what file should be used for playback. It will be played out to those streams.

#### Long Term

A container format will be implemented which supports multiple streams within itself. Based on the characteristics of the streams the best file will be chosen and played back. Each stream within the container will be played out. For existing files without a container the initial support logic will be used.

Bridging
--------

#### Initial Support

The first stream of each type will be connected. This mirrors the existing behavior. While it does not utilize streams (yet) it ensures that existing behavior works.

#### Middle Term

Each stream in order of type from each channel is connected. If stream changes are required (adding/removing) then they are initiated and the result taken into account. If a translation path is required it is set up for audio.

Older Channel Drivers
---------------------

The older channel drivers should have a default stream representation based on the formats on the channel. If audio and video is negotiated, then there should be an audio and video stream and it should be transparent to the channel driver. Ideally \_no\_ changes would be required to the channel drivers. Any requests to change, manipulate, add, or remove streams will result in an error and the operation failing.

So How Do We Get There?
=======================

By not burning down what already exists so we don't go crazy updating everything so it all works again.

Legacy
------

The below design attempts to strike the balance between implementing the functionality we need in streams while maintaining the full media related APIs that exist today. It does this by bringing into code what logically exists within the 'virtual' streams.The API refers to these as default streams. Default streams are the first stream present on a channel for each media type. This mirrors the behavior of the 'virtual' streams present in the original single pipe. All consumers of the existing media related APIs deal with these default streams without knowing it. The internal implementation of each core API is changed to use the default stream that is applicable.

Core Concepts
-------------

As part of the addition of streams support two new core concepts have been added: streams and stream topologies.

Streams are a representation of a flow of media and contain the details described at the beginning of this wiki page.

Stream topologies are an ordered list of associated media streams. 

stream.h
--------

This file holds the public stream API. This covers functionality for inspection by components in the system (such as applications), stream creation, stream manipulation, topology creation, and topology manipulation.




---

  
  


```

/\*!
 \* \brief Forward declaration for a stream, as it is opaque
 \*/
struct ast\_stream;
 
/\*!
 \* \brief The topology of a set of streams
 \*/
struct ast\_stream\_topology;

enum ast\_stream\_state {
 /\*!
 \* \brief Set when the stream has been removed
 \*/
 AST\_STREAM\_STATE\_REMOVED = 0,
 /\*!
 \* \brief Set when the stream is sending and receiving media
 \*/
 AST\_STREAM\_STATE\_SENDRECV,
 /\*!
 \* \brief Set when the stream is sending media only
 \*/
 AST\_STREAM\_STATE\_SENDONLY,
 /\*!
 \* \brief Set when the stream is receiving media only
 \*/
 AST\_STREAM\_STATE\_RECVONLY,
 /\*!
 \* \brief Set when the stream is not sending OR receiving media
 \*/
 AST\_STREAM\_STATE\_INACTIVE,
};
 
/\*!
 \* \brief Create a new media stream representation
 \*
 \* \param name A name for the stream
 \* \param type The media type the stream is handling
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*
 \* \note This is NOT an AO2 object and has no locking. It is expected that a higher level object provides protection.
 \*
 \* \note The stream will default to an inactive state until changed.
 \*/
struct ast\_stream \*ast\_stream\_create(const char \*name, enum ast\_media\_type type);

/\*!
 \* \brief Destroy a media stream representation
 \*
 \* \param stream The media stream
 \*/
void ast\_stream\_destroy(struct ast\_stream \*stream);

/\*!
 \* \brief Get the name of a stream
 \*
 \* \param stream The media stream
 \*
 \* \return The name of the stream
 \*/
const char \*ast\_stream\_get\_name(const struct ast\_stream \*stream);

/\*!
 \* \brief Get the media type of a stream
 \*
 \* \param stream The media stream
 \*
 \* \return The media type of the stream
 \*/
enum ast\_media\_type ast\_stream\_get\_type(const struct ast\_stream \*stream);
 
/\*!
 \* \brief Change the media type of a stream
 \*
 \* \param stream The media stream
 \* \param type The new media type
 \*/
void ast\_stream\_set\_type(struct ast\_stream \*stream, enum ast\_media\_type type);
/\*!
 \* \brief Get the current negotiated formats of a stream
 \*
 \* \param stream The media stream
 \*
 \* \return The negotiated media formats
 \*
 \* \note The reference count is not increased
 \*/
struct ast\_format\_cap \*ast\_stream\_get\_formats(const struct ast\_stream \*stream);
 
/\*!
 \* \brief Set the current negotiated formats of a stream
 \*
 \* \param stream The media stream
 \* \param caps The current negotiated formats
 \*/
void ast\_stream\_set\_formats(struct ast\_stream \*stream, ast\_format\_cap \*caps);

/\*!
 \* \brief Get the current state of a stream
 \*
 \* \param stream The media stream
 \*
 \* \return The state of the stream
\*/
enum ast\_stream\_state ast\_stream\_get\_state(const struct ast\_stream \*stream);
 
/\*!
 \* \brief Set the state of a stream
 \*
 \* \param stream The media stream
 \* \param state The new state that the stream is in
 \*
 \* \note Used by stream creator to update internal state
 \*/
void ast\_stream\_set\_state(struct ast\_stream \*stream, enum ast\_stream\_state state);

/\*!
 \* \brief Get the number of the stream
 \*
 \* \param stream The media stream
 \*
 \* \return The number of the stream
 \*/
unsigned int ast\_stream\_get\_num(const struct ast\_stream \*stream);
 
/\*!
 \* \brief Create a stream topology
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_stream\_topology \*ast\_stream\_topology\_new(void);

/\*!
 \* \brief Add a stream to the topology
 \*
 \* \param topology The topology of streams
 \* \param stream The stream to add
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_stream\_topology\_add(struct ast\_stream\_topology \*topology, struct ast\_stream \*stream);

/\*!
 \* \brief Get the number of streams in a topology
 \*
 \* \param topology The topology of streams
 \*
 \* \return the number of streams
 \*/
size\_t ast\_stream\_topology\_num(const struct ast\_stream\_topology \*topology);

/\*!
 \* \brief Get a specific stream from the topology
 \*
 \* \param topology The topology of streams
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_stream \*ast\_stream\_topology\_get(const struct ast\_stream\_topology \*topology, unsigned int stream\_num);

/\*!
 \* \brief Copy an existing stream topology
 \*
 \* \param topology The existing topology of streams
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_stream\_topology \*ast\_stream\_topology\_copy(const struct ast\_stream\_topology \*topology);
 
/\*!
 \* \brief Set a specific numbered stream in a topology
 \*
 \* \brief topology The topology of streams
 \* \brief num The stream number to set
 \* \brief stream The stream to put in its place
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*
 \* \note If an existing stream exists it will be destroyed
 \*/
int ast\_stream\_topology\_set(struct ast\_stream\_topology \*topology, unsigned int num, struct ast\_stream \*stream);
 
/\*!
 \* \brief A helper function that given a set of formats creates a topology with the required streams to satisfy them
 \*
 \* \param caps The format capabilities containing formats
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*
 \* \note The format capabilities reference is NOT stolen by this function
 \*
 \* \note Each stream will be to sendrecv state
 \*/
struct ast\_stream\_topology \*ast\_stream\_topology\_make(struct ast\_format\_cap \*caps);

/\*!
 \* \brief Destroy a stream topology
 \*
 \* \param topology The topology of streams
 \*
 \* \note All streams contained within the topology will be destroyed
 \*/
void ast\_stream\_topology\_destroy(struct ast\_stream\_topology \*topology);

```


These functions can be used by anything to examine a stream after retrieving a stream (from a channel for example) and to manipulate a stream by a stream user.

As you can see a stream has various attributes: the media type being carried on, a unique (to a channel) identifier, the formats negotiated on it, its current state, a name, and an opaque data. In the case of the name this may be constructed externally (as a result of receiving an SDP offer) or generated locally if we are sending an offer.

It is expected that the originator of a stream associate data within itself using the stream numerical identifier. This allows an array (or a vector) to be used for an easy mapping.

Stream creation is up to the originator of a stream. In the case of a channel driver the channel driver may know a new stream exists, create it, and then place it on a channel. For file playback it may do something similar but place the stream in an internal structure instead. For stream destruction it is up to the holder of stream. This can be the internal channel core, or the file playback implementation. If the channel driver does not support multiple streams the internal core API will take care of the management of default streams.

A common method of describing (and passing around) a topology of streams is also present. This is an ordered list of streams that can be added to, queried, and manipulated.

stream.c
--------

The stream implementation will hold the actual definition of a stream and the implementation of the various functions.




---

  
  


```

struct ast\_stream {
 /\*!
 \* \brief The type of media the stream is handling
 \*/
 enum ast\_media\_type type;
 /\*!
 \* \brief Unique number for the stream within the context of the channel it is on
 \*/
 unsigned int num;
 /\*!
 \* \brief Current formats negotiated on the stream
 \*/
 struct ast\_format\_cap \*formats;
 /\*!
 \* \brief The current state of the stream
 \*/
 enum ast\_stream\_state state;
 /\*!
 \* \brief Name for the stream within the context of the channel it is on
 \*/
 char name[0];
};
 
struct ast\_stream\_topology {
 /\*!
 \* \brief A vector of all the streams in this topology
 \*/
 AST\_VECTOR(, struct ast\_stream \*) streams;
};

```


The contents of a stream very much mirror that of the public and internal APIs. There is not anything truly hidden away yet.

channel.h
---------

The channel header file will be minimally changed to add multiple stream support.




---

  
  


```

 /\*!
 \* \brief Channels with this particular technology support multiple simultaneous streams
 \*/
 AST\_CHAN\_TP\_MULTISTREAM = (1 << 3),
 
struct ast\_channel\_tech {
 /\*!
 \* \brief Callback invoked to write a frame to a specific stream
 \*/
 int (\* const write\_stream)(struct ast\_channel \*chan, unsigned int stream\_num, struct ast\_frame \*frame);
};
 
/\*!
 \* \brief Write a frame to a specific stream on a channel
 \*
 \* \param chan The channel to write to
 \* \param stream\_num The number of the specific stream to send the frame out on
 \* \param frame The frame to write out
 \*
 \* \pre chan is locked
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_write\_stream(struct ast\_channel \*chan, unsigned int stream\_num, struct ast\_frame \*frame);
 
/\*!
 \* \brief Read a frame from all streams
 \*
 \* \param chan The channel to read from
 \* \param stream\_num[out] The number of the specific stream the frame originated from, if a media frame
 \*
 \* \pre chan is locked
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_frame \*ast\_read\_streams(struct ast\_channel \*chan, unsigned int \*stream\_num);

/\*!
 \* \brief Retrieve the topology of streams on a channel
 \*
 \* \param chan The channel to get the stream topology of
 \*
 \* \pre chan is locked
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_stream\_topology \*ast\_channel\_get\_stream\_topology(const struct ast\_channel \*chan);
 
/\*!
 \* \brief Request that the stream topology of a channel change
 \*
 \* \param chan The channel to change
 \* \param topology The new stream topology
 \*
 \* \pre chan is locked
 \*
 \* \retval 0 request has been accepted to be attempted
 \* \retval -1 request could not be attempted
 \*
 \* \note This function initiates an asynchronous request to change the stream topology. It is not
 \* guaranteed that the topology will change and until an AST\_CONTROL\_STREAM\_TOPOLOGY\_CHANGED
 \* frame is received from the channel the current handler of the channel must tolerate the
 \* stream topology as it currently exists.
 \*
 \* \note This interface is provided for applications and resources to request that the topology change.
 \* It is not for use by the channel driver itself.
 \*/
int ast\_channel\_stream\_topology\_request\_change(struct ast\_channel \*chan, struct ast\_stream\_topology \*topology);
 
/\*!
 \* \brief Provide notice to a channel that the stream topology has changed
 \*
 \* \param chan The channel to provide notice to
 \* \param topology The new stream topology
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*
 \* \note This interface is provided for applications and resources to accept a topology change.
 \* It is not for use by the channel driver itself.
 \*/
int ast\_channel\_stream\_topology\_changed(struct ast\_channel \*chan, struct ast\_stream\_topology \*topology);

```


To indicate support for multiple streams a property has been added for channel technologies to enable. An inspection function exists for the purpose of getting the topology of streams on the channel. Once retrieved the normal topology functions can be used to inspect each stream individually. In the case of channel drivers they can also manipulate the stream topology provided the channel lock is held.

#### Stream Creation

If the multiple stream property is not set the act of setting nativeformats for a channel will automatically create (or revive if removed) streams in the background. A stream will exist for each media type of formats on the channel. If the channel has both an audio and video format an audio stream and a video stream will exist. These will be set as the default stream for each media type.

If the multiple stream property is set the act of creating and adding streams is left up to the specific channel driver. As each stream is added to the channel if a default stream for that media type does not exist then the stream will be set as the default.

#### Writing Frames

The ast\_write function will choose a default stream based on the media type of the frame being written. If no default stream exists the frame will not be written.

The ast\_write\_stream function will provide the given frame to the channel driver with the given stream. It is up to the channel driver to write the frame out on that stream. All frames written using either ast\_write or ast\_write\_stream will be provided to the channel driver using the write\_stream technology callback.

#### Reading Frames

The ast\_read function will read frames from ONLY default streams and non-media. If a frame is received on a non-default stream it will be discarded and a null frame returned. This mirrors current behavior.

The ast\_read\_streams function will read frames from ALL streams and non-media. It is up to the caller to then decide to do based on the stream.

#### Changing Stream Topology

An external entity (such as a SIP phone) can request that the stream topology change at any time. The channel driver receives the change in an implementation specific fashion and queues an AST\_CONTROL\_STREAM\_TOPOLOGY\_REQUEST\_CHANGE on the channel. The current handler of the channel reads the frame and acts upon the stream topology within it. The stream topology (whether it is changed or not) is provided to the channel using the ast\_channel\_stream\_topology\_changed function. For legacy reasons the ast\_read() function will not allow topology changes and the current negotiated stream topology will be returned within its implementation, signaling that the topology change did not result in an accepted change.

Components in Asterisk can request that a stream topology change by providing a new topology to the ast\_channel\_stream\_topology\_request\_change function. This is provided to the channel driver and is implementation specific how it is done. The existing stream topology can be used as a base by retrieving the topology from the channel and calling the ast\_stream\_topology\_copy function to copy it. Once the stream topology change result is known in the channel driver it queues an AST\_CONTROL\_STREAM\_TOPOLOGY\_CHANGED frame.

Both of these control frames contain the complete stream topology.

frame.h
-------

The only change to frame related stuff is mere control frame additions.




---

  
  


```

enum ast\_control\_frame\_type {
 AST\_CONTROL\_STREAM\_TOPOLOGY\_REQUEST\_CHANGE = 35, /\*!< Channel indication that a stream topology change has been requested by the channel driver (only visible if ast\_read\_streams is used) \*/
 AST\_CONTROL\_STREAM\_TOPOLOGY\_CHANGED = 36, /\*!< Channel indication that a stream topology change has occurred on the channel driver \*/
};

```


The control frame type is used to communicate a request to change the stream topology or an indication that the stream topology has changed. When written it is a request, when read it is informational.

Examples
========

Creating streams on a channel
-----------------------------




---

  
  


```

 struct ast\_stream \*audio\_stream, \*video\_stream;
 
 audio\_stream = ast\_stream\_create("audio", AST\_MEDIA\_TYPE\_AUDIO);
 video\_stream = ast\_stream\_create("video", AST\_MEDIA\_TYPE\_VIDEO);
 
 ast\_channel\_lock(chan);
 ast\_stream\_topology\_add(ast\_channel\_get\_stream\_topology(chan), audio\_stream);
 ast\_stream\_topology\_add(ast\_channel\_get\_stream\_topology(chan), video\_stream);
 ast\_channel\_unlock(chan);

```


This  creates an audio and video stream and places them on the channel.

Iterating
---------




---

  
  


```

 int i;
 struct ast\_stream\_topology \*topology;
 
 ast\_channel\_lock(chan);
 
 topology = ast\_channel\_get\_stream\_topology(chan);
 for (i = 0; i < ast\_stream\_topology\_num(topology); i++) {
 struct ast\_stream \*stream;
 
 stream = ast\_stream\_topology\_get(topology, i);
 }
 
 ast\_channel\_unlock(chan);

```


This just loops through all the streams on a channel.

Requesting a change to the stream topology
------------------------------------------




---

  
  


```

 struct ast\_stream\_topology \*modified;
 struct ast\_stream \*first;

 ast\_channel\_lock(chan);

 modified = ast\_stream\_topology\_copy(ast\_channel\_get\_stream\_topology(chan));
 first = ast\_stream\_topology\_get(modified, 0);
 ast\_stream\_set\_state(first, AST\_STREAM\_STATE\_INACTIVE);
 ast\_channel\_stream\_topology\_request\_change(chan, modified);

 ast\_channel\_unlock(chan);

```


This code requests that the first stream on the channel be set to inactive.

Handling a request to change the stream topology
------------------------------------------------




---

  
  


```

 struct ast\_frame \*frame;
 unsigned int stream\_num;

 frame = ast\_read\_streams(chan, &stream\_num);
 if (frame->frametype == AST\_CONTROL && frame->subclass.integer == AST\_CONTROL\_STREAM\_TOPOLOGY\_REQUEST\_CHANGE) {
 ast\_channel\_stream\_topology\_changed(chan, frame->data.ptr); 
 }
 ast\_frfree(frame);

```


This code reads in a request to change the topology and accepts the topology as requested. Note that we only receive request changes if we are capable of supporting multiple streams. If this were to use ast\_read() the topology request change would be internally handled.

