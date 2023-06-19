---
title: Asterisk 12 Bridging API
pageid: 22088074
---




---

**WARNING!: READ THIS**  

The API described below is a work in progress. Certain aspects, such as the semantics of what happens to a channel when it is ejected from a bridge and needs to execute a new location in the dialplan, are still being worked out. Treat the documentation here as a working reference, rather than a contractual guarantee.

  



---


[Bridging Framework](http://svn.asterisk.org/svn/asterisk/team/group/bridge_construction/include/asterisk/bridging.h)
=====================================================================================================================


Enumerations
------------


### ast\_bridge\_capability


A bridge technology uses this when it registers to inform the framework which capabilities it can provide. When a bridge is created, the creator of the bridge can specify capabilities that it knows it will need for that bridge and the framework will choose the best technology that matches those capabilities. Additionally, when conditions in a bridge change such that the technology can no longer meet all of the conditions, the framework will use the capabilities to pick a new technology for the bridge.




---

  
  


```



/\*! \brief Capabilities for a bridge technology \*/
enum ast\_bridge\_capability {
 /\*! Bridge is only capable of mixing 2 channels \*/
 AST\_BRIDGE\_CAPABILITY\_1TO1MIX = (1 << 1),
 /\*! Bridge is capable of mixing 2 or more channels \*/
 AST\_BRIDGE\_CAPABILITY\_MULTIMIX = (1 << 2),
 /\*! Bridge should natively bridge two channels if possible \*/
 AST\_BRIDGE\_CAPABILITY\_NATIVE = (1 << 3),
 /\*! Bridge should run using the multithreaded model \*/
 AST\_BRIDGE\_CAPABILITY\_MULTITHREADED = (1 << 4),
 /\*! Bridge should run a central bridge thread \*/
 AST\_BRIDGE\_CAPABILITY\_THREAD = (1 << 5),
 /\*! Bridge technology can do video mixing (or something along those lines) \*/
 AST\_BRIDGE\_CAPABILITY\_VIDEO = (1 << 6),
 /\*! Bridge technology can optimize things based on who is talking \*/
 AST\_BRIDGE\_CAPABILITY\_OPTIMIZE = (1 << 7),
};



```



---


### ast\_bridge\_channel\_state enum


The current state of an `ast_bridge_channel` object.




---

  
  


```



/\*! \brief State information about a bridged channel \*/
enum ast\_bridge\_channel\_state {
 /\*! Waiting for a signal (Channel in the bridge) \*/
 AST\_BRIDGE\_CHANNEL\_STATE\_WAIT = 0,
 /\*! Bridged channel has ended itself (it has hung up) \*/
 AST\_BRIDGE\_CHANNEL\_STATE\_END,
 /\*! Bridged channel was forced out and should be hung up \*/
 AST\_BRIDGE\_CHANNEL\_STATE\_HANGUP,
 /\*! Bridged channel was ast\_bridge\_depart() from the bridge without being hung up \*/
 AST\_BRIDGE\_CHANNEL\_STATE\_DEPART,
 /\*! Bridged channel was ast\_bridge\_depart() from the bridge during AST\_BRIDGE\_CHANNEL\_STATE\_END \*/
 AST\_BRIDGE\_CHANNEL\_STATE\_DEPART\_END,
};



```



---


### ast\_bridge\_write\_result


The possible conditions that a `ast_bridge_technology` write operation can return.




---

  
  


```



/\*! \brief Return values for bridge technology write function \*/
enum ast\_bridge\_write\_result {
 /\*! Bridge technology wrote out frame fine \*/
 AST\_BRIDGE\_WRITE\_SUCCESS = 0,
 /\*! Bridge technology attempted to write out the frame but failed \*/
 AST\_BRIDGE\_WRITE\_FAILED,
 /\*! Bridge technology does not support writing out a frame of this type \*/
 AST\_BRIDGE\_WRITE\_UNSUPPORTED,
};



```



---


### ast\_bridge\_action\_type


The framework uses this enum to determine the action it is supposed to execute on a channel in a bridge.




---

  
  


```



enum ast\_bridge\_action\_type {
 /\*! Bridged channel is to detect a feature hook \*/
 AST\_BRIDGE\_ACTION\_FEATURE,
 /\*! Bridged channel is to act on an interval hook \*/
 AST\_BRIDGE\_ACTION\_INTERVAL,
 /\*! Bridged channel is to send a DTMF stream out \*/
 AST\_BRIDGE\_ACTION\_DTMF\_STREAM,
 /\*! Bridged channel is to indicate talking start \*/
 AST\_BRIDGE\_ACTION\_TALKING\_START,
 /\*! Bridged channel is to indicate talking stop \*/
 AST\_BRIDGE\_ACTION\_TALKING\_STOP,
};



```



---


### ast\_bridge\_video\_mode\_type


For bridges that support video, the supported ways in which a bridge can choose the video source.




---

  
  


```



enum ast\_bridge\_video\_mode\_type {
 /\*! Video is not allowed in the bridge \*/
 AST\_BRIDGE\_VIDEO\_MODE\_NONE = 0,
 /\*! A single user is picked as the only distributed of video across the bridge \*/
 AST\_BRIDGE\_VIDEO\_MODE\_SINGLE\_SRC,
 /\*! A single user's video feed is distributed to all bridge channels, but
 \* that feed is automatically picked based on who is talking the most. \*/
 AST\_BRIDGE\_VIDEO\_MODE\_TALKER\_SRC,
};



```



---


Structures
----------


### ast\_bridge\_tech\_optimizations


Some bridging technologies support advanced talk optimizations/detection operations. This structure provides configuration information for those technologies.




---

  
  


```



/\*!
 \* \brief Structure specific to bridge technologies capable of
 \* performing talking optimizations.
 \*/
struct ast\_bridge\_tech\_optimizations {
 /\*! The amount of time in ms that talking must be detected before
 \* the dsp determines that talking has occurred \*/
 unsigned int talking\_threshold;
 /\*! The amount of time in ms that silence must be detected before
 \* the dsp determines that talking has stopped \*/
 unsigned int silence\_threshold;
 /\*! Whether or not the bridging technology should drop audio
 \* detected as silence from the mix. \*/
 unsigned int drop\_silence:1;
};



```



---


### ast\_bridge\_channel


The `ast_bridge_channel` object maintain the state of an `ast_channel` in a bridge.




---

  
  


```



/\*!
 \* \brief Structure that contains information regarding a channel in a bridge
 \*/
struct ast\_bridge\_channel {
 /\*! Condition, used if we want to wake up a thread waiting on the bridged channel \*/
 ast\_cond\_t cond;
 /\*! Current bridged channel state \*/
 enum ast\_bridge\_channel\_state state;
 /\*! Asterisk channel participating in the bridge \*/
 struct ast\_channel \*chan;
 /\*! Asterisk channel we are swapping with (if swapping) \*/
 struct ast\_channel \*swap;
 /\*! Bridge this channel is participating in \*/
 struct ast\_bridge \*bridge;
 /\*! Private information unique to the bridge technology \*/
 void \*bridge\_pvt;
 /\*! Thread handling the bridged channel \*/
 pthread\_t thread;
 /\*! Additional file descriptors to look at \*/
 int fds[4];
 /\*! Bit to indicate whether the channel is suspended from the bridge or not \*/
 unsigned int suspended:1;
 /\*! TRUE if the imparted channel must wait for an explicit depart from the bridge to reclaim the channel. \*/
 unsigned int depart\_wait:1;
 /\*! Features structure for features that are specific to this channel \*/
 struct ast\_bridge\_features \*features;
 /\*! Technology optimization parameters used by bridging technologies capable of
 \* optimizing based upon talk detection. \*/
 struct ast\_bridge\_tech\_optimizations tech\_args;
 /\*! Call ID associated with bridge channel \*/
 struct ast\_callid \*callid;
 /\*! Linked list information \*/
 AST\_LIST\_ENTRY(ast\_bridge\_channel) entry;
 /\*! Queue of actions to perform on the channel. \*/
 AST\_LIST\_HEAD\_NOLOCK(, ast\_frame) action\_queue;
};



```



---


### ast\_bridge\_video\_single\_src\_data


For bridges that support video that are in AST\_BRIDGE\_VIDEO\_MODE\_SINGLE\_SRC mode, this structure is used to pass information about the video source.




---

  
  


```



/\*! This is used for both SINGLE\_SRC mode to set what channel
 \* should be the current single video feed \*/
struct ast\_bridge\_video\_single\_src\_data {
 /\*! Only accept video coming from this channel \*/
 struct ast\_channel \*chan\_vsrc;
};



```



---


### ast\_bridge\_video\_talker\_src\_data


For bridges that support video that are in AST\_BRIDGE\_VIDEO\_MODE\_TALKER\_SRC mode, this structure is used to pass information about the source of audio and the possible video sources.




---

  
  


```



/\*! This is used for both SINGLE\_SRC\_TALKER mode to set what channel
 \* should be the current single video feed \*/
struct ast\_bridge\_video\_talker\_src\_data {
 /\*! Only accept video coming from this channel \*/
 struct ast\_channel \*chan\_vsrc;
 int average\_talking\_energy;

 /\*! Current talker see's this person \*/
 struct ast\_channel \*chan\_old\_vsrc;
};



```



---


### ast\_bridge\_video\_mode


This structure acts as a wrapper around the various possible video mode channel information objects.




---

  
  


```



struct ast\_bridge\_video\_mode {
 enum ast\_bridge\_video\_mode\_type mode;
 /\* Add data for all the video modes here. \*/
 union {
 struct ast\_bridge\_video\_single\_src\_data single\_src\_data;
 struct ast\_bridge\_video\_talker\_src\_data talker\_src\_data;
 } mode\_data;
};



```



---


### ast\_bridge


The main bridging type, the `ast_bridge` type defines how a bridge behaves, what technology it uses to perform the operations on the channels in the bridge, what channels are in the bridge, the state of the bridge, and more. Operations on a bridge are performed on an instance of `ast_bridge`.




---

  
  


```



/\*!
 \* \brief Structure that contains information about a bridge
 \*/
struct ast\_bridge {
 /\*! Condition, used if we want to wake up the bridge thread. \*/
 ast\_cond\_t cond;
 /\*! Number of channels participating in the bridge \*/
 int num;
 /\*! The video mode this bridge is using \*/
 struct ast\_bridge\_video\_mode video\_mode;
 /\*! The internal sample rate this bridge is mixed at when multiple channels are being mixed.
 \* If this value is 0, the bridge technology may auto adjust the internal mixing rate. \*/
 unsigned int internal\_sample\_rate;
 /\*! The mixing interval indicates how quickly the bridges internal mixing should occur
 \* for bridge technologies that mix audio. When set to 0, the bridge tech must choose a
 \* default interval for itself. \*/
 unsigned int internal\_mixing\_interval;
 /\*! Bit to indicate that the bridge thread is waiting on channels in the bridge array \*/
 unsigned int waiting:1;
 /\*! Bit to indicate the bridge thread should stop \*/
 unsigned int stop:1;
 /\*! Bit to indicate the bridge thread should refresh itself \*/
 unsigned int refresh:1;
 /\*! Bridge flags to tweak behavior \*/
 struct ast\_flags feature\_flags;
 /\*! Bridge technology that is handling the bridge \*/
 struct ast\_bridge\_technology \*technology;
 /\*! Private information unique to the bridge technology \*/
 void \*bridge\_pvt;
 /\*! Thread running the bridge \*/
 pthread\_t thread;
 /\*! Enabled features information \*/
 struct ast\_bridge\_features features;
 /\*! Array of channels that the bridge thread is currently handling \*/
 struct ast\_channel \*\*array;
 /\*! Number of channels in the above array \*/
 size\_t array\_num;
 /\*! Number of channels the array can handle \*/
 size\_t array\_size;
 /\*! Call ID associated with the bridge \*/
 struct ast\_callid \*callid;
 /\*! Linked list of channels participating in the bridge \*/
 AST\_LIST\_HEAD\_NOLOCK(, ast\_bridge\_channel) channels;
 /\*! Linked list of channels removed from the bridge and waiting to be departed. \*/
 AST\_LIST\_HEAD\_NOLOCK(, ast\_bridge\_channel) depart\_wait;
};



```



---


Functions on ast\_bridge
------------------------


### ast\_bridge\_new


Create a new instance of `ast_bridge` with the requested capabilities.




---

  
  


```



/\*!
 \* \brief Create a new bridge
 \*
 \* \param capabilities The capabilities that we require to be used on the bridge
 \* \param flags Flags that will alter the behavior of the bridge
 \*
 \* \retval a pointer to a new bridge on success
 \* \retval NULL on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* struct ast\_bridge \*bridge;
 \* bridge = ast\_bridge\_new(AST\_BRIDGE\_CAPABILITY\_1TO1MIX, AST\_BRIDGE\_FLAG\_DISSOLVE\_HANGUP);
 \* \endcode
 \*
 \* This creates a simple two party bridge that will be destroyed once one of
 \* the channels hangs up.
 \*/
struct ast\_bridge \*ast\_bridge\_new(uint32\_t capabilities, int flags);



```



---


### ast\_bridge\_lock


Lock the bridge. While locked, the state of the bridge cannot be changed by external entities. Internal entities may become blocked as well when they need to change the state of the bridge.




---

  
  


```



/\*!
 \* \brief Lock the bridge.
 \*
 \* \param bridge Bridge to lock
 \*
 \* \return Nothing
 \*/
#define ast\_bridge\_lock(bridge) \_ast\_bridge\_lock(bridge, \_\_FILE\_\_, \_\_PRETTY\_FUNCTION\_\_, \_\_LINE\_\_, #bridge)
static inline void \_ast\_bridge\_lock(struct ast\_bridge \*bridge, const char \*file, const char \*function, int line, const char \*var)
{
 \_\_ao2\_lock(bridge, AO2\_LOCK\_REQ\_MUTEX, file, function, line, var);
}



```



---


### ast\_bridge\_unlock


Unlock the bridge.




---

  
  


```



/\*!
 \* \brief Unlock the bridge.
 \*
 \* \param bridge Bridge to unlock
 \*
 \* \return Nothing
 \*/
#define ast\_bridge\_unlock(bridge) \_ast\_bridge\_unlock(bridge, \_\_FILE\_\_, \_\_PRETTY\_FUNCTION\_\_, \_\_LINE\_\_, #bridge)
static inline void \_ast\_bridge\_unlock(struct ast\_bridge \*bridge, const char \*file, const char \*function, int line, const char \*var)
{
 \_\_ao2\_unlock(bridge, file, function, line, var);
}



```



---


### ast\_bridge\_check


Determine if the Bridging Framework can create a bridge with the requested capabilities.




---

  
  


```



/\*!
 \* \brief See if it is possible to create a bridge
 \*
 \* \param capabilities The capabilities that the bridge will use
 \*
 \* \retval 1 if possible
 \* \retval 0 if not possible
 \*
 \* Example usage:
 \*
 \* \code
 \* int possible = ast\_bridge\_check(AST\_BRIDGE\_CAPABILITY\_1TO1MIX);
 \* \endcode
 \*
 \* This sees if it is possible to create a bridge capable of bridging two channels
 \* together.
 \*/
int ast\_bridge\_check(uint32\_t capabilities);



```



---


### ast\_bridge\_destroy


Explicitly destroy a bridge. Note that a self managing bridge will automatically destroy itself when no more channels are in the bridge.




---

  
  


```



/\*!
 \* \brief Destroy a bridge
 \*
 \* \param bridge Bridge to destroy
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_destroy(bridge);
 \* \endcode
 \*
 \* This destroys a bridge that was previously created using ast\_bridge\_new.
 \*/
int ast\_bridge\_destroy(struct ast\_bridge \*bridge);



```



---


### ast\_bridge\_join


Have the currently executing channel join a bridge. This is a blocking operation, and should only be called from the context of an `ast_channel`'s `pbx_thread`. The function will return on one of three locations:


1. The channel hangs up
2. The channel is booted out
3. The bridge disolves


It is up to the caller of the function to decide what happens next. In general, that should be one of three things:


* Run the `h` extension (if the channel was hung up)
* Run the next dialplan location
* Perform an `ast_async_goto` on the channel




---

  
  


```



/\*!
 \* \brief Join (blocking) a channel to a bridge
 \*
 \* \param bridge Bridge to join
 \* \param chan Channel to join
 \* \param swap Channel to swap out if swapping
 \* \param features Bridge features structure
 \* \param tech\_args Optional Bridging tech optimization parameters for this channel.
 \*
 \* \retval state that channel exited the bridge with
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_join(bridge, chan, NULL, NULL);
 \* \endcode
 \*
 \* This adds a channel pointed to by the chan pointer to the bridge pointed to by
 \* the bridge pointer. This function will not return until the channel has been
 \* removed from the bridge, swapped out for another channel, or has hung up.
 \*
 \* If this channel will be replacing another channel the other channel can be specified
 \* in the swap parameter. The other channel will be thrown out of the bridge in an
 \* atomic fashion.
 \*
 \* If channel specific features are enabled a pointer to the features structure
 \* can be specified in the features parameter.
 \*/
enum ast\_bridge\_channel\_state ast\_bridge\_join(struct ast\_bridge \*bridge,
 struct ast\_channel \*chan,
 struct ast\_channel \*swap,
 struct ast\_bridge\_features \*features,
 struct ast\_bridge\_tech\_optimizations \*tech\_args);



```



---


### ast\_bridge\_impart


Place an `ast_channel` in a bridge. This is a non-blocking operation. Callers of the function should:


1. Have control of the channel before placing it in the bridge, i.e., no `pbx_thread` should be executing on the channel
2. Relinquish control of the channel after calling this method.


When the channel leaves the bridge the channel will:


* Wait for another thread to claim it with ast\_bridge\_depart() if not specified as an independent channel
* Run a PBX at the set location if exited by AST\_SOFTHANGUP\_ASYNCGOTO (any exit location datastore is removed)
* Run a PBX if a location is specified by datastore
* Run the h exten if specifed by datastore then hangup
* hangup




---

  
  


```



/\*!
 \* \brief Impart (non-blocking) a channel onto a bridge
 \*
 \* \param bridge Bridge to impart on
 \* \param chan Channel to impart
 \* \param swap Channel to swap out if swapping. NULL if not swapping.
 \* \param features Bridge features structure. Must be NULL or obtained by ast\_bridge\_features\_new().
 \* \param independent TRUE if caller does not want to reclaim the channel using ast\_bridge\_depart().
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_impart(bridge, chan, NULL, NULL, 0);
 \* \endcode
 \*
 \* \details
 \* This adds a channel pointed to by the chan pointer to the
 \* bridge pointed to by the bridge pointer. This function will
 \* return immediately and will not wait until the channel is no
 \* longer part of the bridge.
 \*
 \* If this channel will be replacing another channel the other
 \* channel can be specified in the swap parameter. The other
 \* channel will be thrown out of the bridge in an atomic
 \* fashion.
 \*
 \* If channel specific features are enabled, a pointer to the
 \* features structure can be specified in the features
 \* parameter.
 \*
 \* \note If you impart a channel as not independent you MUST
 \* ast\_bridge\_depart() the channel. The bridge channel thread
 \* is created join-able. The implication is that the channel is
 \* special and is not intended to be moved to another bridge.
 \*
 \* \note If you impart a channel as independent you must not
 \* ast\_bridge\_depart() the channel. The bridge channel thread
 \* is created non-join-able. The channel must be treated as if
 \* it were placed into the bridge by ast\_bridge\_join().
 \* Channels placed into a bridge by ast\_bridge\_join() are
 \* removed by a third party using ast\_bridge\_remove().
 \*/
int ast\_bridge\_impart(struct ast\_bridge \*bridge, struct ast\_channel \*chan, struct ast\_channel \*swap, struct ast\_bridge\_features \*features, int independent);



```



---


### ast\_bridge\_depart


Remove a previously imparted `ast_channel` from the bridge.




---

  
  


```



/\*!
 \* \brief Depart a channel from a bridge
 \*
 \* \param bridge Bridge to depart from
 \* \param chan Channel to depart
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_depart(bridge, chan);
 \* \endcode
 \*
 \* This removes the channel pointed to by the chan pointer from the bridge
 \* pointed to by the bridge pointer and gives control to the calling thread.
 \* This does not hang up the channel.
 \*
 \* \note This API call can only be used on channels that were added to the bridge
 \* using the ast\_bridge\_impart API call with the independent flag FALSE.
 \*/
int ast\_bridge\_depart(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


### ast\_bridge\_remove


Remove any channel from the bridge.




---

  
  


```



/\*!
 \* \brief Remove a channel from a bridge
 \*
 \* \param bridge Bridge that the channel is to be removed from
 \* \param chan Channel to remove
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_remove(bridge, chan);
 \* \endcode
 \*
 \* This removes the channel pointed to by the chan pointer from the bridge
 \* pointed to by the bridge pointer and requests that it be hung up. Control
 \* over the channel will NOT be given to the calling thread.
 \*
 \* \note This API call can be used on channels that were added to the bridge
 \* using both ast\_bridge\_join and ast\_bridge\_impart.
 \*/
int ast\_bridge\_remove(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


### ast\_bridge\_merge


Merge two bridges together.




---

  
  


```



/\*!
 \* \brief Merge two bridges together
 \*
 \* \param bridge0 First bridge
 \* \param bridge1 Second bridge
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_merge(bridge0, bridge1);
 \* \endcode
 \*
 \* This merges the bridge pointed to by bridge1 with the bridge pointed to by bridge0.
 \* In reality all of the channels in bridge1 are simply moved to bridge0.
 \*
 \* \note The second bridge specified is not destroyed when this operation is
 \* completed.
 \*/
int ast\_bridge\_merge(struct ast\_bridge \*bridge0, struct ast\_bridge \*bridge1);



```



---


### ast\_bridge\_suspend


Suspend a channel from the bridge. Channels that are suspended from the bridge are no longer manipulated by threads in the bridge and can be safely accessed by non-bridge threads. Channels in a bridge **must** be suspended prior to manipulation by external threads.




---

  
  


```



/\*!
 \* \brief Suspend a channel temporarily from a bridge
 \*
 \* \param bridge Bridge to suspend the channel from
 \* \param chan Channel to suspend
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_suspend(bridge, chan);
 \* \endcode
 \*
 \* This suspends the channel pointed to by chan from the bridge pointed to by bridge temporarily.
 \* Control of the channel is given to the calling thread. This differs from ast\_bridge\_depart as
 \* the channel will not be removed from the bridge.
 \*
 \* \note This API call can be used on channels that were added to the bridge
 \* using both ast\_bridge\_join and ast\_bridge\_impart.
 \*/
int ast\_bridge\_suspend(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


### ast\_bridge\_unsuspend


Unsuspend a previously suspended channel, returning control of it back to the bridge's threads.




---

  
  


```



/\*!
 \* \brief Unsuspend a channel from a bridge
 \*
 \* \param bridge Bridge to unsuspend the channel from
 \* \param chan Channel to unsuspend
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_unsuspend(bridge, chan);
 \* \endcode
 \*
 \* This unsuspends the channel pointed to by chan from the bridge pointed to by bridge.
 \* The bridge will go back to handling the channel once this function returns.
 \*
 \* \note You must not mess with the channel once this function returns.
 \* Doing so may result in bad things happening.
 \*/
int ast\_bridge\_unsuspend(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


### ast\_bridge\_change\_state


Change the state of a bridged channel.




---

**WARNING!: WARNING**  

You shouldn't use this unless you are implementing a bridging feature hook.

  



---




---

  
  


```



/\*!
 \* \brief Change the state of a bridged channel
 \*
 \* \param bridge\_channel Channel to change the state on
 \* \param new\_state The new state to place the channel into
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_change\_state(bridge\_channel, AST\_BRIDGE\_CHANNEL\_STATE\_HANGUP);
 \* \endcode
 \*
 \* This places the channel pointed to by bridge\_channel into the state
 \* AST\_BRIDGE\_CHANNEL\_STATE\_HANGUP.
 \*
 \* \note This API call is only meant to be used in feature hook callbacks to
 \* request the channel exit the bridge.
 \*/
void ast\_bridge\_change\_state(struct ast\_bridge\_channel \*bridge\_channel, enum ast\_bridge\_channel\_state new\_state);



```



---


### ast\_bridge\_set\_internal\_sample\_rate


If a bridging technology supports the multimix capability, set the mixing sampling rate.




---

  
  


```



/\*!
 \* \brief Adjust the internal mixing sample rate of a bridge
 \* used during multimix mode.
 \*
 \* \param bridge Channel to change the sample rate on.
 \* \param sample\_rate the sample rate to change to. If a
 \* value of 0 is passed here, the bridge will be free to pick
 \* what ever sample rate it chooses.
 \*
 \*/
void ast\_bridge\_set\_internal\_sample\_rate(struct ast\_bridge \*bridge, unsigned int sample\_rate);



```



---


### ast\_bridge\_set\_mixing\_interval


If a bridging technology supports the multimix capability, set the mixing interval.




---

  
  


```



/\*!
 \* \brief Adjust the internal mixing interval of a bridge used
 \* during multimix mode.
 \*
 \* \param bridge Channel to change the sample rate on.
 \* \param mixing\_interval the sample rate to change to. If 0 is set
 \* the bridge tech is free to choose any mixing interval it uses by default.
 \*/
void ast\_bridge\_set\_mixing\_interval(struct ast\_bridge \*bridge, unsigned int mixing\_interval);



```



---


### ast\_bridge\_set\_single\_src\_video\_mode


If a bridging technology supports video, set the single video source to feed to all participants.




---

  
  


```



/\*!
 \* \brief Set a bridge to feed a single video source to all participants.
 \*/
void ast\_bridge\_set\_single\_src\_video\_mode(struct ast\_bridge \*bridge, struct ast\_channel \*video\_src\_chan);



```



---


### ast\_bridge\_set\_talker\_src\_video\_mode


If a bridging technology supports video, set the video mode to use the current talker.




---

  
  


```



/\*!
 \* \brief Set the bridge to pick the strongest talker supporting
 \* video as the single source video feed
 \*/
void ast\_bridge\_set\_talker\_src\_video\_mode(struct ast\_bridge \*bridge);



```



---


### ast\_bridge\_update\_talker\_src\_video\_mode


Inform a video capable bridging technology about the talk energy and frame information for a specific channel.




---

  
  


```



/\*!
 \* \brief Update information about talker energy for talker src video mode.
 \*/
void ast\_bridge\_update\_talker\_src\_video\_mode(struct ast\_bridge \*bridge, struct ast\_channel \*chan, int talker\_energy, int is\_keyfame);



```



---


### ast\_bridge\_number\_video\_src


Get the number of video sources in the bridge.




---

  
  


```



/\*!
 \* \brief Returns the number of video sources currently active in the bridge
 \*/
int ast\_bridge\_number\_video\_src(struct ast\_bridge \*bridge);



```



---


### ast\_bridge\_is\_video\_src


Return whether or not a channel is a video source.




---

  
  


```



/\*!
 \* \brief Determine if a channel is a video src for the bridge
 \*
 \* \retval 0 Not a current video source of the bridge.
 \* \retval None 0, is a video source of the bridge, The number
 \* returned represents the priority this video stream has
 \* on the bridge where 1 is the highest priority.
 \*/
int ast\_bridge\_is\_video\_src(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


### ast\_bridge\_remove\_video\_src


Remove a channel from being the video source.




---

  
  


```



/\*!
 \* \brief remove a channel as a source of video for the bridge.
 \*/
void ast\_bridge\_remove\_video\_src(struct ast\_bridge \*bridge, struct ast\_channel \*chan);



```



---


[Bridging Technologies](http://svn.asterisk.org/svn/asterisk/team/group/bridge_construction/include/asterisk/bridging_technology.h)
===================================================================================================================================


Enumerations
------------


### ast\_bridge\_preference


An enumeration that specifies for a registered bridging technology the preference the Bridging Framework should assign when picking between technologies with equivalent capabilities.




---

  
  


```


/\*! \brief Preference for choosing the bridge technology \*/
enum ast\_bridge\_preference {
 /\*! Bridge technology should have high precedence over other bridge technologies \*/
 AST\_BRIDGE\_PREFERENCE\_HIGH = 0,
 /\*! Bridge technology is decent, not the best but should still be considered over low \*/
 AST\_BRIDGE\_PREFERENCE\_MEDIUM,
 /\*! Bridge technology is low, it should not be considered unless it is absolutely needed \*/
 AST\_BRIDGE\_PREFERENCE\_LOW,
};


```



---


Structs
-------


### ast\_bridge\_technology


The interface that defines a bridging technology.




---

  
  


```



/\*!
 \* \brief Structure that is the essence of a bridge technology
 \*/
struct ast\_bridge\_technology {
 /\*! Unique name to this bridge technology \*/
 const char \*name;
 /\*! The capabilities that this bridge technology is capable of. This has nothing to do with
 \* format capabilities. \*/
 uint32\_t capabilities;
 /\*! Preference level that should be used when determining whether to use this bridge technology or not \*/
 enum ast\_bridge\_preference preference;
 /\*! Callback for when a bridge is being created \*/
 int (\*create)(struct ast\_bridge \*bridge);
 /\*! Callback for when a bridge is being destroyed \*/
 int (\*destroy)(struct ast\_bridge \*bridge);
 /\*! Callback for when a channel is being added to a bridge \*/
 int (\*join)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Callback for when a channel is leaving a bridge \*/
 int (\*leave)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Callback for when a channel is suspended from the bridge \*/
 void (\*suspend)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Callback for when a channel is unsuspended from the bridge \*/
 void (\*unsuspend)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Callback to see if a channel is compatible with the bridging technology \*/
 int (\*compatible)(struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Callback for writing a frame into the bridging technology \*/
 enum ast\_bridge\_write\_result (\*write)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridged\_channel, struct ast\_frame \*frame);
 /\*! Callback for when a file descriptor trips \*/
 int (\*fd)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel, int fd);
 /\*! Callback for replacement thread function \*/
 int (\*thread)(struct ast\_bridge \*bridge);
 /\*! Callback for poking a bridge thread \*/
 int (\*poke)(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel);
 /\*! Formats that the bridge technology supports \*/
 struct ast\_format\_cap \*format\_capabilities;
 /\*! Bit to indicate whether the bridge technology is currently suspended or not \*/
 unsigned int suspended:1;
 /\*! Module this bridge technology belongs to. Is used for reference counting when creating/destroying a bridge. \*/
 struct ast\_module \*mod;
 /\*! Linked list information \*/
 AST\_RWLIST\_ENTRY(ast\_bridge\_technology) entry;
};



```



---


Functions
---------


### ast\_bridge\_technology\_register


Register a technology with the Bridging Framework.




---

  
  


```



/\*!
 \* \brief Register a bridge technology for use
 \*
 \* \param technology The bridge technology to register
 \* \param mod The module that is registering the bridge technology
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_technology\_register(&simple\_bridge\_tech);
 \* \endcode
 \*
 \* This registers a bridge technology declared as the structure
 \* simple\_bridge\_tech with the bridging core and makes it available for
 \* use when creating bridges.
 \*/
int \_\_ast\_bridge\_technology\_register(struct ast\_bridge\_technology \*technology, struct ast\_module \*mod);

/\*! \brief See \ref \_\_ast\_bridge\_technology\_register() \*/
#define ast\_bridge\_technology\_register(technology) \_\_ast\_bridge\_technology\_register(technology, ast\_module\_info->self)



```



---


### ast\_bridge\_technology\_unregister


Unregister a technology with the Bridging Framework.




---

  
  


```



/\*!
 \* \brief Unregister a bridge technology from use
 \*
 \* \param technology The bridge technology to unregister
 \*
 \* \retval 0 on success
 \* \retval -1 on failure
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_technology\_unregister(&simple\_bridge\_tech);
 \* \endcode
 \*
 \* This unregisters a bridge technlogy declared as the structure
 \* simple\_bridge\_tech with the bridging core. It will no longer be
 \* considered when creating a new bridge.
 \*/
int ast\_bridge\_technology\_unregister(struct ast\_bridge\_technology \*technology);



```



---


### ast\_bridge\_handle\_trip


Notify the Bridging Framework that a channel has a frame waiting.




---

  
  


```



/\*!
 \* \brief Feed notification that a frame is waiting on a channel into the bridging core
 \*
 \* \param bridge The bridge that the notification should influence
 \* \param bridge\_channel Bridge channel the notification was received on (if known)
 \* \param chan Channel the notification was received on (if known)
 \* \param outfd File descriptor that the notification was received on (if known)
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_handle\_trip(bridge, NULL, chan, -1);
 \* \endcode
 \*
 \* This tells the bridging core that a frame has been received on
 \* the channel pointed to by chan and that it should be read and handled.
 \*
 \* \note This should only be used by bridging technologies.
 \*/
void ast\_bridge\_handle\_trip(struct ast\_bridge \*bridge, struct ast\_bridge\_channel \*bridge\_channel, struct ast\_channel \*chan, int outfd);



```



---


### ast\_bridge\_notify\_talking


Notify the Bridging Framework that a channel has started talking.




---

  
  


```



/\*!
 \* \brief Lets the bridging indicate when a bridge channel has stopped or started talking.
 \*
 \* \note All DSP functionality on the bridge has been pushed down to the lowest possible
 \* layer, which in this case is the specific bridging technology being used. Since it
 \* is necessary for the knowledge of which channels are talking to make its way up to the
 \* application, this function has been created to allow the bridging technology to communicate
 \* that information with the bridging core.
 \*
 \* \param bridge\_channel The bridge channel that has either started or stopped talking.
 \* \param started\_talking set to 1 when this indicates the channel has started talking set to 0
 \* when this indicates the channel has stopped talking.
 \*/
void ast\_bridge\_notify\_talking(struct ast\_bridge\_channel \*bridge\_channel, int started\_talking);



```



---


### ast\_bridge\_technology\_suspend


Suspend a bridging technology from consideration by the Bridging Framework.




---

  
  


```



/\*!
 \* \brief Suspend a bridge technology from consideration
 \*
 \* \param technology The bridge technology to suspend
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_technology\_suspend(&simple\_bridge\_tech);
 \* \endcode
 \*
 \* This suspends the bridge technology simple\_bridge\_tech from being considered
 \* when creating a new bridge. Existing bridges using the bridge technology
 \* are not affected.
 \*/
void ast\_bridge\_technology\_suspend(struct ast\_bridge\_technology \*technology);



```



---


### ast\_bridge\_technology\_unsuspend


Unsuspend a bridging technology from consideration by the Bridging Framework.




---

  
  


```



/\*!
 \* \brief Unsuspend a bridge technology
 \*
 \* \param technology The bridge technology to unsuspend
 \*
 \* Example usage:
 \*
 \* \code
 \* ast\_bridge\_technology\_unsuspend(&simple\_bridge\_tech);
 \* \endcode
 \*
 \* This makes the bridge technology simple\_bridge\_tech considered when
 \* creating a new bridge again.
 \*/
void ast\_bridge\_technology\_unsuspend(struct ast\_bridge\_technology \*technology);



```



---


