---
search:
  boost: 0.5
title: ResetCDR
---

# ResetCDR()

### Synopsis

Resets the Call Data Record.

### Description

This application causes the Call Data Record to be reset. Depending on the flags passed in, this can have several effects. With no options, a reset does the following:<br>

1. The 'start' time is set to the current time.<br>

2. If the channel is answered, the 'answer' time is set to the current time.<br>

3. All variables are wiped from the CDR. Note that this step can be prevented with the 'v' option.<br>

On the other hand, if the 'e' option is specified, the effects of the NoCDR application will be lifted. CDRs will be re-enabled for this channel.<br>


/// note
The 'e' option is deprecated. Please use the CDR\_PROP function instead.
///


### Syntax


```

ResetCDR([options])
```
##### Arguments


* `options`

    * `v` - Save the CDR variables during the reset.<br>


    * `e` - Enable the CDRs for this channel only (negate effects of NoCDR).<br>


### See Also

* [Dialplan Applications ForkCDR](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ForkCDR)
* [Dialplan Applications NoCDR](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/NoCDR)
* [Dialplan Functions CDR_PROP](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CDR_PROP)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 