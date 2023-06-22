---
title: Case Sensitivity
pageid: 21463732
---

Case sensitivity of channel variables in Asterisk is dependent on the version of Asterisk in use.


Versions prior to Asterisk 12
=============================


This includes versions


* Asterisk 1.0.X
* Asterisk 1.2.X
* Asterisk 1.4.X
* Asterisk 1.6.0.X
* Asterisk 1.6.1.X
* Asterisk 1.6.2.X
* Asterisk 1.8.X
* Asterisk 10.X
* Asterisk 11.X


These versions of Asterisk follow these three rules:


* Variables evaluated in the dialplan are **case-insensitive**
* Variables evaluated within Asterisk's internals are **case-sensitive**
* Built-in variables are **case-sensitive**


This is best illustrated through the following examples


### Example 1: A user-set variable


In this example, the user retrieves a value from the AstDB and then uses it as the destination for a `Dial` command.




---

  
  


```


[default]
exten => 1000,1,Set(DEST=${DB(egg/salad)})
 same => n,Dial(${DEST},15)


```


Since the `DEST` variable is set and evaluated in the dialplan, its evaluation is case-insensitive. Thus the following would be equivalent:




---

  
  


```


exten => 1000,1,Set(DEST=${DB(egg/salad)})
 same => n,Dial(${dest},15)


```


As would this:




---

  
  


```


exten => 1000,1,Set(DeSt=${DB(egg/salad)})
 same => n,Dial(${dEsT},15)


```


### Example 2: Using a built-in variable


In this example, the user wishes to use a built-in variable in order to determine the destination for a call.




---

  
  


```


exten => \_X.,1,Dial(SIP/${EXTEN})


```


Since the variable `EXTEN` is a built-in variable, the following would **not** be equivalent:




---

  
  


```


exten => \_X.,1,Dial(SIP/${exten})


```


The lowercase `exten` variable would evaluate to an empty string since no previous value was set for `exten`.


### Example 3: A variable used internally by Asterisk


In this example, the user wishes to suggest to the SIP channel driver what codec to use on the call.




---

  
  


```


exten => 1000,Set(SIP\_CODEC=g729)
same => n,Dial(SIP/1000,15)


```


`SIP_CODEC` is set in the dialplan, but it gets evaluated inside of Asterisk, so the evaluation is case-sensitive. Thus the following dialplan would not be equivalent:




---

  
  


```


exten => 1000,Set(sip\_codec=g729)
 same => n,Dial(SIP/1000,15)


```


This can lead to some rather confusing situations. Consider that a user wrote the following dialplan. He intended to set the variable `SIP_CODEC` but instead made a typo:




---

  
  


```


exten => 1000,Set(SIP\_CODEc=g729)
 same => n,Dial(SIP/1000,15)


```


As has already been discussed, this is not equivalent to using `SIP_CODEC`. The user looks over his dialplan and does not notice the typo. As a way of debugging, he decides to place a `NoOp` in the dialplan:




---

  
  


```


exten => 1000,Set(SIP\_CODEc=g729)
 same => n,NoOp(${SIP\_CODEC})
 same => n,Dial(SIP/1000,15)


```


When the user checks the verbose logs, he sees that the second priority has evaluated `SIP_CODEC` to be "g729". This is because the evaluation in the dialplan was done case-insensitively.


Asterisk 12 and above
=====================


Due to potential confusion stemming from the policy, for Asterisk 12, it was proposed that variables should be evaluated consistently. E-mails were sent to the [Asterisk-developers](http://lists.digium.com/pipermail/asterisk-dev/2012-October/057056.html) and [Asterisk-users](http://lists.digium.com/pipermail/asterisk-users/2012-October/275033.html) lists about whether variables should be evaluated case-sensitively or case-insensitively. The majority opinion swayed towards case-sensitive evaluation. Thus in Asterisk 12, all variable evaluation, whether done in the dialplan or internally, will be case-sensitive.


For those who are upgrading to Asterisk 12 from a previous version, be absolutely sure that your variables are used consistently throughout your dialplan.

