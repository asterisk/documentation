---
search:
  boost: 0.5
title: GROUP_MATCH_COUNT
---

# GROUP_MATCH_COUNT()

### Synopsis

Counts the number of channels in the groups matching the specified pattern.

### Description

Calculates the group count for all groups that match the specified pattern. Note: category matching is applied after matching based on group. Uses standard regular expression matching on both (see regex(7)).<br>


### Syntax


```

GROUP_MATCH_COUNT(groupmatch@category)
```
##### Arguments


* `groupmatch` - A standard regular expression used to match a group name.<br>

* `category` - A standard regular expression used to match a category name.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 