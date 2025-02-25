---
search:
  boost: 0.5
title: SayCountedAdj
---

# SayCountedAdj()

### Synopsis

Say a adjective in declined form in order to count things

### Description

Selects and plays the proper form of an adjective according to the gender and of the noun which it modifies and the number of objects named by the noun-verb combination which have been counted. Used when saying things such as "5 new messages". The various singular and plural forms of the adjective are selected by adding suffixes to _filename_.<br>

If the channel language is English, then no suffix will ever be added (since, in English, adjectives are not declined). If the channel language is Russian or some other slavic language, then the suffix will the specified _gender_ for nominative, and "x" for genative plural. (The genative singular is not used when counting things.) For example, SayCountedAdj(1,new,f) will play sound file "newa" (containing the word "novaya"), but SayCountedAdj(5,new,f) will play sound file "newx" (containing the word "novikh").<br>

This application does not automatically answer and should be preceeded by an application such as Answer(), Progress(), or Proceeding().<br>


### Syntax


```

SayCountedAdj(number,filename,[gender])
```
##### Arguments


* `number` - The number of things<br>

* `filename` - File name stem for the adjective<br>

* `gender` - The gender of the noun modified, one of 'm', 'f', 'n', or 'c'<br>

### See Also

* [Dialplan Applications SayCountedNoun](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayCountedNoun)
* [Dialplan Applications SayNumber](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayNumber)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 