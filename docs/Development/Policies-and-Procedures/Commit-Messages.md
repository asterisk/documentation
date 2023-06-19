---
title: Commit Messages
pageid: 3702833
---

A commit message serves to notify others of the changes made to the Asterisk source code, both in a historical sense and in the present. Commit messages are **incredibly** important to the continued success of the Asterisk project. Developers maintaining the Asterisk project in the future will often only have your commit message to guide them in why a particular change was made. For non-developers, archives containing commit messages may be used when searching for fixes to a particular bug. Be sure that the information contained in your message will help them out.




---

**WARNING!: Follow These Guidelines**  
Commit messages are part of your code change. Committing code with a poorly written commit message creates a maintenance problem for everyone in the Asterisk project.  


  



---


This page describes the expected format for commit messages used when submitting code to the Asterisk project. See [Gerrit Usage](/Gerrit-Usage) for more information about pushing your commit for review.

On This Page 


Commit Message Body
===================

### Basic Format

The following illustrates the basic outline for commit messages:




---

  
  


```

<One-liner summary of changes>
<Empty Line>
<Verbose description of the changes>
<Empty Line>
<Special Tags>

```



---


Your summary should, if possible, be preceded by the subsystem(s) affected by the change:




---

  
  


```

app\_foo: Fix crash caused by invalid widget frobbing.

```



---


Some commit history viewers treat the first line of commit messages as the summary for the commit. In addition, the Asterisk project uses many scripts that parse commit messages for a variety of purposes. So, an effort should be made to format our commit messages in this fashion. The verbose description may contain multiple paragraphs, itemized lists, etc. *Always end the first sentence (and any subsequent sentences) with punctuation.*

Commit messages should be wrapped at 72 columns.

Note that for trivial commits, such as fixes for spelling mistakes, the verbose description may not be necessary.

### GitHub Flavored Markdown

Since we've moved to a complete GitHub SCM solution, commit messages will automatically be rendered as markdown when viewed on GitHub.  Feel free to use markdown intentionally, especially to format code snippets, but also be aware that things you used to put in commit messages might unintentionally be rendered as markdown and be improperly formatted.  Consider that dashes and underscores might unintentionally be rendered as strike-through or bold text.

Special Tags for Commit Messages
================================

GitHub and our release process support several commit message trailers.  The trailer name MUST start on a new line and each should be separated by a blank line.  If specified at all, the trailers listed below MUST be the last items in the commit message.  If you specify any other trailers, including ones that were formerly acceptable, they will become part of the official trailer they follow.  so, if you insist on adding trailers like `Signed-Off-By` or `Reported-By` they MUST come before the fist of the official trailers.

### Issue Referencing

To have a commit noted in an issue and to also close the issue, reference the issue with a `Resolves` or `Fixes` commit message trailer as follows:




---

  
  


```

Resolves: #45
or
Fixes: #45

```



---


The trailer must start at the beginning of a new line and contain nothing on the line after it.   The colon separator is important for the automation and the only spaces allowed are between the colon and the hash sign.  The regex for this is `^(Resolves|Fixes):\s*[#][0-9]+`.  

Upgrade and User Notes
----------------------

With the migration to GitHub, Changelog and Upgrade notes are no longer supplied separately in the `doc/CHANGES-staging` and `doc/UPGRADE-staging` directories.  Instead they should be supplied in the commit message as trailers.  Any user-affecting change (new feature, change to CLI commands, etc) must be documented with a `UserNote:` trailer.   Any breaking change (change to dialplan application or function arguments, API change, etc.) must be documented with an `UpgradeNote:` trailer.   Those trailers cause special notes to be output in the change log in addition to the full commit message.  Example complete commit message:




---

  
  


```

app\_foo.c: Add new 'x' argument to the Foo application
 
The Foo application now has an addition argument 'x' that can manipulate
the output RTP stream of the remote channel by causing it to pause for
a configured amount of time, at a configured interval and a configured
number of times. There's no real use for this other as an example of
how to format a commit message. 
 
The code required changes to a number of other modules and is fairly
invasive and poorly written. It also required removing an option from
the existing OldFoo application.
 
Fixes: #666
 
UserNote: The Foo dialplan application now takes an additional argument
'x(a,b,c)' which will cause the remote channel to pause RTP output for
'a' milliseconds, every 'b' milliseconds, a total of 'c' times.
 
UpgradeNote: The X argument to the OldFoo application has been removed
and will cause an error if supplied.
 

```



---


 

 

