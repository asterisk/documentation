---
title: SMS Delivery Reports
pageid: 5243006
---

The SMS specification allows for delivery reports. These are requested using the srr bit. However, as these do not work in the UK yet they are not fully implemented in this application. If anyone has a telco that does implement these, please let me know. BT in the UK have a non standard way to do this by starting the message with \*0#, and so this application may have a UK specific bodge in the near future to handle these.   

The main changes that are proposed for delivery report handling are :

* New queues for sent messages, one file for each destination address and message reference.
* New field in message format, user reference, allowing applications to tie up their original message with a report.
* Handling of the delivery confirmation/rejection and connecting to the outgoing message - the received message file would then have fields for the original outgoing message and user reference allowing applications to handle confirmations better.
