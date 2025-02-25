---
search:
  boost: 0.5
title: Park
---

# Park()

### Synopsis

Park yourself.

### Description

Used to park yourself (typically in combination with an attended transfer to know the parking space).<br>

If you set the **PARKINGEXTEN** variable to a parking space extension in the parking lot, Park() will attempt to park the call on that extension. If the extension is already in use then execution will continue at the next priority.<br>

If the 'parkeddynamic' option is enabled in *res\_parking.conf* the following variables can be used to dynamically create new parking lots. When using dynamic parking lots, be aware of the conditions as explained in the notes section below.<br>

The **PARKINGDYNAMIC** variable specifies the parking lot to use as a template to create a dynamic parking lot. It is an error to specify a non-existent parking lot for the template. If not set then the default parking lot is used as the template.<br>

The **PARKINGDYNCONTEXT** variable specifies the dialplan context to use for the newly created dynamic parking lot. If not set then the context from the parking lot template is used. The context is created if it does not already exist and the new parking lot needs to create extensions.<br>

The **PARKINGDYNEXTEN** variable specifies the 'parkext' to use for the newly created dynamic parking lot. If not set then the 'parkext' is used from the parking lot template. If the template does not specify a 'parkext' then no extensions are created for the newly created parking lot. The dynamic parking lot cannot be created if it needs to create extensions that overlap existing parking lot extensions. The only exception to this is for the 'parkext' extension and only if neither of the overlaping parking lot's 'parkext' is exclusive.<br>

The **PARKINGDYNPOS** variable specifies the parking positions to use for the newly created dynamic parking lot. If not set then the 'parkpos' from the parking lot template is used.<br>


/// note
This application must be used as the first extension priority to be recognized as a parking access extension for blind transfers. Blind transfers and the DTMF one-touch parking feature need this distinction to operate properly. The parking access extension in this case is treated like a dialplan hint.
///


### Syntax


```

Park([parking_lot_name,[options]])
```
##### Arguments


* `parking_lot_name` - Specify in which parking lot to park a call.<br>
The parking lot used is selected in the following order:<br>
1) parking\_lot\_name option to this application<br>
2) **PARKINGLOT** variable<br>
3) 'CHANNEL(parkinglot)' function (Possibly preset by the channel driver.)<br>
4) Default parking lot.<br>

* `options` - A list of options for this parked call.<br>

    * `r` - Send ringing instead of MOH to the parked call.<br>


    * `R` - Randomize the selection of a parking space.<br>


    * `s` - Silence announcement of the parking space number.<br>


    * `c(context,extension,priority)` - If the parking times out, go to this place in the dialplan instead of where the parking lot defines the call should go.<br>

        * `context`

        * `extension`

        * `priority` **required**


    * `t(duration)` - Use a timeout of 'duration' seconds instead of the timeout specified by the parking lot.<br>

        * `duration` **required**


### See Also

* [Dialplan Applications ParkedCall](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ParkedCall)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 