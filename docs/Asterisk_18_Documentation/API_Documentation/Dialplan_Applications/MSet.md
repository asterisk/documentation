---
search:
  boost: 0.5
title: MSet
---

# MSet()

### Synopsis

Set channel variable(s) or function value(s).

### Description

This function can be used to set the value of channel variables or dialplan functions. When setting variables, if the variable name is prefixed with '\_', the variable will be inherited into channels created from the current channel If the variable name is prefixed with '\_\_', the variable will be inherited into channels created from the current channel and all children channels. MSet behaves in a similar fashion to the way Set worked in 1.2/1.4 and is thus prone to doing things that you may not expect. For example, it strips surrounding double-quotes from the right-hand side (value). If you need to put a separator character (comma or vert-bar), you will need to escape them by inserting a backslash before them. Avoid its use if possible.<br>

This application allows up to 99 variables to be set at once.<br>


### Syntax


```

MSet(name1=value1,name2=value2)
```
##### Arguments


* `set1`

    * `name1` **required**

    * `value1` **required**

* `set2`

    * `name2` **required**

    * `value2` **required**

### See Also

* [Dialplan Applications Set](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Set)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 