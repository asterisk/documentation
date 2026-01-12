---
search:
  boost: 0.5
title: AST_CONFIG
---

# AST_CONFIG()

### Synopsis

Retrieve a variable from a configuration file.

### Description

This function reads a variable from an Asterisk configuration file.<br>


### Syntax


```

AST_CONFIG(config_file,category,variable_name[,index])
```
##### Arguments


* `config_file`

* `category`

* `variable_name`

* `index` - If there are multiple variables with the same name, you can specify '0' for the first item (default), '-1' for the last item, or any other number for that specific item. '-1' is useful when the variable is derived from a template and you want the effective value (the last occurrence), not the value from the template (the first occurrence).<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 