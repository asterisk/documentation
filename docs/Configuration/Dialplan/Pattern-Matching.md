---
title: Pattern Matching
pageid: 4817353
---

The next concept we'll cover is called *pattern matching*. Pattern matching allows us to create extension patterns in our dialplan that match more than one possible dialed number. Pattern matching saves us from having to create an extension in the dialplan for every possible number that might be dialed.

When Alice dials a number on her phone, Asterisk first looks for an extension (in the context specified by the channel driver configuration) that matches exactly what Alice dialed. If there's no exact match, Asterisk then looks for a pattern that matches. After we show the syntax and some basic examples of pattern matching, we'll explain how Asterisk finds the best match if there are two or more patterns which match the dialed number.

Special Characters Used in Pattern Matching
===========================================

Pattern matches always begin with an underscore. This is how Asterisk recognizes that the extension is a pattern and not just an extension with a funny name. Within the pattern, we use various letters and characters to represent sets or ranges of numbers. Here are the most common letters:

X
-

The letter **X** or **x** represents a single digit from 0 to 9.

Z
-

The letter **Z** or **z** represents any digit from 1 to 9.

N
-

The letter **N** or **n** matches any digit from 2-9.



Ranges used in Pattern Matching
===============================

A numeric range can be used to match against a dialed number. This is also called a Character Set



[1237-9]
--------

This pattern matches any digit or letter in the brackets. In this example, the pattern will match: 1,2,3,7,8,9



Wilcards used in Pattern Matching
=================================

The following special characters are considered wildcards

* . The '.' character matches one or more characters
* ! The '!' character matches zero or more characters immediately



The exclamation mark wildcard (!), behaves specially and will be further explained below in 'Other Special Characters' below.

Please make sure to read 'Be Careful With Wildcards in Pattern Matches' below.






Basic Example
=============

Now let's look at a sample pattern. If you wanted to match all four-digit numbers that had the first two digits as six and four, you would create an extension that looks like:

```
exten => _64XX,1,SayDigits(${EXTEN})

```

In this example, each **X** represents a single digit, with any value from zero to nine.

The above pattern will match the following examples:

* 6400
* 6401
* 6450
* 6499

We're essentially saying "The first digit must be a six, the second digit must be a four, the third digit can be anything from zero to nine, and the fourth digit can be anything from zero to nine".

Complex Examples
================

Lets use some Character Sets and Wildcards

```
exten => _64X[4-9],1,SayDigits(${EXTEN})
exten => _[6-4]4[4-9],1,SayDigits(${EXTEN})
exten => _64.,1,SayDigits(${EXTEN})

```

The first example: The first must be a six, the second digit must be a four, the third digit can be anything from zero to nine, and the fourth digit must be between four and nine

The second example: The first digit must be between six and four, the second digit must be four, the third digit must be between four and nine

The third example: The first digit must be a six, the second digit must be a four, the third digit can be anything at all (including letters), and we will continue to collect digits until the user stops entering digits

Character Sets
==============

If we want to be more specific about a range of numbers, we can put those numbers or number ranges in square brackets to define a character set. For example, what if we wanted the second digit to be either a three or a four? One way would be to create two patterns (**_64XX** and **_63XX**), but a more compact method would be to do **_6[34]XX**. This specifies that the first digit must be a six, the second digit can be either a three or a four, and that the last two digits can be anything from zero to nine.

You can also use ranges within square brackets. For example, **[1-468]** would match a single digit from one through four or six or eight. It does not match any number from one to four hundred sixty-eight!




!!! note 
    The X, N, and Z convenience notations mentioned earlier have no special meaning within a set.

    The only characters with special meaning within a set are the '-' character, to define a range between two characters, the  '\' character to escape a special character available within a set, and  


      
[//]: # (end-note)



Other Special Characters
========================

Within Asterisk patterns, we can also use a couple of other characters to represent ranges of numbers. The period character (**.**) at the end of a pattern matches one or more remaining **characters**. You put it at the end of a pattern when you want to match extensions of an indeterminate length. As an example, the pattern **_9876.** would match any number that began with **9876** and had at least one more character or digit.

The exclamation mark (**!**) character is similar to the period and matches zero or more remaining characters. It is used in overlap dialing to dial through Asterisk. For example, **_9876!** would match any number that began with **9876** including **9876**, and would respond that the number was complete as soon as there was an unambiguous match.




!!! tip
**  Asterisk treats a period or exclamation mark as the end of a pattern. If you want a period or exclamation mark in your pattern as a plain character you should put it into a character set: **[.]** or **[!]
    .

      
[//]: # (end-tip)





!!! warning Be Careful With Wildcards in Pattern Matches
    Please be extremely cautious when using the period and exclamation mark characters in your pattern matches. They match more than just digits. They match on characters. If you're not careful to filter the input from your callers, a malicious caller might try to use these wildcards to bypass security boundaries on your system.

    For a more complete explanation of this topic and how you can protect yourself, please refer to the **README-SERIOUSLY.bestpractices.txt** file in the Asterisk source code.

      
[//]: # (end-warning)



Order of Pattern Matching
=========================

Now let's show what happens when there is more than one pattern that matches the dialed number. How does Asterisk know which pattern to choose as the best match?

Asterisk uses a simple set of rules to sort the extensions and patterns so that the best match is found first. The best match is simply the most specific pattern. The sorting rules are:

1. The dash (**-**) character is ignored in extensions and patterns except when it is used in a pattern to specify a range in a character set. It has no effect in matching or sorting extensions.
2. Non-pattern extensions are sorted in ASCII sort order before patterns.
3. Patterns are sorted by the most constrained character set per digit first. By most constrained, we mean the pattern that has the fewest possible matches for a digit. As an example, the **N** character has eight possible matches (two through nine), while **X** has ten possible matches (zero through nine) so **N** sorts first.
4. Character sets that have the same number of characters are sorted in ASCII sort order as if the sets were strings of the set characters. As an example, **X** is **0123456789** and **[a-j]** is **abcdefghij** so **X** sorts first. This sort ordering is important if the character sets overlap as with **[0-4]** and **[4-8]**.
5. The period (**.**) wildcard sorts after character sets.
6. The exclamation mark (**!**) wildcard sorts after the period wildcard.

Let's look at an example to better understand how this works. Let's assume Alice dials extension **6421**, and she has the following patterns in her dialplan:

```
exten => _6XX1,1,SayAlpha(A)
exten => _64XX,1,SayAlpha(B)
exten => _640X,1,SayAlpha(C)
exten => _6.,1,SayAlpha(D)
exten => _64NX,1,SayAlpha(E)
exten => _6[45]NX,1,SayAlpha(F)
exten => _6[34]NX,1,SayAlpha(G)

```

Can you tell (without reading ahead) which one would match?

Using the sorting rules explained above, the extensions sort as follows:  





---

  
Sorted extensions  

```
exten => _640X,1,SayAlpha(C)
exten => _64NX,1,SayAlpha(E)
exten => _64XX,1,SayAlpha(B)
exten => _6[34]NX,1,SayAlpha(G)
exten => _6[45]NX,1,SayAlpha(F)
exten => _6XX1,1,SayAlpha(A)
exten => _6.,1,SayAlpha(D)

```

When Alice dials **6421**, Asterisk searches through its list of sorted extensions and uses the first matching extension. In this case **_64NX** is found.

To verify that Asterisk actually does sort the extensions in the manner that we've shown, add the following extensions to the **[users]** context of your own dialplan.

```
exten => _6XX1,1,SayAlpha(A)
exten => _64XX,1,SayAlpha(B)
exten => _640X,1,SayAlpha(C)
exten => _6.,1,SayAlpha(D)
exten => _64NX,1,SayAlpha(E)
exten => _6[45]NX,1,SayAlpha(F)
exten => _6[34]NX,1,SayAlpha(G)

```

Reload the dialplan, and then type **dialplan show 6421@users** at the Asterisk CLI. Asterisk will show you all extensions that match in the **[users]** context. If you were to dial extension **6421** in the **[users]** context the first found extension will execute.

```
server*CLI> dialplan show 6421@users
[ Context 'users' created by 'pbxp_config' ]
 '_64NX' => 1. SayAlpha(E) [pbx_config]
 '_64XX' => 1. SayAlpha(B) [pbx_config]
 '_6[34]NX' => 1. SayAlpha(G) [pbx_config]
 '_6[45]NX' => 1. SayAlpha(F) [pbx_config]
 '_6XX1' => 1. SayAlpha(A) [pbx_config]
 '_6.' => 1. SayAlpha(D) [pbx_config]

-= 6 extensions (6 priorities) in 1 context. =-

```
```
server*CLI> dialplan show users
[ Context 'users' created by 'pbx_config' ]
 '_640X' => 1. SayAlpha(C) [pbx_config]
 '_64NX' => 1. SayAlpha(E) [pbx_config]
 '_64XX' => 1. SayAlpha(B) [pbx_config]
 '_6[34]NX' => 1. SayAlpha(G) [pbx_config]
 '_6[45]NX' => 1. SayAlpha(F) [pbx_config]
 '_6XX1' => 1. SayAlpha(A) [pbx_config]
 '_6.' => 1. SayAlpha(D) [pbx_config]

-= 7 extensions (7 priorities) in 1 context. =-

```

You can dial extension **6421** to try it out on your own.




!!! warning Be Careful with Pattern Matching
    Please be aware that because of the way auto-fallthrough works, if Asterisk can't find the next priority number for the current extension or pattern match, it will also look for that same priority in a less specific pattern match. Consider the following example:
[//]: # (end-warning)


  
  

```
exten => 6410,1,SayDigits(987)
exten => _641X,1,SayDigits(12345)
exten => _641X,n,SayDigits(54321)
  
```

---


If you were to dial extension **6410**, you'd hear "nine eight seven five four three two one".

We strongly recommend you make the **Hangup()** application be the last priority of any extension to avoid this behaviour, unless you purposely want to fall through to a less specific match.

```

Matching on Caller ID
=====================

Within an extension handler, it is also possible to match based upon the Caller ID of the incoming channel by appending a forward slash to the dialed extension or pattern, followed by a Caller ID pattern to be matched. Consider the following example, featuring phones with Caller IDs of 101, 102 and 103.

```
exten => 306,1,NoOp()
same => n,Background(goodbye)
same => n,Hangup()

exten => 306/_101,1,NoOp()
same => n,Background(year)
same => n,Hangup()

exten => 306/_102,1,NoOp()
same => n,Background(beep)
same => n,Hangup()

```

The phone with Caller ID 101, when dialing 306, will hear the prompt "year" and will be hung up.  The phone with Caller ID 102, when dialing 306, will hear the "beep" sound and will be hung up.  The phone with Caller ID 103, or any other caller, when dialing 306, will hear the "goodbye" prompt and will be hung up.




!!! warning Rewriting Caller ID
    Changing the value of **CALLERID(num)** variable inside of extension handler matched by Caller ID can immediately **throw the call to another handler**. Consider the following example:
[//]: # (end-warning)


  
  

```
[unexpected-jump-test]

exten => s/_1XX,1,Set(CALLERID(num)=200) ; <- Example call starts here
same => 2,Hangup() ; <- This line is NEVER reached normally because of the assignment above

exten => s/_2XX,1,SayDigits(1)
same => 2,SayDigits(2) ; <- This is where the dialplan proceeds instead
same => 3,SayDigits(3)
same => 4,SayDigits(4)  



---


You'd expect the call with Caller ID 100 to hang up, but instead you'd hear Asterisk saying "two, three, four".  

```

