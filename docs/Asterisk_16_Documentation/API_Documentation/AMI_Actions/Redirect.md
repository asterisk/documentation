---
search:
  boost: 0.5
title: Redirect
---

# Redirect

### Synopsis

Redirect (transfer) a call.

### Description

Redirect (transfer) a call.<br>


### Syntax


```


    Action: Redirect
    ActionID: <value>
    Channel: <value>
    ExtraChannel: <value>
    Exten: <value>
    ExtraExten: <value>
    Context: <value>
    ExtraContext: <value>
    Priority: <value>
    ExtraPriority: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel to redirect.<br>

* `ExtraChannel` - Second call leg to transfer (optional).<br>

* `Exten` - Extension to transfer to.<br>

* `ExtraExten` - Extension to transfer extrachannel to (optional).<br>

* `Context` - Context to transfer to.<br>

* `ExtraContext` - Context to transfer extrachannel to (optional).<br>

* `Priority` - Priority to transfer to.<br>

* `ExtraPriority` - Priority to transfer extrachannel to (optional).<br>

### See Also

* [AMI Actions BlindTransfer](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/BlindTransfer)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 