---
search:
  boost: 0.5
title: CreateConfig
---

# CreateConfig

### Synopsis

Creates an empty file in the configuration directory.

### Description

This action will create an empty file in the configuration directory. This action is intended to be used before an UpdateConfig action.<br>


### Syntax


```


    Action: CreateConfig
    ActionID: <value>
    Filename: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Filename` - The configuration filename to create (e.g. *foo.conf*).<br>

### See Also

* [AMI Actions GetConfig](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/GetConfig)
* [AMI Actions GetConfigJSON](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/GetConfigJSON)
* [AMI Actions UpdateConfig](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/UpdateConfig)
* [AMI Actions ListCategories](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/ListCategories)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 