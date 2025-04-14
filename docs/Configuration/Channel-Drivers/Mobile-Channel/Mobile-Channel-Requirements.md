---
title: Mobile Channel Requirements
pageid: 4817198
---

In order to use chan_mobile, you must have a working bluetooth subsystem on your Asterisk box. This means one or more working bluetooth adapters, and the BlueZ packages. 

Any bluetooth adapter supported by the Linux kernel will do, including usb bluetooth dongles. 

The BlueZ package you need is bluez-utils. If you are using a GUI then you might want to install bluez-pin also. You also need libbluetooth, and libbluetooth-dev if you are compiling Asterisk from source. 

You need to get bluetooth working with your phone before attempting to use chan_mobile. This means 'pairing' your phone or headset with your Asterisk box. I dont describe how to do this here as the process differs from distro to distro. You only need to pair once per adapter. 

See <http://www.bluez.org> for details about setting up Bluetooth under Linux.
