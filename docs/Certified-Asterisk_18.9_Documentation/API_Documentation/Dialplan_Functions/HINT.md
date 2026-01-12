---
search:
  boost: 0.5
title: HINT
---

# HINT()

### Synopsis

Get the devices set for a dialplan hint.

### Description

The HINT function can be used to retrieve the list of devices that are mapped to a dialplan hint.<br>

``` title="Example: Hint for extension 1234"

same => n,NoOp(Hint for Extension 1234 is ${HINT(1234)})


```

### Syntax


```

HINT(extension,options)
```
##### Arguments


* `extension`

    * `extension` **required**

    * `context`

* `options`

    * `n` - Retrieve name on the hint instead of list of devices.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 