---
title: Asterisk GUI
pageid: 13076491
---

Asterisk GUI is no longer maintained and should not be used

Introduction to Asterisk GUI
============================

Asterisk GUI is a framework for the creation of graphical interfaces for configuring Asterisk. Some sample graphical interfaces for specific vertical markets are included for reference or for actual use and extension.

### Software License

Asterisk GUI HTML and Javascript files Copyright (C) 2006-2011 Digium, Inc.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 2 only. This software is also available under commercial terms from Digium, Inc.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

Please contact Digium for information on alternative licensing arrangements for Asterisk GUI.

### Download

While package release is inconsistent and infrequent, you can always get a current copy of [Asterisk GUI from subversion](http://svn.asterisk.org/svn/asterisk-gui/branches/2.0/). The current stable version will always be under `branches` and is currently located in `branches/2.0`.

### Support

Please note that Asterisk GUI is not officially supported, though bugs, patches, and feature requests may be submitted at <http://issues.asterisk.org> and should reference the Asterisk GUI project. You may also find peer support in the #asterisk-gui IRC channel and the [Asterisk GUI forum](http://forums.asterisk.org/viewforum.php?f=35).

Installation and Configuration
==============================

### Installation

javascript$ ./configure
$ make
$ make install
$ make checkconfig### Configuration

You may install sample configuration files by doing "make samples". Also you will need to edit your Asterisk configuration files to enable Asterisk GUI properly, specifically:

##### http.conf:

Enable http.

javascript[general]
enabled=yes
enablestatic=yes
#bindaddr=0.0.0.0 # allow GUI to be accessible from all IP addresses.
bindaddr=127.0.0.1 # require access from the machine Asterisk is running on
bindport=8088##### manager.conf

Enable manager access.

javascript[general]
enabled = yes
webenabled = yesCreate an appropriate entry in `manager.conf` for the administrative user (PLEASE READ THE security.txt FILE!)

javascript[admin]
secret = thiswouldbeaninsecurepassword
read = system,call,log,verbose,command,agent,config,read,write,originate
write = system,call,log,verbose,command,agent,config,read,write,originate##### Access

Access Asterisk GUI via a URL formatted in the following way, where $IP is the IP address on which both Asterisk and Asterisk GUI are installed, $PORT is `bindport` from `http.conf`, and $PREFIX is the `prefix` from `http.conf`, and it can be omitted if blank.

http://$IP:$PORT/$PREFIX/static/config/index.html### Troubleshooting

Check your filesystem permissions:

javascript$ chown -R asterisk:asterisk /etc/asterisk/ /var/lib/asterisk /usr/share/asterisk # if asterisk runs as the user "asterisk"
$ chmod 644 /etc/asterisk/\*Check that the bindaddr value in `/etc/asterisk/http.conf` matches the IP address of the machine you're using to **access** Asterisk GUI, not necessarily the IP address Asterisk GUI is running on.

Check on the Asterisk CLI that Asterisk is receiving the values you've set.

http show status
manager show settingsOutput should look like this:

amelia\*CLI> http show status
HTTP Server Status:
Prefix: /asterisk
Server Enabled and Bound to 0.0.0.0:8088

Enabled URI's:
/asterisk/httpstatus => Asterisk HTTP General Status
/asterisk/phoneprov/... => Asterisk HTTP Phone Provisioning Tool
/asterisk/amanager => HTML Manager Event Interface w/Digest authentication
/asterisk/arawman => Raw HTTP Manager Event Interface w/Digest authentication
/asterisk/manager => HTML Manager Event Interface
/asterisk/rawman => Raw HTTP Manager Event Interface
/asterisk/static/... => Asterisk HTTP Static Delivery
/asterisk/amxml => XML Manager Event Interface w/Digest authentication
/asterisk/mxml => XML Manager Event Interface

Enabled Redirects:
 None.
amelia\*CLI> manager show settings

Global Settings:
----------------
 Manager (AMI): Yes 
 Web Manager (AMI/HTTP): Yes 
 TCP Bindaddress: 0.0.0.0:5038 
 HTTP Timeout (minutes): 60 
 TLS Enable: No 
 TLS Bindaddress: Disabled 
 TLS Certfile: asterisk.pem 
 TLS Privatekey: 
 TLS Cipher: 
 Allow multiple login: Yes 
 Display connects: Yes 
 Timestamp events: No 
 Channel vars: 
 Debug: No 
 Block sockets: No 
Check that the ports you've specified are open by using telnet from another computer.

telnet $ASTERISK\_SERVER\_IP\_ADDRESS 5038
telnet $ASTERISK\_SERVER\_IP\_ADDRESS 8088Check that the `dahdi_genconf` script runs correctly and creates `/etc/asterisk/dahdi_guiread.conf`.

Check the existence of `/etc/asterisk/guipreferences.conf` and inside that file, the existence of the following line:

javascriptconfig\_upgraded = yesCheck the last modified date of `/etc/asterisk/http.conf`. Asterisk GUI updates the timestamp on this file every time it is loaded. If the timestamp is not getting updated, your HTTP request is either not making it to Asterisk or it is not being processed correctly by Asterisk. This indicates a configuration error.

Check that the user Asterisk runs as has a login shell. Asterisk GUI depends on Asterisk being able to use the System application.

javascriptsu - asteriskIf you installed Asterisk GUI via 'yum' or 'apt-get', you may need to symlink `/var/lib/asterisk/static-http` to `/usr/share/asterisk/static-http`. Unfortunately `/usr/share/asterisk/static-http` will already exist, but fortunately it does not contain any useful files.

ls /var/lib/asterisk/static-http/config && rm -rf /usr/share/asterisk/static-http && ln -s /var/lib/asterisk/static-http /usr/share/asterisk/static-httpDevelopment
===========

### Debugging

To turn on debug messages, open `config/js/session.js`. On line 30, set "log" to "true":

javascript log: true, /\*\*< boolean toggling logging \*/### Hide Menu Categories

Hide menu categories by changing the HTML class attribute to "AdvancedMode" in index.html. Show them by enabling Advanced Options in the GUI.

