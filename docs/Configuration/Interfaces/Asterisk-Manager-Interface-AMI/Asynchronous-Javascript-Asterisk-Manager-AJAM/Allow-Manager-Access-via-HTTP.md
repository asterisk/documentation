---
title: Allow Manager Access via HTTP
pageid: 4817260
---

AJAM is not supported and may have issues and may be removed in the future. Do not use it if at all possible. Use standard TCP based AMI instead.

Configuring manager.conf
------------------------

1. Make sure you have both "enabled = yes" and "webenabled = yes" setup in /etc/asterisk/manager.conf
2. You may also use "httptimeout" to set a default timeout for HTTP connections.
3. Make sure you have a manager username/secret

Usage of AMI over HTTP
----------------------

Once those configurations are complete you can reload or restart Asterisk and you should be able to point your web browser to specific URI's which will allow you to access various web functions. A complete list can be found by typing "http show status" at the Asterisk CLI.

### Examples:

Be sure the syntax for the URLs below is followed precisely

* http://localhost:8088/manager?action=login&username=foo&secret=bar

This logs you into the manager interface's "HTML" view. Once you're logged in, Asterisk stores a cookie on your browser (valid for the length of httptimeout) which is used to connect to the same session.

* http://localhost:8088/rawman?action=status

Assuming you've already logged into manager, this URI will give you a "raw" manager output for the "status" command.

* http://localhost:8088/mxml?action=status

This will give you the same status view but represented as AJAX data, theoretically compatible with RICO (<http://www.openrico.org>).

* http://localhost:8088/static/ajamdemo.html

If you have enabled static content support and have done a make install, Asterisk will serve up a demo page which presents a live, but very basic, "astman" like interface. You can login with your username/secret for manager and have a basic view of channels as well as transfer and hangup calls. It's only tested in Firefox, but could probably be made to run in other browsers as well.

A sample library (astman.js) is included to help ease the creation of manager HTML interfaces.

For the demo, there is no need for **any external web server.**

