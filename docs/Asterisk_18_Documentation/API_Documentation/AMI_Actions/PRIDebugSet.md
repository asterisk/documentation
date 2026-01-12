---
search:
  boost: 0.5
title: PRIDebugSet
---

# PRIDebugSet

### Synopsis

Set PRI debug levels for a span

### Description

Equivalent to the CLI command "pri set debug <level> span <span>".<br>


### Syntax


```


Action: PRIDebugSet
ActionID: <value>
Span: <value>
Level: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Span` - Which span to affect.<br>

* `Level` - What debug level to set. May be a numerical value or a text value from the list below<br>

    * `off`

    * `on`

    * `hex`

    * `intense`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 