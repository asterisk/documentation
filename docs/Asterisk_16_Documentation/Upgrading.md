---
title: Upgrading to Asterisk 16
---

### There is only one breaking change to be aware of when upgrading from Asterisk 15 to Asterisk 16:

* Applications:
	+ The 'Macro' dialplan application has been deprecated and is no longer built by default. If your dialplan uses it you will need to manually enable it for building using menuselect or you will need to update your dialplan to take advantage of the Gosub application instead.



