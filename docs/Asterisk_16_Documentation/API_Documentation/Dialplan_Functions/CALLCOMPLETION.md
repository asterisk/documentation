---
search:
  boost: 0.5
title: CALLCOMPLETION
---

# CALLCOMPLETION()

### Synopsis

Get or set a call completion configuration parameter for a channel.

### Description

The CALLCOMPLETION function can be used to get or set a call completion configuration parameter for a channel. Note that setting a configuration parameter will only change the parameter for the duration of the call. For more information see *doc/AST.pdf*. For more information on call completion parameters, see *configs/ccss.conf.sample*.<br>


### Syntax


```

CALLCOMPLETION(option)
```
##### Arguments


* `option` - The allowable options are:<br>

    * `cc_agent_policy`

    * `cc_monitor_policy`

    * `cc_offer_timer`

    * `ccnr_available_timer`

    * `ccbs_available_timer`

    * `cc_recall_timer`

    * `cc_max_agents`

    * `cc_max_monitors`

    * `cc_callback_macro`

    * `cc_agent_dialstring`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 