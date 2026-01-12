---
search:
  boost: 0.5
title: FAXSessionsEntry
---

# FAXSessionsEntry

### Synopsis

A single list item for the FAXSessions AMI command

### Syntax


```


Event: FAXSessionsEntry
[ActionID: <value>]
Channel: <value>
Technology: <value>
SessionNumber: <value>
SessionType: <value>
Operation: <value>
State: <value>
Files: <value>

```
##### Arguments


* `ActionID`

* `Channel` - Name of the channel responsible for the FAX session<br>

* `Technology` - The FAX technology that the FAX session is using<br>

* `SessionNumber` - The numerical identifier for this particular session<br>

* `SessionType` - FAX session passthru/relay type<br>

    * `G.711`

    * `T.38`

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

* `Files` - File or list of files associated with this FAX session<br>

### Class

REPORTING

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 