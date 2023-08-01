---
title: Asterisk 12 Bridging API
pageid: 22088074
---




!!! warning READ THIS
    The API described below is a work in progress. Certain aspects, such as the semantics of what happens to a channel when it is ejected from a bridge and needs to execute a new location in the dialplan, are still being worked out. Treat the documentation here as a working reference, rather than a contractual guarantee.

      
[//]: # (end-warning)



[Bridging Framework](http://svn.asterisk.org/svn/asterisk/team/group/bridge_construction/include/asterisk/bridging.h)
=====================================================================================================================


Enumerations
------------


### ast_bridge_capability


A bridge technology uses this when it registers to inform the framework which capabilities it can provide. When a bridge is created, the creator of the bridge can specify capabilities that it knows it will need for that bridge and the framework will choose the best technology that matches those capabilities. Additionally, when conditions in a bridge change such that the technology can no longer meet all of the conditions, the framework will use the capabilities to pick a new technology for the bridge.

```


/*! \brief Capabilities for a bridge technolog */
enum ast_bridge_capability {
 /*! Bridge is only capable of mixing 2 channel */
 AST_BRIDGE_CAPABILITY_1TO1MIX = (1 << 1),
 /*! Bridge is capable of mixing 2 or more channel */
 AST_BRIDGE_CAPABILITY_MULTIMIX = (1 << 2),
 /*! Bridge should natively bridge two channels if possibl */
 AST_BRIDGE_CAPABILITY_NATIVE = (1 << 3),
 /*! Bridge should run using the multithreaded mode */
 AST_BRIDGE_CAPABILITY_MULTITHREADED = (1 << 4),
 /*! Bridge should run a central bridge threa */
 AST_BRIDGE_CAPABILITY_THREAD = (1 << 5),
 /*! Bridge technology can do video mixing (or something along those lines */
 AST_BRIDGE_CAPABILITY_VIDEO = (1 << 6),
 /*! Bridge technology can optimize things based on who is talkin */
 AST_BRIDGE_CAPABILITY_OPTIMIZE = (1 << 7),
};

```

### ast_bridge_channel_state enum


The current state of an `ast_bridge_channel` object.

```


/*! \brief State information about a bridged channe */
enum ast_bridge_channel_state {
 /*! Waiting for a signal (Channel in the bridge */
 AST_BRIDGE_CHANNEL_STATE_WAIT = 0,
 /*! Bridged channel has ended itself (it has hung up */
 AST_BRIDGE_CHANNEL_STATE_END,
 /*! Bridged channel was forced out and should be hung u */
 AST_BRIDGE_CHANNEL_STATE_HANGUP,
 /*! Bridged channel was ast_bridge_depart() from the bridge without being hung u */
 AST_BRIDGE_CHANNEL_STATE_DEPART,
 /*! Bridged channel was ast_bridge_depart() from the bridge during AST_BRIDGE_CHANNEL_STATE_EN */
 AST_BRIDGE_CHANNEL_STATE_DEPART_END,
};

```

### ast_bridge_write_result


The possible conditions that a `ast_bridge_technology` write operation can return.

```


/*! \brief Return values for bridge technology write functio */
enum ast_bridge_write_result {
 /*! Bridge technology wrote out frame fin */
 AST_BRIDGE_WRITE_SUCCESS = 0,
 /*! Bridge technology attempted to write out the frame but faile */
 AST_BRIDGE_WRITE_FAILED,
 /*! Bridge technology does not support writing out a frame of this typ */
 AST_BRIDGE_WRITE_UNSUPPORTED,
};

```

### ast_bridge_action_type


The framework uses this enum to determine the action it is supposed to execute on a channel in a bridge.

```


enum ast_bridge_action_type {
 /*! Bridged channel is to detect a feature hoo */
 AST_BRIDGE_ACTION_FEATURE,
 /*! Bridged channel is to act on an interval hoo */
 AST_BRIDGE_ACTION_INTERVAL,
 /*! Bridged channel is to send a DTMF stream ou */
 AST_BRIDGE_ACTION_DTMF_STREAM,
 /*! Bridged channel is to indicate talking star */
 AST_BRIDGE_ACTION_TALKING_START,
 /*! Bridged channel is to indicate talking sto */
 AST_BRIDGE_ACTION_TALKING_STOP,
};

```

### ast_bridge_video_mode_type


For bridges that support video, the supported ways in which a bridge can choose the video source.

```


enum ast_bridge_video_mode_type {
 /*! Video is not allowed in the bridg */
 AST_BRIDGE_VIDEO_MODE_NONE = 0,
 /*! A single user is picked as the only distributed of video across the bridg */
 AST_BRIDGE_VIDEO_MODE_SINGLE_SRC,
 /*! A single user's video feed is distributed to all bridge channels, but
 * that feed is automatically picked based on who is talking the most */
 AST_BRIDGE_VIDEO_MODE_TALKER_SRC,
};

```

Structures
----------


### ast_bridge_tech_optimizations


Some bridging technologies support advanced talk optimizations/detection operations. This structure provides configuration information for those technologies.

```


/*!
 * \brief Structure specific to bridge technologies capable of
 * performing talking optimizations.
 */
struct ast_bridge_tech_optimizations {
 /*! The amount of time in ms that talking must be detected before
 * the dsp determines that talking has occurre */
 unsigned int talking_threshold;
 /*! The amount of time in ms that silence must be detected before
 * the dsp determines that talking has stoppe */
 unsigned int silence_threshold;
 /*! Whether or not the bridging technology should drop audio
 * detected as silence from the mix */
 unsigned int drop_silence:1;
};

```

### ast_bridge_channel


The `ast_bridge_channel` object maintain the state of an `ast_channel` in a bridge.

```


/*!
 * \brief Structure that contains information regarding a channel in a bridge
 */
struct ast_bridge_channel {
 /*! Condition, used if we want to wake up a thread waiting on the bridged channe */
 ast_cond_t cond;
 /*! Current bridged channel stat */
 enum ast_bridge_channel_state state;
 /*! Asterisk channel participating in the bridg */
 struct ast_channel \*chan;
 /*! Asterisk channel we are swapping with (if swapping */
 struct ast_channel \*swap;
 /*! Bridge this channel is participating i */
 struct ast_bridge \*bridge;
 /*! Private information unique to the bridge technolog */
 void \*bridge_pvt;
 /*! Thread handling the bridged channe */
 pthread_t thread;
 /*! Additional file descriptors to look a */
 int fds[4];
 /*! Bit to indicate whether the channel is suspended from the bridge or no */
 unsigned int suspended:1;
 /*! TRUE if the imparted channel must wait for an explicit depart from the bridge to reclaim the channel */
 unsigned int depart_wait:1;
 /*! Features structure for features that are specific to this channe */
 struct ast_bridge_features \*features;
 /*! Technology optimization parameters used by bridging technologies capable of
 * optimizing based upon talk detection */
 struct ast_bridge_tech_optimizations tech_args;
 /*! Call ID associated with bridge channe */
 struct ast_callid \*callid;
 /*! Linked list informatio */
 AST_LIST_ENTRY(ast_bridge_channel) entry;
 /*! Queue of actions to perform on the channel */
 AST_LIST_HEAD_NOLOCK(, ast_frame) action_queue;
};

```

### ast_bridge_video_single_src_data


For bridges that support video that are in AST_BRIDGE_VIDEO_MODE_SINGLE_SRC mode, this structure is used to pass information about the video source.

```


/*! This is used for both SINGLE_SRC mode to set what channel
 * should be the current single video fee */
struct ast_bridge_video_single_src_data {
 /*! Only accept video coming from this channe */
 struct ast_channel \*chan_vsrc;
};

```

### ast_bridge_video_talker_src_data


For bridges that support video that are in AST_BRIDGE_VIDEO_MODE_TALKER_SRC mode, this structure is used to pass information about the source of audio and the possible video sources.

```


/*! This is used for both SINGLE_SRC_TALKER mode to set what channel
 * should be the current single video fee */
struct ast_bridge_video_talker_src_data {
 /*! Only accept video coming from this channe */
 struct ast_channel \*chan_vsrc;
 int average_talking_energy;

 /*! Current talker see's this perso */
 struct ast_channel \*chan_old_vsrc;
};

```

### ast_bridge_video_mode


This structure acts as a wrapper around the various possible video mode channel information objects.

```


struct ast_bridge_video_mode {
 enum ast_bridge_video_mode_type mode;
 /* Add data for all the video modes here */
 union {
 struct ast_bridge_video_single_src_data single_src_data;
 struct ast_bridge_video_talker_src_data talker_src_data;
 } mode_data;
};

```

### ast_bridge


The main bridging type, the `ast_bridge` type defines how a bridge behaves, what technology it uses to perform the operations on the channels in the bridge, what channels are in the bridge, the state of the bridge, and more. Operations on a bridge are performed on an instance of `ast_bridge`.

```


/*!
 * \brief Structure that contains information about a bridge
 */
struct ast_bridge {
 /*! Condition, used if we want to wake up the bridge thread */
 ast_cond_t cond;
 /*! Number of channels participating in the bridg */
 int num;
 /*! The video mode this bridge is usin */
 struct ast_bridge_video_mode video_mode;
 /*! The internal sample rate this bridge is mixed at when multiple channels are being mixed.
 * If this value is 0, the bridge technology may auto adjust the internal mixing rate */
 unsigned int internal_sample_rate;
 /*! The mixing interval indicates how quickly the bridges internal mixing should occur
 * for bridge technologies that mix audio. When set to 0, the bridge tech must choose a
 * default interval for itself */
 unsigned int internal_mixing_interval;
 /*! Bit to indicate that the bridge thread is waiting on channels in the bridge arra */
 unsigned int waiting:1;
 /*! Bit to indicate the bridge thread should sto */
 unsigned int stop:1;
 /*! Bit to indicate the bridge thread should refresh itsel */
 unsigned int refresh:1;
 /*! Bridge flags to tweak behavio */
 struct ast_flags feature_flags;
 /*! Bridge technology that is handling the bridg */
 struct ast_bridge_technology \*technology;
 /*! Private information unique to the bridge technolog */
 void \*bridge_pvt;
 /*! Thread running the bridg */
 pthread_t thread;
 /*! Enabled features informatio */
 struct ast_bridge_features features;
 /*! Array of channels that the bridge thread is currently handlin */
 struct ast_channel \*\*array;
 /*! Number of channels in the above arra */
 size_t array_num;
 /*! Number of channels the array can handl */
 size_t array_size;
 /*! Call ID associated with the bridg */
 struct ast_callid \*callid;
 /*! Linked list of channels participating in the bridg */
 AST_LIST_HEAD_NOLOCK(, ast_bridge_channel) channels;
 /*! Linked list of channels removed from the bridge and waiting to be departed */
 AST_LIST_HEAD_NOLOCK(, ast_bridge_channel) depart_wait;
};

```

Functions on ast_bridge
------------------------


### ast_bridge_new


Create a new instance of `ast_bridge` with the requested capabilities.

```


/*!
 * \brief Create a new bridge
 *
 * \param capabilities The capabilities that we require to be used on the bridge
 * \param flags Flags that will alter the behavior of the bridge
 *
 * \retval a pointer to a new bridge on success
 * \retval NULL on failure
 *
 * Example usage:
 *
 * \code
 * struct ast_bridge \*bridge;
 * bridge = ast_bridge_new(AST_BRIDGE_CAPABILITY_1TO1MIX, AST_BRIDGE_FLAG_DISSOLVE_HANGUP);
 * \endcode
 *
 * This creates a simple two party bridge that will be destroyed once one of
 * the channels hangs up.
 */
struct ast_bridge \*ast_bridge_new(uint32_t capabilities, int flags);

```

### ast_bridge_lock


Lock the bridge. While locked, the state of the bridge cannot be changed by external entities. Internal entities may become blocked as well when they need to change the state of the bridge.

```


/*!
 * \brief Lock the bridge.
 *
 * \param bridge Bridge to lock
 *
 * \return Nothing
 */
#define ast_bridge_lock(bridge) _ast_bridge_lock(bridge, __FILE__, __PRETTY_FUNCTION__, __LINE__, #bridge)
static inline void _ast_bridge_lock(struct ast_bridge \*bridge, const char \*file, const char \*function, int line, const char \*var)
{
 __ao2_lock(bridge, AO2_LOCK_REQ_MUTEX, file, function, line, var);
}

```

### ast_bridge_unlock


Unlock the bridge.

```


/*!
 * \brief Unlock the bridge.
 *
 * \param bridge Bridge to unlock
 *
 * \return Nothing
 */
#define ast_bridge_unlock(bridge) _ast_bridge_unlock(bridge, __FILE__, __PRETTY_FUNCTION__, __LINE__, #bridge)
static inline void _ast_bridge_unlock(struct ast_bridge \*bridge, const char \*file, const char \*function, int line, const char \*var)
{
 __ao2_unlock(bridge, file, function, line, var);
}

```

### ast_bridge_check


Determine if the Bridging Framework can create a bridge with the requested capabilities.

```


/*!
 * \brief See if it is possible to create a bridge
 *
 * \param capabilities The capabilities that the bridge will use
 *
 * \retval 1 if possible
 * \retval 0 if not possible
 *
 * Example usage:
 *
 * \code
 * int possible = ast_bridge_check(AST_BRIDGE_CAPABILITY_1TO1MIX);
 * \endcode
 *
 * This sees if it is possible to create a bridge capable of bridging two channels
 * together.
 */
int ast_bridge_check(uint32_t capabilities);

```

### ast_bridge_destroy


Explicitly destroy a bridge. Note that a self managing bridge will automatically destroy itself when no more channels are in the bridge.

```


/*!
 * \brief Destroy a bridge
 *
 * \param bridge Bridge to destroy
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_destroy(bridge);
 * \endcode
 *
 * This destroys a bridge that was previously created using ast_bridge_new.
 */
int ast_bridge_destroy(struct ast_bridge \*bridge);

```

### ast_bridge_join


Have the currently executing channel join a bridge. This is a blocking operation, and should only be called from the context of an `ast_channel`'s `pbx_thread`. The function will return on one of three locations:


1. The channel hangs up
2. The channel is booted out
3. The bridge disolves


It is up to the caller of the function to decide what happens next. In general, that should be one of three things:


* Run the `h` extension (if the channel was hung up)
* Run the next dialplan location
* Perform an `ast_async_goto` on the channel

```


/*!
 * \brief Join (blocking) a channel to a bridge
 *
 * \param bridge Bridge to join
 * \param chan Channel to join
 * \param swap Channel to swap out if swapping
 * \param features Bridge features structure
 * \param tech_args Optional Bridging tech optimization parameters for this channel.
 *
 * \retval state that channel exited the bridge with
 *
 * Example usage:
 *
 * \code
 * ast_bridge_join(bridge, chan, NULL, NULL);
 * \endcode
 *
 * This adds a channel pointed to by the chan pointer to the bridge pointed to by
 * the bridge pointer. This function will not return until the channel has been
 * removed from the bridge, swapped out for another channel, or has hung up.
 *
 * If this channel will be replacing another channel the other channel can be specified
 * in the swap parameter. The other channel will be thrown out of the bridge in an
 * atomic fashion.
 *
 * If channel specific features are enabled a pointer to the features structure
 * can be specified in the features parameter.
 */
enum ast_bridge_channel_state ast_bridge_join(struct ast_bridge \*bridge,
 struct ast_channel \*chan,
 struct ast_channel \*swap,
 struct ast_bridge_features \*features,
 struct ast_bridge_tech_optimizations \*tech_args);

```

### ast_bridge_impart


Place an `ast_channel` in a bridge. This is a non-blocking operation. Callers of the function should:


1. Have control of the channel before placing it in the bridge, i.e., no `pbx_thread` should be executing on the channel
2. Relinquish control of the channel after calling this method.


When the channel leaves the bridge the channel will:


* Wait for another thread to claim it with ast_bridge_depart() if not specified as an independent channel
* Run a PBX at the set location if exited by AST_SOFTHANGUP_ASYNCGOTO (any exit location datastore is removed)
* Run a PBX if a location is specified by datastore
* Run the h exten if specifed by datastore then hangup
* hangup

```


/*!
 * \brief Impart (non-blocking) a channel onto a bridge
 *
 * \param bridge Bridge to impart on
 * \param chan Channel to impart
 * \param swap Channel to swap out if swapping. NULL if not swapping.
 * \param features Bridge features structure. Must be NULL or obtained by ast_bridge_features_new().
 * \param independent TRUE if caller does not want to reclaim the channel using ast_bridge_depart().
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_impart(bridge, chan, NULL, NULL, 0);
 * \endcode
 *
 * \details
 * This adds a channel pointed to by the chan pointer to the
 * bridge pointed to by the bridge pointer. This function will
 * return immediately and will not wait until the channel is no
 * longer part of the bridge.
 *
 * If this channel will be replacing another channel the other
 * channel can be specified in the swap parameter. The other
 * channel will be thrown out of the bridge in an atomic
 * fashion.
 *
 * If channel specific features are enabled, a pointer to the
 * features structure can be specified in the features
 * parameter.
 *
 * \note If you impart a channel as not independent you MUST
 * ast_bridge_depart() the channel. The bridge channel thread
 * is created join-able. The implication is that the channel is
 * special and is not intended to be moved to another bridge.
 *
 * \note If you impart a channel as independent you must not
 * ast_bridge_depart() the channel. The bridge channel thread
 * is created non-join-able. The channel must be treated as if
 * it were placed into the bridge by ast_bridge_join().
 * Channels placed into a bridge by ast_bridge_join() are
 * removed by a third party using ast_bridge_remove().
 */
int ast_bridge_impart(struct ast_bridge \*bridge, struct ast_channel \*chan, struct ast_channel \*swap, struct ast_bridge_features \*features, int independent);

```

### ast_bridge_depart


Remove a previously imparted `ast_channel` from the bridge.

```


/*!
 * \brief Depart a channel from a bridge
 *
 * \param bridge Bridge to depart from
 * \param chan Channel to depart
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_depart(bridge, chan);
 * \endcode
 *
 * This removes the channel pointed to by the chan pointer from the bridge
 * pointed to by the bridge pointer and gives control to the calling thread.
 * This does not hang up the channel.
 *
 * \note This API call can only be used on channels that were added to the bridge
 * using the ast_bridge_impart API call with the independent flag FALSE.
 */
int ast_bridge_depart(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

### ast_bridge_remove


Remove any channel from the bridge.

```


/*!
 * \brief Remove a channel from a bridge
 *
 * \param bridge Bridge that the channel is to be removed from
 * \param chan Channel to remove
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_remove(bridge, chan);
 * \endcode
 *
 * This removes the channel pointed to by the chan pointer from the bridge
 * pointed to by the bridge pointer and requests that it be hung up. Control
 * over the channel will NOT be given to the calling thread.
 *
 * \note This API call can be used on channels that were added to the bridge
 * using both ast_bridge_join and ast_bridge_impart.
 */
int ast_bridge_remove(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

### ast_bridge_merge


Merge two bridges together.

```


/*!
 * \brief Merge two bridges together
 *
 * \param bridge0 First bridge
 * \param bridge1 Second bridge
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_merge(bridge0, bridge1);
 * \endcode
 *
 * This merges the bridge pointed to by bridge1 with the bridge pointed to by bridge0.
 * In reality all of the channels in bridge1 are simply moved to bridge0.
 *
 * \note The second bridge specified is not destroyed when this operation is
 * completed.
 */
int ast_bridge_merge(struct ast_bridge \*bridge0, struct ast_bridge \*bridge1);

```

### ast_bridge_suspend


Suspend a channel from the bridge. Channels that are suspended from the bridge are no longer manipulated by threads in the bridge and can be safely accessed by non-bridge threads. Channels in a bridge **must** be suspended prior to manipulation by external threads.

```


/*!
 * \brief Suspend a channel temporarily from a bridge
 *
 * \param bridge Bridge to suspend the channel from
 * \param chan Channel to suspend
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_suspend(bridge, chan);
 * \endcode
 *
 * This suspends the channel pointed to by chan from the bridge pointed to by bridge temporarily.
 * Control of the channel is given to the calling thread. This differs from ast_bridge_depart as
 * the channel will not be removed from the bridge.
 *
 * \note This API call can be used on channels that were added to the bridge
 * using both ast_bridge_join and ast_bridge_impart.
 */
int ast_bridge_suspend(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

### ast_bridge_unsuspend


Unsuspend a previously suspended channel, returning control of it back to the bridge's threads.

```


/*!
 * \brief Unsuspend a channel from a bridge
 *
 * \param bridge Bridge to unsuspend the channel from
 * \param chan Channel to unsuspend
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_unsuspend(bridge, chan);
 * \endcode
 *
 * This unsuspends the channel pointed to by chan from the bridge pointed to by bridge.
 * The bridge will go back to handling the channel once this function returns.
 *
 * \note You must not mess with the channel once this function returns.
 * Doing so may result in bad things happening.
 */
int ast_bridge_unsuspend(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

### ast_bridge_change_state


Change the state of a bridged channel.




!!! warning WARNING
    You shouldn't use this unless you are implementing a bridging feature hook.

      
[//]: # (end-warning)

```


/*!
 * \brief Change the state of a bridged channel
 *
 * \param bridge_channel Channel to change the state on
 * \param new_state The new state to place the channel into
 *
 * Example usage:
 *
 * \code
 * ast_bridge_change_state(bridge_channel, AST_BRIDGE_CHANNEL_STATE_HANGUP);
 * \endcode
 *
 * This places the channel pointed to by bridge_channel into the state
 * AST_BRIDGE_CHANNEL_STATE_HANGUP.
 *
 * \note This API call is only meant to be used in feature hook callbacks to
 * request the channel exit the bridge.
 */
void ast_bridge_change_state(struct ast_bridge_channel \*bridge_channel, enum ast_bridge_channel_state new_state);

```

### ast_bridge_set_internal_sample_rate


If a bridging technology supports the multimix capability, set the mixing sampling rate.

```


/*!
 * \brief Adjust the internal mixing sample rate of a bridge
 * used during multimix mode.
 *
 * \param bridge Channel to change the sample rate on.
 * \param sample_rate the sample rate to change to. If a
 * value of 0 is passed here, the bridge will be free to pick
 * what ever sample rate it chooses.
 *
 */
void ast_bridge_set_internal_sample_rate(struct ast_bridge \*bridge, unsigned int sample_rate);

```

### ast_bridge_set_mixing_interval


If a bridging technology supports the multimix capability, set the mixing interval.

```


/*!
 * \brief Adjust the internal mixing interval of a bridge used
 * during multimix mode.
 *
 * \param bridge Channel to change the sample rate on.
 * \param mixing_interval the sample rate to change to. If 0 is set
 * the bridge tech is free to choose any mixing interval it uses by default.
 */
void ast_bridge_set_mixing_interval(struct ast_bridge \*bridge, unsigned int mixing_interval);

```

### ast_bridge_set_single_src_video_mode


If a bridging technology supports video, set the single video source to feed to all participants.

```


/*!
 * \brief Set a bridge to feed a single video source to all participants.
 */
void ast_bridge_set_single_src_video_mode(struct ast_bridge \*bridge, struct ast_channel \*video_src_chan);

```

### ast_bridge_set_talker_src_video_mode


If a bridging technology supports video, set the video mode to use the current talker.

```


/*!
 * \brief Set the bridge to pick the strongest talker supporting
 * video as the single source video feed
 */
void ast_bridge_set_talker_src_video_mode(struct ast_bridge \*bridge);

```

### ast_bridge_update_talker_src_video_mode


Inform a video capable bridging technology about the talk energy and frame information for a specific channel.

```


/*!
 * \brief Update information about talker energy for talker src video mode.
 */
void ast_bridge_update_talker_src_video_mode(struct ast_bridge \*bridge, struct ast_channel \*chan, int talker_energy, int is_keyfame);

```

### ast_bridge_number_video_src


Get the number of video sources in the bridge.

```


/*!
 * \brief Returns the number of video sources currently active in the bridge
 */
int ast_bridge_number_video_src(struct ast_bridge \*bridge);

```

### ast_bridge_is_video_src


Return whether or not a channel is a video source.

```


/*!
 * \brief Determine if a channel is a video src for the bridge
 *
 * \retval 0 Not a current video source of the bridge.
 * \retval None 0, is a video source of the bridge, The number
 * returned represents the priority this video stream has
 * on the bridge where 1 is the highest priority.
 */
int ast_bridge_is_video_src(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

### ast_bridge_remove_video_src


Remove a channel from being the video source.

```


/*!
 * \brief remove a channel as a source of video for the bridge.
 */
void ast_bridge_remove_video_src(struct ast_bridge \*bridge, struct ast_channel \*chan);

```

[Bridging Technologies](http://svn.asterisk.org/svn/asterisk/team/group/bridge_construction/include/asterisk/bridging_technology.h)
===================================================================================================================================


Enumerations
------------


### ast_bridge_preference


An enumeration that specifies for a registered bridging technology the preference the Bridging Framework should assign when picking between technologies with equivalent capabilities.

```

/*! \brief Preference for choosing the bridge technolog */
enum ast_bridge_preference {
 /*! Bridge technology should have high precedence over other bridge technologie */
 AST_BRIDGE_PREFERENCE_HIGH = 0,
 /*! Bridge technology is decent, not the best but should still be considered over lo */
 AST_BRIDGE_PREFERENCE_MEDIUM,
 /*! Bridge technology is low, it should not be considered unless it is absolutely neede */
 AST_BRIDGE_PREFERENCE_LOW,
};

```

Structs
-------


### ast_bridge_technology


The interface that defines a bridging technology.

```


/*!
 * \brief Structure that is the essence of a bridge technology
 */
struct ast_bridge_technology {
 /*! Unique name to this bridge technolog */
 const char \*name;
 /*! The capabilities that this bridge technology is capable of. This has nothing to do with
 * format capabilities */
 uint32_t capabilities;
 /*! Preference level that should be used when determining whether to use this bridge technology or no */
 enum ast_bridge_preference preference;
 /*! Callback for when a bridge is being create */
 int (\*create)(struct ast_bridge \*bridge);
 /*! Callback for when a bridge is being destroye */
 int (\*destroy)(struct ast_bridge \*bridge);
 /*! Callback for when a channel is being added to a bridg */
 int (\*join)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel);
 /*! Callback for when a channel is leaving a bridg */
 int (\*leave)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel);
 /*! Callback for when a channel is suspended from the bridg */
 void (\*suspend)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel);
 /*! Callback for when a channel is unsuspended from the bridg */
 void (\*unsuspend)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel);
 /*! Callback to see if a channel is compatible with the bridging technolog */
 int (\*compatible)(struct ast_bridge_channel \*bridge_channel);
 /*! Callback for writing a frame into the bridging technolog */
 enum ast_bridge_write_result (\*write)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridged_channel, struct ast_frame \*frame);
 /*! Callback for when a file descriptor trip */
 int (\*fd)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel, int fd);
 /*! Callback for replacement thread functio */
 int (\*thread)(struct ast_bridge \*bridge);
 /*! Callback for poking a bridge threa */
 int (\*poke)(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel);
 /*! Formats that the bridge technology support */
 struct ast_format_cap \*format_capabilities;
 /*! Bit to indicate whether the bridge technology is currently suspended or no */
 unsigned int suspended:1;
 /*! Module this bridge technology belongs to. Is used for reference counting when creating/destroying a bridge */
 struct ast_module \*mod;
 /*! Linked list informatio */
 AST_RWLIST_ENTRY(ast_bridge_technology) entry;
};

```

Functions
---------


### ast_bridge_technology_register


Register a technology with the Bridging Framework.

```


/*!
 * \brief Register a bridge technology for use
 *
 * \param technology The bridge technology to register
 * \param mod The module that is registering the bridge technology
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_technology_register(&simple_bridge_tech);
 * \endcode
 *
 * This registers a bridge technology declared as the structure
 * simple_bridge_tech with the bridging core and makes it available for
 * use when creating bridges.
 */
int __ast_bridge_technology_register(struct ast_bridge_technology \*technology, struct ast_module \*mod);

/*! \brief See \ref __ast_bridge_technology_register( */
#define ast_bridge_technology_register(technology) __ast_bridge_technology_register(technology, ast_module_info->self)

```

### ast_bridge_technology_unregister


Unregister a technology with the Bridging Framework.

```


/*!
 * \brief Unregister a bridge technology from use
 *
 * \param technology The bridge technology to unregister
 *
 * \retval 0 on success
 * \retval -1 on failure
 *
 * Example usage:
 *
 * \code
 * ast_bridge_technology_unregister(&simple_bridge_tech);
 * \endcode
 *
 * This unregisters a bridge technlogy declared as the structure
 * simple_bridge_tech with the bridging core. It will no longer be
 * considered when creating a new bridge.
 */
int ast_bridge_technology_unregister(struct ast_bridge_technology \*technology);

```

### ast_bridge_handle_trip


Notify the Bridging Framework that a channel has a frame waiting.

```


/*!
 * \brief Feed notification that a frame is waiting on a channel into the bridging core
 *
 * \param bridge The bridge that the notification should influence
 * \param bridge_channel Bridge channel the notification was received on (if known)
 * \param chan Channel the notification was received on (if known)
 * \param outfd File descriptor that the notification was received on (if known)
 *
 * Example usage:
 *
 * \code
 * ast_bridge_handle_trip(bridge, NULL, chan, -1);
 * \endcode
 *
 * This tells the bridging core that a frame has been received on
 * the channel pointed to by chan and that it should be read and handled.
 *
 * \note This should only be used by bridging technologies.
 */
void ast_bridge_handle_trip(struct ast_bridge \*bridge, struct ast_bridge_channel \*bridge_channel, struct ast_channel \*chan, int outfd);

```

### ast_bridge_notify_talking


Notify the Bridging Framework that a channel has started talking.

```


/*!
 * \brief Lets the bridging indicate when a bridge channel has stopped or started talking.
 *
 * \note All DSP functionality on the bridge has been pushed down to the lowest possible
 * layer, which in this case is the specific bridging technology being used. Since it
 * is necessary for the knowledge of which channels are talking to make its way up to the
 * application, this function has been created to allow the bridging technology to communicate
 * that information with the bridging core.
 *
 * \param bridge_channel The bridge channel that has either started or stopped talking.
 * \param started_talking set to 1 when this indicates the channel has started talking set to 0
 * when this indicates the channel has stopped talking.
 */
void ast_bridge_notify_talking(struct ast_bridge_channel \*bridge_channel, int started_talking);

```

### ast_bridge_technology_suspend


Suspend a bridging technology from consideration by the Bridging Framework.

```


/*!
 * \brief Suspend a bridge technology from consideration
 *
 * \param technology The bridge technology to suspend
 *
 * Example usage:
 *
 * \code
 * ast_bridge_technology_suspend(&simple_bridge_tech);
 * \endcode
 *
 * This suspends the bridge technology simple_bridge_tech from being considered
 * when creating a new bridge. Existing bridges using the bridge technology
 * are not affected.
 */
void ast_bridge_technology_suspend(struct ast_bridge_technology \*technology);

```

### ast_bridge_technology_unsuspend


Unsuspend a bridging technology from consideration by the Bridging Framework.

```


/*!
 * \brief Unsuspend a bridge technology
 *
 * \param technology The bridge technology to unsuspend
 *
 * Example usage:
 *
 * \code
 * ast_bridge_technology_unsuspend(&simple_bridge_tech);
 * \endcode
 *
 * This makes the bridge technology simple_bridge_tech considered when
 * creating a new bridge again.
 */
void ast_bridge_technology_unsuspend(struct ast_bridge_technology \*technology);

```

