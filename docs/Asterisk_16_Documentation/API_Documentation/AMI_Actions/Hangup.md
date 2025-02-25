---
search:
  boost: 0.5
title: Hangup
---

# Hangup

### Synopsis

Hangup channel.

### Description

Hangup a channel.<br>


### Syntax


```


    Action: Hangup
    ActionID: <value>
    Channel: <value>
    Cause: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The exact channel name to be hungup, or to use a regular expression, set this parameter to: /regex/<br>
Example exact channel: SIP/provider-0000012a<br>
Example regular expression: /\^SIP/provider-.*$/<br>

* `Cause` - Numeric hangup cause.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 