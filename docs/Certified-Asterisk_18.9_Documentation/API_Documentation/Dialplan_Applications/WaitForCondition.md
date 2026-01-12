---
search:
  boost: 0.5
title: WaitForCondition
---

# WaitForCondition()

### Synopsis

Wait (sleep) until the given condition is true.

### Description

Waits until _expression_ evaluates to true, checking every _interval_ seconds for up to _timeout_. Default is evaluate _expression_ every 50 milliseconds with no timeout.<br>

``` title="Example: Wait for condition dialplan variable/function to become 1 for up to 40 seconds, checking every 500ms"

same => n,WaitForCondition(#,#["#{condition}"="1"],40,0.5)


```
Sets **WAITFORCONDITIONSTATUS** to one of the following values:<br>


* `WAITFORCONDITIONSTATUS`

    * `TRUE` - Condition evaluated to true before timeout expired.

    * `FAILURE` - Invalid argument.

    * `TIMEOUT` - Timeout elapsed without condition evaluating to true.

    * `HANGUP` - Channel hung up before condition became true.

### Syntax


```

WaitForCondition(replacementchar,expression,[timeout,[interval]])
```
##### Arguments


* `replacementchar` - Specifies the character in the expression used to replace the '$' character. This character should not be used anywhere in the expression itself.<br>

* `expression` - A modified logical expression with the '$' characters replaced by _replacementchar_. This is necessary to pass the expression itself into the application, rather than its initial evaluation.<br>

* `timeout` - The maximum amount of time, in seconds, this application should wait for a condition to become true before dialplan execution continues automatically to the next priority. By default, there is no timeout.<br>

* `interval` - The frequency, in seconds, of polling the condition, which can be adjusted depending on how time-sensitive execution needs to be. By default, this is 0.05.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 