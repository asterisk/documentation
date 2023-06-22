---
title: Asterisk 12 Bridging Use Cases
pageid: 22088050
---

The following are use cases for Bridging in Asterisk. These are written at a very high level, so details regarding the specific mechanism that causes a Bridge to be created may be implied.




!!! note Note
    Unless otherwise specified, it is assumed that all channels are hung up, resources disposed of, and the bridge destroyed at the end of any use case.

      
[//]: # (end-note)



Two Party Bridging
==================


Basic Bridging
--------------


### Core Bridging, Alice initiates hang up


* Alice calls Bob using a configuration that does not allow for native bridging
* Bob Answers and Alice and Bob enter a bridge
* Alice and Bob can both converse with each other
* Alice hangs up
* Bob is hung up on


### Core Bridging, Bob initiates hang up


* Alice calls Bob using a configuration that does not allow for native bridging
* Bob Answers and Alice and Bob enter a bridge
* Alice and Bob can both converse with each other
* Bob hangs up
* Alice is hung up on


### Native Bridging, Alice initiates hang up


* Alice calls Bob using a configuration allows for native bridging
* Bob Answers and Alice and Bob enter a bridge
* Alice and Bob can both converse with each other
* Alice hangs up
* Bob is hung up on


### Native Bridging, Bob initiates hang up


* Alice calls Bob using a configuration that allows for native bridging
* Bob Answers and Alice and Bob enter a bridge
* Alice and Bob can both converse with each other
* Bob hangs up
* Alice is hung up on


Mid-Call Events
---------------


### Party Identification


#### Connected Line Update


* Alice calls Bob
* Bob Answers and Alice and Bob enter a bridge
* Alice causes a connected line update to be sent to Bob
* Bob causes a connected line update to be sent to Alice
* The party identification information for both Alice and Bob is changed.
* Alice hangs up.
* Bob is hung up on.


#### Redirecting Update


* Alice calls Bob
* Bob Answers and Alice and Bob enter a bridge
* Alice causes a redirecting update to be sent to Bob
* Bob causes a redirecting update to be sent to Alice
* Alice hangs up.
* Bob is hung up on.


### Timed Features


#### Timed Call


* Alice calls Bob using an application that warns periodically throughout the call when there is time `T` left in the call and causing the call to end after time `H`
* Bob Answers and Alice and Bob enter a bridge
* Warnings are played to Alice and Bob when there is time `T` left in the call
* Warnings are repeated based on the configured interval
* The call ends after `H` time has elapsed
* Both Bob and Alice are hung up on.


#### Call Time Limit


* Alice calls Bob using an application that terminates the call after `H` time
* Bob Answers and Alice and Bob enter a bridge
* The call ends after `H` time has elapsed
* Both Bob and Alice are hung up on


DTMF Features
=============




!!! note Note
    1. For each DTMF initiated feature, it should be assumed that unless otherwise specified, the option only has an effect on the specified party. Thus, if a feature applies to the caller, the callee should **not** be able to use the feature.
    2. If the feature can be initiated by one party, then a configuration item exists to have it initiated by the other party as well. For example, if a caller can initiate a feature because of a configuration parameter, then another configuration parameter exists that lets the callee initiate the same feature.
    3. DTMF features are not specific to two-party calls, unless otherwise noted.


      
[//]: # (end-note)



DTMF Disconnect
---------------


* Alice calls Bob using an application to allow DTMF disconnect by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice attempts to disconnect the call by pressing the appropriate DTMF
* Both Bob and Alice are hung up on


Auto-Monitor and Auto-MixMonitor
--------------------------------


### Auto-Monitor


* Alice calls Bob using an application that allows DTMF initiation of Auto-Monitor by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Auto-Monitor key to record the call
* Monitor recording begins
* Alice presses the configured Auto-Monitor key to end recording
* Monitor recording ends
* Alice hangs up
* Bob is hung up on


### Auto-MixMonitor


* Alice calls Bob using an application that allows DTMF initiation of Auto-MixMonitor by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Auto-MixMonitor key to record the call
* MixMonitor recording begins
* Alice presses the configured Auto-MixMonitor key to end recording
* MixMonitor recording ends
* Alice hangs up
* Bob is hung up on


### One Touch Parking


* Alice calls Bob using an application that allows DTMF initiation of Parking by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Parking key to park Bob
* Bob is parked
* Alice hangs up
* Bob hangs up


Transfers
---------


### Blind Transfer


* Alice dials Bob using an application that allows Blind Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Blind Transfer key
* Alice enters the extension to transfer Bob to
* Bob is ejected from the bridge and executes the dialplan at the specified location
* Alice is hung up on


### Attended Transfer - Party


* Alice dials Bob using an application that allows Attended Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Attended Transfer key
* Alice enters the extension to transfer Bob to
* Bob is put on Hold
* Alice executes dialplan at the extension to transfer Bob to
* Alice dials Charlie
* Charlie Answers Alice
* Alice and Charlie are placed in the same bridge
* Alice completes the attended transfer
* Bob is taken off Hold
* Bob and Charlie are bridged together
* Alice is hung up on


### Attended Transfer - Application


* Alice dials Bob using an application that allows Attended Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Attended Transfer key
* Alice enters the extension to transfer Bob to
* Bob is put on Hold
* Alice executes dialplan at the extension to transfer Bob to
* Alice enters into an Application
* Alice completes the attended transfer
* Bob is taken off Hold
* Bob is put into the Application at the location that Alice was at
* Alice is hung up on


### Attended Transfer to Multi-Party


* Alice dials Bob using an application that allows Attended Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Attended Transfer key
* Alice enters the extension to transfer Bob to
* Bob is put on Hold
* Alice executes dialplan at the extension to transfer Bob to
* Alice dials Charlie
* Charlie Answers Alice
* Alice and Charlie are placed in the same bridge
* Alice presses the configured Three Party key
* Bob is taken off Hold
* Alice, Bob and Charlie are bridged together
* Alice hangs up
* Bob and Charlie are hung up on


### Failed Attended Transfer - No Answer


* Alice dials Bob using an application that allows Attended Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Attended Transfer key
* Alice enters the extension to transfer Bob to
* Bob is put on Hold
* Alice executes dialplan at the extension to transfer Bob to
* Alice dials Charlie
* Charlie fails to Answer Alice
* Alice is put back into the bridge with Bob
* Bob is taken off Hold
* Alice hangs up
* Bob is hung up on


### Blonde Transfer


* Alice dials Bob using an application that allows Attended Transfers initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Attended Transfer key
* Alice enters the extension to transfer Bob to
* Bob is put on Hold
* Alice executes dialplan at the extension to transfer Bob to
* Alice dials Charlie
* Alice hangs up while Charlie is Ringing
* Charlie Answers
* Bob is taken off Hold
* Bob and Charlie are bridged together


### Transfer Timeout


* Alice dials Bob using an application that allows some kind of Transfer initiated by the caller
* Bob Answers and Alice and Bob enter a bridge
* Alice presses the configured Transfer key
* Alice does not enter an extension
* Alice is notified that the extension is invalid and remains in a bridge with Bob


