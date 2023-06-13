---
title: CDR Variables
pageid: 5242911
---

If the channel has a CDR, that CDR has its own set of variables which can be accessed just like channel variables. The following builtin variables are available. 


* ${CDR(clid)} Caller ID
* ${CDR(src)} Source
* ${CDR(dst)} Destination
* ${CDR(dcontext)} Destination context
* ${CDR(channel)} Channel name
* ${CDR(dstchannel)} Destination channel
* ${CDR(lastapp)} Last app executed
* ${CDR(lastdata)} Last app's arguments
* ${CDR(start)} Time the call started.
* ${CDR(answer)} Time the call was answered.
* ${CDR(end)} Time the call ended.
* ${CDR(duration)} Duration of the call.
* ${CDR(billsec)} Duration of the call once it was answered.
* ${CDR(disposition)} ANSWERED, NO ANSWER, BUSY
* ${CDR(amaflags)} DOCUMENTATION, BILL, IGNORE etc
* ${CDR(accountcode)} The channel's account code.
* ${CDR(uniqueid)} The channel's unique id.
* ${CDR(userfield)} The channels uses specified field.


In addition, you can set your own extra variables by using Set(CDR(name)=value). These variables can be output into a text-format CDR by using the cdr\_custom CDR driver; see the cdr\_custom.conf.sample file in the configs directory for an example of how to do this.

