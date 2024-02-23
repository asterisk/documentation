---
title: Pattern Matching
pageid: 4817353
---

The next concept we'll cover is called *pattern matching*. Pattern matching allows us to create extension patterns in our dialplan that match more than one possible dialed number. It saves us from having to create an extension in the dialplan for every possible number that might be dialed.

When Alice dials a number on her phone, Asterisk first looks for an extension (in the context specified by the channel driver configuration) that matches exactly what Alice dialed. If there's no exact match, Asterisk then looks for a pattern that matches. After we show the syntax and some basic examples of pattern matching, we'll explain how Asterisk finds the best match if there are two or more patterns which match the dialed number.

**Pattern matches always begin with an underscore**. This is how Asterisk recognizes that the extension is a pattern and not just an extension with a funny name. Within the pattern, we use various letters and characters to represent a collection of dial numbers.


Character Set
-------------

Place the characters you want to match between square brackets. If you want to match an `a` or an `e`, use `[ae]`, like in `gr[ae]y`, which matches either `gray` or `grey`.

**Examples**:
* `_gr[ae]y`: Matches `gray`, `grey`
* `_[1-468]`: Matches `1`, `2`, `3`, `4`, `6`, `8`. Note that it does **NOT** match numbers from one to four hundred sixty-eight!
* `_a[c-e]`: Matches `ac`, `ad`, `ae`
* `_[127-9ac-e]`: Matches `1`, `2`, `7`, `8`, `9`, `a`, `c`, `d`, `e`


Special Symbols
---------------

Some Character Sets can be written in a short form. Here are the most common ones:

* `_[0-9]` = `_X` (or `x`): Represents a single digit from 0 to 9.
* `_[1-9]` = `_Z` (or `z`): Represents any digit from 1 to 9.
* `_[2-9]` = `_N` (or `n`): Matches any digit from 2 to 9.

**Examples**:
* `_6[34]XX`: Short form of `_64XX` and `_63XX`, matches `6400`, `6300`, `6401`, `6301`, `6420`, `6320`, `6433`, `6333`, ...
* `_6[34X]`: Matches `63`, `64`, `6X`. The `X`, `N`, and `Z` convenience notations have no special meaning within a set, they represent the literal character.

!!! note
    The only characters with special meaning within a set are the `-` character, to define a range between two characters, the  `\` character to escape a special character available within a set, and  
[//]: # (end-note)


Wilcards
--------

Within Asterisk patterns, we can also use other characters to represent a *family* of dial numbers. The following special characters are considered wildcards:

* `!`: Matches zero or more characters *immediately*. Equivalent to RegEx's `*` quantifier. This wildcard behaves specially. It is used in overlap dialing to dial through Asterisk. For example, `_9876!` would match any number that began with `9876` including `9876`, and would respond that the number was complete as soon as there was an unambiguous match.
* `.`: Matches one or more characters. Equivalent to RegEx's `+` quantifier.

**Examples**:
* `_9876!`: Matches any number that began with `9876` and has zero or more character or digit, *e.g* `9876`, `98760`, `9876a`, `9876xxx`...
* `_9876.`: Matches any number that began with `9876` and has at least one more character or digit, *e.g* `98760`, `9876a`, `9876xxx`...

!!! tip
    Asterisk treats a period or exclamation mark as the end of a pattern. If you want a period or exclamation mark in your pattern as a plain character you should put it into a character set, as in `[.]` and `[!]`.
[//]: # (end-tip)

!!! warning Be Careful With Wildcards in Pattern Matches
    Please be extremely cautious when using the period and exclamation mark characters in your pattern matches. They match more than just digits. They match on characters. If you're not careful to filter the input from your callers, a malicious caller might try to use these wildcards to bypass security boundaries on your system.

    For a more complete explanation of this topic and how you can protect yourself, please refer to the [README-SERIOUSLY.bestpractices.txt](https://github.com/asterisk/asterisk/blob/master/README-SERIOUSLY.bestpractices.md) file in the Asterisk source code.
[//]: # (end-warning)


Basic Example
-------------

Now let's look at a sample pattern. If you wanted to match numbers with exactly four digits that had the first two digits as six and three, you would create an extension that looks like:

```
[users]
exten => _63XX,1,SayDigits(${EXTEN})
```

In this example, each `X` represents a single digit, with any value from zero to nine.

The above pattern will match the following examples:

* `6300`
* `6301`
* `6350`
* `6399`

We're essentially saying "The first digit must be a six, the second digit must be a three, the third digit can be anything from zero to nine, and the fourth digit can be anything from zero to nine".


Complex Examples
----------------

Lets use some Character Sets and Wildcards.

```
[users]
exten => _64X[4-9],1,SayDigits(${EXTEN})
exten => _[6-4]4[4-9],1,SayDigits(${EXTEN})
exten => _64.,1,SayDigits(${EXTEN})
```

The first example: The first must be a six, the second digit must be a four, the third digit can be anything from zero to nine, and the fourth digit must be between four and nine.

The second example: The first digit must be between six and four, the second digit must be four, the third digit must be between four and nine.

The third example: The first digit must be a six, the second digit must be a four, the third digit can be anything at all (including letters), and we will continue to collect digits until the user stops entering digits.


Order of Pattern Matching
-------------------------

Now let's show what happens when there is more than one pattern that matches the dialed number. How does Asterisk know which pattern to choose as the best match?

Asterisk uses a simple set of rules to sort the extensions and patterns so that the best match is found first. The best match is simply the most specific pattern. The sorting rules are:

1. The dash (`-`) character is ignored in extensions and patterns except when it is used in a pattern to specify a range in a character set. It has no effect in matching or sorting extensions.
2. Non-pattern extensions are sorted in ASCII sort order before patterns.
3. Patterns are sorted by the most constrained character set per digit first. By most constrained, we mean the pattern that has the fewest possible matches for a digit. As an example, the `N` character has eight possible matches (two through nine), while `X` has ten possible matches (zero through nine) so `N` sorts first.
4. Character sets that have the same number of characters are sorted in ASCII sort order as if the sets were strings of the set characters. As an example, `X` is `0123456789` and `[a-j]` is `abcdefghij` so `X` sorts first. This sort ordering is important if the character sets overlap as with `[0-4]` and `[4-8]`.
5. The period (`.`) wildcard sorts after character sets.
6. The exclamation mark (`!`) wildcard sorts after the period wildcard.

Let's look at an example to better understand how this works. Let's assume Alice dials extension **6421**, and she has the following dialplan:

```
[users]
exten => _6XX1,1,SayAlpha(A)
exten => _64XX,1,SayAlpha(B)
exten => _640X,1,SayAlpha(C)
exten => _6.,1,SayAlpha(D)
exten => _64NX,1,SayAlpha(E)
exten => _6[45]NX,1,SayAlpha(F)
exten => _6[34]NX,1,SayAlpha(G)
```

Can you tell (*without reading ahead*) which one would match?

Using the sorting rules explained above, the extensions sort as follows:  

```
[users]
exten => _640X,1,SayAlpha(C)
exten => _64NX,1,SayAlpha(E)
exten => _64XX,1,SayAlpha(B)
exten => _6[34]NX,1,SayAlpha(G)
exten => _6[45]NX,1,SayAlpha(F)
exten => _6XX1,1,SayAlpha(A)
exten => _6.,1,SayAlpha(D)
```

When Alice dials `6421`, Asterisk searches through its list of sorted extensions and uses the first matching extension. In this case `_64NX` is found.

To verify that Asterisk actually does sort the extensions in the manner that we've shown, copy the example dialplan to `extensions.conf` and type `dialplan reload` at the Asterisk CLI. The dialplan then becomes:

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

To show all extensions that match in the `[users]` context, type `dialplan show 6421@users` at the Asterisk CLI:

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

If you were to dial extension **6421** in the **[users]** context the first found extension would execute (*i.e.* `_64NX`).

You can dial extension **6421** to try it out on your own.


Auto-Fallthrough
----------------

!!! warning Be Careful with Pattern Matching
    Please be aware that because of the way auto-fallthrough works, if Asterisk can't find the next priority number for the current extension or pattern match, it will also look for that next priority in a less specific pattern match.
[//]: # (end-warning)

Consider the following example:

```
[users]
exten => 6410,1,SayDigits(987)
exten => _641X,1,SayDigits(12345)
exten => _641X,n,SayDigits(54321)
```

If you were to dial extension **6410**, you'd hear "nine eight seven five four three two one".

We strongly recommend you make the `Hangup()` application be the last priority of any extension to avoid this behaviour, unless you purposely want to fall through to a less specific match.


Matching on Caller ID
---------------------

Within an extension handler, it is also possible to match based upon the Caller ID of the incoming channel by appending a forward slash to the dialed extension or pattern, followed by a Caller ID pattern to be matched. Consider the following example.

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

The phone with Caller ID 101, when dialing 306, will hear the "year" prompt and will be hung up.

The phone with Caller ID 102, when dialing 306, will hear the "beep" prompt and will be hung up.

The phone with Caller ID 103, or *any* other caller, when dialing 306, will hear the "goodbye" prompt and will be hung up.

---

!!! warning Rewriting Caller ID
    Changing the value of `CALLERID(num)` variable inside of extension handler matched by Caller ID can immediately **throw the call to another handler**.
[//]: # (end-warning)

Considering the following example, you'd expect the call with Caller ID 100 to hang up, but instead you'd hear Asterisk saying "two, three, four".  

```
[users]
exten => s/_1XX,1,Set(CALLERID(num)=200) ; <- Example call starts here
    same => n,Hangup() ; <- This line is NEVER reached normally because of the assignment above

exten => s/_2XX,1,SayDigits(1)
    same => n,SayDigits(2) ; <- This is where the dialplan jumps instead
    same => n,SayDigits(3)
    same => n,SayDigits(4)  
```
