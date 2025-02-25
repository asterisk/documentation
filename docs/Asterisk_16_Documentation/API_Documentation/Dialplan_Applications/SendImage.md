---
search:
  boost: 0.5
title: SendImage
---

# SendImage()

### Synopsis

Sends an image file.

### Description

Send an image file on a channel supporting it.<br>

Result of transmission will be stored in **SENDIMAGESTATUS**<br>


* `SENDIMAGESTATUS`

    * `SUCCESS` - Transmission succeeded.

    * `FAILURE` - Transmission failed.

    * `UNSUPPORTED` - Image transmission not supported by channel.

### Syntax


```

SendImage(filename)
```
##### Arguments


* `filename` - Path of the filename (image) to send.<br>

### See Also

* [Dialplan Applications SendText](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendText)
* [Dialplan Applications SendURL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendURL)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 