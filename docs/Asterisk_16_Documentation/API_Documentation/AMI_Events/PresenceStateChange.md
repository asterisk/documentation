---
search:
  boost: 0.5
title: PresenceStateChange
---

# PresenceStateChange

### Synopsis

Raised when a presence state changes

### Description

This differs from the 'PresenceStatus' event because this event is raised for all presence state changes, not only for changes that affect dialplan hints.<br>


### Syntax


```


    Event: PresenceStateChange
    Presentity: <value>
    Status: <value>
    Subtype: <value>
    Message: <value>

```
##### Arguments


* `Presentity` - The entity whose presence state has changed<br>

* `Status` - The new status of the presentity<br>

* `Subtype` - The new subtype of the presentity<br>

* `Message` - The new message of the presentity<br>

### Class

CALL
### See Also

* [AMI Events PresenceStatus](/Asterisk_16_Documentation/API_Documentation/AMI_Events/PresenceStatus)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 