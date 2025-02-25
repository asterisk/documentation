---
search:
  boost: 0.5
title: Milliwatt
---

# Milliwatt()

### Synopsis

Generates a 1004 Hz test tone at 0dbm (mu-law).

### Description

Generates a 1004 Hz test tone.<br>

By default, this application does not provide a Milliwatt test tone. It simply plays a 1004 Hz tone, which is not suitable for performing a milliwatt test. The 'm' option should be used so that a real Milliwatt test tone is provided. This will include a 1 second silent interval every 10 seconds.<br>

Previous versions of this application generated a constant tone at 1000 Hz. If for some reason you would prefer that behavior, supply the 'o' option to get the old behavior.<br>


### Syntax


```

Milliwatt([options])
```
##### Arguments


* `options`

    * `m` - Generate a 1004 Hz Milliwatt test tone at 0dbm, with a 1 second silent interval. This option must be specified if you are using this for a milliwatt test line.<br>


    * `o` - Generate a constant tone at 1000 Hz like previous version.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 