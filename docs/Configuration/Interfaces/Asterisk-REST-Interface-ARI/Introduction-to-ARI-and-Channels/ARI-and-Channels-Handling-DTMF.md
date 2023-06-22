---
title: ARI and Channels: Handling DTMF
pageid: 29395612
---

Handling DTMF events
====================

DTMF events are conveyed via the [`ChannelDtmfReceived`](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-ChannelDtmfReceived) event. The event contains the channel that pressed the DTMF key, the digit that was pressed, and the duration of the digit.

While this concept is relatively straight forward, handling DTMF is quite common in applications, as it is the primary mechanism that phones have to inform a server to perform some action. This includes manipulating media, initiating call features, performing transfers, dialling, and just about every thing in between. As such, the examples on this page focus less on simply handling the event and more on using the DTMF in a relatively realistic fashion.

40%On This PageExample: A simple automated attendant
=====================================

This example mimics the [automated attendant/IVR dialplan example](/Deployment/Basic-PBX-Functionality/Auto-attendant-and-IVR-Menus/Handling-Special-Extensions). It does the following:

* Plays a menu to the user which is cancelled when the user takes some action.
* If the user presses 1 or 2, the digit is repeated to the user and the menu restarted.
* If the user presses an invalid digit, a prompt informing the user that the digit was invalid is played to the user and the menu restarted.
* If the user fails to press anything within some period of time, a prompt asking the user if they are still present is played to the user and the menu restarted.

 




!!! tip 
    For this example, you will need the following:

    1. The **extra** sound package from Asterisk. You can install this using the `menuselect` tool.
    2. If using the Python example, `ari-py` version 0.1.3 or later.
    3. If using the JavaScript example, ari-client version 0.1.4 or later.
      
[//]: # (end-tip)



Dialplan
--------

As usual, a very simple dialplan is sufficient for this example. The dialplan takes the channel and places it into the Stasis application `channel-aa`.




---

  
extensions.conf  


```

trueexten => 1000,1,NoOp()
 same => n,Stasis(channel-aa)
 same => n,Hangup()

```


Python
------

As this example is a bit larger, how the code is written and structured is broken up into two phases:

1. Constructing the menu and handling its state as the user presses buttons.
2. Actually handling the button presses from the user.

The full source code for this example immediately follows the walk through.

### Playing the menu

Unlike Playback, which can chain multiple sounds together and play them back in one continuous operation, ARI treats all sound files being played as separate operations. It will queue each sound file up to be played on the channel, and hand back the caller an object to control the operation of that single sound file. The menu announcement for the attendant has the following requirements:

1. Playback the options for the user
2. If the user presses a DTMF key, cancel the playback of the options and handle the request
3. If the user presses an invalid DTMF key, let them know and restart the menu
4. If the user doesn't press anything, wait 10 seconds, ask them if they are still present, and restart the menu

The second requirement makes this a bit more challenging: when the user presses a DTMF key, we want to cancel whatever sound file is currently being played back and immediately handle their request. We thus have to maintain some state in our application about what sound file is currently being played so that we can cancel the correct playback. We also don't want to queue up all of the sounds immediately - we'd have to walk through all of the queued up sounds and cancel each one - that'd be annoying! Instead, we only want to start the next sound in our prompt when the previous has completed.

To start, we'll define in a list at the top of our script the sounds that make up the initial menu prompt:




---

  
  


```

truepy12sounds = ['press-1', 'or', 'press-2']

```


Since we'll want to maintain some state, we'll create a small object to do that for us. In Python, tuples are immutable - and we'll want to mutate the state in callbacks when certain operations happen. As such, it makes sense to use a small class for this with two properties:

1. The current sound being played
2. Whether or not we should consider the menu complete

It's useful to have both pieces of data, as we may cancel the menu half-way through and want to take one set of actions, or we may complete the menu and all the sounds and start a different set of actions.




---

  
  


```

truepy16class MenuState(object):
 """A small tracking object for the channel in the menu"""

 def \_\_init\_\_(self, current\_sound, complete):
 self.current\_sound = current\_sound
 self.complete = complete

```


To start, we'll write a function, `play_intro_menu`, that starts the menu on a channel. It will simply initialize the state of the menu, and get the ball rolling on the channel by calling `queue_up_sound`.




---

  
  


```

truepy24def play\_intro\_menu(channel):
 """Play our intro menu to the specified channel
 Since we want to interrupt the playback of the menu when the user presses
 a DTMF key, we maintain the state of the menu via the MenuState object.
 A menu completes in one of two ways:
 (1) The user hits a key
 (2) The menu finishes to completion
 In the case of (2), a timer is started for the channel. If the timer pops,
 a prompt is played back and the menu restarted.
 Keyword Arguments:
 channel The channel in the IVR
 """
 menu\_state = MenuState(0, False)

 def queue\_up\_sound(channel, menu\_state):
 ...

 queue\_up\_sound(channel, menu\_state)

```


`queue_up_sound` will be responsible for starting the next sound file on the channel and handling the manipulation of that sound file. Since there's a fair amount of checking that goes into this, we'll put the actual act of starting the sound in `play_next_sound`, which will return the `Playback` object from ARI. We'll prep the `menu_state` object for the next sound file playback, and pass it to the `PlaybackFinished` handler for the current sound being played back to the channel.




---

  
  


```

truepy70 def queue\_up\_sound(channel, menu\_state):
 """Start up the next sound and handle whatever happens

 Keywords Arguments:
 channel The channel in the IVR
 menu\_state The current state of the menu
 """

 current\_playback = play\_next\_sound(menu\_state)

 if not current\_playback:
 return
 menu\_state.current\_sound += 1
 current\_playback.on\_event('PlaybackFinished', on\_playback\_finished,
 callback\_args=[menu\_state])


```


`play_next_sound` will do two things:

1. If we shouldn't play another sound - either because we've run out of sounds to play or because the menu is now "complete", we bail and return None.
2. If we should play back a sound, start it up on the channel and return the `Playback` object.




---

  
  


```

truepy42 def play\_next\_sound(menu\_state):
 """Play the next sound, if we should

 Keyword Arguments:
 menu\_state The current state of the IVR

 Returns:
 None if no playback should occur
 A playback object if a playback was started
 """
 if (menu\_state.current\_sound == len(sounds) or menu\_state.complete):
 return None
 try:
 current\_playback = channel.play(media='sound:%s' % sounds[menu\_state.current\_sound])
 except:
 current\_playback = None
 return current\_playback

```


Our playback finished handler is very simple: since we've already incremented the state of the menu, we just call `queue_up_sound` again:




---

  
  


```

truepy60 def on\_playback\_finished(playback, ev, menu\_state):
 """Callback handler for when a playback is finished
 Keyword Arguments:
 playback The playback object that finished
 ev The PlaybackFinished event
 menu\_state The current state of the menu
 """
 queue\_up\_sound(channel, menu\_state)

```


To recap, our `play_intro_menu` function has three nested functions:

1. `queue_up_sound` - starts a sound on a channel, increments the state of the menu, and subscribes for the `PlaybackFinished` event.
2. `play_next_sound` - if possible, actually starts the sound. Called from `queue_up_sound`.
3. `on_playback_finished` - called when `PlaybackFinished` is received for the current playback, and call `queue_up_sound` to start the next sound in the menu.

This will play back the menu sounds, but it doesn't handle cancelling the menu, time-outs, or other conditions. To do that, we're going to need more information from Asterisk.

#### Cancelling the menu

When the user presses a DTMF key, we want to stop the current playback and end the menu. To do that, we'll need to subscribe for DTMF events from the channel. We'll define a new handler function, `cancel_menu`, and tell `ari-py` to call it when a DTMF key is received via the `ChannelDtmfReceived` event. We don't really care about the digit here - we just want to cancel the menu. In the handler function, we'll set `menu_state.complete` to `True`, then tell the `current_playback` to stop.

We should also stop the menu when the channel is hung up. Since the `cancel_menu` , so we'll subscribe to the `StasisEnd` event here and call `cancel_menu` from it as well:




---

  
  


```

truepy70 def queue\_up\_sound(channel, menu\_state):
 """Start up the next sound and handle whatever happens

 Keywords Arguments:
 channel The channel in the IVR
 menu\_state The current state of the menu
 """

 current\_playback = play\_next\_sound(menu\_state)

 def cancel\_menu(channel, ev, current\_playback, menu\_state):
 """Cancel the menu, as the user did something"""
 menu\_state.complete = True
 try:
 current\_playback.stop()
 except:
 pass
 return

 if not current\_playback:
 return
 menu\_state.current\_sound += 1
 current\_playback.on\_event('PlaybackFinished', on\_playback\_finished,
 callback\_args=[menu\_state])

 # If the user hits a key or hangs up, cancel the menu operations
 channel.on\_event('ChannelDtmfReceived', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])
 channel.on\_event('StasisEnd', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])

```


#### Timing out

Now we can cancel the menu, but we also need to restart it if the user doesn't do anything. We can use a Python timer to start a timer if we're finished playing sounds *and* we got to the end of the sound prompt list. We don't want to start the timer if the user pressed a DTMF key - in that case, we would have stopped the menu early and we should be off handling their DTMF key press. The timer will call `menu_timeout`, which will play back a "are you still there?" prompt, then restart the menu.




---

  
  


```

truepy70 def queue\_up\_sound(channel, menu\_state):
 """Start up the next sound and handle whatever happens
 Keywords Arguments:
 channel The channel in the IVR
 menu\_state The current state of the menu
 """

 def menu\_timeout(channel):
 """Callback called by a timer when the menu times out"""
 print 'Channel %s stopped paying attention...' % channel.json.get('name')
  channel.play(media='sound:are-you-still-there')
 play\_intro\_menu(channel)

 def cancel\_menu(channel, ev, current\_playback, menu\_state):
 """Cancel the menu, as the user did something"""
 menu\_state.complete = True
 try:
 current\_playback.stop()
 except:
 pass
 return

 current\_playback = play\_next\_sound(menu\_state)
 if not current\_playback:
 if menu\_state.current\_sound == len(sounds):
 # Menu played, start a timer!
 timer = threading.Timer(10, menu\_timeout, [channel])
 channel\_timers[channel.id] = timer
 timer.start()
 return

 menu\_state.current\_sound += 1
 current\_playback.on\_event('PlaybackFinished', on\_playback\_finished,
 callback\_args=[menu\_state])

 # If the user hits a key or hangs up, cancel the menu operations
 channel.on\_event('ChannelDtmfReceived', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])
 channel.on\_event('StasisEnd', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])

```


Now that we've introduced timers, we know we're going to need to stop them if the user does something. We'll store the timers in a dictionary indexed by channel ID, so we can get them from various parts of the script:




---

  
  


```

truepy14channel\_timers = {}

```


### Handling the DTMF options

While we now have code that plays back the menu to the user, we actually have to implement the attendant menu still. This is slightly easier than playing the menu. We can register for the `ChannelDtmfReceived` event in the `StasisStart` event handler. In that callback, we need to do the following:

1. Cancel any timers associated with the channel. Note that we don't need to stop the playback of the menu, as the menu function `queue_up_sound` already registers a handler for that event and cancels the menu when it gets any digit.
2. Actually handle the digit, if the digit is a `1` or a `2`.
3. If the digit isn't supported, play a prompt informing the user that their option was invalid, and re-play the menu.

The following implements these three items, deferring processing of the valid options to separate functions.




---

  
  


```

truepy150def on\_dtmf\_received(channel, ev):
 """Our main DTMF handler for a channel in the IVR

 Keyword Arguments:
 channel The channel in the IVR
 digit The DTMF digit that was pressed
 """

 # Since they pressed something, cancel the timeout timer
 cancel\_timeout(channel)
 digit = int(ev.get('digit'))

 print 'Channel %s entered %d' % (channel.json.get('name'), digit)
 if digit == 1:
 handle\_extension\_one(channel)
 elif digit == 2:
 handle\_extension\_two(channel)
 else:
 print 'Channel %s entered an invalid option!' % channel.json.get('name')
  channel.play(media='sound:option-is-invalid')
 play\_intro\_menu(channel)


def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s has entered the application" % channel.json.get('name')

 channel.on\_event('ChannelDtmfReceived', on\_dtmf\_received)
 play\_intro\_menu(channel)

```


Cancelling the timer is done in a fashion similar to other examples. If the channel has a Python timer associated with it, we cancel the timer and remove it from the dictionary.




---

  
  


```

truepy138def cancel\_timeout(channel):
 """Cancel the timeout timer for the channel

 Keyword Arguments:
 channel The channel in the IVR
 """
 timer = channel\_timers.get(channel.id)
 if timer:
 timer.cancel()
 del channel\_timers[channel.id]

```


Finally, we need to actually do *something* when the user presses a `1` or a `2`. We could do anything here - but in our case, we're merely going to play back the number that they pressed and restart the menu.




---

  
  


```

truepy114def handle\_extension\_one(channel):
 """Handler for a channel pressing '1'

 Keyword Arguments:
 channel The channel in the IVR
 """
 channel.play(media='sound:you-entered')
 channel.play(media='digits:1')
 play\_intro\_menu(channel)


def handle\_extension\_two(channel):
 """Handler for a channel pressing '2'

 Keyword Arguments:
 channel The channel in the IVR
 """
 channel.play(media='sound:you-entered')
 channel.play(media='digits:2')
 play\_intro\_menu(channel)

```


### channel-aa.py

The full source for `channel-aa.py` is shown below:




---

  
channel-aa.py  


```

truepy#!/usr/bin/env python

import ari
import logging
import threading

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

# Note: this uses the 'extra' sounds package
sounds = ['press-1', 'or', 'press-2']

channel\_timers = {}

class MenuState(object):
 """A small tracking object for the channel in the menu"""

 def \_\_init\_\_(self, current\_sound, complete):
 self.current\_sound = current\_sound
 self.complete = complete


def play\_intro\_menu(channel):
 """Play our intro menu to the specified channel

 Since we want to interrupt the playback of the menu when the user presses
 a DTMF key, we maintain the state of the menu via the MenuState object.
 A menu completes in one of two ways:
 (1) The user hits a key
 (2) The menu finishes to completion

 In the case of (2), a timer is started for the channel. If the timer pops,
 a prompt is played back and the menu restarted.

 Keyword Arguments:
 channel The channel in the IVR
 """

 menu\_state = MenuState(0, False)

 def play\_next\_sound(menu\_state):
 """Play the next sound, if we should

 Keyword Arguments:
 menu\_state The current state of the IVR

 Returns:
 None if no playback should occur
 A playback object if a playback was started
 """
 if (menu\_state.current\_sound == len(sounds) or menu\_state.complete):
 return None
 try:
 current\_playback = channel.play(media='sound:%s' % sounds[menu\_state.current\_sound])
 except:
 current\_playback = None
 return current\_playback

 def on\_playback\_finished(playback, ev, menu\_state):
 """Callback handler for when a playback is finished

 Keyword Arguments:
 playback The playback object that finished
 ev The PlaybackFinished event
 menu\_state The current state of the menu
 """
 queue\_up\_sound(channel, menu\_state)

 def queue\_up\_sound(channel, menu\_state):
 """Start up the next sound and handle whatever happens

 Keywords Arguments:
 channel The channel in the IVR
 menu\_state The current state of the menu
 """

 def menu\_timeout(channel):
 """Callback called by a timer when the menu times out"""
 print 'Channel %s stopped paying attention...' % channel.json.get('name')
  channel.play(media='sound:are-you-still-there')
 play\_intro\_menu(channel)

 def cancel\_menu(channel, ev, current\_playback, menu\_state):
 """Cancel the menu, as the user did something"""
 menu\_state.complete = True
 try:
 current\_playback.stop()
 except:
 pass
 return

 current\_playback = play\_next\_sound(menu\_state)
 if not current\_playback:
 if menu\_state.current\_sound == len(sounds):
 # Menu played, start a timer!
 timer = threading.Timer(10, menu\_timeout, [channel])
 channel\_timers[channel.id] = timer
 timer.start()
 return

 menu\_state.current\_sound += 1
 current\_playback.on\_event('PlaybackFinished', on\_playback\_finished,
 callback\_args=[menu\_state])

 # If the user hits a key or hangs up, cancel the menu operations
 channel.on\_event('ChannelDtmfReceived', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])
 channel.on\_event('StasisEnd', cancel\_menu,
 callback\_args=[current\_playback, menu\_state])

 queue\_up\_sound(channel, menu\_state)


def handle\_extension\_one(channel):
 """Handler for a channel pressing '1'

 Keyword Arguments:
 channel The channel in the IVR
 """
 channel.play(media='sound:you-entered')
 channel.play(media='digits:1')
 play\_intro\_menu(channel)


def handle\_extension\_two(channel):
 """Handler for a channel pressing '2'

 Keyword Arguments:
 channel The channel in the IVR
 """
 channel.play(media='sound:you-entered')
 channel.play(media='digits:2')
 play\_intro\_menu(channel)


def cancel\_timeout(channel):
 """Cancel the timeout timer for the channel

 Keyword Arguments:
 channel The channel in the IVR
 """
 timer = channel\_timers.get(channel.id)
 if timer:
 timer.cancel()
 del channel\_timers[channel.id]

 
def on\_dtmf\_received(channel, ev):
 """Our main DTMF handler for a channel in the IVR

 Keyword Arguments:
 channel The channel in the IVR
 digit The DTMF digit that was pressed
 """

 # Since they pressed something, cancel the timeout timer
 cancel\_timeout(channel)
 digit = int(ev.get('digit'))

 print 'Channel %s entered %d' % (channel.json.get('name'), digit)
 if digit == 1:
 handle\_extension\_one(channel)
 elif digit == 2:
 handle\_extension\_two(channel)
 else:
 print 'Channel %s entered an invalid option!' % channel.json.get('name')
  channel.play(media='sound:option-is-invalid')
 play\_intro\_menu(channel)


def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s has entered the application" % channel.json.get('name')

 channel.on\_event('ChannelDtmfReceived', on\_dtmf\_received)
 play\_intro\_menu(channel)


def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "%s has left the application" % channel.json.get('name')
 cancel\_timeout(channel)


client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb)

client.run(apps='channel-aa')



```


### channel-aa.py in action

The following shows the output of `channel-aa.py` when a PJSIP channel presses `1`, `2`, `8`, then times out. Finally they hang up.




---

  
  


```

Channel PJSIP/alice-00000001 has entered the application
Channel PJSIP/alice-00000001 entered 1
Channel PJSIP/alice-00000001 entered 2
Channel PJSIP/alice-00000001 entered 8
Channel PJSIP/alice-00000001 entered an invalid option!
Channel PJSIP/alice-00000001 stopped paying attention...
PJSIP/alice-00000001 has left the application

```


 

JavaScript (Node.js)
--------------------

As this example is a bit larger, how the code is written and structured is broken up into two phases:

1. Constructing the menu and handling its state as the user presses buttons.
2. Actually handling the button presses from the user.

The full source code for this example immediately follows the walk through.

### Playing the menu

Unlike Playback, which can chain multiple sounds together and play them back in one continuous operation, ARI treats all sound files being played as separate operations. It will queue each sound file up to be played on the channel, and hand back the caller an object to control the operation of that single sound file. The menu announcement for the attendant has the following requirements:

1. Playback the options for the user
2. If the user presses a DTMF key, cancel the playback of the options and handle the request
3. If the user presses an invalid DTMF key, let them know and restart the menu
4. If the user doesn't press anything, wait 10 seconds, ask them if they are still present, and restart the menu

The second requirement makes this a bit more challenging: when the user presses a DTMF key, we want to cancel whatever sound file is currently being played back and immediately handle their request. We thus have to maintain some state in our application about what sound file is currently being played so that we can cancel the correct playback. We also don't want to queue up all of the sounds immediately - we'd have to walk through all of the queued up sounds and cancel each one - that'd be annoying! Instead, we only want to start the next sound in our prompt when the previous has completed.

To start, we'll define an object to represent the menu at the top of our script that defines sounds that make up the initial menu prompt as well as valid DTMF options for the menu:




---

  
  


```

truejs9var menu = {
 // valid menu options
 options: [1, 2],
 // note: this uses the 'extra' sounds package
 sounds: ['sound:press-1', 'sound:or', 'sound:press-2']
};

```


To start with, well register a callback to handle a StasisStart and StasisEnd event on any channel that enters into our application:




---

  
  


```

truejs28function stasisStart(event, channel) {
 console.log('Channel %s has entered the application', channel.name);

 channel.on('ChannelDtmfReceived', dtmfReceived);

 channel.answer(function(err) {
 if (err) {
 throw err;
 }
 playIntroMenu(channel);
 });
}

// Handler for StasisEnd event
function stasisEnd(event, channel) {
 console.log('Channel %s has left the application', channel.name);

 // clean up listeners
 channel.removeListener('ChannelDtmfReceived', dtmfReceived);
 cancelTimeout(channel);
}

```


Note that we register a callback to handle ChannelDtmfReceived events on a channel entering our application in StasisStart and then unregister that callback on StasisEnd. For long running, non-trivial applications, this allows the JavaScript garbage collector to clean up our callback. This is important since every channel entering into our application will register its own copy of the callback which is not be garbage collected until it is unregistered.

We'll cover the DTMF callback handler shortly, but first we'll cover writting functions to handle playing the menu prompt

First we'll write a function to initialize a new instance of our menu; playIntroMenu.

Since we'll want to maintain some state, we'll create a small object to do that for us. This object will keep track of the following:

1. The current sound being played
2. The current Playback object being played
3. Whether or not this menu instance is done

It's useful to have this data, as we may cancel the menu half-way through and want to take one set of actions, or we may play all the sounds that make up the menu prompt and start a different set of actions.




---

  
  


```

truejs88var state = {
 currentSound: menu.sounds[0],
 currentPlayback: undefined,
 done: false
};

```


`playIntroMenu will` start the menu on a channel. It will simply initialize the state of the menu, and get the ball rolling on the channel by calling `queueUpSound` which is a nested function within playIntroMenu.




---

  
  


```

truejs87function playIntroMenu(channel) {
 var state = {
 currentSound: menu.sounds[0],
 currentPlayback: undefined,
 done: false
 };

  channel.on('ChannelDtmfReceived', cancelMenu);
 channel.on('StasisEnd', cancelMenu);
 queueUpSound();
 ...

```


We'll cover cancelMenu shortly, but first let's discuss queueUpSound. `queueUpSound` will be responsible for starting the next sound file on the channel and handling the manipulation of that sound file. queueUpSound is also responsible for starting a timeout once all sounds for the menu prompt have completed to handle reminding the user that they must choose a menu option. We'll cover that part shortly but first, we'll cover handling progerssing through the sounds that make up the menu prompt. We first initiate playback on the current sound in the sequence. We then register a callback to handle that playback finishing, which will trigger queueUpSound to be called again, moving on to the next sound in the sequence. Finally, we update the state object to reflect the next sound to be played in the menu prompt sequence.




---

  
  


```

truejs113function queueUpSound() {
 if (!state.done) {
 // have we played all sounds in the menu?
 if (!state.currentSound) {
 var timer = setTimeout(stillThere, 10 \* 1000);
 timers[channel.id] = timer;
 } else {
 var playback = client.Playback();
 state.currentPlayback = playback;

  channel.play({media: state.currentSound}, playback, function(err) {
 // ignore errors
 });
 playback.once('PlaybackFinished', function(event, playback) {
 queueUpSound();
 });

  var nextSoundIndex = menu.sounds.indexOf(state.currentSound) + 1;
 state.currentSound = menu.sounds[nextSoundIndex];
 }
 }
}


```


Notice that when registering our PlaybackFinished callback handler, we use the once method on the resource instance instead of on. This ensures that the callback will be invoked once and then automatically be unregistered. Since a PlaybackFinished event will only be invoked once for a given Playback instance, it makes sense to use this method which will also enable the callback to be garbage collected once it has been invoked.

queueUpSound will play back the menu sounds, but it doesn't handle cancelling the menu, time-outs, or other conditions. To do that, we're going to need more information from Asterisk.

#### Cancelling the menu

When the user presses a DTMF key, we want to stop the current playback and end the menu. To do that, we'll need to subscribe for DTMF events from the channel. We'll define a new handler function, `cancelMenu`, and tell `ari-client` to call it when a DTMF key is received via the `ChannelDtmfReceived` event. We don't really care about the digit here - we just want to cancel the menu. In the handler function, we'll set `state.done` to t`rue`, then tell the `currentPlayback` to stop.

We should also stop the menu when the channel is hung up. To do this we'll subscribe to the `StasisEnd` event as well and register cancelMenu as its callback handler:




---

  
  


```

truejs99function cancelMenu() {
 state.done = true;
 if (state.currentPlayback) {
 state.currentPlayback.stop(function(err) {
 // ignore errors
 });
 }

  // remove listeners as future calls to playIntroMenu will create new ones
 channel.removeListener('ChannelDtmfReceived', cancelMenu);
 channel.removeListener('StasisEnd', cancelMenu);
}

```


Note that once the cancelMenu callback is invoked, we unregister both the ChannelDtmfReceived and StasisEnd events. This is performed so that once this particular menu instance stops, we do not leave registered callbacks behind that will never be garbage collected.

#### Timing out

Now we can cancel the menu, but we also need to restart it if the user doesn't do anything. We can use a JavaScript timeout to start a timer if we're finished playing sounds *and* we got to the end of the sound prompt sequence. We don't want to start the timer if the user pressed a DTMF key - in that case, we would have stopped the menu early and we should be off handling their DTMF key press. The timer will call `stillThere`, which will play back a "are you still there?" prompt, then restart the menu.




---

  
  


```

truejs137function stillThere() {
 console.log('Channel %s stopped paying attention...', channel.name);

 channel.play({media: 'sound:are-you-still-there'}, function(err) {
 if (err) {
 throw err;
 }

 playIntroMenu(channel);
 });
}

```


Now that we've introduced timers, we know we're going to need to stop them if the user does something. We'll store the timers in an object indexed by channel ID, so we can get them from various parts of the script:




---

  
  


```

truejs16var timers = {};

```


### Handling the DTMF options

While we now have code that plays back the menu to the user, we actually have to implement the attendant menu still. Earlier in our example we registered a callback handler for a ChannelDtmfReceived event on a channel that enters into our application. In that callback, we need to do the following:

1. Cancel any timers associated with the channel. Note that we don't need to stop the playback of the menu, as the menu function `queueUpSound` already registers a handler for that event and cancels the menu when it gets any digit.
2. Actually handle the digit, if the digit is a `1` or a `2`.
3. If the digit isn't supported, play a prompt informing the user that their option was invalid, and re-play the menu.

The following implements these three items, deferring processing of the valid options to a separate function.




---

  
  


```

truejs52function dtmfReceived(event, channel) {
 cancelTimeout(channel);
 var digit = parseInt(event.digit);

 console.log('Channel %s entered %d', channel.name, digit);

 // will be non-zero if valid
 var valid = ~menu.options.indexOf(digit);
 if (valid) {
 handleDtmf(channel, digit);
 } else {
 console.log('Channel %s entered an invalid option!', channel.name);

 channel.play({media: 'sound:option-is-invalid'}, function(err, playback) {
 if (err) {
 throw err;
 }

 playIntroMenu(channel);
 });
 }
}

```


Cancelling the timer is done in a fashion similar to other examples. If the channel has a JavaScript timeout associated with it, we cancel the timer and remove it from the object.




---

  
  


```

truejs151function cancelTimeout(channel) {
 var timer = timers[channel.id];

  if (timer) {
 clearTimeout(timer);
 delete timers[channel.id];
 }
}

```


Finally, we need to actually do *something* when the user presses a `1` or a `2`. We could do anything here - but in our case, we're merely going to play back the number that they pressed and restart the menu.




---

  
  


```

truejs161function handleDtmf(channel, digit) {
 var parts = ['sound:you-entered', util.format('digits:%s', digit)];
 var done = 0;

 var playback = client.Playback();
 channel.play({media: 'sound:you-entered'}, playback, function(err) {
 // ignore errors
 channel.play({media: util.format('digits:%s', digit)}, function(err) {
 // ignore errors
 playIntroMenu(channel);
 });
 });
} 

```


### channel-aa.js

The full source for `channel-aa.js` is shown below:




```javascript title="channel-aa.js" linenums="1"
truejs/\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

var menu = {
 // valid menu options
 options: [1, 2],
 // note: this uses the 'extra' sounds package
 sounds: ['sound:press-1', 'sound:or', 'sound:press-2']
};

var timers = {};

// Handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 // Handler for StasisStart event
 function stasisStart(event, channel) {
 console.log('Channel %s has entered the application', channel.name);

 channel.on('ChannelDtmfReceived', dtmfReceived);

 channel.answer(function(err) {
 if (err) {
 throw err;
 }

 playIntroMenu(channel);
 });
 }

 // Handler for StasisEnd event
 function stasisEnd(event, channel) {
 console.log('Channel %s has left the application', channel.name);

 // clean up listeners
 channel.removeListener('ChannelDtmfReceived', dtmfReceived);
 cancelTimeout(channel);
 }

 // Main DTMF handler
 function dtmfReceived(event, channel) {
 cancelTimeout(channel);
 var digit = parseInt(event.digit);

 console.log('Channel %s entered %d', channel.name, digit);

 // will be non-zero if valid
 var valid = ~menu.options.indexOf(digit);
 if (valid) {
 handleDtmf(channel, digit);
 } else {
 console.log('Channel %s entered an invalid option!', channel.name);

 channel.play({media: 'sound:option-is-invalid'}, function(err, playback) {
 if (err) {
 throw err;
 }

 playIntroMenu(channel);
 });
 }
 }

 /\*\*
 \* Play our intro menu to the specified channel
 \* 
 \* Since we want to interrupt the playback of the menu when the user presses
 \* a DTMF key, we maintain the state of the menu via the MenuState object.
 \* A menu completes in one of two ways:
 \* (1) The user hits a key
 \* (2) The menu finishes to completion
 \*
 \* In the case of (2), a timer is started for the channel. If the timer pops,
 \* a prompt is played back and the menu restarted.
 \*\*/
 function playIntroMenu(channel) {
 var state = {
 currentSound: menu.sounds[0],
 currentPlayback: undefined,
 done: false
 };

 channel.on('ChannelDtmfReceived', cancelMenu);
 channel.on('StasisEnd', cancelMenu);
 queueUpSound();

 // Cancel the menu, as the user did something
 function cancelMenu() {
 state.done = true;
 if (state.currentPlayback) {
 state.currentPlayback.stop(function(err) {
 // ignore errors
 });
 }

 // remove listeners as future calls to playIntroMenu will create new ones
 channel.removeListener('ChannelDtmfReceived', cancelMenu);
 channel.removeListener('StasisEnd', cancelMenu);
 }

 // Start up the next sound and handle whatever happens
 function queueUpSound() {
 if (!state.done) {
 // have we played all sounds in the menu?
 if (!state.currentSound) {
 var timer = setTimeout(stillThere, 10 \* 1000);
 timers[channel.id] = timer;
 } else {
 var playback = client.Playback();
 state.currentPlayback = playback;

 channel.play({media: state.currentSound}, playback, function(err) {
 // ignore errors
 });
 playback.once('PlaybackFinished', function(event, playback) {
 queueUpSound();
 });

 var nextSoundIndex = menu.sounds.indexOf(state.currentSound) + 1;
 state.currentSound = menu.sounds[nextSoundIndex];
 }
 }
 }

 // plays are-you-still-there and restarts the menu
 function stillThere() {
 console.log('Channel %s stopped paying attention...', channel.name);

 channel.play({media: 'sound:are-you-still-there'}, function(err) {
 if (err) {
 throw err;
 }

 playIntroMenu(channel);
 });
 }
 }

 // Cancel the timeout for the channel
 function cancelTimeout(channel) {
 var timer = timers[channel.id];

 if (timer) {
 clearTimeout(timer);
 delete timers[channel.id];
 }
 }

 // Handler for channel pressing valid option
 function handleDtmf(channel, digit) {
 var parts = ['sound:you-entered', util.format('digits:%s', digit)];
 var done = 0;

 var playback = client.Playback();
 channel.play({media: 'sound:you-entered'}, playback, function(err) {
 // ignore errors
 channel.play({media: util.format('digits:%s', digit)}, function(err) {
 // ignore errors
 playIntroMenu(channel);
 });
 });
 }

 client.start('channel-aa');
}

```


### channel-aa.js in action

The following shows the output of `channel-aa.js` when a PJSIP channel presses `1`, `2`, `8`, then times out. Finally they hang up.




---

  
  


```

Channel PJSIP/alice-00000001 has entered the application
Channel PJSIP/alice-00000001 entered 1
Channel PJSIP/alice-00000001 entered 2
Channel PJSIP/alice-00000001 entered 8
Channel PJSIP/alice-00000001 entered an invalid option!
Channel PJSIP/alice-00000001 stopped paying attention...
PJSIP/alice-00000001 has left the application

```


 

 

