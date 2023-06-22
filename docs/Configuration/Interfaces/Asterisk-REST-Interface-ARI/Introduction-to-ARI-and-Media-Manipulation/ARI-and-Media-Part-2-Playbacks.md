---
title: ARI and Media: Part 2 - Playbacks
pageid: 30277828
---

Querying for sounds
===================

In our voice mail application we have been creating, we have learned the ins and outs of creating and manipulating live and stored recordings. Let's make the voice mail application more user-friendly now by adding some playbacks of installed sounds. The voice mail application has some nice capabilities, but it is not very user-friendly yet. Let's modify the current application to play a greeting to the user when they call into the application. This is the updated state machine:

![](vm-full.png)

40%On this Page


To make the new "greeting" state more interesting, we are going to add some safety to this state by ensuring that the sound we want to play is installed on the system. The [`/sounds`](/Asterisk-13-Sounds-REST-API) resource in ARI provides methods to list the sounds installed on the system, as well as the ability to get specific sound files.

Asterisk searches for sounds in the `/sounds/` subdirectory of the configured `astdatadir` option in `asterisk.conf`. By default, Asterisk will search for sounds in `/var/lib/asterisk/sounds`. When Asterisk starts up, it indexes the installed sounds and keeps an in-data representation of those sound files. When an ARI application asks Asterisk for details about a specific sound or for a list of sounds on the system, Asterisk consults its in-memory index instead of searching the file system directly. This has some trade-offs. When querying for sound information, this in-memory indexing makes the operations much faster. On the other hand, it also means that Asterisk has to be "poked" to re-index the sounds if new sounds are added to the file system after Asterisk is running.  The Asterisk CLI command "module reload sounds" provides a means of having Asterisk re-index the sounds on the system so that they are available to ARI.

For our greeting, we will play the built-in sound "vm-intro". Here is the code for our new state:




---

  
greeting\_state.py  


```

pytruefrom event import Event

def sounds\_installed(client):
 try:
 client.sounds.get(soundId='vm-intro')
 except:
 print "Required sound 'vm-intro' not installed. Aborting"
 raise


class GreetingState(object):
 state\_name = "greeting"

 def \_\_init\_\_(self, call):
 self.call = call
 self.hangup\_event = None
 self.playback\_finished = None
 self.dtmf\_event = None
 self.playback = None
 sounds\_installed(call.client)

 def enter(self):
 print "Entering greeting state"
 self.hangup\_event = self.call.channel.on\_event('ChannelHangupRequest',
 self.on\_hangup)
 self.playback\_finished = self.call.client.on\_event(
 'PlaybackFinished', self.on\_playback\_finished)
 self.dtmf\_event = self.call.channel.on\_event('ChannelDtmfReceived',
 self.on\_dtmf)
 self.playback = self.call.channel.play(media="sound:vm-intro")

 def cleanup(self):
 self.playback\_finished.close()
 self.dtmf\_event.close()
 self.hangup\_event.close()

 def on\_hangup(self, channel, event):
 print "Abandoning voicemail recording on hangup"
 self.cleanup()
 self.call.state\_machine.change\_state(Event.HANGUP)

 def on\_playback\_finished(self, playback):
 self.cleanup()
 self.call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE)

 def on\_dtmf(self, channel, event):
 digit = event.get('digit')
 if digit == '#':
 print "Cutting off greeting on DTMF #"
 # Let on\_playback\_finished take care of state change
 self.playback.stop()

```




```javascript title="greeting\_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds\_installed(client) {
 client.sounds.get({soundId: 'vm-intro'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-intro' not installed. Aborting");
 throw err;
 }
 });
}

function GreetingState(call) {
 this.state\_name = "greeting";
 sounds\_installed(call.client);

 this.enter = function() {
 var playback = call.client.Playback();
 console.log("Entering greeting state");
 call.channel.on("ChannelHangupRequest", on\_hangup);
 call.channel.on("ChannelDtmfReceived", on\_dtmf);
 call.client.on("PlaybackFinished", on\_playback\_finished);
 call.channel.play({media: 'sound:vm-intro'}, playback);

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on\_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on\_dtmf);
 call.client.removeListener('PlaybackFinished', on\_playback\_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on\_hangup(event, channel) {
 console.log("Abandoning voicemail recording on hangup");
 cleanup();
 call.state\_machine.change\_state(Event.HANGUP);
 }

 function on\_playback\_finished(event) {
 if (playback && playback.id === event.playback.id) {
 cleanup();
 call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE);
 }
 }

 function on\_dtmf(event, channel) {
 switch (event.digit) {
 case '#':
 console.log("Skipping greeting");
 cleanup();
 call.state\_machine.change\_state(Event.DTMF\_OCTOTHORPE);
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
from greeting\_state import GreetingState

#In VoiceMailCall::setup\_state\_machine()
 def setup\_state\_machine(self):
 hungup\_state = HungUpState(self)
 recording\_state = RecordingState(self)
 ending\_state = EndingState(self)
 reviewing\_state = ReviewingState(self)
 greeting\_state = GreetingState(self)
 self.state\_machine = StateMachine()
 self.state\_machine.add\_transition(recording\_state, Event.DTMF\_OCTOTHORPE,
 reviewing\_state)
 self.state\_machine.add\_transition(recording\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(recording\_state, Event.DTMF\_STAR,
 recording\_state)
 self.state\_machine.add\_transition(reviewing\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(reviewing\_state, Event.DTMF\_OCTOTHORPE,
 ending\_state)
 self.state\_machine.add\_transition(reviewing\_state, Event.DTMF\_STAR,
 recording\_state)
 self.state\_machine.add\_transition(greeting\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(greeting\_state,
 Event.PLAYBACK\_COMPLETE,
 recording\_state)
 self.state\_machine.start(greeting\_state)

```




```javascript title="vm-call.js" linenums="1"
jstrue//At the top of the file
var GreetingState = require('./greeting\_state');

//In VoicemailCall::setup\_state\_machine()
this.setup\_state\_machine = function() {
 var hungup\_state = new HungUpState(this);
 var recording\_state = new RecordingState(this);
 var ending\_state = new EndingState(this);
 var reviewing\_state = new ReviewingState(this);
 var greeting\_state = new GreetingState(this);
 this.state\_machine = new StateMachine();
 this.state\_machine.add\_transition(recording\_state, Event.DTMF\_OCTOTHORPE, reviewing\_state);
 this.state\_machine.add\_transition(recording\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(recording\_state, Event.DTMF\_STAR, recording\_state);
 this.state\_machine.add\_transition(reviewing\_state, Event.DTMF\_OCTOTHORPE, ending\_state);
 this.state\_machine.add\_transition(reviewing\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(reviewing\_state, Event.DTMF\_STAR, recording\_state);
 this.state\_machine.add\_transition(greeting\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(greeting\_state, Event.PLAYBACK\_COMPLETE, recording\_state);
 this.state\_machine.start(greeting\_state);
}

```


Here is a sample run where the user cuts off the greeting by pressing the '#' key, records a greeting and presses the '#' key, and after listening to the recording presses the '#' key once more.




---

  
  


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

from state\_machine import StateMachine
from ending\_state import EndingState
from hungup\_state import HungUpState
from listening\_state import ListeningState
from preamble\_state import PreambleState
from empty\_state import EmptyState
from event import Event

logging.basicConfig(level=logging.ERROR)
LOGGER = logging.getLogger(\_\_name\_\_)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')


class VoiceMailCall(object):
 def \_\_init\_\_(self, ari\_client, channel, mailbox):
 self.client = ari\_client
 self.channel = channel

 self.voicemails = []
 recordings = ari\_client.recordings.listStored()
 vm\_number = 1
 for rec in recordings:
 if rec.json['name'].startswith('voicemail/{0}'.format(mailbox)):
 self.voicemails.append((vm\_number, rec.json['name']))
 vm\_number += 1

 self.current\_voicemail = 0
 self.setup\_state\_machine()

 def setup\_state\_machine(self):
 hungup\_state = HungUpState(self)
 ending\_state = EndingState(self)
 listening\_state = ListeningState(self)
 preamble\_state = PreambleState(self)
 empty\_state = EmptyState(self)
 self.state\_machine = StateMachine()
 self.state\_machine.add\_transition(listening\_state, Event.DTMF\_4,
 preamble\_state)
 self.state\_machine.add\_transition(listening\_state, Event.DTMF\_6,
 preamble\_state)
 self.state\_machine.add\_transition(listening\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(listening\_state, Event.DTMF\_OCTOTHORPE,
 ending\_state)
 self.state\_machine.add\_transition(listening\_state, Event.DTMF\_STAR,
 preamble\_state)
 self.state\_machine.add\_transition(preamble\_state, Event.DTMF\_OCTOTHORPE,
 listening\_state)
 self.state\_machine.add\_transition(preamble\_state,
 Event.PLAYBACK\_COMPLETE,
 listening\_state)
 self.state\_machine.add\_transition(preamble\_state, Event.MAILBOX\_EMPTY,
 empty\_state)
 self.state\_machine.add\_transition(preamble\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(empty\_state, Event.HANGUP,
 hungup\_state)
 self.state\_machine.add\_transition(empty\_state,
 Event.PLAYBACK\_COMPLETE,
 ending\_state)
 self.state\_machine.start(preamble\_state)

 def next\_message(self):
 self.current\_voicemail += 1
 if self.current\_voicemail == len(self.voicemails):
 self.current\_voicemail = 0

 def previous\_message(self):
 self.current\_voicemail -= 1
 if self.current\_voicemail < 0:
 self.current\_voicemail = len(self.voicemails) - 1

 def delete\_message(self):
 del self.voicemails[self.current\_voicemail]
 if self.current\_voicemail == len(self.voicemails):
 self.current\_voicemail = 0

 def get\_current\_voicemail\_number(self):
 return self.voicemails[self.current\_voicemail][0]

 def get\_current\_voicemail\_file(self):
 return self.voicemails[self.current\_voicemail][1]

 def mailbox\_empty(self):
 return len(self.voicemails) == 0


def stasis\_start\_cb(channel\_obj, event):
 channel = channel\_obj['channel']
 channel\_name = channel.json.get('name')
 mailbox = event.get('args')[0]
 print("Channel {0} recording voicemail for {1}".format(
 channel\_name, mailbox))
 channel.answer()
 VoiceMailCall(client, channel, mailbox)


client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.run(apps=sys.argv[1])

```




```javascript title="vm-playback.js" linenums="1"
jstrue/\*jshint node:true\*/
'use strict';
 
var ari = require('ari-client');
var util = require('util');
var path = require('path');

var Event = require('./event');
var StateMachine = require('./state\_machine');
var EndingState = require('./ending\_state');
var HungUpState = require('./hungup\_state');
var PreambleState = require('./preamble\_state');
var EmptyState = require('./empty\_state');
var ListeningState = require('./listening\_state');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

var VoiceMailCall = function(ari\_client, channel, mailbox) {
 this.client = ari\_client;
 this.channel = channel;
 var current\_voicemail = 0;
 var voicemails = [];

 this.setup\_state\_machine = function() {
 var hungup\_state = new HungUpState(this);
 var ending\_state = new EndingState(this);
 var listening\_state = new ListeningState(this);
 var preamble\_state = new PreambleState(this);
 var empty\_state = new EmptyState(this);
 this.state\_machine = new StateMachine(this);
 this.state\_machine.add\_transition(listening\_state, Event.DTMF\_4, preamble\_state);
 this.state\_machine.add\_transition(listening\_state, Event.DTMF\_6, preamble\_state);
 this.state\_machine.add\_transition(listening\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(listening\_state, Event.DTMF\_OCTOTHORPE, ending\_state);
 this.state\_machine.add\_transition(listening\_state, Event.DTMF\_STAR, preamble\_state);
 this.state\_machine.add\_transition(preamble\_state, Event.DTMF\_OCTOTHORPE, listening\_state);
 this.state\_machine.add\_transition(preamble\_state, Event.PLAYBACK\_COMPLETE, listening\_state);
 this.state\_machine.add\_transition(preamble\_state, Event.MAILBOX\_EMPTY, empty\_state);
 this.state\_machine.add\_transition(preamble\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(empty\_state, Event.HANGUP, hungup\_state);
 this.state\_machine.add\_transition(empty\_state, Event.PLAYBACK\_COMPLETE, ending\_state);
 this.state\_machine.start(preamble\_state);
 }

 this.next\_message = function() {
 current\_voicemail++;
 if (current\_voicemail === voicemails.length) {
 current\_voicemail = 0;
 }
 }

 this.previous\_message = function() {
 current\_voicemail--;
 if (current\_voicemail < 0) {
 current\_voicemail = voicemails.length - 1;
 }
 }

 this.delete\_message = function() {
 voicemails.splice(current\_voicemail, 1);
 if (current\_voicemail === voicemails.length) {
 current\_voicemail = 0;
 }
 }

 this.get\_current\_voicemail\_file = function() {
 return voicemails[current\_voicemail]['file'];
 }

 this.mailbox\_empty = function() {
 return voicemails.length === 0;
 }

 var self = this;
 ari\_client.recordings.listStored(function (err, recordings) {
 var vm\_number = 1;
 var regex = new RegExp('^voicemail/' + mailbox);
 for (var i = 0; i < recordings.length; i++) {
 var rec\_name = recordings[i].name;
 if (rec\_name.search(regex) != -1) {
 console.log("Found voicemail", rec\_name);
 voicemails.push({'number': vm\_number, 'file': rec\_name});
 vm\_number++;
 }
 }
 self.setup\_state\_machine();
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

  
preamble\_state.py  


```

pytruefrom event import Event
import uuid

def sounds\_installed(client):
 try:
 client.sounds.get(soundId='vm-message')
 except:
 print "Required sound 'vm-message' not installed. Aborting"
 raise 


class PreambleState(object):
 state\_name = "preamble"

 def \_\_init\_\_(self, call):
 self.call = call
 self.hangup\_event = None
 self.playback\_finished = None
 self.dtmf\_event = None
 self.playback = None
 sounds\_installed(call.client)

 def enter(self):
 print "Entering preamble state"
 if self.call.mailbox\_empty():
 self.call.state\_machine.change\_state(Event.MAILBOX\_EMPTY)
 return
 self.hangup\_event = self.call.channel.on\_event("ChannelHangupRequest",
 self.on\_hangup)
 self.playback\_finished = self.call.client.on\_event(
 'PlaybackFinished', self.on\_playback\_finished)
 self.dtmf\_event = self.call.channel.on\_event('ChannelDtmfReceived',
 self.on\_dtmf)
 self.initialize\_playbacks()

 def initialize\_playbacks(self):
 self.current\_playback = 0
 current\_voicemail = self.call.get\_current\_voicemail\_number()
 self.sounds\_to\_play = [
 {
 'id': str(uuid.uuid4()),
 'media': 'sound:vm-message'
 },
 {
 'id': str(uuid.uuid4()),
 'media': 'number:{0}'.format(current\_voicemail)
 }
 ]
 self.start\_playback()

 def start\_playback(self):
 current\_sound = self.sounds\_to\_play[self.current\_playback]
 self.playback = self.call.channel.playWithId(
 playbackId=current\_sound['id'],
 media=current\_sound['media']
 )

 def cleanup(self):
 self.playback\_finished.close()
 if self.playback:
 self.playback.stop()
 self.dtmf\_event.close()
 self.hangup\_event.close()

 def on\_hangup(self, channel, event):
 self.playback = None
 self.cleanup()
 self.call.state\_machine.change\_state(Event.HANGUP)

 def on\_playback\_finished(self, event):
 current\_sound = self.sounds\_to\_play[self.current\_playback]
 if current\_sound['id'] == event.get('playback').get('id'):
 self.playback = None
 self.current\_playback += 1
 if self.current\_playback == len(self.sounds\_to\_play):
 self.cleanup()
 self.call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE)
 else:
 self.start\_playback()

 def on\_dtmf(self, channel, event):
 digit = event.get('digit')
 if digit == '#':
 self.cleanup()
 self.call.state\_machine.change\_state(Event.DTMF\_OCTOTHORPE)

```




```javascript title="preamble\_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds\_installed(client) {
 client.sounds.get({soundId: 'vm-message'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-message' not installed. Aborting");
 throw err;
 }
 });
}

function PreambleState(call) {
 this.state\_name = "preamble";
 this.enter = function() {
 var current\_playback;
 var sounds\_to\_play;
 var playback;
 console.log("Entering preamble state");
 if (call.mailbox\_empty()) {
 call.state\_machine.change\_state(Event.MAILBOX\_EMPTY);
 return;
 }
 call.channel.on("ChannelHangupRequest", on\_hangup);
 call.client.on("PlaybackFinished", on\_playback\_finished);
 call.channel.on("ChannelDtmfReceived", on\_dtmf);
 initialize\_playbacks();

 function initialize\_playbacks() {
 current\_playback = 0;
 sounds\_to\_play = [
 {
 'playback': call.client.Playback(),
 'media': 'sound:vm-message'
 },
 {
 'playback': call.client.Playback(),
 'media': 'number:' + call.get\_current\_voicemail\_number()
 }
 ];
 start\_playback();
 }

 function start\_playback() {
 current\_sound = sounds\_to\_play[current\_playback];
 playback = current\_sound['playback'];
 call.channel.play({media: current\_sound['media']}, playback);
 }

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on\_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on\_dtmf);
 call.client.removeListener('PlaybackFinished', on\_playback\_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on\_hangup(event, channel) {
 playback = null;
 cleanup();
 call.state\_machine.change\_state(Event.HANGUP);
 }

 function on\_playback\_finished(event) {
 var current\_sound = sounds\_to\_play[current\_playback];
 if (playback && (playback.id === event.playback.id)) {
 playback = null;
 current\_playback++;
 if (current\_playback === sounds\_to\_play.length) {
 cleanup();
 call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE);
 } else {
 start\_playback();
 }
 }
 }

 function on\_dtmf(event, channel) {
 switch(event.digit) {
 case '#':
 cleanup();
 call.state\_machine.change\_state(Event.DTMF\_OCTOTHORPE);
 }
 }
 }
}



module.exports = PreambleState;

```


`PreambleState` should look similar to the `GreetingState` introduced previously on this page. The biggest difference is that the code is structured to play multiple sound files instead of just a single one. Note that it is acceptable to call `channel.play()` while a playback is playing on a channel in order to queue a second playback. For our application though, we have elected to play the second sound only after the first has completed. The reason for this is that if there is only a single active playback at any given time, then it becomes easier to clean up the current state when an event occurs that causes a state change.

Next, here is the "empty" state code:




---

  
empty\_state.py  


```

pytruefrom event import Event
import uuid

def sounds\_installed(client):
 try:
 client.sounds.get(soundId='vm-nomore')
 except:
 print "Required sound 'vm-nomore' not installed. Aborting"
 raise


class EmptyState(object):
 state\_name = "empty"

 def \_\_init\_\_(self, call):
 self.call = call
 self.playback\_id = None
 self.hangup\_event = None
 self.playback\_finished = None
 self.playback = None
 sounds\_installed(call.client)

 def enter(self):
 self.playback\_id = str(uuid.uuid4())
 print "Entering empty state"
 self.hangup\_event = self.call.channel.on\_event("ChannelHangupRequest",
 self.on\_hangup)
 self.playback\_finished = self.call.client.on\_event(
 'PlaybackFinished', self.on\_playback\_finished)
 self.playback = self.call.channel.playWithId(
 playbackId=self.playback\_id, media="sound:vm-nomore")

 def cleanup(self):
 self.playback\_finished.close()
 if self.playback:
 self.playback.stop()
 self.hangup\_event.close()

 def on\_hangup(self, channel, event):
 # Setting playback to None stops cleanup() from trying to stop the
 # playback.
 self.playback = None
 self.cleanup()
 self.call.state\_machine.change\_state(Event.HANGUP)

 def on\_playback\_finished(self, event):
 if self.playback\_id == event.get('playback').get('id'):
 self.playback = None
 self.cleanup()
 self.call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE)

```




```javascript title="empty\_state.js" linenums="1"
jstruevar Event = require('./event');

function sounds\_installed(client) {
 client.sounds.get({soundId: 'vm-nomore'}, function(err) {
 if (err) {
 console.log("Required sound 'vm-nomore' not installed. Aborting");
 throw err;
 }
 });
}

function EmptyState(call) {
 this.state\_name = "empty";

 this.enter = function() {
 console.log("Entering empty state");
 playback = call.client.Playback();
 call.channel.on("ChannelHangup", on\_hangup);
 call.client.on("PlaybackFinished", on\_playback\_finished);
 call.channel.play({media: 'sound:vm-nomore'}, playback);

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on\_hangup);
 call.channel.removeListener('PlaybackFinished', on\_playback\_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on\_hangup(event, channel) {
 playback = null;
 cleanup();
 call.state\_machine.change\_state(Event.HANGUP);
 }

 function on\_playback\_finished(event) {
 if (playback && playback.id === event.playback.id) {
 playback = null;
 cleanup();
 call.state\_machine.change\_state(Event.PLAYBACK\_COMPLETE);
 }
 }
 }
}

module.exports = EmptyState;

```


This state does not introduce anything we haven't seen already, so let's move on to the "listening" state code:




---

  
listening\_state.py  


```

pytruefrom event import Event
import uuid

class ListeningState(object):
 state\_name = "listening"

 def \_\_init\_\_(self, call):
 self.call = call
 self.playback\_id = None
 self.hangup\_event = None
 self.playback\_finished = None
 self.dtmf\_event = None
 self.playback = None

 def enter(self):
 self.paused = False
 self.playback\_id = str(uuid.uuid4())
 print "Entering listening state"
 self.hangup\_event = self.call.channel.on\_event("ChannelHangupRequest",
 self.on\_hangup)
 self.playback\_finished = self.call.client.on\_event(
 'PlaybackFinished', self.on\_playback\_finished)
 self.dtmf\_event = self.call.channel.on\_event('ChannelDtmfReceived',
 self.on\_dtmf)
 self.playback = self.call.channel.playWithId(
 playbackId=self.playback\_id, media="recording:{0}".format(
 self.call.get\_current\_voicemail\_file()))

 def cleanup(self):
 self.playback\_finished.close()
 if self.playback:
 self.playback.stop()
 self.dtmf\_event.close()
 self.hangup\_event.close()

 def on\_hangup(self, channel, event):
 self.cleanup()
 self.call.state\_machine.change\_state(Event.HANGUP)

 def on\_playback\_finished(self, event):
 if self.playback\_id == event.get('playback').get('id'):
 self.playback = None

 def on\_dtmf(self, channel, event):
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
 self.call.previous\_message()
 self.call.state\_machine.change\_state(Event.DTMF\_4)
 elif digit == '5':
 if self.playback:
 self.playback.control(operation='restart')
 elif digit == '6':
 self.cleanup()
 self.call.next\_message()
 self.call.state\_machine.change\_state(Event.DTMF\_6)
 elif digit == '#':
 self.cleanup()
 self.call.state\_machine.change\_state(Event.DTMF\_OCTOTHORPE)
 elif digit == '\*':
 print ("Deleting stored recording {0}".format(
 self.call.get\_current\_voicemail\_file()))
 self.cleanup()
 self.call.client.recordings.deleteStored(
 recordingName=self.call.get\_current\_voicemail\_file())
 self.call.delete\_message()
 self.call.state\_machine.change\_state(Event.DTMF\_STAR)

```




```javascript title="listening\_state.js" linenums="1"
jstruevar Event = require('./event');

var ListeningState = function(call) {
 this.state\_name = "listening";
 this.call = call;
}

function ListeningState(call) {
 this.state\_name = "listening";
 this.enter = function() {
 var playback = call.client.Playback();
 var url = "recording:" + call.get\_current\_voicemail\_file();

 console.log("Entering Listening state");
 call.channel.on("ChannelHangupRequest", on\_hangup);
 call.channel.on("ChannelDtmfReceived", on\_dtmf);
 call.client.on("PlaybackFinished", on\_playback\_finished);
 console.log("Playing file %s", url);
 call.channel.play({media: url}, playback, function(err) {
 if (err) {
 console.error(err);
 }
 });

 function cleanup() {
 call.channel.removeListener('ChannelHangupRequest', on\_hangup);
 call.channel.removeListener('ChannelDtmfReceived', on\_dtmf);
 call.client.removeListener('PlaybackFinished', on\_playback\_finished);
 if (playback) {
 playback.stop();
 }
 }

 function on\_hangup(event, channel) {
 playback = null;
 cleanup();
 call.state\_machine.change\_state(Event.HANGUP);
 }

 function on\_playback\_finished(event) {
 if (playback && (playback.id === event.playback.id)) {
 playback = null;
 }
 }

 function on\_dtmf(event, channel) {
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
 call.previous\_message();
 call.state\_machine.change\_state(Event.DTMF\_4);
 break;
 case '5':
 if (playback) {
 playback.control({operation: 'restart'});
 }
 break;
 case '6':
 cleanup();
 call.next\_message();
 call.state\_machine.change\_state(Event.DTMF\_6);
 break;
 case '#':
 cleanup();
 call.state\_machine.change\_state(Event.DTMF\_OCTOTHORPE);
 break;
 case '\*':
 console.log("Deleting stored recording", call.get\_current\_voicemail\_file());
 cleanup();
 call.client.recordings.deleteStored({recordingName:call.get\_current\_voicemail\_file()});
 call.delete\_message();
 call.state\_machine.change\_state(Event.DTMF\_STAR);
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

