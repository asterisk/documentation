---
search:
  boost: 0.5
title: QueueWithdrawCaller
---

# QueueWithdrawCaller

### Synopsis

Request to withdraw a caller from the queue back to the dialplan.

### Description


### Syntax


```


Action: QueueWithdrawCaller
ActionID: <value>
Queue: <value>
Caller: <value>
[WithdrawInfo: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Queue` - The name of the queue to take action on.<br>

* `Caller` - The caller (channel) to withdraw from the queue.<br>

* `WithdrawInfo` - Optional info to store. If the call is successfully withdrawn from the queue, this information will be available in the QUEUE\_WITHDRAW\_INFO variable.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 