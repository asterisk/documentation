---
search:
  boost: 0.5
title: Echo
---

# Echo()

### Synopsis

Echo media, DTMF back to the calling party

### Description

Echos back any media or DTMF frames read from the calling channel back to itself. This will not echo CONTROL, MODEM, or NULL frames. Note: If '#' detected application exits.<br>

This application does not automatically answer and should be preceeded by an application such as Answer() or Progress().<br>


### Syntax


```

Echo()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 