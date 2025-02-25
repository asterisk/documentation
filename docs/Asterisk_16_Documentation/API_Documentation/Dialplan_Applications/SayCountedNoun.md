---
search:
  boost: 0.5
title: SayCountedNoun
---

# SayCountedNoun()

### Synopsis

Say a noun in declined form in order to count things

### Description

Selects and plays the proper singular or plural form of a noun when saying things such as "five calls". English has simple rules for deciding when to say "call" and when to say "calls", but other languages have complicated rules which would be extremely difficult to implement in the Asterisk dialplan language.<br>

The correct sound file is selected by examining the _number_ and adding the appropriate suffix to _filename_. If the channel language is English, then the suffix will be either empty or "s". If the channel language is Russian or some other Slavic language, then the suffix will be empty for nominative, "x1" for genative singular, and "x2" for genative plural.<br>

Note that combining _filename_ with a suffix will not necessarily produce a correctly spelled plural form. For example, SayCountedNoun(2,man) will play the sound file "mans" rather than "men". This behavior is intentional. Since the file name is never seen by the end user, there is no need to implement complicated spelling rules. We simply record the word "men" in the sound file named "mans".<br>

This application does not automatically answer and should be preceeded by an application such as Answer() or Progress.<br>


### Syntax


```

SayCountedNoun(number,filename)
```
##### Arguments


* `number` - The number of things<br>

* `filename` - File name stem for the noun that is the name of the things<br>

### See Also

* [Dialplan Applications SayCountedAdj](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayCountedAdj)
* [Dialplan Applications SayNumber](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayNumber)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 