---
search:
  boost: 0.5
title: MinivmDelete
---

# MinivmDelete()

### Synopsis

Delete Mini-Voicemail voicemail messages.

### Description

This application is part of the Mini-Voicemail system, configured in *minivm.conf*.<br>

It deletes voicemail file set in MVM\_FILENAME or given filename.<br>


* `MVM_DELETE_STATUS` - This is the status of the delete operation.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

MinivmDelete(filename)
```
##### Arguments


* `filename` - File to delete<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 