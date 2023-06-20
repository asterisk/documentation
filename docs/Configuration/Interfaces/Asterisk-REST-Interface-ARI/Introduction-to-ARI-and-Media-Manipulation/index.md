---
title: Overview
pageid: 29396202
---

Media Control
=============

ARI contains tools for manipulating media, such as playing sound files, playing tones, playing numbers and digits, recording media, deleting stored recordings, manipulating playbacks (e.g. rewind and fast-forward), and intercepting DTMF tones. Some channel-specific information and examples for [playing media](/ARI-and-Channels:-Simple-Media-Manipulation) and [intercepting DTMF](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Channels/ARI-and-Channels-Handling-DTMF) have been covered on previous pages. While some information will be repeated here, the intention of this section is to delve deeper into media manipulation.

To frame the discussion, we will be creating a set of applications that mimic a minimal voice mail system.

About the Code Samples
======================

The following ARI client libraries are used in the code samples on these pages

* Python code samples use [ari-py](https://github.com/asterisk/ari-py)
* Node.js samples use [node-ari-client](https://github.com/asterisk/node-ari-client)
40%On This Page


Media In DepthAll of the code presented here has been tested with Asterisk 13 and works as intended. That being said, the code samples given are intended more to demonstrate the capabilities of ARI than to be a best practices guide for writing an application or to illustrate watertight code. Error-handling is virtually non-existent in the code samples. For a real application, Python calls to ARI should likely be in `try-catch` blocks in case there is an error, and Node.js calls to ARI should provide callbacks that detect if there was an error.

The asynchronous nature of Node.js and the node-ari-client library is not always used in the safest ways in the code samples provided. For instance, there are code samples where DTMF presses cause media operations to take place, and the code does not await confirmation that the media operation has actually completed before accepting more DTMF presses. This could potentially result in the desired media operations happening out of order if many DTMF presses occur in rapid succession.

State Machine
=============

Voice mail, at its heart, is an IVR. IVRs are most easily represented using a finite state machine. The way a state machine works is that a program switches between pre-defined states based on events that occur. Certain events will cause program code within the state to take certain actions, and other events will result in a change to a different program state. Each state can almost be seen as a self-contained program.

To start our state machine, we will define what events might cause state transitions. If you think about a typical IVR, the events that can occur are DTMF key presses, and changes in the state of a call, such as hanging up. As such, we'll define a base set of events.




---

  
event.py  


```

pytrueclass Event(object):
 # DTMF digits
 DTMF\_1 = "1"
 DTMF\_2 = "2"
 DTMF\_3 = "3"
 DTMF\_4 = "4"
 DTMF\_5 = "5"
 DTMF\_6 = "6"
 DTMF\_7 = "7"
 DTMF\_8 = "8"
 DTMF\_9 = "9"
 DTMF\_0 = "0"
 # Use "octothorpe" so there is no confusion about "pound" or "hash"
 # terminology.
 DTMF\_OCTOTHORPE = "#"
 DTMF\_STAR = "\*"
 # Call has hung up
 HANGUP = "hangup"
 # Playback of a file has completed
 PLAYBACK\_COMPLETE = "playback\_complete"
 # Mailbox has been emptied
 MAILBOX\_EMPTY = "empty"

```



---




---

  
event.js  


```

jstruevar Event = {
 // DTMF digits
 DTMF\_1: "1",
 DTMF\_2: "2",
 DTMF\_3: "3",
 DTMF\_4: "4",
 DTMF\_5: "5",
 DTMF\_6: "6",
 DTMF\_7: "7",
 DTMF\_8: "8",
 DTMF\_9: "9",
 DTMF\_0: "0",
 // Use "octothorpe" so there is no confusion about "pound" or "hash"
 // terminology.
 DTMF\_OCTOTHORPE: "#",
 DTMF\_STAR: "\*",
 // Call has hung up
 HANGUP: "hangup",
 // Playback of a file has completed
 PLAYBACK\_COMPLETE: "playback\_complete",
 // Mailbox has been emptied
 MAILBOX\_EMPTY: "empty"
}
module.exports = Event;

```



---


There is no hard requirement for our application that we define events as named constants, but doing so makes it easier for tools like pylint and jslint to find potential mistakes.

After we have defined our events, we need to create a state machine itself. The state machine keeps track of what the current state is, and which events cause state changes. Here is a simple implementation of a state machine




---

  
state\_machine.py  


```

pytrueclass StateMachine(object):
 def \_\_init\_\_(self):
 self.transitions = {}
 self.current\_state = None

 def add\_transition(self, src\_state, event, dst\_state):
 if not self.transitions.get(src\_state.state\_name):
 self.transitions[src\_state.state\_name] = {}

 self.transitions[src\_state.state\_name][event] = dst\_state

 def change\_state(self, event):
 self.current\_state = self.transitions[self.current\_state.state\_name][event]
 self.current\_state.enter()

 def start(self, initial\_state):
 self.current\_state = initial\_state
 self.current\_state.enter()

```



---




---

  
state\_machine.js  


```

jstruefunction StateMachine() {
 var transitions = {};
 var current\_state = null;

 this.add\_transition = function(src\_state, event, dst\_state) {
 if (!transitions.hasOwnProperty(src\_state.state\_name)) {
 transitions[src\_state.state\_name] = {};
 }
 transitions[src\_state.state\_name][event] = dst\_state;
 }

 this.change\_state = function(event) {
 current\_state = transitions[current\_state.state\_name][event];
 current\_state.enter();
 }

 this.start = function(initial\_state) {
 current\_state = initial\_state;
 current\_state.enter();
 }
}

module.exports = StateMachine;

```



---


The state machine code is pretty straightforward. The state machine has transitions added to it with the `add_transition()` method and can be started with the `start()` method. Our use of the state machine will always be to define all transitions, and then to start the state machine.

States within a state machine have certain duties that they must fulfill if they want to work well in the state machine we have devised

* A state must know what events should cause it to change states, though it does not need to know what state it will be transitioning to.
* A state must set up ARI event listeners each time the state is entered, and it must remove these before changing states.
* The state must define the following attributes:
	+ `state_name`, a string that represents the name of the state.
	+ `enter()`, a method that is called whenever the state is entered.

It should be noted that this state machine implementation is not necessarily ideal, since it requires the states to know what events cause it to change states. However, it will become clear later that for a simple voice mail system, this is not that big a deal. To see how we use this state machine, continue on to the sub-pages.

