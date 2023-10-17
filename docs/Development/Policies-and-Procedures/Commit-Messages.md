---
title: Commit Messages
pageid: 3702833
---

# Overview

A commit message serves to notify others of the changes made to the Asterisk source code, both in a historical sense and in the present. Commit messages are **incredibly** important to the continued success of the Asterisk project. Developers maintaining the Asterisk project in the future will often only have your commit message to guide them in why a particular change was made. For non-developers, archives containing commit messages may be used when searching for fixes to a particular bug. Be sure that the information contained in your message will help them out.

!!! warning Follow These Guidelines
    Commit messages are part of your code change. Committing code with a poorly written commit message creates a maintenance problem for everyone in the Asterisk project.  


[//]: # (end-warning)


This page describes the expected format for commit messages used when submitting code to the Asterisk project. See [Code Contribution](/Development/Policies-and-Procedures/Code-Contribution) for more information about pushing your commit for review.

## Commit Message Body

### Basic Format

The following illustrates the basic outline for commit messages:

```
<One-liner summary of changes>
<Empty Line>
<Verbose description of the changes>
<Empty Line>
<Special Trailers>

```

Your summary should, if possible, be preceded by the subsystem(s) affected by the change:

```
app_foo: Fix crash caused by invalid widget frobbing.

```

Most commit history viewers treat the first line of commit messages as the summary for the commit. In addition, the Asterisk project uses many scripts that parse commit messages for a variety of purposes. So, an effort should be made to format our commit messages in this fashion. The verbose description may contain multiple paragraphs, itemized lists, etc. *Always end the first sentence (and any subsequent sentences) with punctuation.*

Commit messages should be wrapped at 72 columns.

Note that for trivial commits, such as fixes for spelling mistakes, the verbose description may not be necessary.

### GitHub Flavored Markdown

Since we've moved to a complete GitHub SCM solution, commit messages will automatically be rendered as [GitHub Flavored Markdown](https://github.github.com/gfm/) when viewed on GitHub.  Feel free to use markdown intentionally, especially to format code snippets, but also be aware that things you used to put in commit messages might unintentionally be rendered as markdown and be improperly formatted.  Consider that dashes and underscores might unintentionally be rendered as strike-through or bold text.

### Special Trailers for Commit Messages

GitHub and our release process support several commit message trailers that are used by the change log generation process.  The trailer name MUST start on a new line, be followed by a colin (`:`) and each should be separated by a blank line.  If specified at all, the trailers listed below MUST be the last items in the commit message.  

!!! warning
    If you specify any other trailers, including ones that were formerly acceptable, they will become part of the official trailer they follow. So, if you insist on adding trailers like `ASTERISK-nnnnn`, `Signed-Off-By` or `Reported-By` they MUST come BEFORE the first of the official trailers.

Current official trailers:

* **Resolves**: To reference a GitHub issue, use a  `Resolves: #<issueid>` trailer.  This causes GitHub to automatically close the isse when the PR is merged, and it adds the commit to the list of issues closed in the release change log.
* **Fixes**: Synonym for Resolves.  You can use either.
* **UpgradeNote**: To make users aware of possible breaking changes on update, use an `UpgradeNote: <text>` trailer.
* **UserNote**: To make users aware of a new feature or significant fix, use a `UserNote: <text>` trailer.

Any user-affecting change (new feature, change to CLI commands, etc) must be documented with a `UserNote:` trailer.   Any breaking change (change to dialplan application or function arguments, API change, etc.) must be documented with an `UpgradeNote:` trailer.   Those trailers cause special notes to be output in the change log in addition to the full commit message.

## Example complete commit message:

```
app_foo.c: Add new 'x' argument to the Foo application

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

