---
title: Janitor Projects
pageid: 4260010
---

What is this page?
==================


This page contains janitor (small, cleanup) projects for Asterisk that are waiting for a kind developer to take them on and bring them to completion.




---


* Audit uses of usleep() to ensure that the argument is never greater than 1 million. On some systems, that is considered an error. In any such cases, convert the usage ver to use nanosleep(), instead.


* Convert all existing uses of astobj.h to astobj2.h. chan_sip already in progress in a branch


* There are many places where large character buffers are allocated in structures. There is a new system for string handling that uses dynamically allocatted memory pools which is documented in include/asterisk/stringfields.h. Examples of where they are currently used are the ast_channel structure defined in include/asterisk/channel.h, some structures in chan_sip.c, and chan_dahdi.c.


* There is a convenient set of macros defined in include/asterisk/linkedlists.h for handling linked lists. However, there are some open-coded lists throughout the code. Converting linked lists to use these macros will make list handling more consistent and reduce the possibility of coding errors.


* Clean up and add [Doxygen Documentation](http://www.asterisk.org/doxygen/trunk/index.html). When generating the documentation with make progdocs, a lot of warnings are generated. All of these need to be fixed. There is also plenty of code that still needs to be documented. All public API functions should be documented. That is pretty much anything in include/asterisk/*.h. <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-20259>


* Check all ast_copy_string() usage to ensure that buffers are not being unnecessarily zeroed before or after calling it.


* Find any remaining open-coded struct timeval manipulation and convert to use new time library functions.


* Use the ast_str API in strings.h to replace multiple calls to strncat(), snprintf() with funky math, etc.


* Audit all channel/res/app/etc. modules to ensure that they do not register any entrypoints with the Asterisk core until after they are ready to service requests; all config file reading/processing, structure allocation, etc. must be completed before Asterisk is made aware of any services the module offers.


* Ensure that Realtime-enabled modules do not depend on the order of columns returned by the database lookup (example: outboundproxy and host settings in chan_sip).


* Convert all usage of the signal(2) system API to the more portable sigaction(2) system API.


* Find options and arguments in Asterisk which specify a time period in seconds or milliseconds and convert them to use the new ast_app_parse_timelen() function.


* Find applications and functions in Asterisk that would benefit from being able to encode control characters and extended ASCII and embed calls to ast_get_encoded_char, ast_get_encoded_str, and ast_str_get_encoded_str.


* There are a number of function, applications, etc. in Asterisk that are not properly source-documented. Someone needs to document them as defined in the [Coding Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Coding-Guidelines). The items needing documentation include:
	+ func_curl
	+ func_logic
	+ func_module
	+ func_speex
	+ func_strings
	+ func_uri
	+ app_cdr
	+ app_directed_pickup
	+ app_fax
	+ app_image
	+ app_talkdetect
	+ app_url


* In Asterisk 11, documentation for AMI events has been added. While a subset of the events in Asterisk have received documentation, not all applications/functions/resource modules/channel drivers have been updated. All of the extended support modules should receive AMI event documentation.


