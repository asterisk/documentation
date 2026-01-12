---
search:
  boost: 0.5
title: Transfer
---

# Transfer()

### Synopsis

Transfer caller to remote extension.

### Description

Requests the remote caller be transferred to a given destination. If TECH (SIP, IAX2, etc) is used, only an incoming call with the same channel technology will be transferred. Note that for SIP, if you transfer before call is setup, a 302 redirect SIP message will be returned to the caller.<br>

The result of the application will be reported in the **TRANSFERSTATUS** channel variable:<br>


* `TRANSFERSTATUS`

    * `SUCCESS` - Transfer succeeded.

    * `FAILURE` - Transfer failed.

    * `UNSUPPORTED` - Transfer unsupported by channel driver.

* `TRANSFERSTATUSPROTOCOL`

    * `0` - No error.

    * `3XX-6XX` - SIP example - Error result code.

### Syntax


```

Transfer([Tech/destination])
```
##### Arguments


* `dest`

    * `Tech/`

    * `destination` **required**


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 