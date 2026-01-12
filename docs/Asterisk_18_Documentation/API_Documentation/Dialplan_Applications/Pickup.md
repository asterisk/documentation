---
search:
  boost: 0.5
title: Pickup
---

# Pickup()

### Synopsis

Directed extension call pickup.

### Description

This application can pickup a specified ringing channel. The channel to pickup can be specified in the following ways.<br>

1) If no _extension_ targets are specified, the application will pickup a channel matching the pickup group of the requesting channel.<br>

2) If the _extension_ is specified with a _context_ of the special string 'PICKUPMARK' (for example 10@PICKUPMARK), the application will pickup a channel which has defined the channel variable 'PICKUPMARK' with the same value as _extension_ (in this example, '10').<br>

3) If the _extension_ is specified with or without a _context_, the channel with a matching _extension_ and _context_ will be picked up. If no _context_ is specified, the current context will be used.<br>


/// note
The _extension_ is typically set on matching channels by the dial application that created the channel. The _context_ is set on matching channels by the channel driver for the device.
///


### Syntax


```

Pickup(extension&[extension2[&...]])
```
##### Arguments


* `targets`

    * `extension` **required** - Specification of the pickup target.<br>

        * `extension` **required**

        * `context`

    * `extension2[,extension2...]` - Additional specifications of pickup targets.<br>

        * `extension2` **required**

        * `context2`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 