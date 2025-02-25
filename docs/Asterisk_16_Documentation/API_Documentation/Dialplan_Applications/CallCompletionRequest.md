---
search:
  boost: 0.5
title: CallCompletionRequest
---

# CallCompletionRequest()

### Synopsis

Request call completion service for previous call

### Description

Request call completion service for a previously failed call attempt.<br>

This application sets the following channel variables:<br>


* `CC_REQUEST_RESULT` - This is the returned status of the request.<br>

    * `SUCCESS`

    * `FAIL`

* `CC_REQUEST_REASON` - This is the reason the request failed.<br>

    * `NO\_CORE\_INSTANCE`

    * `NOT\_GENERIC`

    * `TOO\_MANY\_REQUESTS`

    * `UNSPECIFIED`

### Syntax


```

CallCompletionRequest()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 