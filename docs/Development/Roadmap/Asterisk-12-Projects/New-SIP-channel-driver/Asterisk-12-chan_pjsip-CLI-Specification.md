---
title: Asterisk 12 chan_pjsip CLI Specification
pageid: 26478200
---

!!! warning 
    This is a draft under construction.

[//]: # (end-warning)

Asterisk 12 chan_pjsip CLI Specification
=========================================

Here we are specifying what the use and output of each command should look like.

### General formatting guidelines:

These are guidelines meant to help readability of the output.

* 1 blank line before output and after output to separate the output from the prompt (output must begin and end with newlines)
* 2 spaces before each line of output to separate the output from the left side of terminal
* For tabulated content there should be 2 spaces between the longest lines in each column.
* For <option> = <value> , vertically oriented lists of two column tables, the right-hand column containing values should be at least 2 spaces out from the longest option name.
* When listing <option>'s we should use the actual option name when possible, rather than an expanded English version. As when you expand it, you'll run into situations where it is not clear to a user which configuration option that listing relates to.
* For listings with more than one column, column names using more than a single word should have no whitespace and use camel case, (e.g. "LastRegTime") for reading clarity.
	+ An exception may be made where additional information needs to be expressed. As in "AORs/Contacts" or "Expiry(sec)". We should avoid this where possible.

The general formatting guidelines should override any discrepancies with the mock up output examples.

CLI Command Specifications
==========================

pjsip show endpoints
--------------------

---
