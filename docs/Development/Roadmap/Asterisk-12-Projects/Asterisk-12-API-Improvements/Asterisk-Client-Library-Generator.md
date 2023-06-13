---
title: Asterisk Client Library Generator
pageid: 22088290
---

Asterisk Client Library Generator
=================================


Generator for client libraries for Asterisk's REST API which is provided by res\_http\_stasis.


Languages
---------


* Python
* JavaScript
* Perl
* format such that additional language support is not difficult.


Library structure
=================


* Top-level library or object or structure
	+ Asterisk.get\_info()
	+ Endpoints.get\_endpoints()
	+ Channels.get\_channels()
	+ Bridges.get\_bridges()
	+ Recordings.get\_recordings()
	+ Endpoint.get\_endpoint(id)
	+ Channel.get\_channel(id)
	+ Bridges.get\_bridge(id)
	+ Recordings.get\_recording(id)
	+ add\_event\_handler(event\_name, function)
	+ remove\_event\_handler(event\_name, function)
* Each object in the Swagger resource files
	+ Methods listed therein
	+ Relevant object attribute getters
	+ add\_event\_handler(event\_name, function)
	+ remove\_event\_handler(event\_name, function)


Library behavior
================


HTTP codes
----------


* 2XX - no error. If we got a JSON response, return it, else, return void.
* 3XX - followed by HTTP libraries
* 400 Bad Request - used when the requested action cannot be attempted because of bad params. Throw an `IllegalInputException`.
* 404 Not Found - used when the object to be acted upon doesn't exist. Throw a `NotFoundException`.
* 409 Conflict - used when the requested action cannot be attempted because of bad state. Throw an `IllegalStateException`.
* 500 - Throw an `AsteriskServerException`.
* 501 - Throw a `NoSuchMethodException`.
* 5XX - Throw a `AsteriskUnknownException`.
Python
------
* Methods should return the object specified in the Swagger documentation or throw an appropriate exception.
Perl
----
* Methods should return the object specified in the Swagger documentation if the call succeeds. Undecided as of yet how error-handling will take place. We will avoid setting an error variable which may be over written by subsequent or parallel calls.
JavaScript
----------
* Methods should pass the object specified in the Swagger documentation into a success handler (2xx). Fatal errors (400, 418, 5XX) will cause an error to be throw. Non-fatal errors will call an error handler (404, 409).


Project location and directory structure
========================================


This project is located [on GitHub](https://github.com/asterisk/asterisk_rest_libraries). Inside asterisk\_rest\_libraries



asterisk\_rest\_libraries
 generate\_library.py
 api.py
 test\_api\_calls.py
 test\_asterispy.py
 perl/
 lib/
 templates/
 ... et. al.
 python/
 lib/
 \_\_init\_\_.py
 asteriskpy.py
 asterisk\_rest\_api.py
 errors.py
 ... and generated files
 templates/
 copyright.proto
 class\_def.proto
 method\_def.proto
 ... and perhaps more in the future
 test\_resources/
 asterisk.json
 bridges.json
 channels.json
 endpoints.json
 recordings.json
 resources.json
 ... and perhaps more in the future
