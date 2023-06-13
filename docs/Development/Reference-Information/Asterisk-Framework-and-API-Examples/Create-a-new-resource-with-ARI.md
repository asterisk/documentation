---
title: Create a new resource with ARI
pageid: 26478494
---

Creating new ARI resources is fairly straightforward.

Create the API declaration
==========================

In the Asterisk source tree, the Swagger API declarations are stored in `./rest-api/api-docs/`. For this example, we are creating a new resource named "fizzbuzz".

These API declarations are documented using [Swagger](https://developers.helloreverb.com/swagger/). Details on documenting the API declarations can be found [on the Swagger wiki](https://github.com/wordnik/swagger-core/wiki/API-Declaration).

fizzbuzz.jsontruejstrue{
 "\_copyright": "Copyright (C) 2013, Digium, Inc.",
 "\_author": "David M. Lee, II <dlee@digium.com>",
 "\_svn\_revision": "$Revision$",
 "apiVersion": "0.0.1",
 "swaggerVersion": "1.1",
 "basePath": "http://localhost:8088/stasis",
 "resourcePath": "/api-docs/fizzbuzz.{format}",
 "apis": [
 {
 "path": "/fizzbuzz",
 "description": "The FizzBuzz test. See http://www.codinghorror.com/blog/2007/02/why-cant-programmers-program.html.",
 "operations": [
 {
 "httpMethod": "GET",
 "summary": "Returns an array of numbers from 1 to 100. But for multiples of three return \"Fizz\" instead of the number and for the multiples of five return \"Buzz\". For numbers which are multiples of both three and five return \"FizzBuzz\".",
 "nickname": "fizzbuzz",
 "responseClass": "object",
 "parameters": [
 {
 "name": "max",
 "description": "Set the max number to fizzbuzz up to",
 "paramType": "query",
 "required": false,
 "dataType": "long"
 }
 ]
 }
 ]
 }
 ],
 "models": {
 "FizzBuzz": {
 "id": "FizzBuzz",
 "description": "List of ints, with Fizz and Buzz mixed in",
 "properties": {
 "fizzbuzz": {
 "type": "List[object]"
 }
 }
 }
 }
}Add it to `resources.json`
==========================

The master list of resources served by Asterisk is kept in `rest-api/resources.json`. Simply add your resource to the end of the list.

resources.json.diffdiffIndex: rest-api/resources.json
===================================================================
--- rest-api/resources.json (revision 401118)
+++ rest-api/resources.json (working copy)
@@ -41,6 +41,10 @@
 {
 "path": "/api-docs/applications.{format}",
 "description": "Stasis application resources"
+ },
+ {
+ "path": "/api-docs/fizzbuzz.{format}",
+ "description": "FizzBuzz example"
 }
 ]
 }Generate the code
=================

The API declarations are used to generate much of the boilerplate code in Asterisk for routing RESTful API invocations. This code is generated using `make ari-stubs`.

The code generator requires [Pystache](https://pypi.python.org/pypi/pystache), which can be installed using `pip install pystache`.

bash$ make ari-stubs
/usr/bin/python rest-api-templates/make\_ari\_stubs.py \
 rest-api/resources.json .
Writing ./doc/rest-api/Asterisk 12 Fizzbuzz REST API.wiki
Writing ./res/res\_ari\_fizzbuzz.c
Writing ./res/ari/resource\_fizzbuzz.h
Writing ./res/ari/resource\_fizzbuzz.c
Writing ./res/ari.makeImplement the API
=================

As you can see, a number of files are generated. Most of the files are always regenerated, and not meant to be modified. However `./res/ari/resource_fizbuzz.c` is simply stub functions to help you get started with your implementation.

The parameters described in your API declaration are parsed into an `args` structure for use in your implementation. The `response` struct is to be filled in with the HTTP response.

resource\_fizzbuzz.ctruecppvoid ast\_ari\_fizzbuzz(struct ast\_variable \*headers,
 struct ast\_fizzbuzz\_args \*args,
 struct ast\_ari\_response \*response)
{
 RAII\_VAR(struct ast\_json \*, json, NULL, ast\_json\_unref);
 struct ast\_json \*fb;
 int i;
 int max = 100;
 if (args->max) {
 max = args->max;
 }
 json = ast\_json\_pack("{s: []}", "fizzbuzz");
 fb = ast\_json\_object\_get(json, "fizzbuzz");
 /\* This is what one would call "business logic", and doesn't belong in
 \* the ARI layer. But this is just a silly example.
 \*/
 for (i = 1; i <= max; ++i) {
 if (i % 15 == 0) {
 ast\_json\_array\_append(fb,
 ast\_json\_string\_create("FizzBuzz"));
 } else if (i % 5 == 0) {
 ast\_json\_array\_append(fb,
 ast\_json\_string\_create("Buzz"));
 } else if (i % 3 == 0) {
 ast\_json\_array\_append(fb,
 ast\_json\_string\_create("Fizz"));
 } else {
 ast\_json\_array\_append(fb, ast\_json\_integer\_create(i));
 }
 }
 ast\_ari\_response\_ok(response, json);
}Recommended practices
=====================

Use HTTP error codes
--------------------

The HTTP error codes do a surprisingly good job describing error conditions you are likely to encounter. Do your best to stay true to the original intention of the error code; it will help keep the API understandable.

The use of extensions can also be useful. For example, we use `422 Unprocessable Entity` to indicate that a request was syntactically correct, but semantically invalid. This helps to keep `400 Bad Request` from being a  catch all for all sort of errors.

Validate your inputs
--------------------

While Swagger can describe input constraints (min, max, required), these are currently not validated in the request routing. Path parameters cannot be `NULL` (because you couldn't route the request if they were), but query parameters could be.

Don't put business logic in the ARI code
----------------------------------------

The design of Asterisk, including ARI, is to be modular. All of the `res_ari_*.so` modules are supposed to be the logic exposing underlying API's via an HTTP interface. Think of it as a controller in a Model-View-Controller architecture. This could should look up objects, validate inputs, call functions on those object, build the HTTP response.

If you find yourself writing lots of logic in your ARI code, it should probably be extracted down into either a `res_stasis*.so` module, or into Asterisk core.

