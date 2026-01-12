---
search:
  boost: 0.5
title: FAXOPT
---

# FAXOPT() - [res_fax\]

### Synopsis

Gets/sets various pieces of information about a fax session.

### Description

FAXOPT can be used to override the settings for a FAX session listed in *res\_fax.conf*, it can also be used to retrieve information about a FAX session that has finished eg. pages/status.<br>


### Syntax


```

FAXOPT(item)
```
##### Arguments


* `item`

    * `ecm` - R/W Error Correction Mode (ECM) enable with 'yes', disable with 'no'.<br>

    * `error` - R/O FAX transmission error code upon failure.<br>

    * `filename` - R/O Filename of the first file of the FAX transmission.<br>

    * `filenames` - R/O Filenames of all of the files in the FAX transmission (comma separated).<br>

    * `headerinfo` - R/W FAX header information.<br>

    * `localstationid` - R/W Local Station Identification.<br>

    * `minrate` - R/W Minimum transfer rate set before transmission.<br>

    * `maxrate` - R/W Maximum transfer rate set before transmission.<br>

    * `modem` - R/W Modem type (v17/v27/v29).<br>

    * `gateway` - R/W T38 fax gateway, with optional fax activity timeout in seconds (yes\[,timeout\]/no)<br>

    * `faxdetect` - R/W Enable FAX detect with optional timeout in seconds (yes,t38,cng\[,timeout\]/no)<br>

    * `pages` - R/O Number of pages transferred.<br>

    * `rate` - R/O Negotiated transmission rate.<br>

    * `remotestationid` - R/O Remote Station Identification after transmission.<br>

    * `resolution` - R/O Negotiated image resolution after transmission.<br>

    * `sessionid` - R/O Session ID of the FAX transmission.<br>

    * `status` - R/O Result Status of the FAX transmission.<br>

    * `statusstr` - R/O Verbose Result Status of the FAX transmission.<br>

    * `t38timeout` - R/W The timeout used for T.38 negotiation.<br>

    * `negotiate_both` - R/W Upon v21 detection allow gateway to send negotiation requests to both T.38 endpoints, and do not wait on the "other" side to initiate (yes|no)<br>

### See Also

* [Dialplan Applications ReceiveFAX](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/ReceiveFAX)
* [Dialplan Applications SendFAX](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SendFAX)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 