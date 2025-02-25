---
search:
  boost: 0.5
title: MINIVMACCOUNT
---

# MINIVMACCOUNT()

### Synopsis

Gets MiniVoicemail account information.

### Description

<br>


### Syntax


```

MINIVMACCOUNT(account:item)
```
##### Arguments


* `account`

* `item` - Valid items are:<br>

    * `path` - Path to account mailbox (if account exists, otherwise temporary mailbox).<br>

    * `hasaccount` - 1 is static Minivm account exists, 0 otherwise.<br>

    * `fullname` - Full name of account owner.<br>

    * `email` - Email address used for account.<br>

    * `etemplate` - Email template for account (default template if none is configured).<br>

    * `ptemplate` - Pager template for account (default template if none is configured).<br>

    * `accountcode` - Account code for the voicemail account.<br>

    * `pincode` - Pin code for voicemail account.<br>

    * `timezone` - Time zone for voicemail account.<br>

    * `language` - Language for voicemail account.<br>

    * `<channel variable name>` - Channel variable value (set in configuration for account).<br>

### See Also

* [Dialplan Applications MinivmRecord](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmRecord)
* [Dialplan Applications MinivmGreet](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmGreet)
* [Dialplan Applications MinivmNotify](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmNotify)
* [Dialplan Applications MinivmDelete](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmDelete)
* [Dialplan Applications MinivmAccMess](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmAccMess)
* [Dialplan Applications MinivmMWI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MinivmMWI)
* [Dialplan Functions MINIVMCOUNTER](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/MINIVMCOUNTER)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 