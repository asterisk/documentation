---
search:
  boost: 0.5
title: PJSIPShowEndpoint
---

# PJSIPShowEndpoint

### Synopsis

Detail listing of an endpoint and its objects.

### Description

Provides a detailed listing of options for a given endpoint. Events are issued showing the configuration and status of the endpoint and associated objects. These events include 'EndpointDetail', 'AorDetail', 'AuthDetail', 'TransportDetail', and 'IdentifyDetail'. Some events may be listed multiple times if multiple objects are associated (for instance AoRs). Once all detail events have been raised a final 'EndpointDetailComplete' event is issued.<br>


### Syntax


```


Action: PJSIPShowEndpoint
ActionID: <value>
Endpoint: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Endpoint` - The endpoint to list.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 