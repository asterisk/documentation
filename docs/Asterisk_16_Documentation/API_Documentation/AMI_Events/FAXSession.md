---
search:
  boost: 0.5
title: FAXSession
---

# FAXSession

### Synopsis

Raised in response to FAXSession manager command

### Syntax


```


    Event: FAXSession
    [ActionID:] <value>
    SessionNumber: <value>
    Operation: <value>
    State: <value>
    [ErrorCorrectionMode:] <value>
    [DataRate:] <value>
    [ImageResolution:] <value>
    [PageNumber:] <value>
    [FileName:] <value>
    [PagesTransmitted:] <value>
    [PagesReceived:] <value>
    [TotalBadLines:] <value>

```
##### Arguments


* `ActionID`

* `SessionNumber` - The numerical identifier for this particular session<br>

* `Operation` - FAX session operation type<br>

    * `gateway`

    * `V.21`

    * `send`

    * `receive`

    * `none`

* `State` - Current state of the FAX session<br>

    * `Uninitialized`

    * `Initialized`

    * `Open`

    * `Active`

    * `Complete`

    * `Reserved`

    * `Inactive`

    * `Unknown`

* `ErrorCorrectionMode` - Whether error correcting mode is enabled for the FAX session. This field is not included when operation is 'V.21 Detect' or if operation is 'gateway' and state is 'Uninitialized'<br>

    * `yes`

    * `no`

* `DataRate` - Bit rate of the FAX. This field is not included when operation is 'V.21 Detect' or if operation is 'gateway' and state is 'Uninitialized'.<br>

* `ImageResolution` - Resolution of each page of the FAX. Will be in the format of X\_RESxY\_RES. This field is not included if the operation is anything other than Receive/Transmit.<br>

* `PageNumber` - Current number of pages transferred during this FAX session. May change as the FAX progresses. This field is not included when operation is 'V.21 Detect' or if operation is 'gateway' and state is 'Uninitialized'.<br>

* `FileName` - Filename of the image being sent/received for this FAX session. This field is not included if Operation isn't 'send' or 'receive'.<br>

* `PagesTransmitted` - Total number of pages sent during this session. This field is not included if Operation isn't 'send' or 'receive'. Will always be 0 for 'receive'.<br>

* `PagesReceived` - Total number of pages received during this session. This field is not included if Operation is not 'send' or 'receive'. Will be 0 for 'send'.<br>

* `TotalBadLines` - Total number of bad lines sent/received during this session. This field is not included if Operation is not 'send' or 'received'.<br>

### Class

REPORTING

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 