---
title: Setting up the Asterisk HTTP server
pageid: 4817258
---

Next you'll need to enable Asterisk's Builtin mini-HTTP server.

1. Uncomment the line "enabled=yes" in /etc/asterisk/http.conf to enable Asterisk's builtin micro HTTP server.
2. If you want Asterisk to actually deliver simple HTML pages, CSS, javascript, etc. you should uncomment "enablestatic=yes"
3. Adjust your "bindaddr" and "bindport" settings as appropriate for your desired accessibility
4. Adjust your "prefix" if appropriate, which must be the beginning of any URI on the server to match. The default is blank, that is no prefix and the rest of these instructions assume that value.
