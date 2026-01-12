---
search:
  boost: 0.5
title: DISA
---

# DISA()

### Synopsis

Direct Inward System Access.

### Description

The DISA, Direct Inward System Access, application allows someone from outside the telephone switch (PBX) to obtain an *internal* system dialtone and to place calls from it as if they were placing a call from within the switch. DISA plays a dialtone. The user enters their numeric passcode, followed by the pound sign '#'. If the passcode is correct, the user is then given system dialtone within _context_ on which a call may be placed. If the user enters an invalid extension and extension 'i' exists in the specified _context_, it will be used.<br>

Be aware that using this may compromise the security of your PBX.<br>

The arguments to this application (in *extensions.conf*) allow either specification of a single global _passcode_ (that everyone uses), or individual passcodes contained in a file (_filename_).<br>

The file that contains the passcodes (if used) allows a complete specification of all of the same arguments available on the command line, with the sole exception of the options. The file may contain blank lines, or comments starting with '#' or ';'.<br>


### Syntax


```

DISA(passcode|filename,[context,[cid,mailbox@[context],[options]]]])
```
##### Arguments


* `passcode|filename` - If you need to present a DISA dialtone without entering a password, simply set _passcode_ to 'no-password'<br>
You may specified a _filename_ instead of a _passcode_, this filename must contain individual passcodes<br>

* `context` - Specifies the dialplan context in which the user-entered extension will be matched. If no context is specified, the DISA application defaults to the 'disa' context. Presumably a normal system will have a special context set up for DISA use with some or a lot of restrictions.<br>

* `cid` - Specifies a new (different) callerid to be used for this call.<br>

* `mailbox` - Will cause a stutter-dialtone (indication *dialrecall*) to be used, if the specified mailbox contains any new messages.<br>

    * `mailbox` **required**

    * `context`

* `options`

    * `n` - The DISA application will not answer initially.<br>


    * `p` - The extension entered will be considered complete when a '#' is entered.<br>


### See Also

* [Dialplan Applications Authenticate](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Authenticate)
* [Dialplan Applications VMAuthenticate](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/VMAuthenticate)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 