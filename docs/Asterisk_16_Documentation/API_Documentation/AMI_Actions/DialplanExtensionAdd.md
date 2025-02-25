---
search:
  boost: 0.5
title: DialplanExtensionAdd
---

# DialplanExtensionAdd

### Synopsis

Add an extension to the dialplan

### Description

### Syntax


```


    Action: DialplanExtensionAdd
    ActionID: <value>
    Context: <value>
    Extension: <value>
    Priority: <value>
    Application: <value>
    [ApplicationData:] <value>
    [Replace:] <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Context` - Context where the extension will be created. The context will be created if it does not already exist.<br>

* `Extension` - Name of the extension that will be created (may include callerid match by separating with '/')<br>

* `Priority` - Priority being added to this extension. Must be either 'hint' or a numerical value.<br>

* `Application` - The application to use for this extension at the requested priority<br>

* `ApplicationData` - Arguments to the application.<br>

* `Replace` - If set to 'yes', '1', 'true' or any of the other values we evaluate as true, then if an extension already exists at the requested context, extension, and priority it will be overwritten. Otherwise, the existing extension will remain and the action will fail.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 