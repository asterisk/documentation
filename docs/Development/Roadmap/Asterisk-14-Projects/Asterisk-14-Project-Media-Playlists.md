---
title: Asterisk 14 Project - Media Playlists
pageid: 31097097
---

Project Overview
================

Media playback in ARI today queues multiple play operations to a resource, such as a `bridge` or `channel`. That is, performing the following will result in three different `Playback` objects:

```
POST /channels/12345/play?media=sound:tt-monkeys
POST /channels/12345/play?media=sound:tt-weasels
POST /channels/12345/play?media=number:555

```

This works well enough when you know that a user needs to listen to all of the prompts, and you don't need to cancel them. If, however, you need to let the prompts be interruptible or allow a user to manipulate the playback, you have to keep a reference to the current `Playback` object for the resource, as well as any 'future' `Playback` objects (so you can `delete` them). Alternatively, of course, you don't have to initiate all of the media operations at once - you can ostensibly play each when the previous has finished. However, that negates the benefit of the media queueing, and entails writing a state machine.

Either way, however, the client is required to maintain state. That state is cumbersome - having to 'remember' which media operation the resource is currently in and/or future media operations to be performed/are enqueued is extra work that a developer using ARI shouldn't have to perform.

Ideally, an ARI user should be able to issue a list of media that they would like played, and Asterisk should play it back as a list. Operations should be performed (wherever possible) on the list itself.

Requirements Specification
==========================

Channels/Bridges Resource Operations
------------------------------------

ARI will allow a user to specify multiple media resources to play on a supported resource (currently, `channels` and `bridges`).

### Example

```
POST /channels/12345/play?media=sound:tt-monkeys&media=sound:tt-weasels&media=number:555

```

### Other Media Parameters

Other existing media parameters will be supported as follows:

* `lang` - specified only once, and applies to all `sound:` resources.
* `offsetms` - specified only once, and only applies to the first specified resource. If the first specified resource is not a `sound:` resource, the parameter has no effect.
* `skipms` - specified only once, and applies to all `sound:` resources. If the process of issuing a reverse/forward takes the user past the beginning/end of a media resource, then the previous media resource/next media resource should be started at the approximate offset.

Playbacks Resource Operations
-----------------------------

A `Playback` resource will support two new operations:

* `next` - move to the next media resource in the list
* `prev` - move to the previous media resource in the list

An attempt to move past the end of the last media resource will return a 2xx response and will result in a `PlaybackFinished` event. An attempt to move prior to the beginning of the first media resource will return a 2xx response and will result in a `PlaybackStarted` event.







On this Page








### Example

```
POST /playbacks/1283791327846/control?operation=next

```

### Existing Operations

The existing operations will work as follows:

* `restart` - restarts the current media in the list.
* `pause` - pauses the current media in the list.
* ``unpause`` - unpauses the current media in the list.
* `reverse` - reverses the current media in the list. If that causes the media to reach the beginning of a sound file, it will do one of the two following actions:
	1. If the previous media resource was a sound file, it will start playback of the previous media resource at an offset equal to the remaining jump not displaced in the existing sound file.
	2. If the previous media resource was not a sound file (and cannot be indexed), it will start playback at the start of that resource.
* `forward` - fast-forwards the current media in the list. if that causes the media to reach the end of a sound file, the sound file will complete and the next media resource will be started.
	1. If the next media resource is a sound file, it will start playback of the next media resource at an offset equal to the remaining jump not displaced in the existing sound file.
	2. If the next media resource was not a sound file (and cannot be indexed), it will start playback at the start of that resource.
Configuration
=============

No configuration should be needed.

Design/Implementation
=====================

Swagger Model updates
---------------------

The `channels` and `bridges` resources will have their respective `play` operations updated to allow multiple `media` query parameters. The list is constructed in the order that the query parameters are presented.




---

  
\[channels|bridges\]/play  

```js
{
 "name": "media",
 "description": "Media URIs to play.",
 "paramType": "query",
 "required": true,
 "allowMultiple": true,
 "dataType": "string"
 },

```

The `playbacks` resource will have its `control` operation updated with new options for the `operation` query parameter.




---

  
playbacks/control  

```
js  {
 "name": "operation",
 "description": "Operation to perform on the playback.",
 "paramType": "query",
 "required": true,
 "allowMultiple": false,
 "dataType": "string",
 "allowableValues": {
 "valueType": "LIST",
 "values": [
 "restart",
 "pause",
 "unpause",
 "reverse",
 "forward",
 "next",
 "prev"
 ]
 }
 }

```

Core updates
------------

* New control frames for `next` and `prev` should be added:




---

  
frame.h  

```cpp
 AST_CONTROL_STREAM_STOP = 1000, /*!< Indicate to a channel in playback to stop the strea */
 AST_CONTROL_STREAM_SUSPEND = 1001, /*!< Indicate to a channel in playback to suspend the strea */
 AST_CONTROL_STREAM_RESTART = 1002, /*!< Indicate to a channel in playback to restart the strea */
 AST_CONTROL_STREAM_REVERSE = 1003, /*!< Indicate to a channel in playback to rewin */
 AST_CONTROL_STREAM_FORWARD = 1004, /*!< Indicate to a channel in playback to fast forwar */
 AST_CONTROL_STREAM_PREV = 1005, /*!< Indicate to a channel in playback to play the previous strea */
 AST_CONTROL_STREAM_NEXT = 1006, /*!< Indicate to a channel in playback to play the next strea */

```

* Update `channel.c` to consume and ignore the two new frame types
* Have `file.c` `waitstream_core` handle the two new frame types. These should break out of the control loop and return the frame value.
* Add a new function to `app.h` (because we don't have enough yet) called `ast_control_streamfile_lang_w_cb`. Its usage should be somewhat obvious.

res_stasis_playback
---------------------

In addition model and parameter changes that will ripple through the auto-generated HTTP server/resource bindings, the control of the playback will have to be modified in the following ways in `res_stasis_playback`:

* The `stasis_app_playback` struct will have to specify a list of media resources to play, as well as the current/next file to be played.
* `play_on_channel` will have to iterate over that list. If `ast_control_streamfile_lang` returns a `next` or `prev` result, it will have to handle it accordingly.
	+ Use `ast_control_streamfile_lang_w_cb` instead of `ast_control_streamfile_lang`. Pass the `stasis_app_playback` object as the `void *`. If the `rewind` or `fast forward` operation indicates that we are at the beginning or end of a file, alter the next file to be played accordingly.
	+ Implement handling for the control frame values corresponding to `PREV` and `NEXT`.
* Add two new function handlers for `playback_opreation_cb` - `playback_next` and `playback_prev`. Queue the control frames appropriately.

app_controlplayback
--------------------

Currently, the `ControlPlayback` dialplan application does not support playback of multiple files. As such, handling of the new feature should be defensive in nature only.

* `controlplayback_exec` should be modified to handle the return of `AST_CONTROL_STREAM_PREV` and `AST_CONTROL_STREAM_NEXT` gracefully. Since the application does not currently handle multiple playbacks, it should simply return with the correct `CPLAYBACKSTATUS` as `PREVIOUS` or `NEXT`, respectively.
* `controlplayback_manager` should be updated to understand "prev" and "next" as valid control signals (as, who knows, you may want to use AMI to control a channel in ARI, if you're that crazy)

res_agi
--------

The `control stream file` AGI command does not support playback of multiple files. As such, handling of the new feature should be defensive in nature only.

* `handle_controlstreamfile` should be modified to handle the return of `AST_CONTROL_STREAM_PREV` and `AST_CONTROL_STREAM_NEXT` gracefully. The result of `CPLAYBACKSTATUS` should mirror that of `app_controlplayback`.

chan_iax2
----------

* Explicitly specify that the two new control frames should not be passed over the wire.

func_frame_trace
------------------

* Do the frame trace dance
Testing
=======



| Test | Path | Purpose |
| --- | --- | --- |
| control_prev | tests/apps/control_playback | Verify that sending a remote initiated `prev` command via AMI results in `CPLAYBACKSTATUS` being set to `PREVIOUS`. |
| control_next | tests/apps/control_playback | Verify that sending a remote initiated `next` command via AMI results in `CPLAYBACKSTATUS` being set to `NEXT`. |
| remote_prev | tests/apps/playback | Verify that sending a remote initiated `prev` command via AMI results in a test event indicating that the playback was broken |
| remote_next | tests/apps/playback | Verify that sending a remote initiated `next` command via AMI results in a test event indicating that the playback was broken |
| channels/playback/list | tests/rest_api | Verify that nominal playback of a list - with no user control - occurs in the expected fashion, and that each sound file in the list is played in the correct sequence |
| channels/playback/list_forward | tests/rest_api | Verify that playback of a list where a user fast forwards plays through each sound file in sequence. Verify that unsupported skippable media is handled correctly. |
| channels/playback/list_reverse | tests/rest_api | Verify that playback of a list where a user reverses through each sound file is handled correctly, including restarting already played media. Verify that media that cannot be reversed through is restarted as well. |
| channels/playback/next | tests/rest_api | Verify that playback of a list supports skipping to the next media in the list, for multiple media resource types |
| channels/playback/prev | tests/rest_api | Verify that playback of a list supports skipping to the previous media in the list, for multiple media resource types |
| bridges/playback/list | tests/rest_api | Verify that nominal playback of a list - with no user control - occurs in the expected fashion, and that each sound file in the list is played in the correct sequence |
| bridges/playback/list_forward | tests/rest_api | Verify that playback of a list where a user fast forwards plays through each sound file in sequence. Verify that unsupported skippable media is handled correctly. |
| bridges/playback/list_reverse | tests/rest_api | Verify that playback of a list where a user reverses through each sound file is handled correctly, including restarting already played media. Verify that media that cannot be reversed through is restarted as well. |
| bridges/playback/next | tests/rest_api | Verify that playback of a list supports skipping to the next media in the list, for multiple media resource types |
| bridges/playback/prev | tests/rest_api | Verify that playback of a list supports skipping to the previous media in the list, for multiple media resource types |

Project Planning
================

The following are rough tasks that need to be done in order to complete this feature. These are meant to be guidelines, and should not necessarily be followed verbatim. Note that many of these are actually independent of each other, and can be worked out simultaneously. If you're interested in helping out with any of these tasks, please speak up on the `asterisk-dev` mailing list!

The various phases are meant to be implemented as separately as possible to ease the process of peer review.

Phase One - Write Tests That Fail
---------------------------------

In both of these cases, it is expected that the existing tests can be used as a basis.



| Task | Description | Status |
| --- | --- | --- |
| Write the dialplan application tests | Write tests that exercise the `ControlPlayback` and `Playback` applications with the new options. |  |
| Write the REST API tests | Write tests that update the existing options, as well as the new options. |  |

Phase Two - Update the core/non-ARI portions
--------------------------------------------



| Task | Description | Status |
| --- | --- | --- |
| Add the control frame handling | * Add the new control frame types
* Update the various modules that simply have to be aware of the new frame's existence
* Update `waitstream_core` to handle the new frames and pass the value back up to the caller
* Add the new function and update the signature of the callback and its corresponding functions.
 |  |
| Update non-ARI consumers | Update:* Playback
* ControlPlayback (dialplan application and AMI action)
* control stream file AGI command
 |  |

Phase Three - Update ARI
------------------------



| Task | Description | Status |
| --- | --- | --- |
| Update the swagger model; generate bindings | What the task says. |  |
| Add operation handlers | Handle `prev` and `next`, queueing up control frames on the channel |  |
| Update `play_on_channel` to play multiple files | * Iterate over the files in the list, playing them back
* If the `NEXT` or `PREV` control frame is returned, skip to the next/previous media resource
 |  |
| Update `play_on_channel` to handle reversing/forwarding between files in a list | * Add a callback when initiating the control stream file operation in the core, passing the playback object along
* If the callback is called and the file is at the end/beginning of the stream, shift to the next/previous file appropriately and store the offset
* In the main loop, start the playback at the appropriate offset
 |  |

