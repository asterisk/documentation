---
search:
  boost: 0.5
title: res_parking
---

# res_parking

This configuration documentation is for functionality provided by res_parking.

## Configuration File: res_parking.conf

### [globals]: Options that apply to every parking lot

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [parkeddynamic](#parkeddynamic)| Boolean| no| false| Enables dynamically created parkinglots.| |


#### Configuration Option Descriptions

##### parkeddynamic

If the option is enabled then the following variables can be used to dynamically create new parking lots.<br>

The **PARKINGDYNAMIC** variable specifies the parking lot to use as a template to create a dynamic parking lot. It is an error to specify a non-existent parking lot for the template. If not set then the default parking lot is used as the template.<br>

The **PARKINGDYNCONTEXT** variable specifies the dialplan context to use for the newly created dynamic parking lot. If not set then the context from the parking lot template is used. The context is created if it does not already exist and the new parking lot needs to create extensions.<br>

The **PARKINGDYNEXTEN** variable specifies the 'parkext' to use for the newly created dynamic parking lot. If not set then the 'parkext' is used from the parking lot template. If the template does not specify a 'parkext' then no extensions are created for the newly created parking lot. The dynamic parking lot cannot be created if it needs to create extensions that overlap existing parking lot extensions. The only exception to this is for the 'parkext' extension and only if neither of the overlaping parking lot's 'parkext' is exclusive.<br>

The **PARKINGDYNPOS** variable specifies the parking positions to use for the newly created dynamic parking lot. If not set then the 'parkpos' from the parking lot template is used.<br>


### [parking_lot]: Defined parking lots for res_parking to use to park calls on

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [comebackcontext](#comebackcontext)| String| parkedcallstimeout| false| Context where parked calls will enter the PBX on timeout when comebacktoorigin=no| |
| comebackdialtime| Unsigned Integer| 30| false| Timeout for the Dial extension created to call back the parker when a parked call times out.| |
| [comebacktoorigin](#comebacktoorigin)| Boolean| yes| false| Determines what should be done with the parked channel if no one picks it up before it times out.| |
| [context](#context)| String| parkedcalls| false| The name of the context where calls are parked and picked up from.| |
| [courtesytone](#courtesytone)| String| | false| If the name of a sound file is provided, use this as the courtesy tone| |
| [findslot](#findslot)| Custom| first| false| Rule to use when trying to figure out which parking space a call should be parked with.| |
| [parkedcallhangup](#parkedcallhangup)| Custom| no| false| Who to apply the DTMF hangup feature to when parked calls are picked up or timeout.| |
| [parkedcallrecording](#parkedcallrecording)| Custom| no| false| Who to apply the DTMF MixMonitor recording feature to when parked calls are picked up or timeout.| |
| [parkedcallreparking](#parkedcallreparking)| Custom| no| false| Who to apply the DTMF parking feature to when parked calls are picked up or timeout.| |
| [parkedcalltransfers](#parkedcalltransfers)| Custom| no| false| Who to apply the DTMF transfer features to when parked calls are picked up or timeout.| |
| parkedmusicclass| String| | false| Which music class to use for parked calls. They will use the default if unspecified.| |
| [parkedplay](#parkedplay)| Custom| caller| false| Who we should play the courtesytone to on the pickup of a parked call from this lot| |
| [parkext](#parkext)| String| | false| Extension to park calls to this parking lot.| |
| parkext_exclusive| Boolean| no| false| If yes, the extension registered as parkext will park exclusively to this parking lot.| |
| parkinghints| Boolean| no| false| If yes, this parking lot will add hints automatically for parking spaces.| |
| parkingtime| Unsigned Integer| 45| false| Amount of time a call will remain parked before giving up (in seconds).| |
| [parkpos](#parkpos)| Custom| 701-750| false| Numerical range of parking spaces which can be used to retrieve parked calls.| |


#### Configuration Option Descriptions

##### comebackcontext

The extension the call enters will prioritize the flattened peer name in this context. If the flattened peer name extension is unavailable, then the 's' extension in this context will be used. If that also is unavailable, the 's' extension in the 'default' context will be used.<br>


##### comebacktoorigin

Valid Options:<br>


* `yes` - Automatically have the parked channel dial the device that parked the call with dial timeout set by the 'parkingtime' option. When the call times out an extension to dial the PARKER will automatically be created in the 'park-dial' context with an extension of the flattened parker device name. If the call is not answered, the parked channel that is timing out will continue in the dial plan at that point if there are more priorities in the extension (which won't be the case unless the dialplan deliberately includes such priorities in the 'park-dial' context through pattern matching or deliberately written flattened peer extensions).<br>

* `no` - Place the call into the PBX at 'comebackcontext' instead. The extension will still be set as the flattened peer name. If an extension the flattened peer name isn't available then it will fall back to the 's' extension. If that also is unavailable it will attempt to fall back to 's@default'. The normal dial extension will still be created in the 'park-dial' context with the extension also being the flattened peer name.<br>

/// note
Flattened Peer Names - Extensions can not include slash characters since those are used for pattern matching. When a peer name is flattened, slashes become underscores. For example if the parker of a call is called 'SIP/0004F2040001' then flattened peer name and therefor the extensions created and used on timeouts will be 'SIP\_0004F204001'.
///


/// note
When parking times out and the channel returns to the dial plan, the following variables are set:
///


* `PARKING_SPACE` - extension that the call was parked in prior to timing out.<br>

* `PARKEDLOT` - name of the lot that the call was parked in prior to timing out.<br>

* `PARKER` - The device that parked the call<br>

* `PARKER_FLAT` - The flat version of **PARKER**<br>

##### context

This option is only used if parkext is set.<br>


##### courtesytone

By default, this tone is only played to the caller of a parked call. Who receives the tone can be changed using the 'parkedplay' option.<br>


##### findslot


* `first` - Always try to place in the lowest available space in the parking lot<br>

* `next` - Track the last parking space used and always attempt to use the one immediately after.<br>

##### parkedcallhangup


* `no` - Apply to neither side.<br>

* `caller` - Apply only to the call connecting with the call coming out of the parking lot.<br>

* `callee` - Apply only to the call coming out of the parking lot.<br>

* `both` - Apply to both sides.<br>

##### parkedcallrecording


* `no` - Apply to neither side.<br>

* `caller` - Apply only to the call connecting with the call coming out of the parking lot.<br>

* `callee` - Apply only to the call coming out of the parking lot.<br>

* `both` - Apply to both sides.<br>

##### parkedcallreparking


* `no` - Apply to neither side.<br>

* `caller` - Apply only to the call connecting with the call coming out of the parking lot.<br>

* `callee` - Apply only to the call coming out of the parking lot.<br>

* `both` - Apply to both sides.<br>

##### parkedcalltransfers


* `no` - Apply to neither side.<br>

* `caller` - Apply only to the call connecting with the call coming out of the parking lot.<br>

* `callee` - Apply only to the call coming out of the parking lot.<br>

* `both` - Apply to both sides.<br>

##### parkedplay


* `no` - Apply to neither side.<br>

* `caller` - Apply only to the call connecting with the call coming out of the parking lot.<br>

* `callee` - Apply only to the call coming out of the parking lot.<br>

* `both` - Apply to both sides.<br>

/// note
If courtesy tone is not specified then this option will be ignored.
///


##### parkext

If this option is used, this extension will automatically be created to place calls into parking lots. In addition, if 'parkext\_exclusive' is set for this parking lot, the name of the parking lot will be included in the application's arguments so that it only parks to this parking lot. The extension will be created in 'context'. Using this option also creates extensions for retrieving parked calls from the parking spaces in the same context.<br>


/// note
Generated parking extensions cannot overlap. The only exception is if neither overlapping 'parkext' is exclusive.
///


##### parkpos

If 'parkext' is set, these extensions will automatically be mapped in 'context' in order to pick up calls parked to these parking spaces.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 