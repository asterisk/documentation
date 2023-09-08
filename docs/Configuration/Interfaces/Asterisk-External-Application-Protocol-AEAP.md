---
title: Asterisk External Application Protocol (AEAP)
pageid: 47875006
---

The Asterisk External Application Protocol (AEAP) is used to communicate configuration, data, and other information using a simple request/response messaging system. Currently, JSON is the only supported message description format. At present, the following request/response messages are supported:

* setup - Initializes a remote application
* get - Retrieves settings and other information from a remote application
* set - Updates settings and other information on a remote application

Every request and response type will always contain the following fields:

* request | response : <name>
* id: <unique id>

Each request has a specified name that's shared with a subsequent matching response. For example, if the request name is "hello", then the response to that request will also have the name "hello". Similarly, every new request has a unique message id that's echoed in the response.

Setup
=====

A "setup" must be the first request sent. It is used to determine if further interactions will be allowed, and if so then any given parameters are used to establish initial configuration and setup.




---

  
offer request  

```
{
 "request": "setup",
 "id": <unique id>,
 "version": <version number>,
 "codecs": [
 "name": <codec name>,
 "attributes": {
 <name>: <value>,
 ...,
 },
 ...,
 ],
 "params": {
 <name>: <value>,
 ...,
 },
}

```

"request", "id", and "version" are all required fields and must be included. The version is a value that represents the current AEAP message version. As well, at least one or more "codecs" must be specified. While the codec "name" is mandatory, codec attributes are optional. However, if a codec attribute is given then both the attribute "name" and "value" must be provided. "params" is optional, but when given each parameter must be specified as a "name"/"value" pair.




---

  
Example 1 offer request  

```
{
 "request": "setup",
 "id": "9c8d7625-d70d-4225-8b4f-53063ea8e774",
 "version": "0.1.0",
 "codecs": [ { "name": "ulaw" } ],
}

```



---

  
Example 2 offer request  

```
{
 "request": "setup",
 "id": "7180e464-c022-40e6-a49c-9d2007f008a7",
 "version": "0.1.0",
 "codecs": [ { "name": "ulaw" }, { "name": "opus", "attributes": { "maxplaybackrate": 8000 } } ],
}

```



---

  
Example 3 offer request  

```
{
 "request": "setup",
 "id": "b3eda99f-464f-477e-b8a3-4ebafda0b482",
 "version": "0.1.0",
 "codecs": [ { "name": "ulaw" } ],
 "params": { "language": "en", "gender": "male" },
}

```

A "setup" response must only be sent in response to a "setup" request, and must be formatted as follows:




---

  
offer response okay  

```
{
 "response": "setup",
 "id": <unique id from request>,
 "codecs": [{
 "name": <selected codec name from request>,
 "attributes": {
 <name>: <value>,
 ...,
 }],
 }
}

```

Much like the initial request, "response", "id", and "codecs" are required fields. The codec "name" is also required, and must match one of the names given in the request's codec list. "attributes" are again optional.




---

  
Example 1 offer response okay  

```
{
 "response": "setup",
 "id": "7180e464-c022-40e6-a49c-9d2007f008a7",
 "codecs": [{ "name": "ulaw" }],
}

```

Get
===

A "get" request can be sent anytime after an initial "setup" is accepted, and is used to retrieve attributes, settings, and other data (e.g. results). A "get" request has the following form:




---

  
get request  

```
{
 "request": "get",
 "id": <unique id>,
 "params": [<name>, ...],
}

```

All fields are required, and at least one parameter name to retrieve must be specified. Parameter names should be the name of the attribute, setting, etc... to be retrieved.




---

  
Example 1 get request  

```
{
 "request": "get",
 "id": "f066e049-d4ef-4093-a05b-0effef1bc077",
 "params": ["language"],
}

```

A "get" response is similar, but retrieved "params" are made available in name/value pairs:




---

  
get response okay  

```
{
 "response": "get",
 "id": <unique id from request>,
 "params": { <name from request> : <its value>, ... },
}

```

Be aware that the returned value's type is named parameter dependent. For instance, depending on the given "param" the returned "value" could be a string, an integer, or even an array of values.




---

  
Example 1 get response okay  

```
{
 "response": "get",
 "id": "f066e049-d4ef-4093-a05b-0effef1bc077",
 "params": { "language" : "en" },
}

```

Set
===

A "set" request can be sent anytime after an initial "setup" is accepted, and is used to set attributes, settings, and other data on the remote. A "set" request has the following form, and can be used to even set multiple parameters at once:




---

  
set request  

```
{
 "request": "set",
 "id": <unique id>,
 "params": { <name> : <value>. ... },
}

```

All fields are required. Similar to "get", a named parameter's value type varies based on the parameters themselves.




---

  
Example 1 set request  

```
{
 "response": "set",
 "id": "9f424395-736b-412c-b8f4-a67a3497415b",
 "params": { "language" : "en" },
}

```

A "set" response to a successful request is just a basic acknowledgment that only contains response name and id:




---

  
set response  

```
{
 "response": "set",
 "id": <unique id from request>,
}

```



---

  
Example 1 set response okay  

```
 {
 "response": "set",
 "id": "9f424395-736b-412c-b8f4-a67a3497415b",
}

```

Errors
======

When an error occurs for any given request all responses follow the same format. Similar to a regular response the response name and id are the same as that of the request. The only other additional field is an "error_msg", which is a text description of the error:




---

  
error response  

```
{
 "response": <name of request being responded to>,
 "id": <unique id from request>,
 "error_msg": <error text description>
}

```



---

  
Example 1 setup error  

```
{
 "response": "setup",
 "id": "b3eda99f-464f-477e-b8a3-4ebafda0b482",
 "error_msg": "No supported codec(s)"
}

```



---

  
Example 2 get error  

```
{
 "response": "get",
 "id": "f066e049-d4ef-4093-a05b-0effef1bc077",
 "error_msg": "No language parameter available"
}

```



---

  
Example 3 set error  

```
{
 "response": "set",
 "id": "9f424395-736b-412c-b8f4-a67a3497415b",
 "error_msg": "Unable to set language to 'en-US'"
}

```







