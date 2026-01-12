---
search:
  boost: 0.5
title: SHA1
---

# SHA1()

### Synopsis

Computes a SHA1 digest.

### Description

Generate a SHA1 digest via the SHA1 algorythm.<br>

``` title="Example: Set sha1hash variable to SHA1 hash of junky"

exten => s,1,Set(sha1hash=${SHA1(junky)})


```
The example above sets the asterisk variable sha1hash to the string '60fa5675b9303eb62f99a9cd47f9f5837d18f9a0' which is known as its hash<br>


### Syntax


```

SHA1(data)
```
##### Arguments


* `data` - Input string<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 