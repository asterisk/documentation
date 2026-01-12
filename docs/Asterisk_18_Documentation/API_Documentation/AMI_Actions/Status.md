---
search:
  boost: 0.5
title: Status
---

# Status

### Synopsis

List channel status.

### Description

Will return the status information of each channel along with the value for the specified channel variables.<br>


### Syntax


```


Action: Status
ActionID: <value>
[Channel: <value>]
Variables: <value>
AllVariables: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The name of the channel to query for status.<br>

* `Variables` - Comma ',' separated list of variable to include.<br>

* `AllVariables` - If set to "true", the Status event will include all channel variables for the requested channel(s).<br>

    * `true`

    * `false`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 