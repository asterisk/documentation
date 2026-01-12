---
search:
  boost: 0.5
title: Authenticate
---

# Authenticate()

### Synopsis

Authenticate a user

### Description

This application asks the caller to enter a given password in order to continue dialplan execution.<br>

If the password begins with the '/' character, it is interpreted as a file which contains a list of valid passwords, listed 1 password per line in the file.<br>

When using a database key, the value associated with the key can be anything.<br>

Users have three attempts to authenticate before the channel is hung up.<br>


### Syntax


```

Authenticate(password,[options,[maxdigits,prompt&[prompt2[&...]])
```
##### Arguments


* `password` - Password the user should know<br>

* `options`

    * `a` - Set the channels' account code to the password that is entered<br>


    * `d` - Interpret the given path as database key, not a literal file.<br>


    * `m` - Interpret the given path as a file which contains a list of account codes and password hashes delimited with ':', listed one per line in the file. When one of the passwords is matched, the channel will have its account code set to the corresponding account code in the file.<br>


    * `r` - Remove the database key upon successful entry (valid with 'd' only)<br>


* `maxdigits` - maximum acceptable number of digits. Stops reading after maxdigits have been entered (without requiring the user to press the '#' key). Defaults to 0 - no limit - wait for the user press the '#' key.<br>

* `prompt` - Override the "agent-pass" sound file. Can be an ampersand separated list of filenames. If the filename is a relative filename (it does not begin with a slash), it will be searched for in the Asterisk sounds directory. If the filename is able to be parsed as a URL, Asterisk will download the file and then begin playback on it. To include a literal '&' in the URL you can enclose the URL in single quotes.<br>

    * `prompt` **required**

    * `prompt2[,prompt2...]`

### See Also

* [Dialplan Applications VMAuthenticate](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/VMAuthenticate)
* [Dialplan Applications DISA](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/DISA)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 