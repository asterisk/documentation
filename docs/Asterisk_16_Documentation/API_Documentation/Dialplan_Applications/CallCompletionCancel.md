---
search:
  boost: 0.5
title: CallCompletionCancel
---

# CallCompletionCancel()

### Synopsis

Cancel call completion service

### Description

Cancel a Call Completion Request.<br>

This application sets the following channel variables:<br>


* `CC_CANCEL_RESULT` - This is the returned status of the cancel.<br>

    * `SUCCESS`

    * `FAIL`

* `CC_CANCEL_REASON` - This is the reason the cancel failed.<br>

    * `NO\_CORE\_INSTANCE`

    * `NOT\_GENERIC`

    * `UNSPECIFIED`

### Syntax


```

CallCompletionCancel()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 