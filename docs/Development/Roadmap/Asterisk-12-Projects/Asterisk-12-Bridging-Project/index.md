---
title: Overview
pageid: 22088024
---




!!! note 
    This page is a living document; expect missing and incomplete information. Still, feel free to discuss on [asterisk-dev](http://lists.digium.com/mailman/listinfo/asterisk-dev).

      
[//]: # (end-note)



Project Overview
================


At [AstriDevCon 2012](/Development/Roadmap/AstriDevCon-2012), one of the focus points of development was determined to be the [Asterisk APIs](../Asterisk-12-API-Improvements). In particular, some common complaints were:


* Asterisk changes the name of a channel during masquerades. As the name is used as the handle to the channel, this requires a lot of state replication by consumers of the APIs.
* Asterisk's APIs tend to expose internal implementation details (such as masquerades), when consumers of the APIs would rather not be aware of these details.


Both of these topics often come back to the same problem: masquerades. But why are masquerades such a problem?


What is a Masquerade
--------------------


A channel masquerade is a fundamental yet incredibly confusing concept in Asterisk. It exists as a way for a thread to 'take' control of a channel that happens to be on another thread. This is a critically important operation when you need to, say, move a channel from the VoiceMail application and have it start executing logic at a different place in the dialplan.




---

  
A comment from ast_do_masquerade  

```

/* XXX This operation is a bit odd. We're essentially putting the guts of
 * the clone channel into the original channel. Start by killing off the
 * original channel's backend. While the features are nice, which is the
 * reason we're keeping it, it's still awesomely weird. XX */

```

The way the operation works is to take two channels and 'swap' portions of them. In the diagram below, assume that Thread A has a channel that Thread B wants to take over. Thread B creates a new channel ("Original") and starts a Masquerade operation on the channel owned by Thread A ("Clone"). Both channels are locked, and the state of the Clone channel is moved into the Original channel, while the Clone channel obtains the Original channel's state. In order to denote that the channel is about to die, a special ZOMBIE flag is put on the channel and the name renamed to Clone<ZOMBIE>. The lock is released, and the Original channel - which now has the state associated with Clone channel - executes in Thread B, while the Clone channel (which is now quite dead) see's that its dead and goes off to silently contemplate its demise in an `h` extension.


Asterisk_12_MasqueradesL
Except, of course, that this is a dramatic simplification. It's never quite that easy.


* What is a channel's state? For the purposes of the operation, we consider it to be the channel's datastores, technology, and other pertinent data - but there's plenty of data that shouldn't be transferred over. That includes things like locking primitives on the channel, file descriptors, and other resources that Thread A is probably using (and depending on). Other information - such as CDR related information - sometimes can be moved, and sometimes shouldn't.
* The locking picture is complicated. Thread B has no idea what Thread A is doing with the channel when it tries to get the channel lock for the Clone channel. If Thread B is holding a lock and tries to get Clone's channel lock, and Thread A is holding Clone's channel lock and needs a lock held by Thread B, a deadlock occurs.
* Lots of things care a lot when the name of a channel is swapped out from underneath the actual channel pointer. Channel technologies care a lot, and so there are masquerade callbacks that go into the channel technologies and notify them when a masquerade occurs. This creates another locking point, complicating the locking picture further (and causing more deadlocks).


So, Masquerades are bad. But why are they used everywhere?


Why Bridging Uses Masquerades and what We can do about it
---------------------------------------------------------




!!! tip Channel Farm
    "All channels are created equal, but some channels are created more equal than others."

      
[//]: # (end-tip)



Not all channels get an execution thread (`pbx_thread`) in Asterisk. In general, an inbound channel get's a thread; outbound channels do not. As a result, a two-party bridge that is created between the two channels uses the inbound channel's `pbx_thread` to service frames between the two channels. Regardless of the two-party bridge type in play, this is how it works in Asterisk.


This made sense when most bridges were two-party bridges. They probably still are, but it's very common now to have scenarios that require a lot more than a two-party bridge. Say, for example, we want to blind transfer the outbound channel to a new dialplan extension. The outbound channel has no `pbx_thread` - so how can we get him there?


Simple! We use a Masquerade. The Masquerade creates a new channel (with a `pbx_thread`) and swaps the guts of the outbound channel with the new channel. The new channel (with the guts of the outbound channel) starts to execute, and the old outbound channel dies.


You can see what happened next: everything started to use Masquerades to get around the fact that there were channels without threads. Transfers, Asynchronous Gotos, Parking, Local channel optimization... lots of things ended up needing to use Masquerades to work around the threading model.


Then, along came [ConfBridge](/Configuration/Applications/Conferencing-Applications/ConfBridge).




!!! note We All Do
    Ignore MeetMe.

      
[//]: # (end-note)



ConfBridge used a brand spiffy "new" (as in Asterisk 1.6 timeframe) Bridging API developed by Joshua Colp. A bridge becomes a first class object, and no longer a state that two channels happen to find themselves in. Channels owned by a bridge object are each given a thread. Even more interesting, the Bridging API provided an abstraction above how the media of the channels in the bridge was mixed. ConfBridge, for example, used the softmix bridging technology, suitable for multiple channels in a bridge. However, there are other bridging technologies - some optimized for managing two channels (or sets of two channels). Others - such as bridging technologies developed for special purpose applications - are possible. The Bridging API itself provides safe mechanisms to move channels between bridges, merge bridges, and generally do things without the need for masquerades.


As a side effect, the view from the outside world of what Asterisk is doing to channels in a bridge becomes sane.


The Future of Masquerades is Grim
---------------------------------


Unfortunately, there is still one reason to use a Masquerade: when you have to steal it out of an application. This occurs in situations where an attended transfer is performed and the party starting the attended transfer does not transfer the other party into a bridge but rather into an application. So they aren't going to go away completely.


But, a wholesale migration to the Bridging API let's us:


* Do away with Masquerades in lots of situations
* Optimize the hell out of two party bridging
* Switch between two and multi-party bridging seamlessly
* Present a sane model of the bridging world to the APIs




!!! tip A word of advice
    If you're familiar with the bridging code in `features.c`, you probably have a good idea of how big a task this work is. When you do away with the bridging loop, lots of things break, and they aren't all obvious. CDRs break. CEL breaks. Queue Logs probably break. AMI is wonky. DTMF handling has to be tweaked significantly. Lots change.


    This is scary, but it's time.

      
[//]: # (end-tip)



Requirements and Specification
==============================


Functionally, Bridging should remain as much the same as possible when compared with previous versions. When this is not possible, the difference should be documented.


The following will require specifications for Asterisk 12:


* CDRs
* CEL
* Queue Log
* AMI (see ﻿[AMI v2 Specification](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI/AMI-v2-Specification))


For Use Cases, see [Bridging Use Cases](Asterisk-12-Bridging-Use-Cases).


Design
======


High Level Design
-----------------


Note that the diagram below is not meant to contain all functions and attributes for the objects shown, nor does it show all objects. It is meant to convey the relationships between principle objects in the Bridging Framework.


Bridge API DesignL
#### ast_bridge_controller


The `ast_bridge_controller` manages one or more bridges. It provides the thread that services actions that are being taken within a bridge and operations between bridges.


#### ast_bridge


An `ast_bridge` object **is** the bridge. A bridge may have many channels in it, and the bridge object is responsible for keeping track of the state of the bridge and managing the channels. The `ast_bridge_technology` callbacks provide the way in which operations on the bridge and its channels are implemented for different ways of 'bridging'. For example, in a two-party bridge, the bridge technology may only have to pass frames between two channels and can simply swap the frames between two `ast_bridge_channel` objects. In a multi-party bridge, however, the bridge technology has to decide which `ast_bridge_channel` objects receive frames from what other `ast_bridge_channel` objects, how those frames are mixed, etc.


#### ast_bridge_channel


The `ast_bridge_channel` object manages the thread, state, and actions executing on a channel in a bridge. There is a one to one relationship between the `ast_bridge_channel` object and an `ast_channel` object in a bridge. An `ast_bridge` manages channels through the `ast_bridge_channel` object.


#### ast_bridge_technology


The `ast_bridge_technology` provides the callbacks that specific bridging implementations implement. It is up to the bridging implementations to determine how frames are passed between the `ast_bridge_channel` objects, what Asterisk control frames are processed and how, etc.


#### ast_bridge_features


The `ast_bridge_features` object provides hooks that can be passed to `ast_bridge_channel` objects when they join that bridge. The feature hooks implement specific interception callbacks that occur on DTMF key presses, after some period of time has passed, or given some other criteria. These callbacks can affect the channels in a bridge but may also affect the entire bridge.


Detailed information about the Bridging Framework APIs can be seen in [Asterisk 12 Bridging API](Asterisk-12-Bridging-API).


Richard's Ramblings on Bridging
-------------------------------


### The Existing API and Proposed Changes


#### enum ast_bridge_channel_state ast_bridge_join(struct ast_bridge \*bridge, struct ast_channel \*chan, struct ast_channel \*swap, struct ast_bridge_features \*features, struct, ast_bridge_tech_optimizations \*tech_args, int pass_reference);


* Put a channel into the specified bridge. The bridge takes custody of the channel.
	+ On success, the caller blocks until:
		- the channel hangs up
		- the channel is kicked out
		- the bridge dissolves
			* The caller must then run the PBX which runs the h exten, next dialplan location, or ast_async_goto() location.
* An error joining the bridge gives the channel back.
* The pass_reference flag passes the bridge reference of the caller back to the bridge so the bridge will complete destroying itself when the last channel leaves the bridge. The caller cannot use the bridge pointer when the function returns.


#### int ast_bridge_impart(struct ast_bridge \*bridge, struct ast_channel \*chan, struct ast_channel \*swap, struct ast_bridge_features \*features, int independent);


* Put a channel into the specified bridge. The bridge takes custody of the channel.
* The caller does not block.
* An error joining the bridge gives the channel back.
* On success, the caller does not get the channel back.
* When the channel leaves the bridge the channel will:
	+ wait for another thread to claim it with ast_bridge_depart() if not specified as independent
	+ run a PBX at the set location if exited by AST_SOFTHANGUP_ASYNCGOTO (any exit location datastore is removed)
	+ run a PBX if a location is specified by datastore
	+ run the h exten if specifed by datastore then hangup
	+ hangup


#### int ast_bridge_depart(struct ast_channel \*chan);


* This function must be removed from the API or severely restricted.


API changed that when a channel is imparted, it must be specified that the channel will be departed. These channels can not be moved/merged to another bridge. Channels that can be departed are special channels because the channel must be departed and can not be made to normally execute dialplan when they leave a bridge.


With the change that ast_channel has an ast_bridge_channel pointer instead of an ast_bridge pointer, ast_bridge_depart() does not need to be provided an ast_bridge pointer. Also these channels can move to other bridges and still be departed.


Departing from the bridge must not interfere with an AST_BRIDGE_CHANNEL_STATE_END in progress since it is likely to dissolve the bridge. (Sorta fixed with AST_BRIDGE_CHANNEL_STATE_DEPART_END. Really need to revamp the depart mess.)


#### int ast_bridge_remove(struct ast_bridge \*bridge, struct ast_channel \*chan);


* Request that the channel be removed from the specified bridge.
* If the channel is not in a bridge then return error.


Channels are removed when the bridge action kicks the channel out. It does not matter if the channel is currently suspended from the bridge.


#### int ast_bridge_move(struct ast_bridge \*bridge, struct ast_channel \*chan, struct ast_channel \*swap, struct ast_bridge_features \*features, struct ast_bridge_tech_optimizations \*tech_args);


* Move a channel from its current bridge to the specified bridge.
* The channel knows which bridge it is in because ast_channel_internal_bridge() returns it.
* If the channel is not in a bridge then return error.
* If the channel is not moveable then return error.
* If the channel is already in the bridge then return error.
* If the bridge cannot accept the channel then return error.


#### int ast_bridge_merge(struct ast_bridge \*bridge_dest, struct ast_bridge \*bridge_src, struct ast_channel \*\*exclude_chans, int num_chans);


* Merge bridge_src into bridge_dest and kick out the channels specified by exclude_chans from the bridges. The bridge_src is gutted and may destroy itself.
* bridge_dest can be given new properties.
* Channel properties/roles may need to change.
* Channel driver attended transfers can be accomplished by merging bridges.


This is likely only going to be used for local channel optimization. Unfortunately this will as a result be executed by the thread handling the media which would be not good. When local channel is given the go ahead, the local channels need to be suspended and the merge performed by another thread. A good thread would be one of the local channel bridge channels if it doesn't have much to do in its action queue. (Now do it on the bridge thread.)


Switching to-from-native to 1-1 bridges is going to need to be done on a bridge channel thread as well. (Now do it on the bridge thread.)


Always have a bridge thread. It will control the bridge restructuring, bridge tech selection, bridge hooks, and bridge timer hooks. The bridge thread will also do the bridge media handling depending upon the bridge tech. The early, native, and simple tech will use the bridge thread for media. The multiplexed bridge tech will pass the media duties to a thread common to several bridge instances. The softmix bridge uses the bridge thread for mixing the media after each bridge_channel thread has read it from the channel. Always having a bridge thread means it does not get created/destroyed when the bridge tech is changed by the smart bridge code.


The bridge_dest needs to pull the channels from bridge_src for a merge/move. This will avoid the bridge ao2 reference problem if the bridge_src pushes the channels to bridge_dest.


#### int ast_bridge_suspend(struct ast_bridge \*bridge, struct ast_channel \*chan);


#### int ast_bridge_unsuspend(struct ast_bridge \*bridge, struct ast_channel \*chan);


* Peers of suspended channels need to act like autoserviced channels and save important frames like DTMF and control frames.


##### int ast_is_deferrable_frame(const struct ast_frame \*frame);


Those frames get sent to the suspended channel and put in its action queue. The bridge needs to generate silence frames to the peer while DTMF is being collected or the chan is suspended.


The suspend/unsuspend functions by a third party should be removed. The bridging code mostly assumes that suspends are from the bridge channel thread and not an external party.


#### int ast_bridge_count_channels(struct ast_bridge \*bridge);


Return number of channels in the bridge.


#### struct ast_channel \*ast_bridge_peer(struct ast_bridge \*bridge, struct ast_channel \*chan);


Return the bridge peer channel of the given channel. The peer channel is returned with an increased ref count.


This function feels dangerous.


#### int ast_channel_is_bridged(struct ast_channel \*chan);


Return TRUE if the channel is currently bridged.


#### struct ast_bridge \*ast_channel_get_bridge(struct ast_channel \*chan);


Get the bridge the channel is currently in.


#### int ast_bridge_play_to_chan(struct ast_bridge \*bridge, struct ast_channel \*chan, const char \*file);


Play a file to the specified channel in a bridge.  



#### int ast_bridge_play_to_bridge(struct ast_bridge \*bridge, const char \*file);


Play a file to the specified bridge.


#### int ast_bridge_transfer_blind(struct ast_channel \*transferrer, const char \*context, const char \*exten, int priority);


* The bridge peer of the transferrer channel is blind transferred.
* The bridge peer action runs ast_channel_transfer_blind() after UNHOLDing the channel. The target location is also checked for a Parking exten and a park is performed instead.


#### int ast_channel_transfer_blind(struct ast_channel \*target, const char \*transferrer_chan_name, const char \*ctx_exten_pri);


* The ctx_exten_pri is a parseable string: "[[context,]exten,]priority". The optional values are filled in by the target channel. transferrer_chan_name can be NULL if done anonymously.


* Set BLINDTRANSFER on target channel with transferer channel name. I don't see why it has historically been put on both channels since the Park app is who needs the variable set so it can announce the parking slot.
* UNHOLD target.
* Post AMI blind transfer event.
* Do the ast_async_goto steps.


#### ast_async_goto()


This function actually is a blind transfer!


* if channel in a bridge
	+ if channel has a PBX
		- set PBX location on the channel + 1 because autoloop will decrement
	+ else
		- set PBX location on the channel
	+ set AST_SOFTHANGUP_ASYNCGOTO
* else if channel has a PBX
	+ set PBX location on the channel + 1 because autoloop will decrement
	+ set AST_SOFTHANGUP_ASYNCGOTO
* else
	+ create new channel
	+ set PBX location on the channel
	+ masquerade into it


#### int ast_bridge_transfer_attended(struct ast_channel \*party_a, struct ast_channel \*party_c);


* UNHOLD target party_a peer.
* Post AMI attended transfer event.
* If party_a and party_c are in bridges, ast_bridge_merge() party_c bridge into party_a bridge removing party_a and party_c channels from the bridges.
* If one of the channels is not bridged then we'll have to do it the old way with masquerades.
* If neither of the channels are in bridges then return error.


Problems if party_c is in the parking bridge. How to get party_a to take party_c's place in that bridge? Need an `ast_bridge_park(struct ast_bridge *parking_bridge, struct ast_bridge_channel *chan, struct ast_bridge_channel *swap);` The original party_a bridge is then dissolved.


Problem is worse for ConfBridge. You cannot swap a channel into that bridge because ConfBridge maintains a lot of state outside of the bridge module. You can only masquerade into the ConfBridge.


To eliminate the masquerade here it is likely that every application needs to become a mini channel driver attaching to a mini bridge associated with every channel. A radical rethink would be necessary for PBX and bridges.




!!! note 
    We'd really like to do that, but won't have time. 

      
[//]: # (end-note)



#### int ast_bridge_park(struct ast_bridge \*parking_bridge, struct ast_bridge_channel \*chan, struct ast_bridge_channel \*swap);


Moves chan into the parking bridge and replaces the swap channel already in the bridge at the same parking space. This is a specialized ast_bridge_move().


### Features and other thoughts


#### chan_agent ideas:


* Agent logs in and waits for calls just like now. The agent could be placed into a holding bridge with some kind of monitoring for a caller.


* Calls come in and get put into a waiting call list container. These calls can abort if chan_agent is not configured to allow multiple waiting calls or if the agent is not logged in.


* Agent thread sees waiting call in the container and finds the early bridge the call is in. The agent can decide when to accept the call. The agent thread then does a Pickup of the incoming call by joining the early bridge.


* Incoming calls that are hungup by the caller or are canceled because the agent joined the early bridge are just removed from the waiting container.


* Agent channels that are blind transferred create a local channel to run dialplan at the specified location and joins the early bridge.


#### COLP ideas:


* COLP updates happen as an optional result of bridge enter/leave and merge events. Local channel optimizations do not request COLP updates when the bridges merge. Transfer merges do request COLP updates.


* Bridge join/impart new channel initiates a COLP update exchange if there are two peers or from the bridge COLP setting.


* A peer leaving a bridge causes a COLP update if two peers remain in the bridge.


* Multi-peer bridges should be given a COLP identity somehow that is user configurable. If none is given, then the bridge won't give any COLP updates when a new peer joins. The COLP could be assigned by an interception macro/gosub when the bridge goes multi-peer.


* COLP role flag for exchange/bridge updates.


#### ConfBridge COLP ideas:


* Marked users can give a bridge their COLP identity when they join. This could let peers know who is moderating the conference.


* Multi-marked users could cause COLP updates when they talk.


* The bridge profile used can give it a COLP identity and any COLP update


#### Parking ideas:


* Add parking lot configuration option to give the parking lot a COLP identity.


#### Add new CHANNEL() option:


CHANNEL(after_bridge_goto)=<parseable-goto>  



#### BridgeWait()


Potential new dialplan appliction that puts the channel into a holding bridge that the Bridge application or the Bridge AMI action can move to the real bridge. This will avoid the need for a masquerade when the Wait application is used. The Bridge applicaiton and Bridge AMI action will need to be modified to not use masquerades unconditionally if these channels can be moved from the current bridge they are in.


#### More Stuff


The DTMF features could be a channel property datastore so they can be removed/restored to the channel depending upon which bridge they are in at the time. As a property they could be set by the CHANNEL() function.


Two party bridges need to keep ast_channel_internal_bridged_channel_set() up to date with the peer.


The default controlling channel for impromptu threeway bridges is the oldest channel controls the destruction of the bridge. A channel variable or CHANNEL(value) set by dialplan could be used to alter the bridge controller.


It would be nice to implement DTMF attended transfer to be able to toggle back and forth between party A and C like DAHDI analog can do.  



Bridge channel hooks can move the bridge channel between bridges. This would be needed to implement the toggle between A and C bridges feature.


A way to implement the toggle between A and C parties is to have an atxfer bridge subclass. Setup the links this way:

```

 A -- B1 --Local@special/b -- Batxfer1 -- B -- Batxfer2 -- Local@special/b -- B2 -- C

```

The atxfer bridges grant B the transfer menu because it has the TransferrerRoll defined on the channel. When the transfer is completed, the TransferrerRoll is removed.


The atxfer bridges have AST_BRIDGE_FLAG_MERGE_INHIBIT_TO set. They also have the inhibit merge count non-zero while the transfer is incomplete to prevent any local channel optimization.


The only difference between a self managing bridge and an externally managed bridge is if there is something outside of the bridge referencing it. The bridge destructor posts the AMI bridge destroy event.


Suspended channels can still be removed from a bridge. When they try to unsuspend, they find out if they are still part of the bridge or if it is still active.


Non-native 1-1 bridges need to generate AST_CONTROL_SRCUPDATE frames.


A channel that dissolves the bridge needs to update the peer channels hangup cause as it ejects them.


Any channel that later tries to join a dissolved bridge will be immediately ejected with the cause code stored on the bridge.


Event hooks are needed for the following type of events:


* bridge timeouts(bridge duration, interval),
* channel timeouts(duration, interval)
	+ Since only the bridge is aware of time, channel timeouts are managed timeouts on the bridge. The enter/leave/merge code needs to update these channel timer hooks.]
* channel DTMF features,
* channel enter/leave,
* bridge empty,
* bridge merge,
* bridge tech changes,


The bridge channel needs to keep track of the last HOLD/UNHOLD state and any DTMF digit in progress so they can be stopped when the channel is removed from the bridge.


The bridge_channel action queue will fix many of the issues I have been having with bridge member updates. The bridge core code determines which bridge_channel to put actions on from a feature hook. For example:


* Blind transfer hook triggers
* Hook gathers destination digits
* Hook validates destination
* Hook asks bridge core to post blind transfer action onto peer channel.
* Bridge may refuse if the request cannot be put onto a peer channel because it no longer exists or there is more than one.
* If the bridge refuses then the blind transfer fails and the hook just returns to the bridge as if the user did not try blind transfer. The queued action also needs a destructor as part of the queued struct.


The bridge also needs an action queue to do things like smart bridge, bridge merges, channel join, and channel leave. COLP update action.


#### Masquerades


Masquerades are used in two ways:


1. A third party has a channel that they want to take the place of an existing channel. Pickup, Local channel optimization, attended transfer with an application. Running an h exten on the zombie is a good thing.
2. Steal a channel from some other thread. Park, bridging, blind transfers of channels without a PBX. Running an h exten on this zombie does not do much because it was a sacrificial channel anyway.


#### Bridge Merging


Bridges can be marked as non-mergable. (Should be a non-mergable count to handle temporary merge blocks.)


Maybe this should be done automatically while a bridge channel executes a bridge hook.


* This will block local channel optimizations until ready for it.
* This will prevent ConfBridge bridges from absorbing foreign bridges.
* This will prevent Parking bridges from absorbing foreign bridges.


#### Bridge Event Hooks


Event hooks need to be able to be registered/unregistered/destroyed.


Need to add to API: calls to register/unregister/destroy event observer callbacks with private pointer data.


* Channel bridge enter/exit - notify.
* Bridge technology change to/from specific technology - notify.
* Bridge stop/destroy hooks - notify.
* Bridge merge hooks to direct how merges transform the resulting bridge.
	+ Pre-merge-veto - Multiple callbacks allowed. Any can veto merge.
	+ Pre-merge - Multiple callbacks allowed.
	+ Post-merge - Multiple callbacks allowed to inform of completed merge.
* Bridge merge hooks per channel
	+ Pre-merge-veto - Multiple callbacks allowed. Any can veto merge.
	+ Pre-merge - Multiple callbacks allowed.
	+ Post-merge - Multiple callbacks allowed to inform of completed merge.


#### Roles


Need to add role concepts for channels in bridge. Channels can change roles using feature hooks. Rolls may be flags.


* Caller/Callee for early media bridge and COLP interception macros.
* Announcer - Plays messages/music to channels in the bridge. Not considered a peer.
* Recorder - Records bridge. Not considered a peer.
* Agent - Can hear Supervisor whisper. Considered a peer. Only ability other than default.
* Supervisor - Can whisper to Agent. Not considered a peer.
* Default - Regular participant in the bridge. Considered a peer.
* ConfBridge - Regular participant in the bridge. Not considered a peer.


Roll flags:


* Caller - Only significant in early media bridge. The caller flag can also be used for COLP interception macros. Attended transfers would need to manipulate the caller role flag for proper roles. Party A is always the caller role and Party C is the callee role.
* Peer - Normal bridges exchange control frames when only two channels are marked as peers. Early media bridges (if they but existed) also look at the Caller flag for control frame exchanges.
* COLP-exchange - Channel can exchange COLP updates with peer. Exchanges COLP when there are less than three channels in the bridge marked as such. Otherwise, it behaves like the COLP-bridge role flag.
* COLP-bridge - Channel can recieve COLP updates from the bridge. ConfBridge users just have this flag set to only receive COLP updates from the bridge.


Future role flags (softmix bridge):


* Whisper - Channel can only be heard by a channel marked Whisper-receiver
* Whisper-receiver
* Recorder - Channel receives the recording mix of recordable channels.
* NonRecordable - Channel is not heard by a recording channel.
* Announcer - Channel can only be heard by a channel marked Announcer-receiver
* Announcer-receiver


Recorder/Announcer channels need an option flag to exit the bridge if there is noone else in the bridge. Otherwise there is the possibility that the bridge will become orphaned with just those special channels in the bridge. AST_BRIDGE_FLAG_LONELY


### New Objects


#### Design patterns


* The state pattern could be applied to ast_bridge.
	+ ast_bridge could be thought of as a state of ast_bridge_channel.
	+ Changing states is moving to another bridge. This is a bit of a stretch though.


ast_bridge_technology is the strategy pattern


The decorator pattern could be applied to ast_bridge_channel to decorate the channel with feature hooks. Decorators can be added/removed at run time just like features. Though this pattern may be a bit expensive resource wise.


The Basic, Parking, ConfBridge, atxfer, and Queue bridges could be thought of as a strategy instead of subclassing ast_bridge_channel. It is looks more like ast_bridge_technology in relation to ast_bridge/ast_bridge_channel. Changed this back to just subclassing ast_bridge.


#### Bridge Classes


Bridge technologies are an embedded object of the abstract bridge class.


Park, Queue, ConfBridge could be derivative classes of the abstract bridge class.

```

class ast_bridge {
 join(struct ast_channel \*chan);
 depart(struct ast_channel \*chan);
 remove(struct ast_channel \*chan);
 move_pull(class ast_bridge_channel \*chan);
 Pull a channel out of this bridge to be pushed into another bridge.
 move_push(class ast_bridge_channel \*chan, class ast_bridge_channel \*swap);
 Push a channel into this bridge that was pulled from another bridge.
 masquerade_pull(class ast_bridge_channel \*chan);
 A masquerade is figuratively pulling this channel out of the bridge
 to be pushed back in as a new channel.
 This is done for the clone and original channels because a masquerade
 swaps the guts of the two channels.
 masquerade_push(class ast_bridge_channel \*chan);
 Push the channel back into the bridge as a new channel.
 poke();
 new();
 The derived bridge classes need to have a default channel
 configuration for when a channel is pushed into it.
 Park needs to assign a parking space and timeout.
 ConfBridge needs to have a default user profile.
 The class also needs to remove special channel configuration
 when it it pulled.
 The class needs to have a channel inherit the configuration
 of a swapped channel when it is pushed or joined.
};
class ast_bridge_channel {
 class ast_bridge \*bridge;
 suspend();
 Mark channel as suspended and poke the bridge to recognize it.
 unsuspend();
 Mark channel as unsuspended and poke the bridge to recognize it.
};

```

#### Locking precedence order:

```

 bridges ao2_container
 |
 ast_bridge
 |
 channels ao2_container ast_bridge_channel
 | _____________/
 ast_channel
 /
channel private

```

#### New Bridge Techs


##### Early media bridge tech:


* Allowed channel roles: 0-1 Caller / 1-n Callees
* The bridge can start with this tech but cannot switch back to it.
* At most one Peer channel UP and at least one Peer channel not UP.
* Does not do audio mixing.
* First call to answer kicks out all other Peer non-Caller channels and answers the Caller channel if needed.
* The bridge tech needs to change to a normal bridge type.
* The bridge can have a timeout to connect.




!!! note 
    We are, unfortunately, punting on the Early Media Bridge Technology. Not because it isn't awesome or the right way to do it, but because app_dial and app_queue are a bitch to refactor.

      
[//]: # (end-note)



##### Parking bridge tech:


* Adds ability to access bridge channels in it by parking space/slot.
* Parking bridges are found in a container by parking lot name.
* Parking lots can be configured with COLP information.
* The parking tech has extra methods to manage the parking lot:
	+ move_bridged_channel_to_parking,
	+ move_bridged_channel_from_parking,
	+ swap_bridged_channel_with_parked
* Actually these extra methods look like they should be part of the base bridge class.
* Timed out calls leave the parking lot by blind transfer.


#### DTMF Feature Transfers


##### DTMF Blind transfer:


* (Transfer will fail if the transferee channel is imparted to be departed.)
* Up non-merge count on host bridge.
* Get transfer destination.
* Validate it is in the dialplan.
* Check if it is a parking exten and park instead.
* Queue action to bridge peer to blind transfer.
	+ Supply transfering channel, exten@context
* Peer channel executes blind transfer action. ast_async_goto().
	+ Channel leaves bridge and starts executing dialplan.
* Drop non-merge count on host bridge.


##### DTMF Attended transfer:


* If party A hangs up the original bridge should be set to dissolve and automatically kick out party B from the bridge.
* Up non-merge count on host bridge.
* Get transfer destination.
* Validate it is in the dialplan.
* Check if it is a parking exten and park instead.
* Create early media bridge.
	+ Bridge does not dissolve,
	+ Bridge times out,
	+ Bridge non-mergable(to prevent local channel optimization)
* Dial party C
* Pull party B bridge_channel out of the bridge
* Create an atxfer caretaker thread to see it through. Pass party B bridge_channel, party C, and early media bridge
	+ The early media bridge is not really viable here unless we want to allow it to be able to keep going with no caller.
	+ If party B hangs up before party C answers we need to save party B channel name, release party B channel, and wait the timeout for party C to answer
	+ If party C answers within the timeout then we can impart it into the original bridge to talk to party A.
	+ If party C does not answer within the timeout, we need to bounce back and forth call attempts to party B and party C.
* Impart party C into early media bridge, Party C dissolves bridge when it hangs up.
	+ If Party C is forwarded, the forwarded channel replaces the party C channel and takes Party C's properties.
* Join party B into early media bridge (or not )
* Party B leaves the bridge when
	+ early media bridge times out
	+ Party B cancels/aborts transfer
	+ Party B wishes threeway call
	+ Party B hangs up (early media bridge or normal bridge keeps going)
	+ Party C hangs up
* if party B hangs up
	+ if party C is up
		- Mark bridge channels as non-dissolving(Only party C should be in the bridge if still there)
		- move Party C bridge channel to original bridge
		- destroy temporary bridge
		- Drop non-merge count on host bridge.
		- party B returns to original bridge and leaves bridge
		- done
	+ wait for party C to answer or the timeout
* else if party B cancels/aborts transfer
	+ destroy temporary bridge
	+ Drop non-merge count on host bridge.
	+ party B returns to original bridge
	+ done
* else if party B wishes threeway call
	+ Mark bridge channels as non-dissolving(Only party C should be in the bridge if still there)
	+ mark party B on original bridge as dissolves bridge when it hangs up.
	+ mark original bridge as non-dissolving
	+ move Party C bridge channel to original bridge
	+ destroy temporary bridge
	+ Drop non-merge count on host bridge.
	+ party B returns to original bridge
	+ done
* if early media bridge times out
	+ If party C does not answer within the timeout, we need to bounce back and forth
	+ call attempts to party B and party C.


##### Parking (DTMF one-touch-park, DTMF blind transfer, DTMF attended transfer):


* Determine parking lot to put peer into.
* Create parking space channel for masquerade.
* Reserve space in the parking lot.
* Queue action to bridge peer to park
	+ Supply parking channel name, parking channel
* Peer channel executes park-me action
* Park-me action queues play slot number or failure message back to peer
* Park-me action masquerades bridge_channel to parking channel.
* Parking channel is put into the parking manager thread.


##### Pickup:


* Find appropriate ringing channel in early media bridge
* Join-swap ringing channel
* Need some race condition insurance that some other channel won't win
* while the pickup channel is coming into the bridge. Otherwise we would
* wind up with a three or more party bridge.




!!! note 
    This won't be how this works. It's still going to be a masquerade.

      
[//]: # (end-note)



##### Local channel optimization:


* Needs more thought because we don't want to optimize in the middle of other operations.
* Local channel determines it is possible to masquerade.
* The non-merge count will block optimizations during inopportune times.
* Optimization is done by merging bridges and ejecting the merging local channels from the resulting merged bridge.


##### FollowMe:


* For followme need an event-hook/frame-hook to intercept the AST_CONTROL_ANSWER so it can handle the user query. Each outgoing channel needs to have its own timer so it can drop out if it isn't answered. The main followme thread also has a timer to dump the next round of calls into the early-media bridge.


##### Queue:


* Like parking, the call can be stuck in a holding bridge until:
	1. an agent gets the call
	2. caller hangs up
	3. caller presses DTMF to goto new location
* The holding bridge could periodically or when the number of calls ahead of the caller changes announce to the caller what position in the queue they are in.


### APIs for Folks


#### CLI commands:

```

bridge show all
 List all current bridges by bridge-id and number of channels in the bridge.

bridge show bridge-id
 Dump information about the specified bridge.
 bridge-id, bridge tech using, bridge tech could use, channels in bridge,
 bridge type (normal, parking, queue, ConfBridge), other information

bridge destroy all
 Destroy all bridges in the system.
 Maybe we should qualify this as destroy only transient bridges. Not
 bridges that exist as long as the system is running or the module is loaded.

bridge destroy bridge-id
 Destroy the specified bridge.

bridge kick <channel>
 Kick a channel out of a bridge if it is in one.

 NOTE: Be careful because it does not destroy the bridge. If there is only
 one channel left in the bridge, that channel may just sit there.

bridge suspend <tech>
 Suspend the bridge technology from use by bridges.
 Bridges currently using the technology will continue to use it.

bridge unsuspend <tech>
 Unsuspend the bridge technology from use by bridges.

```

Corresponding AMI actions should also be created.


Test Plan
=========


Bridging has wide-ranging affects on a call. While each bridging test will have some aspect of bridging as its fundamental focus, each will also have common elements that are checked as well, independent of the primary purpose of the test. For example, even if the focus of the test is a feature such as Auto-Monitor, fundamental attributes such as CDRs should be checked for correctness as well.


Tests need to be crafted not only to test the nominal path for features. For instance, it is not enough to write a transfer test wherein all parties behave as expected. There should be tests where a transfer is made to a non-existent extension, or a test where a transfer is started but an extension is not typed in within the appropriate time limit.


See [Asterisk 12 Bridging Test Plan](Asterisk-12-Bridging-Test-Plan) for mappings between the Asterisk tests and the defined Use Cases.


Features Not to Test
--------------------


There are some features and applications in Asterisk that, upon first glance, appear to be in the realm of a bridging test plan. Upon further inspection, however, they do not belong in the test plan.


### Bridge Manager Action/Application


These only represent different ways of erecting bridges between parties. They don't actually affect the operations and machinations of the bridge that gets created.


### Call Pickup


Call pickup occurs entirely before a bridge is formed, therefore it does not belong in a suite of bridge tests.




!!! note Note
    This may actually change, if channels are placed into a new bridge technology that performs early media playback ("Early Bridge"). This would be advantageous as the channel picking up the call would simply join the bridge with the channel in early media, and the bridge technology would swap from the Early Bridge technology to a compatible Two-Party bridge technology.


    If that occurs, this test plan will be updated.

      
[//]: # (end-note)





!!! note Note #2
    Most likely, call pickup will not have an early bridge 

      
[//]: # (end-note)



### Invoking bridges from multiple applications


Since we're concerned with the operation of the actual bridge, it does not matter how the bridge gets invoked. Whether app_dial, app_queue, or app_followme is used to create the bridge, it makes no difference in the way the bridge ends up operating. This also means the various forms of call origination don't need to be tested, either.


Common elements to check during tests
-------------------------------------


During all bridging tests, the bridge should be checked to make sure that media frames are being passed properly. The easiest way to do this is to pass DTMF between the two parties and ensure that they are received properly on the opposite side.


The table below lists the items that should be checked in each test.




|  Item  |  Rationale  |
| --- | --- |
|  CDRs  |  The content of these will vary from test to test, but for common two-party bridges, these should be remarkably similar  |
|  CELs  |  Same applies for these as for CDRs  |
|  CallerID  |  Check that the Caller ID for each channel involved in the bridge is what it is expected to be  |
|  Connected Line  |  Check that connected line for each channel involved is what is expected  |
|  Common Channel variables  |  BRIDGEPEER, BRIDGEPVTCALLID should be set appropriately  |
|  Bridge*|  Check that the AMI Bridge event occurs when expected  |


Project Planning
================


High Level Bridging construction tasks:
---------------------------------------


* **DONE** Change ast_bridge_call callers to not expect getting peer back. Part of this is to add an optional goto dialplan location datastore to set where the peer should go when it exits the bridge. The location datastore is removed if a channel exits with AST_SOFTHANGUP_ASYNCGOTO set or the channel is masqueraded. Part of this is to implement the self managing bridge functionality.


* **DONE** Make all bridge technologies have a bridging thread to handle bridge restructuring tasks like smart bridge and bridge merges. When the bridge thread is not being used to restructure the


* **DONE** Implement a v-method table to subclass struct ast_bridge. Parking, Queues, ConfBridge, and other holding bridges would then be able to subclass ast_bridge to allow merge/moves between bridges.


* **DONE**(except for the role support in softmix. It won't be needed until much later if ever.): Add control frame support/processing. Part of this needs to add AST_CONTROL_SRCUPDATE generation on 1-1 bridging. Part of this needs to add the caller role flag for the initial role flags support. Mark normal channels with the peer role flag and respect it. Initially all channels not in a ConfBridge will be marked as a peer.


* **DONE** Add bridge CLI commands. Part is to add bridge id support. How unique does the bridge id need to be? UUID, hostname/timestamp/sequence-no, timestamp/sequence-no, or just sequence-no AMI Transfer start/complete events. Implements the global bridges ao2 container. This container is needed for ConfBridge, Parking, BridgeWait, and Queue to find bridges by name. As a consequence of this, bridges must explicitly know when to die rather than counting on the ao2 reference count to drop to zero.


* **DONE** Create the Basic bridge subclass. This bridge enables the DTMF features controlled by features.conf: One-touch-parking, Blind transfer, attended transfer, monitor-recording, mixmonitor-recording, dynamic features. The Basic bridge subclass pulls most of the code from ast_bridge_call into itself.


* **DONE** Add bridge and bridge channel hooks for enter/leave/answer/merge/tech-change/empty events. An answer hook will not be usable until the early bridge is implemented.


* **DONE** (save for complete) Add create/enter/leave/destroy bridge stasis/AMI events. The complete event is needed to indicate if the transfer was successful, aborted, or was turned into a threeway.


* Get local channel optimization functional again. I would like to pull chan_local into the bridging module. There seem to be times where it could be useful to create a local channel structure and impart the channels into different bridges or put one end into a bridge and the other executes an application. Pulling chal_local into the bridge module could wait until I actually have a real need to do so.


* Implement ast_bridge_transfer_blind() and ast_bridge_transfer_attended(). Attended transfer needs to update the caller role flags on peer channels. Attended transfer will need revisiting when parking is reworked.


* Get the channel drivers to use the ast_bridge_transfer_blind() and ast_bridge_transfer_attended() calls. This can be a task for each channel driver: chan_dahdi, chan_sip, chan_misdn, etc...


* Implement early bridging. I'm now thinking that the early media bridge will turn into just enhancing the dialing API because of the way Page works. Dial/Queue/FollowMe would need to be converted to use the dialing API.




!!! note 
    Punt.

      
[//]: # (end-note)



* Dial/Queue/FollowMe/Pickup updated to use early bridging.




!!! note 
    Punt.

      
[//]: # (end-note)



* Get DTMF transfer features on par with current functionality. DTMF attended transfer will need a manager thread to handle operations after Party B hangs up and before Party C answers. Bonus is that the new bridging API allows threeway conferences. Since features.conf is being gutted should we eliminate it in favor of new config files?


* Implement parking bridge and get the system to use it. Park(), ParkedCall(), ParkAndAnnounce(), DTMF one touch park.


* Implement DTMF one touch record. Monitor and MixMonitor support.


* Get chan_agent working again since the chan->_bridge pointer is no more. Must be done after early bridging so the agent channel can Pickup the caller.


* Lastly native bridging technology.


JIRA Issues
-----------


true
Contributors
------------




|  Name  |  E-mail Address  |
| --- | --- |
|  Matt Jordan  |  mjordan@digium.com  |
|  Richard Mudgett  |  rmudgett@digium.com  |
|  Jonathan Rose  |  jrose@digium.com  |


Reference Information
=====================


Test Reviews
------------




|  Review  |  Link  |
| --- | --- |
|  Bridging Test Suite Object  | <https://reviewboard.asterisk.org/r/2065/> |
|  Timed Features Tests  | <https://reviewboard.asterisk.org/r/2247/> |
|  Connected Line Tests  | <https://reviewboard.asterisk.org/r/2249/> |
|  Auto-monitor, -mix-monitor, blind transfer detection; CDR/CEL integration Tests  | <https://reviewboard.asterisk.org/r/2067/> |
|  Auto-monitor, -mix-monitor basic Tests  | <https://reviewboard.asterisk.org/r/2250/> |
|  Call Parking (basic) Tests  | <https://reviewboard.asterisk.org/r/2273/> |
|  Call Parking Timeout (comebacktoorigin=yes) Tests  | <https://reviewboard.asterisk.org/r/2306/> |
|  Call Parking Timeout (comebacktoorigin=no) Tests  | <https://reviewboard.asterisk.org/r/2301/> |
|  Transfer Capability Tests  | <https://reviewboard.asterisk.org/r/2268/> |


