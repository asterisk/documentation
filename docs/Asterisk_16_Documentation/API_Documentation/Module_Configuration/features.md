---
search:
  boost: 0.5
title: features
---

# features: Features Configuration

This configuration documentation is for functionality provided by features.

## Configuration File: features.conf

### [globals]: 

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [atxferabort](#atxferabort)| Custom| *1| false| Digits to dial to abort an attended transfer attempt| |
| atxfercallbackretries| Custom| 2| false| Number of times to re-attempt dialing a transfer destination| |
| [atxfercomplete](#atxfercomplete)| Custom| *2| false| Digits to dial to complete an attended transfer| |
| [atxferdropcall](#atxferdropcall)| Custom| 0| false| Hang up the call entirely if the attended transfer fails| |
| atxferloopdelay| Custom| 10| false| Seconds to wait between attempts to re-dial transfer destination| |
| atxfernoanswertimeout| Custom| 15| false| Seconds to wait for attended transfer destination to answer| |
| [atxferswap](#atxferswap)| Custom| *4| false| Digits to dial to toggle who the transferrer is currently bridged to during an attended transfer| |
| [atxferthreeway](#atxferthreeway)| Custom| *3| false| Digits to dial to change an attended transfer into a three-way call| |
| courtesytone| Custom| | false| Sound to play when automon or automixmon is activated| |
| featuredigittimeout| Custom| 1000| false| Milliseconds allowed between digit presses when entering a feature code.| |
| [pickupexten](#pickupexten)| Custom| *8| false| Digits used for picking up ringing calls| |
| pickupfailsound| Custom| | false| Sound to play to picker when a call cannot be picked up| |
| pickupsound| Custom| | false| Sound to play to picker when a call is picked up| |
| recordingfailsound| Custom| | false| Sound to play when automon or automixmon is attempted but fails to start| |
| transferannouncesound| Custom| pbx-transfer| false| Sound that is played to the transferer when a transfer is initiated. If empty, no sound will be played.| |
| transferdialattempts| Custom| 3| false| Number of dial attempts allowed when attempting a transfer| |
| transferdigittimeout| Custom| 3| false| Seconds allowed between digit presses when dialing a transfer destination| |
| transferinvalidsound| Custom| privacy-incorrect| false| Sound that is played when an incorrect extension is dialed and the transferer has no attempts remaining.| |
| transferretrysound| Custom| pbx-invalid| false| Sound that is played when an incorrect extension is dialed and the transferer should try again.| |
| xferfailsound| Custom| beeperr| false| Sound to play to a transferee when a transfer fails| |
| [xfersound](#xfersound)| Custom| beep| false| Sound to play to during transfer and transfer-like operations.| |


#### Configuration Option Descriptions

##### atxferabort

This option is only available to the transferrer during an attended transfer operation. Aborting a transfer results in the transfer being cancelled and the original parties in the call being re-bridged.<br>


##### atxfercomplete

This option is only available to the transferrer during an attended transfer operation. Completing the transfer with a DTMF sequence is functionally equivalent to hanging up the transferrer channel during an attended transfer. The result is that the transfer target and transferees are bridged.<br>


##### atxferdropcall

When this option is set to 'no', then Asterisk will attempt to re-call the transferrer if the call to the transfer target fails. If the call to the transferrer fails, then Asterisk will wait _atxferloopdelay_ milliseconds and then attempt to dial the transfer target again. This process will repeat until _atxfercallbackretries_ attempts to re-call the transferrer have occurred.<br>

When this option is set to 'yes', then Asterisk will not attempt to re-call the transferrer if the call to the transfer target fails. Asterisk will instead hang up all channels involved in the transfer.<br>


##### atxferswap

This option is only available to the transferrer during an attended transfer operation. Pressing this DTMF sequence will result in the transferrer swapping which party he is bridged with. For instance, if the transferrer is currently bridged with the transfer target, then pressing this DTMF sequence will cause the transferrer to be bridged with the transferees.<br>


##### atxferthreeway

This option is only available to the transferrer during an attended transfer operation. Pressing this DTMF sequence will result in the transferrer, the transferees, and the transfer target all being in a single bridge together.<br>


##### pickupexten

In order for the pickup attempt to be successful, the party attempting to pick up the call must either have a _namedpickupgroup_ in common with a ringing party's _namedcallgroup_ or must have a _pickupgroup_ in common with a ringing party's _callgroup_.<br>


##### xfersound

This sound will play to the transferrer and transfer target channels when an attended transfer completes. This sound is also played to channels when performing an AMI 'Bridge' action.<br>


### [featuremap]: DTMF options that can be triggered during bridged calls

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [atxfer](#atxfer)| Custom| | false| DTMF sequence to initiate an attended transfer| |
| [automixmon](#automixmon)| Custom| | false| DTMF sequence to start or stop MixMonitor on a call| |
| [automon](#automon)| Custom| | false| DTMF sequence to start or stop Monitor on a call| |
| [blindxfer](#blindxfer)| Custom| #| false| DTMF sequence to initiate a blind transfer| |
| [disconnect](#disconnect)| Custom| *| false| DTMF sequence to disconnect the current call| |
| [parkcall](#parkcall)| Custom| | false| DTMF sequence to park a call| |


#### Configuration Option Descriptions

##### atxfer

The transferee parties will be placed on hold and the transferrer may dial an extension to reach a transfer target. During an attended transfer, the transferrer may consult with the transfer target before completing the transfer. Once the transferrer has hung up or pressed the _atxfercomplete_ DTMF sequence, then the transferees and transfer target will be bridged.<br>


##### automixmon

This will cause the channel that pressed the DTMF sequence to be monitored by the 'MixMonitor' application. The format for the recording is determined by the _TOUCH\_MIXMONITOR\_FORMAT_ channel variable. If this variable is not specified, then 'wav' is the default. The filename is constructed in the following manner:<br>

prefix-timestamp-suffix.fmt<br>

where prefix is either the value of the _TOUCH\_MIXMONITOR\_PREFIX_ channel variable or 'auto' if the variable is not set. The timestamp is a UNIX timestamp. The suffix is either the value of the _TOUCH\_MIXMONITOR_ channel variable or the callerID of the channels if the variable is not set.<br>


##### automon

This will cause the channel that pressed the DTMF sequence to be monitored by the 'Monitor' application. The format for the recording is determined by the _TOUCH\_MONITOR\_FORMAT_ channel variable. If this variable is not specified, then 'wav' is the default. The filename is constructed in the following manner:<br>

prefix-timestamp-suffix.fmt<br>

where prefix is either the value of the _TOUCH\_MONITOR\_PREFIX_ channel variable or 'auto' if the variable is not set. The timestamp is a UNIX timestamp. The suffix is either the value of the _TOUCH\_MONITOR_ channel variable or the callerID of the channels if the variable is not set.<br>


##### blindxfer

The transferee parties will be placed on hold and the transferrer may dial an extension to reach a transfer target. During a blind transfer, as soon as the transfer target is dialed, the transferrer is hung up.<br>


##### disconnect

Entering this DTMF sequence will cause the bridge to end, no matter the number of parties present<br>


##### parkcall

The parking lot used to park the call is determined by using either the _PARKINGLOT_ channel variable or a configured value on the channel (provided by the channel driver) if the variable is not present. If no configured value on the channel is present, then '"default"' is used. The call is parked in the next available space in the parking lot.<br>


### [applicationmap]: Section for defining custom feature invocations during a call

The applicationmap is an area where new custom features can be created. Items defined in the applicationmap are not automatically accessible to bridged parties. Access to the individual items is controled using the _DYNAMIC\_FEATURES_ channel variable. The _DYNAMIC\_FEATURES_ is a '#' separated list of either applicationmap item names or featuregroup names.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| | Custom| | false| A custom feature to invoke during a bridged call| |


#### Configuration Option Descriptions

##### 

Each item listed here is a comma-separated list of parameters that determine how a feature may be invoked during a call<br>

Example:<br>

eggs = *5,self,Playback(hello-world),default<br>

This would create a feature called 'eggs' that could be invoked during a call by pressing the '*5'. The party that presses the DTMF sequence would then trigger the 'Playback' application to play the 'hello-world' file. The application invocation would happen on the party that pressed the DTMF sequence since 'self' is specified. The other parties in the bridge would hear the 'default' music on hold class during the playback.<br>

In addition to the syntax outlined in this documentation, a backwards-compatible alternative is also allowed. The following applicationmap lines are functionally identical:<br>

eggs = *5,self,Playback(hello-world),default<br>

eggs = *5,self,Playback,hello-world,default<br>

eggs = *5,self,Playback,"hello-world",default<br>


### [featuregroup]: Groupings of items from the applicationmap

Feature groups allow for multiple applicationmap items to be grouped together. Like with individual applicationmap items, feature groups can be part of the _DYNAMIC\_FEATURES_ channel variable. In addition to creating groupings, the feature group section allows for the DTMF sequence used to invoke an applicationmap item to be overridden with a different sequence.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| | Custom| | false| Applicationmap item to place in the feature group| |


#### Configuration Option Descriptions

##### 

Each item here must be a name of an item in the applicationmap. The argument may either be a new DTMF sequence to use for the item or it may be left blank in order to use the DTMF sequence specified in the applicationmap. For example:<br>

eggs => *1<br>

bacon =><br>

would result in the applicationmap items 'eggs' and 'bacon' being in the featuregroup. The former would have its default DTMF trigger overridden with '*1' and the latter would have the DTMF value specified in the applicationmap.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 