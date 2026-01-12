---
search:
  boost: 0.5
title: LOG_GROUP
---

# LOG_GROUP()

### Synopsis

Set the channel group name for log filtering on this channel

### Description

Assign a channel to a group for log filtering.<br>

Because this application can result in dialplan execution logs being suppressed (or unsuppressed) from the CLI if filtering is active, it is recommended to call this as soon as possible when dialplan execution begins.<br>

Calling this multiple times will replace any previous group assignment.<br>

``` title="Example: Associate channel with group test"

exten => s,1,Set(LOG_GROUP()=test)
same => n,NoOp() ; if a logging call ID group filter name is enabled but test is not included, you will not see this

			
```
``` title="Example: Associate channel with group important"

exten => s,1,Set(LOG_GROUP()=important)
same => n,Set(foo=bar) ; do some important things to show on the CLI (assuming it is filtered with important enabled)
same => n,Set(LOG_GROUP()=) ; remove from group important to stop showing execution on the CLI
same => n,Wait(5) ; do some unimportant stuff

		
```

### Syntax


```

LOG_GROUP([group])
```
##### Arguments


* `group` - Channel log group name. Leave empty to remove any existing group membership.<br>
You can use any arbitrary alphanumeric name that can then be used by the "logger filter changroup" CLI command to filter dialplan output by group name.<br>

### See Also

* [Dialplan Applications Log](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Log)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 