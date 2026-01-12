---
search:
  boost: 0.5
title: GetConfig
---

# GetConfig

### Synopsis

Retrieve configuration.

### Description

This action will dump the contents of a configuration file by category and contents or optionally by specified category only. In the case where a category name is non-unique, a filter may be specified to match only categories with matching variable values.<br>


### Syntax


```


Action: GetConfig
ActionID: <value>
Filename: <value>
Category: <value>
Filter: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Filename` - Configuration filename (e.g. *foo.conf*).<br>

* `Category` - Category in configuration file.<br>

* `Filter` - A comma separated list of _name\_regex_=_value\_regex_ expressions which will cause only categories whose variables match all expressions to be considered. The special variable name 'TEMPLATES' can be used to control whether templates are included. Passing 'include' as the value will include templates along with normal categories. Passing 'restrict' as the value will restrict the operation to ONLY templates. Not specifying a 'TEMPLATES' expression results in the default behavior which is to not include templates.<br>

### See Also

* [AMI Actions GetConfigJSON](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/GetConfigJSON)
* [AMI Actions UpdateConfig](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/UpdateConfig)
* [AMI Actions CreateConfig](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/CreateConfig)
* [AMI Actions ListCategories](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/ListCategories)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 