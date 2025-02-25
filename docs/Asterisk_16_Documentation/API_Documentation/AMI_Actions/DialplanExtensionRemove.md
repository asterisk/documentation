---
search:
  boost: 0.5
title: DialplanExtensionRemove
---

# DialplanExtensionRemove

### Synopsis

Remove an extension from the dialplan

### Description

### Syntax


```


    Action: DialplanExtensionRemove
    ActionID: <value>
    Context: <value>
    Extension: <value>
    [Priority:] <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Context` - Context of the extension being removed<br>

* `Extension` - Name of the extension being removed (may include callerid match by separating with '/')<br>

* `Priority` - If provided, only remove this priority from the extension instead of all priorities in the extension.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 