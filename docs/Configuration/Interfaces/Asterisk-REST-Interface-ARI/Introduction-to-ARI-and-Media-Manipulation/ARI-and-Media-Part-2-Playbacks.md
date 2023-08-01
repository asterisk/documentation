---
title: ARI and Media: Part 2 - Playbacks
pageid: 30277828
---

Querying for sounds
===================

In our voice mail application we have been creating, we have learned the ins and outs of creating and manipulating live and stored recordings. Let's make the voice mail application more user-friendly now by adding some playbacks of installed sounds. The voice mail application has some nice capabilities, but it is not very user-friendly yet. Let's modify the current application to play a greeting to the user when they call into the application. This is the updated state machine:

![](vm-full.png)

40%On this Page


To make the new "greeting" state more interesting, we are going to add some safety to this state by ensuring that the sound we want to play is installed on the system. The [`/sounds`](/Asterisk-13-Sounds-REST-API) resource in ARI provides methods to list the sounds installed on the system, as well as the ability to get specific sound files.

Asterisk searches for sounds in the `/sounds/` subdirectory of the configured `astdatadir` option in `asterisk.conf`. By default, Asterisk will search for sounds in `/var/lib/asterisk/sounds`. When Asterisk starts up, it indexes the installed sounds and keeps an in-data representation of those sound files. When an ARI application asks Asterisk for details about a specific sound or for a list of sounds on the system, Asterisk consults its in-memory index instead of searching the file system directly. This has some trade-offs. When querying for sound information, this in-memory indexing makes the operations much faster. On the other hand, it also means that Asterisk has to be "poked" to re-index the sounds if new sounds are added to the file system after Asterisk is running.  The Asterisk CLI command "module reload sounds" provides a means of having Asterisk re-index the sounds on the system so that they are available to ARI.

For our greeting, we will play the built-in sound "vm-intro". Here is the code for our new state:




---

  
greeting_state.py  

```
pytruefrom event import Event

def sounds_installed(client):
 try:
 client.sounds.get(soundId='vm-intro')
 except:
 print "Required sound 'vm-intro' not installed. Aborting"
 raise


class GreetingState(object):
 state_name = "greeting"

 def __init__(self, call):
 self.call = call
 self.hangup_event = None
 self.playback_finished = None
 self.dtmf_event = None
 self.playback = None
 sounds_installed(call.client)

 def enter(self):
 print "Entering greeting state"
 self.hangup_event = self.call.channel.on_event('ChannelHangupRequest',
 self.on_hangup)
 self.playback_finished = self.call.client.on_event(
 'PlaybackFinished', self.on_playback_finished)
 self.dtmf_event = self.call.channel.on_event('ChannelDtmfReceived',
 self.on_dtmf)
 self.playback = self.call.channel.play(media="sound:vm-intro")

 def cleanup(self):
 self.playback_finished.close()
 self.dtmf_event.close()
 self.hangup_event.close()

 def on_hangup(self, channel, event):
 print "Abandoning voicemail recording on hangup"
 self.cleanup()
 self.call.state_machine.change_state(Event.HANGUP)

 def on_playback_finished(self, playback):
 self.cleanup()
 self.call.state_machine.change_state(Event.PLAYBACK_COMPLETE)

 def on_dtmf(self, channel, event):
 digit = event.get('digit')
 if digit == '#':
 print "Cutting off greeting on DTMF #"
 # Let on_playback_finished take care of state change
 self.playback.stop()

```
```javascript title="greeting_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds_installed(client) {
 client.sounds.get({soundId: 'vm-intro'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-intro' not installed. Aborting");
 throw err;
 }
 });
}

function GreetingState(call) {
 this.state_name = "greeting";
 sounds_installed(call.client);

 this.enter = function() {
 var playback = call.client.Playback();
 console.log("Entering greeting state");
 call.channel.on("ChannelHangupRequest", on_hangup);
 call.channel.on("ChannelDtmfReceived", on_dtmf);
 call.client.on("PlaybackFinished", on_playback_finished);
 call.channel.play({media: 'sound:vm-intro'}, playback);

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on_dtmf);
 call.client.removeListener('PlaybackFinished', on_playback_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on_hangup(event, channel) {
 console.log("Abandoning voicemail recording on hangup");
 cleanup();
 call.state_machine.change_state(Event.HANGUP);
 }

 function on_playback_finished(event) {
 if (playback && playback.id === event.playback.id) {
 cleanup();
 call.state_machine.change_state(Event.PLAYBACK_COMPLETE);
 }
 }

 function on_dtmf(event, channel) {
 switch (event.digit) {
 case '#':
 console.log("Skipping greeting");
 cleanup();
 call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
 }
 }
 }
}
 module.exports = GreetingState;

```

The `sounds.get()` method employed here allows for a single sound to be retrieved based on input parameters. Here, we simply specify the name of the recording we want to ensure that it exists in some form on the system. By checking for the sound's existence in the initialization of `GreetingState`, we can abort the call early if the sound is not installed.

And here is our updated state machine:




---

  
vm-call.py  

```
pytrue#At the top of the file
from greeting_state import GreetingState

#In VoiceMailCall::setup_state_machine()
 def setup_state_machine(self):
 hungup_state = HungUpState(self)
 recording_state = RecordingState(self)
 ending_state = EndingState(self)
 reviewing_state = ReviewingState(self)
 greeting_state = GreetingState(self)
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
 self.state_machine.add_transition(greeting_state, Event.HANGUP,
 hungup_state)
 self.state_machine.add_transition(greeting_state,
 Event.PLAYBACK_COMPLETE,
 recording_state)
 self.state_machine.start(greeting_state)

```
```javascript title="vm-call.js" linenums="1"
jstrue//At the top of the file
var GreetingState = require('./greeting_state');

//In VoicemailCall::setup_state_machine()
this.setup_state_machine = function() {
 var hungup_state = new HungUpState(this);
 var recording_state = new RecordingState(this);
 var ending_state = new EndingState(this);
 var reviewing_state = new ReviewingState(this);
 var greeting_state = new GreetingState(this);
 this.state_machine = new StateMachine();
 this.state_machine.add_transition(recording_state, Event.DTMF_OCTOTHORPE, reviewing_state);
 this.state_machine.add_transition(recording_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(recording_state, Event.DTMF_STAR, recording_state);
 this.state_machine.add_transition(reviewing_state, Event.DTMF_OCTOTHORPE, ending_state);
 this.state_machine.add_transition(reviewing_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(reviewing_state, Event.DTMF_STAR, recording_state);
 this.state_machine.add_transition(greeting_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(greeting_state, Event.PLAYBACK_COMPLETE, recording_state);
 this.state_machine.start(greeting_state);
}

```

Here is a sample run where the user cuts off the greeting by pressing the '#' key, records a greeting and presses the '#' key, and after listening to the recording presses the '#' key once more.

```
Channel PJSIP/200-0000000b recording voicemail for 305
Entering greeting state
Cutting off greeting on DTMF #
Entering recording state
Recording voicemail at voicemail/305/1411503204.75
Accepted recording voicemail/305/1411503204.75 on DTMF #
Cleaning up event handlers
Entering reviewing state
Accepted recording voicemail/305/1411503204.75 on DTMF #
Ending voice mail call from PJSIP/200-0000000b

```

silverseagreenReader Exercise 1solidblackOur current implementation of `GreetingState` does not take language into consideration. The `sounds_installed` method checks for the existence of the sound file, but it does not ensure that we have the sound file in the language of the channel that is in our application.

For this exercise, modify `sounds_installed()` to also check if the retrieved sound exists in the language of the calling channel. The channel's language can be retrieved using the `getChannelVar()` method on a channel to retrieve the value of variable "CHANNEL(language)". The sound returned by `sounds.get()` contains an array of `FormatLang` objects that are a pair of format and language strings. If the sound exists, but not in the channel's language, then throw an exception.

Controlling playbacks
=====================

So far in our voice mail application, we have stopped playbacks, but there are a lot more interesting operations that can be done on them, such as reversing and fast-forwarding them. Within the context of recording a voicemail, these operations are pretty useless, so we will shift our focus now to the other side of voicemail: listening to recorded voicemails.

For this, we will write a new application. This new application will allow a caller to listen to the voicemails that are stored in a specific mailbox. When the caller enters the application, a prompt is played to the caller saying which message number the caller is hearing. When the message number finishes playing (or if the caller interrupts the playback with '#'), then the caller hears the specified message in the voicemail box. While listening to the voicemail, the caller can do several things:

* Press the '1' key to go back 3 seconds in the current message playback.
* Press the '2' key to pause or unpause the current message playback.
* Press the '3' key to go forward 3 seconds in the current message playback.
* Press the '4' key to play to the previous message.
* Press the '5' key to restart the current message playback.
* Press the '6' key to play to the next message.
* Press the '\*' key to delete the current message and play the next message.
* Press the '#' key to end the call.

If all messages in a mailbox are deleted or if the mailbox contained no messages to begin with, then "no more messages" is played back to the user, and the call is completed.

This means defining a brand new state machine. To start with, we'll define three new states. The "preamble" state is the initial state of the state machine, where the current message number is played back to the listener. The "listening" state is where the voice mail message is played back to the listener. The "empty" state is where no more messages remain in the mailbox. Here is the state machine we will be using:

![](vm-listen.png)

Notice that while in the listening state, DMTF '4', '6', and '\*' all change the state to the preamble state. This is so that the new message number can be played back to the caller before the next message is heard. Also notice that the preamble state is responsible for determining if the state should change to empty. This keeps the logic in the listening state more straight-forward since it is already having to deal with a lot of DTMF events. It also gracefully handles the case where a caller calls into the application when the caller has no voicemail messages.

Here is the implementation of the application.




---

  
vm-playback.py  

```
pytrue#!/usr/bin/env python

import ari
import logging
import sys

from state_machine import StateMachine
from ending_state import EndingState
from hungup_state import HungUpState
from listening_state import ListeningState
from preamble_state import PreambleState
from empty_state import EmptyState
from event import Event

logging.basicConfig(level=logging.ERROR)
LOGGER = logging.getLogger(__name__)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')


class VoiceMailCall(object):
 def __init__(self, ari_client, channel, mailbox):
 self.client = ari_client
 self.channel = channel

 self.voicemails = []
 recordings = ari_client.recordings.listStored()
 vm_number = 1
 for rec in recordings:
 if rec.json['name'].startswith('voicemail/{0}'.format(mailbox)):
 self.voicemails.append((vm_number, rec.json['name']))
 vm_number += 1

 self.current_voicemail = 0
 self.setup_state_machine()

 def setup_state_machine(self):
 hungup_state = HungUpState(self)
 ending_state = EndingState(self)
 listening_state = ListeningState(self)
 preamble_state = PreambleState(self)
 empty_state = EmptyState(self)
 self.state_machine = StateMachine()
 self.state_machine.add_transition(listening_state, Event.DTMF_4,
 preamble_state)
 self.state_machine.add_transition(listening_state, Event.DTMF_6,
 preamble_state)
 self.state_machine.add_transition(listening_state, Event.HANGUP,
 hungup_state)
 self.state_machine.add_transition(listening_state, Event.DTMF_OCTOTHORPE,
 ending_state)
 self.state_machine.add_transition(listening_state, Event.DTMF_STAR,
 preamble_state)
 self.state_machine.add_transition(preamble_state, Event.DTMF_OCTOTHORPE,
 listening_state)
 self.state_machine.add_transition(preamble_state,
 Event.PLAYBACK_COMPLETE,
 listening_state)
 self.state_machine.add_transition(preamble_state, Event.MAILBOX_EMPTY,
 empty_state)
 self.state_machine.add_transition(preamble_state, Event.HANGUP,
 hungup_state)
 self.state_machine.add_transition(empty_state, Event.HANGUP,
 hungup_state)
 self.state_machine.add_transition(empty_state,
 Event.PLAYBACK_COMPLETE,
 ending_state)
 self.state_machine.start(preamble_state)

 def next_message(self):
 self.current_voicemail += 1
 if self.current_voicemail == len(self.voicemails):
 self.current_voicemail = 0

 def previous_message(self):
 self.current_voicemail -= 1
 if self.current_voicemail < 0:
 self.current_voicemail = len(self.voicemails) - 1

 def delete_message(self):
 del self.voicemails[self.current_voicemail]
 if self.current_voicemail == len(self.voicemails):
 self.current_voicemail = 0

 def get_current_voicemail_number(self):
 return self.voicemails[self.current_voicemail][0]

 def get_current_voicemail_file(self):
 return self.voicemails[self.current_voicemail][1]

 def mailbox_empty(self):
 return len(self.voicemails) == 0


def stasis_start_cb(channel_obj, event):
 channel = channel_obj['channel']
 channel_name = channel.json.get('name')
 mailbox = event.get('args')[0]
 print("Channel {0} recording voicemail for {1}".format(
 channel_name, mailbox))
 channel.answer()
 VoiceMailCall(client, channel, mailbox)


client.on_channel_event('StasisStart', stasis_start_cb)
client.run(apps=sys.argv[1])

```
```javascript title="vm-playback.js" linenums="1"
jstrue/*jshint node:true */
'use strict';
 
var ari = require('ari-client');
var util = require('util');
var path = require('path');

var Event = require('./event');
var StateMachine = require('./state_machine');
var EndingState = require('./ending_state');
var HungUpState = require('./hungup_state');
var PreambleState = require('./preamble_state');
var EmptyState = require('./empty_state');
var ListeningState = require('./listening_state');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

var VoiceMailCall = function(ari_client, channel, mailbox) {
 this.client = ari_client;
 this.channel = channel;
 var current_voicemail = 0;
 var voicemails = [];

 this.setup_state_machine = function() {
 var hungup_state = new HungUpState(this);
 var ending_state = new EndingState(this);
 var listening_state = new ListeningState(this);
 var preamble_state = new PreambleState(this);
 var empty_state = new EmptyState(this);
 this.state_machine = new StateMachine(this);
 this.state_machine.add_transition(listening_state, Event.DTMF_4, preamble_state);
 this.state_machine.add_transition(listening_state, Event.DTMF_6, preamble_state);
 this.state_machine.add_transition(listening_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(listening_state, Event.DTMF_OCTOTHORPE, ending_state);
 this.state_machine.add_transition(listening_state, Event.DTMF_STAR, preamble_state);
 this.state_machine.add_transition(preamble_state, Event.DTMF_OCTOTHORPE, listening_state);
 this.state_machine.add_transition(preamble_state, Event.PLAYBACK_COMPLETE, listening_state);
 this.state_machine.add_transition(preamble_state, Event.MAILBOX_EMPTY, empty_state);
 this.state_machine.add_transition(preamble_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(empty_state, Event.HANGUP, hungup_state);
 this.state_machine.add_transition(empty_state, Event.PLAYBACK_COMPLETE, ending_state);
 this.state_machine.start(preamble_state);
 }

 this.next_message = function() {
 current_voicemail++;
 if (current_voicemail === voicemails.length) {
 current_voicemail = 0;
 }
 }

 this.previous_message = function() {
 current_voicemail--;
 if (current_voicemail < 0) {
 current_voicemail = voicemails.length - 1;
 }
 }

 this.delete_message = function() {
 voicemails.splice(current_voicemail, 1);
 if (current_voicemail === voicemails.length) {
 current_voicemail = 0;
 }
 }

 this.get_current_voicemail_file = function() {
 return voicemails[current_voicemail]['file'];
 }

 this.mailbox_empty = function() {
 return voicemails.length === 0;
 }

 var self = this;
 ari_client.recordings.listStored(function (err, recordings) {
 var vm_number = 1;
 var regex = new RegExp('^voicemail/' + mailbox);
 for (var i = 0; i < recordings.length; i++) {
 var rec_name = recordings[i].name;
 if (rec_name.search(regex) != -1) {
 console.log("Found voicemail", rec_name);
 voicemails.push({'number': vm_number, 'file': rec_name});
 vm_number++;
 }
 }
 self.setup_state_machine();
 });
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

Quite a bit of this is similar to what we were using for our voice mail recording application. The biggest difference here is that the call has many more methods defined since playing back voice mails is more complicated than recording a single one.

Now that we have the state machine defined and the application written, let's actually write the required new states. First of the new states is the "preamble" state.




---

  
preamble_state.py  

```
pytruefrom event import Event
import uuid

def sounds_installed(client):
 try:
 client.sounds.get(soundId='vm-message')
 except:
 print "Required sound 'vm-message' not installed. Aborting"
 raise 


class PreambleState(object):
 state_name = "preamble"

 def __init__(self, call):
 self.call = call
 self.hangup_event = None
 self.playback_finished = None
 self.dtmf_event = None
 self.playback = None
 sounds_installed(call.client)

 def enter(self):
 print "Entering preamble state"
 if self.call.mailbox_empty():
 self.call.state_machine.change_state(Event.MAILBOX_EMPTY)
 return
 self.hangup_event = self.call.channel.on_event("ChannelHangupRequest",
 self.on_hangup)
 self.playback_finished = self.call.client.on_event(
 'PlaybackFinished', self.on_playback_finished)
 self.dtmf_event = self.call.channel.on_event('ChannelDtmfReceived',
 self.on_dtmf)
 self.initialize_playbacks()

 def initialize_playbacks(self):
 self.current_playback = 0
 current_voicemail = self.call.get_current_voicemail_number()
 self.sounds_to_play = [
 {
 'id': str(uuid.uuid4()),
 'media': 'sound:vm-message'
 },
 {
 'id': str(uuid.uuid4()),
 'media': 'number:{0}'.format(current_voicemail)
 }
 ]
 self.start_playback()

 def start_playback(self):
 current_sound = self.sounds_to_play[self.current_playback]
 self.playback = self.call.channel.playWithId(
 playbackId=current_sound['id'],
 media=current_sound['media']
 )

 def cleanup(self):
 self.playback_finished.close()
 if self.playback:
 self.playback.stop()
 self.dtmf_event.close()
 self.hangup_event.close()

 def on_hangup(self, channel, event):
 self.playback = None
 self.cleanup()
 self.call.state_machine.change_state(Event.HANGUP)

 def on_playback_finished(self, event):
 current_sound = self.sounds_to_play[self.current_playback]
 if current_sound['id'] == event.get('playback').get('id'):
 self.playback = None
 self.current_playback += 1
 if self.current_playback == len(self.sounds_to_play):
 self.cleanup()
 self.call.state_machine.change_state(Event.PLAYBACK_COMPLETE)
 else:
 self.start_playback()

 def on_dtmf(self, channel, event):
 digit = event.get('digit')
 if digit == '#':
 self.cleanup()
 self.call.state_machine.change_state(Event.DTMF_OCTOTHORPE)

```
```javascript title="preamble_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds_installed(client) {
 client.sounds.get({soundId: 'vm-message'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-message' not installed. Aborting");
 throw err;
 }
 });
}

function PreambleState(call) {
 this.state_name = "preamble";
 this.enter = function() {
 var current_playback;
 var sounds_to_play;
 var playback;
 console.log("Entering preamble state");
 if (call.mailbox_empty()) {
 call.state_machine.change_state(Event.MAILBOX_EMPTY);
 return;
 }
 call.channel.on("ChannelHangupRequest", on_hangup);
 call.client.on("PlaybackFinished", on_playback_finished);
 call.channel.on("ChannelDtmfReceived", on_dtmf);
 initialize_playbacks();

 function initialize_playbacks() {
 current_playback = 0;
 sounds_to_play = [
 {
 'playback': call.client.Playback(),
 'media': 'sound:vm-message'
 },
 {
 'playback': call.client.Playback(),
 'media': 'number:' + call.get_current_voicemail_number()
 }
 ];
 start_playback();
 }

 function start_playback() {
 current_sound = sounds_to_play[current_playback];
 playback = current_sound['playback'];
 call.channel.play({media: current_sound['media']}, playback);
 }

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on_dtmf);
 call.client.removeListener('PlaybackFinished', on_playback_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on_hangup(event, channel) {
 playback = null;
 cleanup();
 call.state_machine.change_state(Event.HANGUP);
 }

 function on_playback_finished(event) {
 var current_sound = sounds_to_play[current_playback];
 if (playback && (playback.id === event.playback.id)) {
 playback = null;
 current_playback++;
 if (current_playback === sounds_to_play.length) {
 cleanup();
 call.state_machine.change_state(Event.PLAYBACK_COMPLETE);
 } else {
 start_playback();
 }
 }
 }

 function on_dtmf(event, channel) {
 switch(event.digit) {
 case '#':
 cleanup();
 call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
 }
 }
 }
}



module.exports = PreambleState;

```

`PreambleState` should look similar to the `GreetingState` introduced previously on this page. The biggest difference is that the code is structured to play multiple sound files instead of just a single one. Note that it is acceptable to call `channel.play()` while a playback is playing on a channel in order to queue a second playback. For our application though, we have elected to play the second sound only after the first has completed. The reason for this is that if there is only a single active playback at any given time, then it becomes easier to clean up the current state when an event occurs that causes a state change.

Next, here is the "empty" state code:




---

  
empty_state.py  

```
pytruefrom event import Event
import uuid

def sounds_installed(client):
 try:
 client.sounds.get(soundId='vm-nomore')
 except:
 print "Required sound 'vm-nomore' not installed. Aborting"
 raise


class EmptyState(object):
 state_name = "empty"

 def __init__(self, call):
 self.call = call
 self.playback_id = None
 self.hangup_event = None
 self.playback_finished = None
 self.playback = None
 sounds_installed(call.client)

 def enter(self):
 self.playback_id = str(uuid.uuid4())
 print "Entering empty state"
 self.hangup_event = self.call.channel.on_event("ChannelHangupRequest",
 self.on_hangup)
 self.playback_finished = self.call.client.on_event(
 'PlaybackFinished', self.on_playback_finished)
 self.playback = self.call.channel.playWithId(
 playbackId=self.playback_id, media="sound:vm-nomore")

 def cleanup(self):
 self.playback_finished.close()
 if self.playback:
 self.playback.stop()
 self.hangup_event.close()

 def on_hangup(self, channel, event):
 # Setting playback to None stops cleanup() from trying to stop the
 # playback.
 self.playback = None
 self.cleanup()
 self.call.state_machine.change_state(Event.HANGUP)

 def on_playback_finished(self, event):
 if self.playback_id == event.get('playback').get('id'):
 self.playback = None
 self.cleanup()
 self.call.state_machine.change_state(Event.PLAYBACK_COMPLETE)

```
```javascript title="empty_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds_installed(client) {
 client.sounds.get({soundId: 'vm-nomore'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-nomore' not installed. Aborting");
 throw err;
 }
 });
}

function EmptyState(call) {
 this.state_name = "empty";

 this.enter = function() {
 console.log("Entering empty state");
 playback = call.client.Playback();
 call.channel.on("ChannelHangup", on_hangup);
 call.client.on("PlaybackFinished", on_playback_finished);
 call.channel.play({media: 'sound:vm-nomore'}, playback);

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on_hangup);
 call.channel.removeListener('PlaybackFinished', on_playback_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on_hangup(event, channel) {
 playback = null;
 cleanup();
 call.state_machine.change_state(Event.HANGUP);
 }

 function on_playback_finished(event) {
 if (playback && playback.id === event.playback.id) {
 playback = null;
 cleanup();
 call.state_machine.change_state(Event.PLAYBACK_COMPLETE);
 }
 }
 }
}

module.exports = EmptyState;

```

This state does not introduce anything we haven't seen already, so let's move on to the "listening" state code:




---

  
listening_state.py  

```
pytruefrom event import Event
import uuid

class ListeningState(object):
 state_name = "listening"

 def __init__(self, call):
 self.call = call
 self.playback_id = None
 self.hangup_event = None
 self.playback_finished = None
 self.dtmf_event = None
 self.playback = None

 def enter(self):
 self.paused = False
 self.playback_id = str(uuid.uuid4())
 print "Entering listening state"
 self.hangup_event = self.call.channel.on_event("ChannelHangupRequest",
 self.on_hangup)
 self.playback_finished = self.call.client.on_event(
 'PlaybackFinished', self.on_playback_finished)
 self.dtmf_event = self.call.channel.on_event('ChannelDtmfReceived',
 self.on_dtmf)
 self.playback = self.call.channel.playWithId(
 playbackId=self.playback_id, media="recording:{0}".format(
 self.call.get_current_voicemail_file()))

 def cleanup(self):
 self.playback_finished.close()
 if self.playback:
 self.playback.stop()
 self.dtmf_event.close()
 self.hangup_event.close()

 def on_hangup(self, channel, event):
 self.cleanup()
 self.call.state_machine.change_state(Event.HANGUP)

 def on_playback_finished(self, event):
 if self.playback_id == event.get('playback').get('id'):
 self.playback = None

 def on_dtmf(self, channel, event):
 digit = event.get('digit')
 if digit == '1':
 if self.playback:
 self.playback.control(operation='reverse')
 elif digit == '2':
 if not self.playback:
 return
 if self.paused:
 self.playback.control(operation='unpause')
 self.paused = False
 else:
 self.playback.control(operation='pause')
 self.paused = True
 elif digit == '3':
 if self.playback:
 self.playback.control(operation='forward')
 elif digit == '4':
 self.cleanup()
 self.call.previous_message()
 self.call.state_machine.change_state(Event.DTMF_4)
 elif digit == '5':
 if self.playback:
 self.playback.control(operation='restart')
 elif digit == '6':
 self.cleanup()
 self.call.next_message()
 self.call.state_machine.change_state(Event.DTMF_6)
 elif digit == '#':
 self.cleanup()
 self.call.state_machine.change_state(Event.DTMF_OCTOTHORPE)
 elif digit == '\*':
 print ("Deleting stored recording {0}".format(
 self.call.get_current_voicemail_file()))
 self.cleanup()
 self.call.client.recordings.deleteStored(
 recordingName=self.call.get_current_voicemail_file())
 self.call.delete_message()
 self.call.state_machine.change_state(Event.DTMF_STAR)

```
```javascript title="listening_state.js" linenums="1"
jstruevar Event = require('./event');

var ListeningState = function(call) {
 this.state_name = "listening";
 this.call = call;
}

function ListeningState(call) {
 this.state_name = "listening";
 this.enter = function() {
 var playback = call.client.Playback();
 var url = "recording:" + call.get_current_voicemail_file();

 console.log("Entering Listening state");
 call.channel.on("ChannelHangupRequest", on_hangup);
 call.channel.on("ChannelDtmfReceived", on_dtmf);
 call.client.on("PlaybackFinished", on_playback_finished);
 console.log("Playing file %s", url);
 call.channel.play({media: url}, playback, function(err) {
 if (err) {
 console.error(err);
 }
 });

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on_dtmf);
 call.client.removeListener('PlaybackFinished', on_playback_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on_hangup(event, channel) {
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
 case '1':
 if (playback) {
 playback.control({operation: 'reverse'});
 }
 break;
 case '2':
 if (!playback) {
 break;
 }
 if (paused) {
 playback.control({operation: 'unpause'});
 paused = false;
 } else {
 playback.control({operation: 'pause'});
 paused = true;
 }
 break;
 case '3':
 if (playback) {
 playback.control({operation: 'forward'});
 }
 break;
 case '4':
 cleanup();
 call.previous_message();
 call.state_machine.change_state(Event.DTMF_4);
 break;
 case '5':
 if (playback) {
 playback.control({operation: 'restart'});
 }
 break;
 case '6':
 cleanup();
 call.next_message();
 call.state_machine.change_state(Event.DTMF_6);
 break;
 case '#':
 cleanup();
 call.state_machine.change_state(Event.DTMF_OCTOTHORPE);
 break;
 case '\*':
 console.log("Deleting stored recording", call.get_current_voicemail_file());
 cleanup();
 call.client.recordings.deleteStored({recordingName:call.get_current_voicemail_file()});
 call.delete_message();
 call.state_machine.change_state(Event.DTMF_STAR);
 }
 }
 }
}

module.exports = ListeningState;

```

`ListeningState` is where we introduce new playback control concepts. Playbacks have their controlling operations wrapped in a single method, `control()`, rather than having lots of separate operations. All control operations (reverse, pause, unpause, forward, and restart) are demonstrated by this state.

silverseagreenReader Exercise 2solidblackYou may have noticed while exploring the playbacks API that the `control()` method takes no parameters other than the operation. This means that certain properties of operations are determined when the playback is started on the channel.

For this exercise, modify the `ListeningState` so that DTMF '1' and '3' reverse or forward the playback by 5000 milliseconds instead of the default 3000 milliseconds.

Playbacks on bridges
====================

Just as channels allow for playbacks to be performed on them, bridges also have the capacity to have sounds, recordings, tones, numbers, etc. played back on them. The difference is is that all participants in the bridge will hear the playback instead of just a single channel. In bridging situations, it can be useful to play certain sounds to an entire bridge (e.g. Telling participants the call is being recorded), but it can also be useful to play sounds to specific participants (e.g. Telling a caller he has joined a conference bridge). A playback on a bridge can be stopped or controlled exactly the same as a playback on a channel.

silverseagreenReader Exercise 3solidblackIf you've read through the Recording and Playbacks pages, then you should have a good grasp on the operations available, as well as a decent state machine implementation. For our final exercise, instead of adding onto the existing voice mail applications, create a new application that uses some of the recording and playback operations that you have learned about.

You will be creating a rudimentary call queue application. The queue application will have two types of participants: agents and callers. Agents and callers call into the same Stasis application and are distinguished based on arguments to the Stasis application (e.g. A caller might call Stasis(queue,caller) and an agent might call Stasis(queue,agent) from the dialplan).

* When an agent calls into the Stasis application, the agent is placed into an agent queue.
	+ While in the agent queue, the agent should hear music on hold. Information about how to play music on hold to a channel can be found here.
* When a caller calls into the Stasis application, the caller is placed into a caller queue.
	+ While in the caller queue, the caller should hear music on hold.
	+ Every 30 seconds, the caller should hear an announcement. If the caller is at the front of the queue, the "queue-youarenext" sound should play. If the caller is not at the front of the queue, then the caller should hear the "queue-thereare" sound, then the number of callers ahead in the queue, then the "queue-callswaiting" sound.
* If there is a caller in the caller queue and an agent in the agent queue, then the caller and agent at the front of their respective queues are removed and placed into a bridge with each other. For more information on bridging channels, see [this page](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Bridges/ARI-and-Bridges-Basic-Mixing-Bridges). If this happens while a caller has a sound file playing, then this should cause the sound file to immediately stop playing in order to bridge the call.
* Once bridged, the agent can perform the following:
	+ Pressing '0' should start recording the bridge. Upon recording the bridge, the caller should hear a beep sound.
	+ Pressing '5' while the call is being recorded should pause the recording. Pressing '5' a second time should unpause the recording.
	+ Pressing '7' while the call is being recorded should stop the recording.
	+ Pressing '9' while the call is being recorded should discard the recording.
	+ Pressing '#' at any time (whether the call is being recorded or not) should end the call, causing the agent to be placed into the back of the agent queue and the caller to be hung up.
	+ If the agent hangs up, then the caller should also be hung up.
* Once bridged, if the caller hangs up, then the agent should be placed into the back of the agent queue.

Best of luck!

