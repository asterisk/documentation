# Commit Messages

This page describes the expected format for commit messages used when submitting code to the Asterisk project. See [Code Contribution](/Development/Policies-and-Procedures/Code-Contribution) for more information about pushing your commit for review.

A commit message serves to notify others of the changes made to the Asterisk source code, both in a historical sense and as part of teh code review process. Commit messages are **incredibly** important to the continued success of the Asterisk project. Developers maintaining the Asterisk project in the future will often only have your commit message to guide them in why a particular change was made. For non-developers, archives containing commit messages may be used when searching for fixes to a particular bug. Be sure that the information contained in your message will help them out.

/// warning | Follow These Rules!
Commit messages are part of your code change. Committing code with a poorly written commit message creates a maintenance problem for everyone in the Asterisk project.  Pull Requests can and will be rejected if the commit message doesn't follow these rules!
///

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

GitHub will automatically use the one-line summary as the title for pull requests created from the commit.  The rest of the commit message will then be placed in the first PR comment.

The verbose description may contain multiple paragraphs, itemized lists, etc. *Always end the first sentence (and any subsequent sentences) with punctuation.*

Commit messages should be wrapped at 80 columns.

Note that for trivial commits, such as fixes for spelling mistakes, the verbose description may not be necessary.

### GitHub Flavored Markdown

Since we've moved to a complete GitHub SCM solution, commit messages will automatically be rendered as [GitHub Flavored Markdown](https://github.github.com/gfm/) when viewed on GitHub.  Feel free to use markdown intentionally, especially to format code snippets, but also be aware that things you used to put in commit messages might unintentionally be rendered as markdown and be improperly formatted.  Consider that dashes and underscores might unintentionally be rendered as strike-through or bold text.

### Special Trailers for Commit Messages

GitHub and the Asterisk release process support several commit message trailers that are used to automatically close related issues and to create the release change logs.  The trailer name MUST start on a new line, be followed by a colon and a space (`: `) and each should be separated by a blank line.  If specified at all, the trailers listed below MUST be the last items in the commit message.

/// warning | Unofficial Trailers
If you specify any other trailers, including ones that were formerly acceptable, they will become part of the official trailer they follow. So, if you insist on adding trailers like `ASTERISK-nnnnn`, `Signed-Off-By` or `Reported-By` they MUST come BEFORE the first of the official trailers.
///

Current official trailers:

* **Resolves**: To reference a GitHub issue, use a  `Resolves: #<issueid>` trailer.  This causes GitHub to automatically close the issue when the PR is merged, and it adds the commit to the list of issues closed in the release change log.
* **Fixes**: Synonym for Resolves.  You can use either.
* **UpgradeNote**: To make users aware of possible breaking changes on update, use an `UpgradeNote: <text>` trailer.
* **UserNote**: To make users aware of a new feature or significant fix, use a `UserNote: <text>` trailer.
* **DeveloperNote**: To make developers aware of a new or changed API
or any other change that might be of interest to those working on Asterisk itself, custom modules, or external apps that integrate with Asterisk, use a `DeveloperNote: <text>` trailer.

Any user-affecting change (new feature, change to CLI commands, etc) must be documented with a `UserNote:` trailer.   Any potentially breaking change (change to or new alembic database scripts, change to dialplan application or function arguments, etc.) must be documented with an `UpgradeNote:` trailer.  Any changes to public APIs that might affect external developers must be documented with a `DeveloperNote:` trailer.  These trailers cause special notes to be output in the change log in addition to the full commit message.

/// warning | Updating Commit Messages
GitHub only looks in the PR comments for the `Resolves` or `Fixes` trailers not the commit message, however the Asterisk release process only looks in the commit message for the trailers so it's important that they match.  Be aware though, if you subsequently force push the commit after the PR is created, GitHub will NOT automatically update the PR title or the description/first comment from the updated commit so if you've added or changed the `Resolves:` or `Fixes:` trailers in the commit message and forced pushed, you MUST manually edit the PR description/first comment or GitHub won't be able to automatically close any related issues.
///

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
