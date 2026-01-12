---
search:
  boost: 0.5
title: VoicemailRefresh
---

# VoicemailRefresh

### Synopsis

Tell Asterisk to poll mailboxes for a change

### Description

Normally, MWI indicators are only sent when Asterisk itself changes a mailbox. With external programs that modify the content of a mailbox from outside the application, an option exists called 'pollmailboxes' that will cause voicemail to continually scan all mailboxes on a system for changes. This can cause a large amount of load on a system. This command allows external applications to signal when a particular mailbox has changed, thus permitting external applications to modify mailboxes and MWI to work without introducing considerable CPU load.<br>

If _Context_ is not specified, all mailboxes on the system will be polled for changes. If _Context_ is specified, but _Mailbox_ is omitted, then all mailboxes within _Context_ will be polled. Otherwise, only a single mailbox will be polled for changes.<br>


### Syntax


```


Action: VoicemailRefresh
ActionID: <value>
Context: <value>
Mailbox: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Context`

* `Mailbox`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 