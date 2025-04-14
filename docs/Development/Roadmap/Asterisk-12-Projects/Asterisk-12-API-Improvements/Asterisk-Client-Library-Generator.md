---
title: Asterisk Client Library Generator
pageid: 22088290
---

Asterisk Client Library Generator
=================================

Generator for client libraries for [Asterisk's REST API](../) which is provided by res_http_stasis.

Languages
---------

* Python
* JavaScript
* Perl
* format such that additional language support is not difficult.

Library structure
=================

* Top-level library or object or structure
	+ Asterisk.get_info()
	+ Endpoints.get_endpoints()
	+ Channels.get_channels()
	+ Bridges.get_bridges()
	+ Recordings.get_recordings()
	+ Endpoint.get_endpoint(id)
	+ Channel.get_channel(id)
	+ Bridges.get_bridge(id)
	+ Recordings.get_recording(id)
	+ add_event_handler(event_name, function)
	+ remove_event_handler(event_name, function)
* Each object in the Swagger resource files
	+ Methods listed therein
	+ Relevant object attribute getters
	+ add_event_handler(event_name, function)
	+ remove_event_handler(event_name, function)

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

This project is located [on GitHub](https://github.com/asterisk/asterisk_rest_libraries). Inside asterisk_rest_libraries

```

asterisk_rest_libraries
 generate_library.py
 api.py
 test_api_calls.py
 test_asterispy.py
 perl/
 lib/
 templates/
 ... et. al.
 python/
 lib/
 __init__.py
 asteriskpy.py
 asterisk_rest_api.py
 errors.py
 ... and generated files
 templates/
 copyright.proto
 class_def.proto
 method_def.proto
 ... and perhaps more in the future
 test_resources/
 asterisk.json
 bridges.json
 channels.json
 endpoints.json
 recordings.json
 resources.json
 ... and perhaps more in the future

```
