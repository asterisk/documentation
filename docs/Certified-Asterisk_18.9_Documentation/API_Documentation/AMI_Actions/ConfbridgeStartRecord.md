---
search:
  boost: 0.5
title: ConfbridgeStartRecord
---

# ConfbridgeStartRecord

### Synopsis

Start recording a Confbridge conference.

### Description

Start recording a conference. If recording is already present an error will be returned. If RecordFile is not provided, the default record file specified in the conference's bridge profile will be used, if that is not present either a file will automatically be generated in the monitor directory.<br>


### Syntax


```


Action: ConfbridgeStartRecord
ActionID: <value>
Conference: <value>
[RecordFile: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Conference`

* `RecordFile`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 