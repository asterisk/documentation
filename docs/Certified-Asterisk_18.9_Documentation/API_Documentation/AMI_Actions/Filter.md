---
search:
  boost: 0.5
title: Filter
---

# Filter

### Synopsis

Dynamically add filters for the current manager session.

### Description

The filters added are only used for the current session. Once the connection is closed the filters are removed.<br>

This comand requires the system permission because this command can be used to create filters that may bypass filters defined in manager.conf<br>


### Syntax


```


Action: Filter
ActionID: <value>
Operation: <value>
Filter: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Operation`

    * `Add` - Add a filter.<br>

* `Filter` - Filters can be whitelist or blacklist<br>
Example whitelist filter: "Event: Newchannel"<br>
Example blacklist filter: "!Channel: DAHDI.*"<br>
This filter option is used to whitelist or blacklist events per user to be reported with regular expressions and are allowed if both the regex matches and the user has read access as defined in manager.conf. Filters are assumed to be for whitelisting unless preceeded by an exclamation point, which marks it as being black. Evaluation of the filters is as follows:<br>
- If no filters are configured all events are reported as normal.<br>
- If there are white filters only: implied black all filter processed first, then white filters.<br>
- If there are black filters only: implied white all filter processed first, then black filters.<br>
- If there are both white and black filters: implied black all filter processed first, then white filters, and lastly black filters.<br>

### See Also

* [AMI Actions FilterList](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/FilterList)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 