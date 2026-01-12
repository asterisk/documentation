---
search:
  boost: 0.5
title: SendFAX
---

# SendFAX() - [res_fax\]

### Synopsis

Sends a specified TIFF/F file as a FAX.

### Description

This application is provided by res\_fax, which is a FAX technology agnostic module that utilizes FAX technology resource modules to complete a FAX transmission.<br>

Session arguments can be set by the FAXOPT function and to check results of the SendFAX() application.<br>


### Syntax


```

SendFAX([filename2[&...]],[options])
```
##### Arguments


* `filename`

    * `filename2[,filename2...]` - TIFF file to send as a FAX.<br>

* `options`

    * `d` - Enable FAX debugging.<br>


    * `f` - Allow audio fallback FAX transfer on T.38 capable channels.<br>


    * `F` - Force usage of audio mode on T.38 capable channels.<br>


    * `s` - Send progress Manager events (overrides statusevents setting in res\_fax.conf).<br>


    * `z` - Initiate a T.38 reinvite on the channel if the remote end does not.<br>


### See Also

* [Dialplan Functions FAXOPT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/FAXOPT)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 