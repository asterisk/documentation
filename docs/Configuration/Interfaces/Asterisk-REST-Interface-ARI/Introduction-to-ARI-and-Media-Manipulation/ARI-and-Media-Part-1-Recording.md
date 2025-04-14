# The Recording API

Recordings in ARI are divided into two main categories: live and stored. Live recordings are those that are currently being recorded on a channel or bridge, and stored recordings are recordings that have been completed and saved to the file system. The API for the `/recordings` resource can be found [here](/Latest_API/API_Documentation/Asterisk_REST_Interface/Recordings_REST_API).

Live recordings can be manipulated as they are being made, with options to manipulate the flow of audio such as muting, pausing, stopping, or canceling the recording. Stored recordings are simply files on the file system on which Asterisk is installed. The location of stored recordings is in the `/recording` subdirectory of the configured `astspooldir` in `asterisk.conf`. By default, this places recordings in `/var/spool/asterisk/recording`.

Channels can have their audio recorded using the [`/channels/{channelId}/record`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#record) resource, and Bridges can have their audio recorded using the `[/bridges/{bridgeId}/record](/Latest_API/API_Documentation/Asterisk_REST_Interface/Bridges_REST_API/#record)` resource.

## Voice Mail Application Skeleton

Our application to record voice mails will be based on the following skeleton. As we add new features, we will create new states for our state machine, and add a few extra lines to our application skeleton in order to link the states together appropriately.

```python title="vm-record.py" linenums="1"
#!/usr/bin/env python

import ari
import logging
import time
import os
import sys

from event import Event
from state_machine import StateMachine
# As we add more states to our state machine, we'll import the necessary
# states here.

logging.basicConfig(level=logging.ERROR)
LOGGER = logging.getLogger(__name__)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

class VoiceMailCall(object):
	def __init__(self, ari_client, channel, mailbox):
		self.client = ari_client
		self.channel = channel
		self.vm_path = os.path.join('voicemail', mailbox, str(time.time()))
		self.setup_state_machine()

	def setup_state_machine(self):
		# This is where we will initialize states, create a state machine, add
		# state transitions to the state machine, and start the state machine.

def stasis_start_cb(channel_obj, event):
	channel = channel_obj['channel']
	channel_name = channel.json.get('name')
	mailbox = event.get('args')[0]

	 print("Channel {0} recording voicemail for {1}".format(channel_name, mailbox))
	 channel.answer()
	 VoiceMailCall(client, channel, mailbox)

client.on_channel_event('StasisStart', stasis_start_cb)
client.run(apps=sys.argv[1])
```

```javascript title="vm-record.js" linenums="1"
/*jshint node:true */
'use strict';

var ari = require('ari-client');
var util = require('util');
var path = require('path');

var Event = require('./event');
var StateMachine = require('./state_machine');
// As we add new states to our state machine, this is where we will
// add the new required states. 

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

var VoiceMailCall = function(ari_client, channel, mailbox) {
	this.client = ari_client;
	this.channel = channel;
	this.vm_path = path.join('voicemail', mailbox, Date.now().toString());

	this.setup_state_machine = function() {
		// This is where we will initialize states, create a state machine, add
		// state transitions to the state machine, and start the state machine.
	}

	this.setup_state_machine();
}

function clientLoaded(err, client) {
	if (err) {
		throw err;
	}

	client.on('StasisStart', stasisStart);

	function stasisStart(event, channel) {
		var mailbox = event.args[0]
		channel.answer(function(err) {
			if (err) {
				throw err;
			}
			new VoiceMailCall(client, channel, mailbox);
		});
	}

	client.start(process.argv[2]);
}
```

With a few modifications, this same application skeleton can be adapted for use with non-voice mail applications. The biggest voice mail-specific thing being done here is the calculation of the path for voice mail recordings based on the application argument. The intended use of this application is something like the following:

```text title="extensions.conf" linenums="1"
[default]
exten => _3XX,1,NoOp()
 same => n,Stasis(vm-record, ${EXTEN})
 same => n,Hangup()
```

This way, when calling any three-digit extension that begins with the number '3', the user will call into the application with the mailbox dialled (e.g. dialling "305" will allow the user to leave a message for mailbox "305").

## Basic Voice Mail Recording

We've seen a lot of the underlying concepts for our application, so let's actually make something useful now. We'll start with a very simple application that allows callers to record a message upon entering the application. When the caller has completed recording the message, the caller may press the <kbd>#</kbd> key or may hang up to accept the recording. Here is a state machine diagram for the application:

![](record.png)

Notice that even though DTMF '#' and a caller hangup result in the same end result that there are two separate states that are transitioned into. This is because our code needs to behave differently at the end of a voice mail call based on whether the channel has been hung up or not. In short, the "Ending" state in the diagram will forcibly hang up the channel, whereas the "Hung up" state does not need to do so.

For this, we will be defining three states: recording, hungup, and ending. The following is the code for the three states:

```python title="recording_state.py" linenums="1"
from event import Event

class RecordingState(object):
	state_name = "recording"

	def __init__(self, call):
		self.call = call
		self.hangup_event = None
		self.dtmf_event = None
		self.recording = None

	def enter(self):
		print "Entering recording state"
		self.hangup_event = self.call.channel.on_event('ChannelHangupRequest',self.on_hangup)
		self.dtmf_event = self.call.channel.on_event('ChannelDtmfReceived',	self.on_dtmf)
		self.recording = self.call.channel.record(name=self.call.vm_path,format='wav',
			beep=True,
			ifExists='overwrite')
		print("Recording voicemail at {0}".format(self.call.vm_path))

	def cleanup(self):
		print "Cleaning up event handlers"
		self.dtmf_event.close()
		self.hangup_event.close()

	def on_hangup(self, channel, event):
		print("Accepted recording {0} on hangup".format(self.call.vm_path))
		self.cleanup()
		self.call.state_machine.change_state(Event.HANGUP)

	def on_dtmf(self, channel, event):
		digit = event.get('digit')
		if digit == '#':
			rec_name = self.recording.json.get('name')
			print("Accepted recording {0} on DTMF #".format(rec_name))
			self.cleanup()
			self.recording.stop()
			self.call.state_machine.change_state(Event.DTMF_OCTOTHORPE)
```

```javascript title="recording_state.js" linenums="1"
var Event = require('./event')

function RecordingState(call) {
	this.state_name = "recording";

	this.enter = function() {
		var recording = call.client.LiveRecording(call.client, {name: call.vm_path});
		console.log("Entering recording state");
		call.channel.on("ChannelHangupRequest", on_hangup);
		call.channel.on("ChannelDtmfReceived", on_dtmf);
		call.channel.record({name: recording.name, format: 'wav', beep: true,
			ifExists: 'overwrite'}, recording);

		function cleanup() {
			call.channel.removeListener('ChannelHangupRequest', on_hangup);
			call.channel.removeListener('ChannelDtmfReceived', on_dtmf);
		}

		function on_hangup(event, channel) {
			console.log("Accepted recording %s on hangup", recording.name);
			cleanup();
			call.state_machine.change_state(Event.HANGUP);
		}

		function on_dtmf(event, channel) {
			switch (event.digit) {
			case '#':
				console.log("Accepted recording", call.vm_path);
				cleanup();
				recording.stop(function(err) {
					call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
				});
			break;
			}
		}
	}
}

module.exports = RecordingState;
```

When entered, the state sets up listeners for hangup and DTMF events on the channel, since those are the events that will cause the state to change. In all cases, before a state change occurs, the `cleanup()` function is invoked to remove event listeners. This way, the event listeners set by the recording state will not accidentally still be set up when the next state is entered. This same `cleanup()` method will be used for all states we create that set up ARI event listeners.

The `stop` method causes a live recording to finish and be saved to the file system. Notice that the `on_hangup()` method does not attempt to stop the live recording. This is because when a channel hangs up, any live recordings on that channel are automatically stopped and stored.

The other two states in the state machine are much simpler, since they are terminal states and do not need to watch for any events.

```python title="ending_state.py" linenums="1"
class EndingState(object):
	state_name = "ending"

	def __init__(self, call):
		self.call = call

	def enter(self):
		channel_name = self.call.channel.json.get('name')
		print("Ending voice mail call from {0}".format(channel_name))
		self.call.channel.hangup()
```

```javascript title="ending_state.js" linenums="1"
function EndingState(call) {
	this.state_name = "ending";

	this.enter = function() {
		channel_name = call.channel.name;
		console.log("Ending voice mail call from", channel_name);
		call.channel.hangup();
	}
}
module.exports = EndingState;
```

```python title="hangup_state.py" linenums="1"
class HungUpState(object):
	state_name = "hungup"

	def __init__(self, call):
		self.call = call

	def enter(self):
		channel_name = self.call.channel.json.get('name')
		print("Channel {0} hung up".format(channel_name))

```

```javascript title="hungup_state.js" linenums="1"
function HungUpState(call) {
	this.state_name = "hungup";

	this.enter = function() {
		channel_name = call.channel.name;
		console.log("Channel %s hung up", channel_name);
	}
}
module.exports = HungUpState;
```

These two states are two sides to the same coin. The `EndingState` is used to end the call by hanging up the channel, and the `HungUpState` is used to terminate the state machine when the caller has hung up. You may find yourself wondering why a `HungUpState` is needed at all. For our application, it does not do much, but it's a great place to perform post-call logic if your application demands it. See the second reader exercise on this page to see an example of that.

Using the application skeleton we set up earlier, we can make the following modifications to accommodate our state machine:

```python title="vm-call.py" linenums="1"
# At the top of the file
from recording_state import RecordingState
from ending_state import EndingState
from hungup_state import HungUpState

# Inside our VoiceMailCall class
	def setup_state_machine(self):
		hungup_state = HungUpState(self)
		recording_state = RecordingState(self)
		ending_state = EndingState(self)

		self.state_machine = StateMachine()
		self.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE, ending_state)
		self.state_machine.add_transition(recording_state, Event.HANGUP, hungup_state)
		self.state_machine.start(recording_state)
```

```javascript title="vm-call.js" linenums="1"
// At the top of the file
var RecordingState = require('./recording_state');
var EndingState = require('./ending_state');
var HungUpState = require('./hungup_state');

 // Inside our VoiceMailCall function
	 this.setup_state_machine = function() {
		 var hungup_state = new HungUpState(self)
		 var recording_state = new RecordingState(self)
		 var ending_state = new EndingState(self)

		 this.state_machine = new StateMachine()
		 this.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE, ending_state)
		 this.state_machine.add_transition(recording_state, Event.HANGUP, hungup_state)
		 this.state_machine.start(recording_state)
	 }

```

The following is a sample output of a user calling the application and pressing the <kbd>#</kbd> key when finished recording

```
Channel PJSIP/200-00000003 recording voicemail for 305
Entering recording state
Recording voicemail at voicemail/305/1411497846.53
Accepted recording voicemail/305/1411497846.53
Cleaning up event handlers
Ending voice mail call from PJSIP/200-00000003

```

### Reader Exercise 1

Currently, the voicemails being recorded are all kept in a single "folder" for a specific mailbox. See if you can change the code to record messages in an "INBOX" folder on the mailbox instead.

### Reader Exercise 2

`EndingState` and `HungUpState` don't do much of anything at the moment. States like these can be great in voice mail applications for updating the message-waiting state of mailboxes on a system. If you're feeling industrious, read the API for the `/mailboxes` resource in ARI. Try to change `HungUpState` and `EndingState` to update the message-waiting status of a mailbox when a new message is left. To keep the exercise simple, for now you can assume the following:

* The number of "old" messages in a mailbox is always 0
* Since you are more concerned with alerting the mailbox owner that there exist new messages, do not try to count the messages in the mailbox. Instead, just state that there is 1 new message.

## Cancelling a Recording

Now we have a simple application set up to record a message, but it's pretty bare at the moment. Let's start expanding some. One feature we can add is the ability to press a DTMF key while recording a voice mail to cancel the current recording and re-start the recording process. We'll use the DTMF <kbd>*</kbd> key to accomplish this. The updated state machine diagram looks like the following:

![](record-with-retry.png)

All that has changed is that there is a new transition, which means a minimal change to our current code to facilitate the change. In our `recording_state` file, we will rewrite the `on_dtmf` method as follows:

```python title="recording_state.py" linenums="1"
def on_dtmf(self, channel, event):
	digit = event.get('digit')
	if digit == '#':
		rec_name = self.recording.json.get('name')
		print "Accepted recording {0} on DTMF #".format(rec_name)
		self.cleanup()
		self.recording.stop()
		self.call.state_machine.change_state(Event.DTMF_OCTOTHORPE)
	# NEW CONTENT
	elif digit == '\*':
		rec_name = self.recording.json.get('name')
		print "Canceling recording {0} on DTMF \*".format(rec_name)
		self.cleanup()
		self.recording.cancel()
		self.call.state_machine.change_state(Event.DTMF_STAR)
```

```javascript title="recording_state.js" linenums="1"
function on_dtmf(event, channel) {
	switch (event.digit) {
	case '#':
		console.log("Accepted recording", call.vm_path);
		cleanup();
		recording.stop(function(err) {
			call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
		});
		break;
	// NEW CONTENT
	case '\*':
		console.log("Canceling recording", call.vm_path);
		cleanup();
		recording.cancel(function(err) {
			call.state_machine.change_state(Event.DTMF_STAR);
		});
		break;
	}
}
```

The first part of the method is the same as it was before, but we have added extra handling for when the user presses the <kbd>*</kbd> key. The `cancel()` method for live recordings causes the live recording to be stopped and for it not to be stored on the file system.

We also need to add our new transition while setting up our state machine. Our `VoiceMailCall::setup_state_machine()` method now looks like:

```python title="vm-call.py" linenums="1"
def setup_state_machine(self):
	hungup_state = HungUpState(self)
	recording_state = RecordingState(self)
	ending_state = EndingState(self)
	self.state_machine = StateMachine()
	self.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE,
		ending_state)
	self.state_machine.add_transition(recording_state, Event.HANGUP,
		hungup_state)
	self.state_machine.add_transition(recording_state, Event.DTMF_STAR,
		recording_state)
	self.state_machine.start(recording_state)
```

```javascript title="vm-call.js" linenums="1"
this.setup_state_machine = function() {
	var hungup_state = new HungUpState(this);
	var recording_state = new RecordingState(this);
	var ending_state = new EndingState(this);

	this.state_machine = new StateMachine();
	this.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE, ending_state);
	this.state_machine.add_transition(recording_state, Event.HANGUP, hungup_state);
	this.state_machine.add_transition(recording_state, Event.DTMF_STAR, recording_state);
	this.state_machine.start(recording_state);
}
```

This is exactly the same as it was, except for the penultimate line adding the ``Event.DTMF_STAR`` transition. Here is sample output for when a user calls in, presses <kbd>*</kbd> twice, and then presses <kbd>#</kbd> to complete the call

```
Channel PJSIP/200-00000007 recording voicemail for 305
Entering recording state
Recording voicemail at voicemail/305/1411498790.65
Canceling recording voicemail/305/1411498790.65 on DTMF \*
Cleaning up event handlers
Entering recording state
Recording voicemail at voicemail/305/1411498790.65
Canceling recording voicemail/305/1411498790.65 on DTMF \*
Cleaning up event handlers
Entering recording state
Recording voicemail at voicemail/305/1411498790.65
Accepted recording voicemail/305/1411498790.65 on DTMF #
Cleaning up event handlers
Ending voice mail call from PJSIP/200-00000007
```

### Reader Exercise 3
We have covered the `stop()` and `cancel()` methods, but live recordings provide other methods as well. In particular, there are `pause()`, which causes the live recording to temporarily stop recording audio, and `unpause()`, which causes the live recording to resume recording audio.

Modify the `RecordingState` to allow a DTMF digit of your choice to toggle pausing and unpausing the live recording.

### Reader Exercise 4
Our application provides the ability to cancel recordings and re-record them, but it gives no ability to cancel the recording and end the call.

Modify the `RecordingState` to allow for a DTMF digit of your choice to cancel the recording and end the call.

## Operating on Stored Recordings

So far, we've recorded a channel, stopped a live recording, and cancelled a live recording. Now let's turn our attention to operations that can be performed on stored recordings. An obvious operation to start with is to play back the stored recording. We're going to make another modification to our voice mail recording application that adds a "reviewing" state after a voicemail is recorded. In this state, a user that has recorded a voice mail will hear the recorded message played back to him/her. The user may press the <kbd>#</kbd> key or hang up in order to accept the recorded message, or the user may press <kbd>*</kbd> to erase the stored recording and record a new message in its place. Below is the updated state diagram with the new "reviewing" state added.

![](record-with-review.png)

To realize this, here is the code for our new "reviewing" state:

```python title="reviewing_state.py"
import uuid

class ReviewingState(object):
	state_name = "reviewing"

	def __init__(self, call):
		self.call = call
		self.playback_id = None
		self.hangup_event = None
		self.playback_finished = None
		self.dtmf_event = None
		self.playback = None

	def enter(self):
		self.playback_id = str(uuid.uuid4())
		print("Entering reviewing state")
		self.hangup_event = self.call.channel.on_event("ChannelHangupRequest",
			self.on_hangup)
		self.playback_finished = self.call.client.on_event(
			'PlaybackFinished', self.on_playback_finished)
		self.dtmf_event = self.call.channel.on_event('ChannelDtmfReceived',
			self.on_dtmf)
		self.playback = self.call.channel.playWithId(
			playbackId=self.playback_id, media="recording:{0}".format(
			self.call.vm_path))

	def cleanup(self):
		self.playback_finished.close()
		if self.playback:
			self.playback.stop()
			self.dtmf_event.close()
			self.hangup_event.close()

	def on_hangup(self, channel, event):
		print("Accepted recording {0} on hangup".format(self.call.vm_path))
		self.cleanup()
		self.call.state_machine.change_state(Event.HANGUP)

	def on_playback_finished(self, event):
		if self.playback_id == event.get('playback').get('id'):
			self.playback = None

	def on_dtmf(self, channel, event):
		digit = event.get('digit')
		if digit == '#':
			print("Accepted recording {0} on DTMF #".format(self.call.vm_path))
			self.cleanup()
			self.call.state_machine.change_state(Event.DTMF_OCTOTHORPE)
		elif digit == '\*':
			print("Discarding stored recording {0} on DTMF \*".format(self.call.vm_path))
			self.cleanup()
			self.call.client.recordings.deleteStored(
				recordingName=self.call.vm_path)
			self.call.state_machine.change_state(Event.DTMF_STAR)
```

```javascript title="reviewing_state.js" linenums="1"
var Event = require('./event');

function ReviewingState(call) {
	this.state_name = "reviewing";

	this.enter = function() {
		var playback = call.client.Playback();
		var url = "recording:" + call.vm_path;
		console.log("Entering reviewing state");
		call.channel.on("ChannelHangupRequest", on_hangup);
		call.channel.on("ChannelDtmfReceived", on_dtmf);
		call.client.on("PlaybackFinished", on_playback_finished);
		call.channel.play({media: url}, playback);

		function cleanup() {
			call.channel.removeListener('ChannelHangupRequest', on_hangup);
			call.channel.removeListener('ChannelDtmfReceived', on_dtmf);
			call.client.removeListener('PlaybackFinished', on_playback_finished);
			if (playback) {
				playback.stop();
			}
		}

		function on_hangup(event, channel) {
			console.log("Accepted recording %s on hangup", call.vm_path);
			playback = null;
			cleanup();
			call.state_machine.change_state(Event.HANGUP);
		}

		function on_playback_finished(event) {
			if (playback && (playback.id === event.playback.id)) {
				playback = null;
			}
		}

		function on_dtmf(event, channel) {
			switch (event.digit) {
			case '#':
				console.log("Accepted recording", call.vm_path);
				cleanup();
				call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
				break;
			case '\*':
				console.log("Canceling recording", call.vm_path);
				cleanup();
				call.client.recordings.deleteStored({recordingName: call.vm_path});
				call.state_machine.change_state(Event.DTMF_STAR);
				break;
			}
		}
	}
}
module.exports = ReviewingState;
```

The code for this state is similar to the code from `RecordingState`. The big difference is that instead of recording a message, it is playing back a stored recording. Stored recordings can be played using the channel's [`play()`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#play) method (or as we have used in the python code, `playWithId()`). If the URI of the media to be played is prefixed with the "recording:" scheme, then Asterisk knows to search for the specified file where recordings are stored. More information on playing back files on channels, as well as a detailed list of media URI schemes can be found [here](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Channels/ARI-and-Channels-Simple-Media-Manipulation). Note the method that is called when a DTMF '\*' is received. The `deleteStored()` method can be used on the `/recordings` resource of the ARI client to delete a stored recording from the file system on which Asterisk is running.

One more thing to point out is the code that runs in `on_playback_finished()`. When reviewing a voicemail recording, the message may finish playing back before the user decides what to do with it. If this happens, we detect that the playback has finished so that we do not attempt to stop an already-finished playback once the user decides how to proceed.

We need to get this new state added into our state machine, so we make the following modifications to our code to allow for the new state to be added:

```python title="vm-call.py" linenums="1"
#At the top of the file
from reviewing_state import ReviewingState

#In VoiceMailCall::setup_state_machine
def setup_state_machine(self):
	hungup_state = HungUpState(self)
	recording_state = RecordingState(self)
	ending_state = EndingState(self)
	reviewing_state = ReviewingState(self)
	self.state_machine = StateMachine()
	self.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE,
		reviewing_state) 
	self.state_machine.add_transition(recording_state, Event.HANGUP,
		hungup_state)
	self.state_machine.add_transition(recording_state, Event.DTMF_STAR,
		recording_state) 
	self.state_machine.add_transition(reviewing_state, Event.HANGUP,
		hungup_state)
	self.state_machine.add_transition(reviewing_state, Event.DTMF_OCTOTHORPE,
		ending_state)
	self.state_machine.add_transition(reviewing_state, Event.DTMF_STAR,
		recording_state)
	self.state_machine.start(recording_state)

```

```javascript title="vm-call.js" linenums="1"
// At the top of the file
var ReviewingState = require('./reviewing_state');

// In VoicemailCall::setup_state_machine
this.setup_state_machine = function() {
	var hungup_state = new HungUpState(this);
	var recording_state = new RecordingState(this);
	var ending_state = new EndingState(this);
	var reviewing_state = new ReviewingState(this);

	this.state_machine = new StateMachine();
	this.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE, reviewing_state);
	this.state_machine.add_transition(recording_state, Event.HANGUP, hungup_state);
	this.state_machine.add_transition(recording_state, Event.DTMF_STAR, recording_state);
	this.state_machine.add_transition(reviewing_state, Event.DTMF_OCTOTHORPE, ending_state);
	this.state_machine.add_transition(reviewing_state, Event.HANGUP, hungup_state);
	this.state_machine.add_transition(reviewing_state, Event.DTMF_STAR, recording_state);
	this.state_machine.start(recording_state);
}

```

The following is the output from a sample call. The user records audio, then presses <kbd>#</kbd>. Upon hearing the recording, the user decides to record again, so the user presses <kbd>*</kbd>. After re-recording, the user presses <kbd>#</kbd>. The user hears the new version of the recording played back and is satisfied with it, so the user presses <kbd>#</kbd> to accept the recording.

```
Channel PJSIP/200-00000009 recording voicemail for 305
Entering recording state
Recording voicemail at voicemail/305/1411501058.42
Accepted recording voicemail/305/1411501058.42 on DTMF #
Cleaning up event handlers
Entering reviewing state
Discarding stored recording voicemail/305/1411501058.42 on DTMF \*
Entering recording state
Recording voicemail at voicemail/305/1411501058.42
Accepted recording voicemail/305/1411501058.42 on DTMF #
Cleaning up event handlers
Entering reviewing state
Accepted recording voicemail/305/1411501058.42 on DTMF #
Ending voice mail call from PJSIP/200-00000009

```

### Reader Exercise 5
In the previous section we introduced the ability to delete a stored recording. Stored recordings have a second operation available to them: [copying](/Latest_API/API_Documentation/Asterisk_REST_Interface/Recordings_REST_API/#copystored). The `copy()` method of a stored recording can be used to copy the stored recording from one location to another.

For this exercise modify `ReviewingState` to let a DTMF key of your choice copy the message to a different mailbox on the system. When a user presses this DTMF key, the state machine should transition into a new state called "copying." The "copying" state should gather DTMF from the user to determine which mailbox the message should be copied to. If <kbd>#</kbd> is entered, then the message is sent to the mailbox the user has typed in. If <kbd>*</kbd> is entered, then the copying operation is cancelled. Both a <kbd>#</kbd> and a <kbd>*</kbd> should cause the state machine to transition back into `ReviewingState`.

As an example, let's say that you have set DTMF <kbd>0</kbd> to be the key that the user presses in `ReviewingState` to copy the message. The user presses <kbd>0</kbd>. The user then presses <kbd>3</kbd> <kbd>2</kbd> <kbd>0</kbd> <kbd>#</kbd>. The message should be copied to mailbox "320", and the user should start hearing the message played back again. Now let's say the user presses <kbd>0</kbd> to copy the message again. The user then presses <kbd>3</kbd> <kbd>2</kbd> <kbd>1</kbd> <kbd>0</kbd> <kbd>*</kbd>. The message should not be copied to any mailbox, and the user should start hearing the message played back again.

## Recording Bridges

This discussion of recordings has focused on recording channel audio. It's important to note that bridges also have an option to be recorded. What's the difference? Recording a channel's audio records only the audio coming **from** a channel. Recording a bridge records the mixed audio coming from all channels into the bridge. This means that if you are attempting to do something like record a conversation between participants in a phone call, you would want to record the audio in the bridge rather than on either of the channels involved.

Once recording is started on a bridge, the operations available for the live recording and the resulting stored recording are exactly the same as for live recordings and stored recordings on a channel. Since the API for recording a bridge and recording a channel are so similar, this page will not provide any examples of recording bridge audio.
