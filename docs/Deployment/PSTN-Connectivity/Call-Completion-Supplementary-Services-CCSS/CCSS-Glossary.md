---
title: CCSS Glossary
pageid: 5243099
---

In this document, we will use some terms which may require clarification. Most of these terms are specific to Asterisk, and are by no means standard.


* CCBS: Call Completion on Busy Subscriber. When a call fails because the recipient's phone is busy, the caller will have the opportunity to request CCBS. When the recipient's phone is no longer busy, the caller will be alerted. The means by which the caller is alerted is dependent upon the type of agent used by the caller.


* CCNR: Call Completion on No Response. When a call fails because the recipient does not answer the phone, the caller will have the opportun- ity to request CCNR. When the recipient's phone becomes busy and then is no longer busy, the caller will be alerted. The means by which the caller is alerted is dependent upon the type of the agent used by the caller.


* Agent: The agent is the entity within Asterisk that communicates with and acts on behalf of the calling party.


* Monitor: The monitor is the entity within Asterisk that communicates with and monitors the status of the called party.


* Generic Agent: A generic agent is an agent that uses protocol-agnostic methods to communicate with the caller. Generic agents should only be used for phones, and never should be used for "trunks."


* Generic Monitor: A generic monitor is a monitor that uses protocol- agnostic methods to monitor the status of the called party. Like with generic agents, generic monitors should only be used for phones.


* Native Agent: The opposite of a generic agent. A native agent uses protocol-specific messages to communicate with the calling party. Native agents may be used for both phones and trunks, but it must be known ahead of time that the device with which Asterisk is communica- ting supports the necessary signaling.


* Native Monitor: The opposite of a generic monitor. A native monitor uses protocol-specific messages to subscribe to and receive notifica- tion of the status of the called party. Native monitors may be used for both phones and trunks, but it must be known ahead of time that the device with which Asterisk is communicating supports the necessary signaling.


* Offer: An offer of CC refers to the notification received by the caller that he may request CC.


* Request: When the caller decides that he would like to subscribe to CC, he will make a request for CC. Furthermore, the term may refer to any outstanding requests made by callers.


* Recall: When the caller attempts to call the recipient after being alerted that the recipient is available, this action is referred to as a "recall."


