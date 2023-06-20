---
title: Code Contribution
pageid: 52069715
---

Overview
========

All code management/contribution/review processes will be handled with [GitHub Asterisk Pull Requests](https://github.com/asterisk/asterisk/pulls) and [GitHub Testsuite Pull Requests](https://github.com/asterisk/testsuite/pulls).   Note that Asterisk and Testsuite pull requests must be created in their own repositories.

Code Contribution Process
=========================

Install the [GitHub CLI "gh"](https://cli.github.com) tool
----------------------------------------------------------

While not strictly required, using the "[gh](https://cli.github.com)" tool to manage the process will make things much easier.  The package is available in most distribution's package management systems as "gh".

1. Create a GitHub Personal Access Token.  Although "[gh](https://cli.github.com)" will allow you to authenticate via a browser, having a PAT does make things easier.
	1. Log into GitHub
	2. Navigate to Settings/Developer Settings.
	3. Click "Personal access tokens"
	4. Click "Tokens (classic)".  Don't use "Fine-grained tokens".
	5. Click "Generate new token" and select "Generate new token (classic)"
	6. Set the name and expiration to your liking.
	7. Select at least the "repo", "workflow", "admin:org/read:org" and "user" scopes.
	8. Click "Generate token"
	9. Copy the generated token to a safe place.  YOU CAN'T VIEW IT AGAIN.
2. Install "gh" from your distribution's package manager or download directly from [https://cli.github.com](https://cli.github.com)(https://cli.github.com/)
3. Run `gh auth login`
	1. Select "GitHub.com as the account
	2. Select "HTTPS" as the preferred protocol for Git operation
	3. Select "paste an authentication token" as the authentication method.
4. Run `gh auth setup-git` to allow git itself to use the gh authentication method.

Fork the Repositories
---------------------

Contributors must fork the [asterisk/asterisk](https://github.com/asterisk/asterisk) and [asterisk/testsuite](https://github.com/asterisk/testsuite) repositories into their own GitHub account. If you clone the asterisk/asterisk or asterisk/testsuite repositories directly to your development system you will NOT be able to submit pull requests from it.  If you have existing repositories cloned from Gerrit, please don't try to re-use the clone by changing the remotes.  Similarly, if you happen to already have a fork of the repos in your GitHub account, it's a good idea to delete those forks and re-create them.  Starting fresh will ensure you don't have issues later.

1. Run `gh repo fork asterisk/asterisk` and `gh repo fork asterisk/testsuite`
2. Run `gh repo clone <user>/asterisk` and `gh repo clone <user>/testsuite`




---

**WARNING!:**   
The `gh repo fork` command has a `--clone` option that's supposed to do both of the above steps at the same time however it rarely works and usually creates a mess. The reason is that after a fork operation *appears* to complete, it can take a few seconds before GitHub finishes background work during which time attempts to clone will fail. The `gh` tool doesn't account for this and tries to clone immediately which fails with a "repository not found" message.

  



---


Git Remotes will automatically be created for both your fork and the upstream repo.

In each of the clones, run `gh repo set-default`.  Select either asterisk/asterisk or asterisk/testsuite as appropriate.  They should be the defaults but check anyway. Also run `git config user.email` and `git config user.name` in each of the repos to make sure they're correct.  At a minimum, user.email should match one of the emails you've added to your GitHub account.

Do Work
-------

Checkout the **HIGHEST** VERSION branch to which your work will apply ('master', '20', '18', etc.), update it to match the upstream repo, then push it to your fork.

1. `git checkout master`
2. `git pull upstream master`
3. `git push`

Now, check out that branch to a branch with a new name.  For instance if you're working on issue 45 and your work will apply to the 18, 20 and master branches, check out the master branch and create a new branch from it: 

1. `git checkout -b master-issue-45`

The name of the new branch can be anything but it does show up in the GitHub UI so including the base branch at least is a good idea.  That branch name will also be used if someone downloads your PR for testing.

If your work fixes a bug in a non-master branch that doesn't exist in the higher branches, start with the highest version branch that the fix does apply to.  For instance, if the fix applies to 20 and 18 but not master, base your new branch on 20.




---

**WARNING!:**   
You should never do work in the upstream branches like '18', '20', or 'master'.  Doing so will pollute those branches in your fork and will make updating them difficult.

  



---


Now make your change and test locally.




---

**Note:**  You no longer have to create entries in the doc/CHANGES-staging or doc/UPGRADE-staging directories. The change logs are generated from the commit messages. See below.

  



---


Commit
------

Commit messages should follow the guidelines established in [Commit Messages](/Development/Policies-and-Procedures/Commit-Messages).  That page will be updated as follows after the cut-over.

* You can use [GitHub Flavored Markdown](https://github.github.com/gfm/) in your commit messages to make them look nicer.
* If there isn't an open GitHub issue for your work, open one now.  If there was an existing JIRA issue, you must still open a new GitHub issue.
* To reference an issue, use a  `Resolves: #<issueid>` header on a separate line.
* To make users aware of possible breaking changes on update, use an `UpgradeNote: <text>` header starting on a new line and ending with an empty line.
* To make users aware of a new feature or significant fix, use a `UserNote: <text>` header starting on a new line and ending with an empty line.

The new headers create entries near the top of the ChangeLogs.




---

  
Sample Commit Message  


```

textapp\_something:  Add some new capability 
 
app\_something has been updated to include new feature "X". To configure,
edit app\_something.conf and add an "X = something" to the "general"
section.
 
Resolves: #456
 
UpgradeNote: The old "X" option in app\_something.conf has been renamed to
"Z" to better reflect its true purpose.
 
UserNote: app\_something has been updated to include new feature "X".

```



---


Test and check for Cherry-pick-ability
--------------------------------------

This should go without saying but test your change locally to make sure it does what you think it should and that it doesn't break anything else.  If it passes and it needs to be cherry-picked to other branches, test cherry-picking now.  Create a new branch off the cherry-pick target branch, cherry-pick your change into it then compile and test.  If it picks cleanly and passes your tests, you can just delete the branch as you won't be creating additional pull requests for it.  If it doesn't apply or pass the tests, you have two options...

1. Change the code in the original branch, amend the commit and re-cherry-pick and test as many times as needed to get it to pass in both branches, then you can delete the new branch.
2. Submit a separate pull request from the target branch using the process below.

You should always use option 1 when possible.  Unlike Gerrit, GitHub was never designed to handle pushing the same change to multiple branches.  There's no easy way to relate the pull requests and even the GitHub UI doesn't indicate what the target branch is.  This makes it labor intensive for us to manage.

Create a Pull Request
---------------------

When you've finished your work and committed, you can create a new pull request by running `gh pr create --fill --base 18`.  The `--fill` option sets the pull request description to the same as the commit message and the `--base` option indicates which asterisk branch the pull request is targeted for.  This is similar to running `git review 18` to create a new Gerrit review.  When prompted where the new branch should be pushed, choose your fork, NOT the upstream repo.

If you want your change to be automatically cherry-picked to other branches, you'll need to add a comment to your pull request.  Head over to <https://github.com/asterisk/asterisk/pulls> and open your PR. Add a comment with a `cherry-pick-to: <branch>"` header line for each branch.  For example, if the PR is against the master branch and you want it cherry-picked down to 20 and 18...




---

  
PR Cherry-Pick Request comment example  


```

textcherry-pick-to: 20
cherry-pick-to: 18

```



---


Each branch must be on a separate line and don't put anything else in the comment.  When all the PR tests and checks have passed, an Asterisk Core developer will trigger the cherry-pick test process which will look for that comment.  If the commit can't be cherry-picked cleanly to the branches you indicated or the tests fail, none of the commits will be merged.  This is why it's important for you to make sure your commit cherry-picks cleanly before submitting the first pull request.

If you don't need your PR automatically cherry-picked, please add a comment stating "No cherry-picks required".  This saves us not having to ask if you want it cherry-picked.




---

**Note:**  You can also add comments to a PR from the command line with `gh pr comment`. See the man page for more info.

  



---




---

**WARNING!:**   
**If you change your mind and don't want your PR automatically cherry-picked, edit the comment and replace the "cherry-pick-to" lines with "No cherry-picks required".** Don't use formatting or other means to say "nevermind". The automation might not understand.

  



---


 

Pull Request Review Process
===========================

As with Gerrit reviews, a new PR triggers a set of tests and checks.  If you browse to your PR and scroll to the bottom, you'll see the status of those checks listed.  There are some differences to Gerrit however.

New Contributor License Agreement
---------------------------------

Every contributor will be required to sign a new Contributor License Agreement before their first PR can be merged.  One of the PR checks will be "license/cla" which looks like this...

![](image2023-4-17-14:4:2.png)

which indicates that you haven't signed it yet.  Click the "Details" link to be taken to the page that allows you to fill out the form and sign.  Acceptance is automatic so there should be no delay and you only have to do this once.  YOUR PR CANNOT BE MERGED UNTIL THIS CHECK IS COMPLETED.

Automated Tests
---------------

GitHub gives us access to more resources for testing than we've ever had so instead of running the Unit tests at PR submission and the Gate/Testsuite tests when the change has been approved, we run both the Unit and Gate/Testsuite tests immediately upon submission.  The Unit tests run as a single job/check but the Gates are broken up into multiple jobs/checks so they can be run in parallel.  When each check is completed, a comment will be added to the PR with the result and each check will have it's own line in the checks summary a the bottom of the PR.  All checks must pass or be deemed "false alarms" before a PR can be merged.

Reviewing a change
------------------

GitHub has two types of Pull Request comments.

### General Comments

These are comments you leave on the main PR page.  They are just that...comments.  They have no bearing on whether the PR can be merged.  If you have general comments or questions about a PR,  this is where you leave them.  The Gerrit equivalent is clicking the "REPLY" button at the top of the review and leaving a comment without changing your vote.

### Review Comments

These are comments you have about the code itself.  These are left by clicking on the 'Files changed" tab at the top of the PR, then...

* Clicking the 'Review changes" button to leave an overall comment and vote.  This is similar to clicking the "REPLY" button at the top of a Gerrit review and leaving a comment with a vote.
* Clicking on a specific line in a file to leave a single comment without a vote.  This is similar to clicking on a file in a Gerrit review, entering a comment on a specific line, but leaving your vote at "0" when clicking the "REPLY" button.  Unlike a general comment however, this type of comment creates a "conversation" which must be "resolved" before a PR can be merged.
* Clicking on a specific line in a file to leave a comment and starting a review where you will leave a vote.  This is similar to clicking on a file in a Gerrit review, entering a comment on a specific line, then setting your vote to +1 or -1 when clicking the "REPLY" button.




---

**Note:**  If you're not the submitter but you want to test a PR locally, you can do so easily with the gh tool:

`gh pr checkout <pr_number>` 

  



---


Address Review Comments and Test Failures
-----------------------------------------

If you need to make code changes to address comments or failures, the process is much like it is with Gerrit...

1. Make the changes locally in the branch you submitted the PR from.
2. When finished, do a `git commit -a --amend`
3. Push the commit to GitHub with `git push --force`

This will force push the commit to your fork first, then update the PR with the new commit and restart the testing process.




---

**WARNING!:**   
Unlike Gerrit, GitHub allows you to have multiple commits for a pull request but it was intended to allow a PR to be broken up into multiple logical chunks, not to address review comments. Using multiple commits to address review comments will make the commit history messy and confusing. Please amend and force push for them.  



---


Cherry-Pick Tests
-----------------

When an Asterisk Core Team member believes the PR is ready, they'll add a `cherry-pick` label to the PR that will jobs to run that check that the cherry-pick applies cleanly to the other branches and run the same automated tests that ran for the original PR.  These tests must pass (or be deemed false alarms) for the PR to be eligible for merging.

Merge
-----

When an Asterisk Core Team member believes the PR is ready for merging, they'll approve the merge which will cause the original PR to merge into its target branch and cause the change to be cherry-picked  into each of the cherry-pick target branches.

