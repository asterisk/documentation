---
search:
  boost: 0.5
title: STRPTIME
---

# STRPTIME()

### Synopsis

Returns the epoch of the arbitrary date/time string structured as described by the format.

### Description

This is useful for converting a date into 'EPOCH' time, possibly to pass to an application like SayUnixTime or to calculate the difference between the two date strings<br>

``` title="Example: Prints 1141219835"

same => n,NoOp(${STRPTIME(2006-03-01 07:30:35,America/Chicago,%Y-%m-%d %H:%M:%S)})


```

### Syntax


```

STRPTIME(datetime,timezone,format)
```
##### Arguments


* `datetime`

* `timezone`

* `format`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 