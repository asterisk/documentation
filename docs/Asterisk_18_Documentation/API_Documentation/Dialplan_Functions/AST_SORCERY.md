---
search:
  boost: 0.5
title: AST_SORCERY
---

# AST_SORCERY()

### Synopsis

Get a field from a sorcery object

### Description

### Syntax


```

AST_SORCERY(module_name,object_type,object_id,field_name[,retrieval_method[,retrieval_details]])
```
##### Arguments


* `module_name` - The name of the module owning the sorcery instance.<br>

* `object_type` - The type of object to query.<br>

* `object_id` - The id of the object to query.<br>

* `field_name` - The name of the field.<br>

* `retrieval_method` - Fields that have multiple occurrences may be retrieved in two ways.<br>

    * `concat` - Returns all matching fields concatenated in a single string separated by _separator_ which defaults to ','.<br>

    * `single` - Returns the nth occurrence of the field as specified by _occurrence\_number_ which defaults to '1'.<br>
The default is 'concat' with separator ','.<br>

* `retrieval_details` - Specifies either the separator for 'concat' or the occurrence number for 'single'.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 