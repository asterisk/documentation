---
search:
  boost: 0.5
title: ReceiveFAX
---

# ReceiveFAX() - [res_fax\]

### Synopsis

Receive a FAX and save as a TIFF/F file.

### Description

This application is provided by res\_fax, which is a FAX technology agnostic module that utilizes FAX technology resource modules to complete a FAX transmission.<br>

Session arguments can be set by the FAXOPT function and to check results of the ReceiveFAX() application.<br>


### Syntax


```

ReceiveFAX(filename,[options])
```
##### Arguments


* `filename`

* `options`

    * `d` - Enable FAX debugging.<br>


    * `f` - Allow audio fallback FAX transfer on T.38 capable channels.<br>


    * `F` - Force usage of audio mode on T.38 capable channels.<br>


    * `s` - Send progress Manager events (overrides statusevents setting in res\_fax.conf).<br>


### See Also

* [Dialplan Functions FAXOPT](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/FAXOPT)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 