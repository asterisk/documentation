---
title: Call Parking
pageid: 32376513
---

# Call Parking

Some organizations have the need to facilitate calls to employees who move around the office a lot or who don't necessarily sit at a desk all day. In Asterisk, it is possible to allow a call to be put on hold at one location and then picked up from a different location such that the conversation can be continued from a device other than the one from which call was originally answered. This concept is known as call parking.

Call parking is a feature that allows a participant in a call to put the other participants on hold while they themselves hang up. When parking, the party that initiates the park will be told a parking space, which under standard configuration doubles as an extension. This extension, or parking space, serves as the conduit for accessing the parked call. At this point, as long as the parking space is known, the parked call can be retrieved from a different location/device from where it was originally answered.

## Call Parking Configuration Files and Module

In versions of Asterisk prior to Asterisk 12, call parking was considered an Asterisk core feature and was configured using `features.conf`. However, Asterisk 12 underwent vast architectural changes, several of which were directed at call parking support. Because the amount of changes introduced in Asterisk 12 was quite extensive, they have been omitted from this document.

In a nutshell, Asterisk 12 relocated its support for call parking from the Asterisk core into a separate, loadable module, `res_parking`. As a result, configuration for call parking was also moved to [`res_parking.conf`](/latest_api/API_Documentation/Module_Configuration/res_parking). Configuration for call parking through `features.conf`for versions of Asterisk 12 and beyond is no longer supported. Additionally, support for the [`ParkAndAnnounce`](/latest_api/API_Documentation/Dialplan_Applications/ParkAndAnnounce) application was relocated to the `res_parking` module and the `app_parkandannounce` module was removed.

Before we move any further, there is one more rather important detail to address regarding configuration for `res_parking`:

!!! note 
    `res_parking` uses the configuration framework. If an invalid configuration is  supplied, `res_parking` will fail to load or fail to reload. Previously,  invalid configurations would generally be accepted, with certain errors  resulting in individually disabled parking lots.

      
[//]: # (end-note)

Now that we've covered all of that, let's look at some examples of how all this works.

## Example Configurations

### Basic Call Parking/Retrieval Scenario

This is a basic scenario that only requires minimal adjustments to the following configuration files: `res_parking.conf`, `features.conf`, and `extensions.conf`.

In this scenario, our dialplan contains an extension to accept calls from the outside. Let's assume that the extension the caller dialed was: `5555001`. The handler will then attempt to dial the `alice` extension, using the `k` option.

Sadly for our caller, the `alice` extension answers the call and immediately after saying, "Hello world!", sends the DTMF digits to invoke the call parking feature without giving the caller a chance to speak. The `alice` extension quickly redeems itself by using the `GoTo` application to navigate to the `701` extension in the `parkedcalls` context to retrieve the parked call. But, since the next thing the `alice` extension does is hangup on our caller, I am beginning to think the `alice` extension doesn't want to be bothered.

In summary:

* Outside caller dials `5555001`
* Alice picks up the device and says "Hello World!"
* Alice presses the one touch parking DTMF combination
* Alice then dials the extension that the call was parked to (`701`) to retrieve the call
* Alice says, "Goodbye", and disconnects the caller

---

res_parking.conf  

```
[general]
parkext => 700 ; Sets the default extension used to park calls. Note: This option
 ; can take any alphanumeric string.

parkpos => 701-709 ; Sets the range of extensions used as the parking lot. Parked calls
 ; may be retrieved by dialing the numbers in this range. Note: These
 ; need to be numeric, as Asterisk starts from the start position and
 ; increments with one for the next parked call.

context => parkedcalls ; Sets the default dialplan context where the parking extension and
 ; the parking lot extensions are created. These will be automatically
 ; generated since we have specified a value for the 'parkext' option
 ; above. If you need to use this in your dialplan (extensions.conf),
 ; just include it like: include => parkedcalls.

parkingtime => 300 ; Specifies the number of seconds a call will wait in the parking
 ; lot before timing out. In this example, a parked call will time out
 ; if it is not un-parked before 300 seconds (5 minutes) elapses.

findslot => next ; Configures the parking slot selection behavior. For this example,
 ; the next free slot will be selected when a call is parked.

```



---

  
features.conf  

```
[featuremap]
parkcall => #72 ; Parks the call (one-step parking). For this example, a call will be
 ; automatically parked when an allowed party presses the DTMF digits,
 ; #·7·2. A party is able to make use of this when the the K/k options
 ; are used when invoking the Dial() application. For convenience, the
 ; values of this option are defined below:
 ; K - Allow the calling party to enable parking of the call.
 ; k - Allow the called party to enable parking of the call.

```
---
extensions.conf  

```
[globals]
; Extension Maps
5001=alice ; Maps 5001 to a local extension that will emulate
 ; a party pressing DTMF digits from a device.
;5001=PJSIP/sip:alice@127.0.0.1:5060 ; What a realistc mapping for the alice device would look like.

; Realistically, 'alice' would map to a channel for a local device that would receive the call, therefore
; rendering this extension unnecessary. However, for the purposes of this demonstration, the extension is
; presented to you to show that sending the sequence of DTMF digits defined in the 'parkcall' option in
; 'features.conf' is the trigger that invokes the one-step parking feature.

[parking-example]
include => parkedcalls

exten => alice,1,NoOp(Handles calls to alice.)
 same => n,Answer()
 same => n,Playback(hello-world)
 same => n,SendDTMF(#72w)
 same => n,Goto(parkedcalls,701,1)
 same => n,Playback(vm-goodbye)
 same => n,Hangup()

[from-outside]
exten => 5555001,1,NoOp(Route to a local extension.)
 ; Dials the device that is mapped to the local resource, alice, giving the recipient of the call the ability
 ; to park it. Assuming the value of LocalExtension is 5001, the Dial() command will look like: Dial(alice,,k)
 same => n,Dial(PJSIP/alice)
 same => n,Hangup()

```

### Basic Handling for Call Parking Timeouts

Next we will move on to explain how to handle situations where a call is parked but is not retrieved before the value specified as the `parkingtime` option elapses. Just like the scenario above, this is a basic scenario that only requires minimal adjustments to the following configuration files: `res_parking.conf`, `features.conf`, and `extensions.conf`.

Like before, our dialplan contains an extension to accept calls from the outside. Again, let's assume that the extension the caller dialed was: `5555001`. The handler will then attempt to dial the `alice` extension, using the `k` option.

Sadly for our caller, the `alice` extension answers the call and immediately sends the DTMF digits to invoke the call parking feature without giving the caller a chance to speak. Unlike in the previous scenario, however, the `alice` extension does not retrieve the parked call. Our sad caller is now even more sad.

After a period of `300 seconds`, or `5 minutes` (as defined in the `parkingtime` option in `res_parking.conf`), the call will time out. Because we told Asterisk to return a timed-out parked call to the party that originally parked the call (`comebacktoorigin=yes`), Asterisk will attempt to call `alice` using an extension automagically created in the special context, `park-dial`.

Unfortunately, the `alice` extension has no time to be bothered with us at this moment, so the call is not answered. After a period of `20 seconds` elapses (the value specified for the `comebackdialtime` option in `res_parking.conf`), Asterisk finally gives up and the `t` extension in the `park-dial` context is executed. Our caller is then told "Goodbye" before being disconnected.

In summary:

* Outside caller dials `5555001`
* Alice picks up the device and says "Hello World!"
* Alice presses the one touch parking DTMF combination
* The parked call times out after 300 seconds
* Asterisk sends the call to the origin, or the `alice` extension
* A period of `20 seconds` elapses without an answer
* Asterisk sends the call to `t` extension in the `park-dial` context
* Our caller hears, "Goodbye", before being disconnected




---

  
res_parking.conf  

```
truetext1[general]
parkext => 700 ; Sets the default extension used to park calls. Note: This option
 ; can take any alphanumeric string.

parkpos => 701-709 ; Sets the range of extensions used as the parking lot. Parked calls
 ; may be retrieved by dialing the numbers in this range. Note: These
 ; need to be numeric, as Asterisk starts from the start position and
 ; increments with one for the next parked call.

context => parkedcalls ; Sets the default dialplan context where the parking extension and
 ; the parking lot extensions are created. These will be automatically
 ; generated since we have specified a value for the 'parkext' option
 ; above. If you need to use this in your dialplan (extensions.conf),
 ; just include it like: include => parkedcalls.

parkingtime => 300 ; Specifies the number of seconds a call will wait in the parking
 ; lot before timing out. In this example, a parked call will time out
 ; if it is not un-parked before 300 seconds (5 minutes) elapses.

findslot => next ; Configures the parking slot selection behavior. For this example,
 ; the next free slot will be selected when a call is parked.

comebackdialtime=20 ; When a parked call times out, this is the number of seconds to dial
 ; the device that originally parked the call, or the PARKER
 ; channel variable. The value of 'comebackdialtime' is available as
 ; the channel variable 'COMEBACKDIALTIME' after a parked call has
 ; timed out. For this example, when a parked call times out, Asterisk
 ; will attempt to call the PARKER for 20 seconds, using an extension
 ; it will automatically create in the 'park-dial' context. If the
 ; party does not answer the call during this period, Asterisk will
 ; continue executing any remaining priorities in the dialplan.

comebacktoorigin=yes ; Determines what should be done with a parked call if it is not
 ; retrieved before the time specified in the 'parkingtime' option
 ; elapses. In the case of this example where 'comebacktoorigin=yes',
 ; Asterisk will attempt to return the parked call to the party that
 ; originally parked the call, or the PARKER channel variable, using
 ; an extension it will automatically create in the 'park-dial'
 ; context.

```



---

  
features.conf  

```
truetext1[featuremap]
parkcall => #72 ; Parks the call (one-step parking). For this example, a call will be
 ; automatically parked when an allowed party presses the DTMF digits,
 ; #·7·2. A party is able to make use of this when the the K/k options
 ; are used when invoking the Dial() application. For convenience, the
 ; values of this option are defined below:
 ; K - Allow the calling party to enable parking of the call.
 ; k - Allow the called party to enable parking of the call.

```



---

  
extensions.conf  

```
truetext1[globals]
; Extension Maps
5001=alice ; Maps 5001 to a local extension that will emulate
 ; a party pressing DTMF digits from a device.
;5001=PJSIP/sip:alice@127.0.0.1:5060 ; What a realistc mapping for the alice device would look like.

; Realistically, 'alice' would map to a channel for a local device that would receive the call, therefore
; rendering this extension unnecessary. However, for the purposes of this demonstration, the extension is
; presented to you to show that sending the sequence of DTMF digits defined in the 'parkcall' option in
; 'features.conf' is the trigger that invokes the one-step parking feature.

[parking-example]
include => parkedcalls

exten => alice,1,NoOp(Handles calls to alice.)
 same => n,Answer()
 same => n,Playback(hello-world)
 same => n,SendDTMF(#72w)
 same => n,Wait(300)
 same => n,Hangup()

[from-outside]
exten => 5555001,1,NoOp(Route to a local extension.)
 ; Dials the device that is mapped to the local resource, alice, giving the recipient of the call the ability
 ; to park it. Assuming the value of LocalExtension is 5001, the Dial() command will look like: Dial(alice,,k)
 same => n,Dial(PJSIP/alice)
 same => n,Hangup()

[park-dial]
; Route here if the party that initiated the call parking cannot be reached after a period of time equaling the
; value specified in the 'comebackdialtime' option elapses.
exten => t,1,NoOp(End of the line for a timed-out parked call.)
 same => n,Playback(vm-goodbye)
 same => n,Hangup()

```

### Custom Handling for Call Parking Timeouts

Finally, we will move on to explain how to handle situations where upon a parked call session timing out, it is not desired to return to the parked call to the device from where the call was originally parked. (This might be handy for situations where you have a dedicated receptionist or service desk extension to handle incoming call traffic.) Just like the previous two examples, this is a basic scenario that only requires minimal adjustments to the following configuration files: `res_parking.conf`, `features.conf`, and `extensions.conf`.

Like before, our dialplan contains an extension to accept calls from the outside. Again, let's assume that the extension the caller dialed was: `5555001`. The handler will then attempt to dial the `alice` extension, using the `k` option.

Sadly for our caller, the `alice` extension answers the call and immediately sends the DTMF digits to invoke the call parking feature without giving the caller a chance to speak. Just like in the previous scenario, the `alice` extension does not retrieve the parked call. Maybe the `alice` extension is having a bad day.

After a period of `300 seconds`, or `5 minutes` (as defined in the `parkingtime` option in `res_parking.conf`), the call will time out. Because we told Asterisk to send a timed-out parked call to the `parkedcallstimeout` context (`comebacktoorigin=no`), we are able to bypass the default logic that directs Asterisk to returning the call to the person who initiated the park. In our example, when a parked call enters our `s` extension in our `parkedcallstimeout` context, we only play a sound file to the caller and hangup the call, but this is where you could do any custom logic like returning the call to a different extension, or performing a lookup of some sort.

In summary:

* Outside caller dials `5555001`
* Alice picks up the device and says "Hello World!"
* Alice presses the one touch parking DTMF combination
* The parked call times out after 300 seconds
* Asterisk sends the call to the `s` extension in our `parkedcallstimeout`
* Our caller hears, "Goodbye", before being disconnected




---

  
res_parking.conf  

```
truetext1[general]

[default]
parkext => 700 ; Sets the default extension used to park calls. Note: This option
 ; can take any alphanumeric string.

parkpos => 701-709 ; Sets the range of extensions used as the parking lot. Parked calls
 ; may be retrieved by dialing the numbers in this range. Note: These
 ; need to be numeric, as Asterisk starts from the start position and
 ; increments with one for the next parked call.

context => parkedcalls ; Sets the default dialplan context where the parking extension and
 ; the parking lot extensions are created. These will be automatically
 ; generated since we have specified a value for the 'parkext' option
 ; above. If you need to use this in your dialplan (extensions.conf),
 ; just include it like: include => parkedcalls.

parkingtime => 300 ; Specifies the number of seconds a call will wait in the parking
 ; lot before timing out. In this example, a parked call will time out
 ; if it is not un-parked before 300 seconds (5 minutes) elapses.

findslot => next ; Configures the parking slot selection behavior. For this example,
 ; the next free slot will be selected when a call is parked.

comebacktoorigin=no ; Determines what should be done with a parked call if it is not
 ; retrieved before the time specified in the 'parkingtime' option
 ; elapses.
 ;
 ; Setting 'comebacktoorigin=no' (like in this example) is for cases
 ; when you want to perform custom dialplan logic to gracefully handle
 ; the remainder of the parked call when it times out.

comebackcontext=parkedcallstimeout ; The context that a parked call will be routed to in the event it
 ; times out. Asterisk will first attempt to route the call to an
 ; extension in this context that matches the flattened peer name. If
 ; no such extension exists, Asterisk will next attempt to route the
 ; call to the 's' extension in this context. Note: If you set
 ; 'comebacktoorigin=no' in your configuration but do not define this
 ; value, Asterisk will route the call to the 's' extension in the
 ; default context.

```



---

  
features.conf  

```
truetext1[featuremap]
parkcall => #72 ; Parks the call (one-step parking). For this example, a call will be
 ; automatically parked when an allowed party presses the DTMF digits,
 ; #·7·2. A party is able to make use of this when the the K/k options
 ; are used when invoking the Dial() application. For convenience, the
 ; values of this option are defined below:
 ; K - Allow the calling party to enable parking of the call.
 ; k - Allow the called party to enable parking of the call.

```



---

  
extensions.conf  

```
truetext1[globals]
; Extension Maps
5001=alice ; Maps 5001 to a local extension that will emulate
 ; a party pressing DTMF digits from a device.
;5001=PJSIP/sip:alice@127.0.0.1:5060 ; What a realistc mapping for the alice device would look like.

; Realistically, 'alice' would map to a channel for a local device that would receive the call, therefore
; rendering this extension unnecessary. However, for the purposes of this demonstration, the extension is
; presented to you to show that sending the sequence of DTMF digits defined in the 'parkcall' option in
; 'features.conf' is the trigger that invokes the one-step parking feature.

[parking-example]
include => parkedcalls

exten => alice,1,NoOp(Handles calls to alice.)
 same => n,Answer()
 same => n,Playback(hello-world)
 same => n,SendDTMF(#72w)
 same => n,Wait(300)
 same => n,Hangup()

[from-outside]
exten => 5555001,1,NoOp(Route to a local extension.)
 ; Dials the device that is mapped to the local resource, alice, giving the recipient of the call the ability
 ; to park it. Assuming the value of LocalExtension is 5001, the Dial() command will look like: Dial(alice,,k)
 same => n,Dial(PJSIP/alice)
 same => n,Hangup()

[parkedcallstimeout]
exten => s,1,NoOp(This is all that happens to parked calls if they time out.)
 same => n,Playback(vm-goodbye)
 same => n,Hangup()

```

