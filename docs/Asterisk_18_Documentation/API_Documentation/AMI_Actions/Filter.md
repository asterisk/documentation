---
search:
  boost: 0.5
title: Filter
---

# Filter

### Synopsis

Dynamically add filters for the current manager session.

### Description

See the manager.conf.sample file in the configs/samples directory of the Asterisk source tree for a full description and examples.<br>


/// note
The filters added are only used for the current session. Once the connection is closed the filters are removed.
///


/// note
This comand requires the system permission because this command can be used to create filters that may bypass filters defined in manager.conf
///


### Syntax


```


Action: Filter
ActionID: <value>
Operation: <value>
MatchCriteria: <value>
Filter: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Operation`

    * `Add` - Add a filter.<br>

* `MatchCriteria` - Advanced match criteria. If not specified, the 'Filter' parameter is assumed to be a regular expression and will be matched against the entire event payload.<br>
Syntax: \[name(<event\_name>)\]\[,header(<header\_name>)\]\[,<match\_method>\]<br>
One of each of the following may be specified separated by commas.<br>
<br>

    * `action(include|exclude)` - Instead of prefixing the Filter with '!' to exclude matching events, specify 'action(exclude)'. Although the default is 'include' if 'action' isn't specified, adding 'action(include)' will help with readability.<br>
<br>

    * `name(<event_name>)` - Only events with name _event\_name_ will be included.<br>
<br>

    * `header(<header_name>)` - Only events containing a header with a name of _header\_name_ will be included and the 'Filter' parameter (if supplied) will only be matched against the value of the header.<br>
<br>

    * `<match_method>` - Specifies how the 'Filter' parameter is to be applied to the results of applying any 'name(<event\_name>)' and/or 'header(<header\_name>)' parameters above.<br>
One of the following:<br>

        * `regex` - The 'Filter' parameter contains a regular expression which will be matched against the result. (default)<br>
<br>

        * `exact` - The 'Filter' parameter contains a string which must exactly match the entire result.<br>
<br>

        * `startsWith` - The 'Filter' parameter contains a string which must match the beginning of the result.<br>
<br>

        * `endsWith` - The 'Filter' parameter contains a string which must match the end of the result.<br>
<br>

        * `contains` - The 'Filter' parameter contains a string which will be searched for in the result.<br>
<br>

        * `none` - The 'Filter' parameter is ignored.<br>

* `Filter` - The match expression to be applied to the event.<br>
See the manager.conf.sample file in the configs/samples directory of the Asterisk source tree for more information.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 