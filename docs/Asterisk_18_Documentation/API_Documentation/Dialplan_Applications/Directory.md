---
search:
  boost: 0.5
title: Directory
---

# Directory()

### Synopsis

Provide directory of voicemail extensions.

### Description

This application will present the calling channel with a directory of extensions from which they can search by name. The list of names and corresponding extensions is retrieved from the voicemail configuration file, *voicemail.conf*, or from the specified filename.<br>

This application will immediately exit if one of the following DTMF digits are received and the extension to jump to exists:<br>

0 - Jump to the 'o' extension, if it exists.<br>

* - Jump to the 'a' extension, if it exists.<br>

This application will set the following channel variables before completion:<br>


* `DIRECTORY_RESULT` - Reason Directory application exited.<br>

    * `OPERATOR` - User requested operator

    * `ASSISTANT` - User requested assistant

    * `TIMEOUT` - User allowed DTMF wait duration to pass without sending DTMF

    * `HANGUP` - The channel hung up before the application finished

    * `SELECTED` - User selected a user to call from the directory

    * `USEREXIT` - User exited with '#' during selection

    * `FAILED` - The application failed

* `DIRECTORY_EXTEN` - If the skip calling option is set this will be set to the selected extension provided one is selected.<br>

### Syntax


```

Directory([vm-context,[dial-context,[options]]])
```
##### Arguments


* `vm-context` - This is the context within voicemail.conf to use for the Directory. If not specified and 'searchcontexts=no' in *voicemail.conf*, then 'default' will be assumed.<br>

* `dial-context` - This is the dialplan context to use when looking for an extension that the user has selected, or when jumping to the 'o' or 'a' extension. If not specified, the current context will be used.<br>

* `options`

    * `e` - In addition to the name, also read the extension number to the caller before presenting dialing options.<br>


    * `f(n)` - Allow the caller to enter the first name of a user in the directory instead of using the last name. If specified, the optional number argument will be used for the number of characters the user should enter.<br>

        * `n` **required**


    * `l(n)` - Allow the caller to enter the last name of a user in the directory. This is the default. If specified, the optional number argument will be used for the number of characters the user should enter.<br>

        * `n` **required**


    * `b(n)` - Allow the caller to enter either the first or the last name of a user in the directory. If specified, the optional number argument will be used for the number of characters the user should enter.<br>

        * `n` **required**


    * `a` - Allow the caller to additionally enter an alias for a user in the directory. This option must be specified in addition to the 'f', 'l', or 'b' option.<br>


    * `m` - Instead of reading each name sequentially and asking for confirmation, create a menu of up to 8 names.<br>


    * `n` - Read digits even if the channel is not answered.<br>


    * `p(n)` - Pause for n milliseconds after the digits are typed. This is helpful for people with cellphones, who are not holding the receiver to their ear while entering DTMF.<br>

        * `n` **required**


    * `c(filename)` - Load the specified config file instead of voicemail.conf<br>

        * `filename` **required**


    * `s` - Skip calling the extension, instead set it in the **DIRECTORY\_EXTEN** channel variable.<br>


    * `d` - Enable ADSI support for screen phone searching and retrieval of directory results.<br>
Additionally, the channel must be ADSI-enabled and you must have an ADSI-compatible (Type III) CPE for this to work.<br>


    /// note
Only one of the _f_, _l_, or _b_ options may be specified. *If more than one is specified*, then Directory will act as if _b_ was specified. The number of characters for the user to type defaults to '3'.
///



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 