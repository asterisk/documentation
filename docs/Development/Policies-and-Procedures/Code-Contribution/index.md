# Code Contribution

All code management/contribution/review processes will be handled with [GitHub Asterisk Pull Requests](https://github.com/asterisk/asterisk/pulls) and [GitHub Testsuite Pull Requests](https://github.com/asterisk/testsuite/pulls).   Note that Asterisk and Testsuite pull requests must be created in their own repositories.

## Code Contribution Process

### Install the [GitHub CLI "gh"](https://cli.github.com) tool

While not strictly required, using the "[gh](https://cli.github.com)" tool to manage the process will make things much easier.  The package is available in most distribution's package management systems as "gh".

1. Create a GitHub Personal Access Token.  Although "[gh](https://cli.github.com)" will allow you to authenticate via a browser, having a PAT does make things easier.
	1. Log into GitHub
	2. Navigate to Settings/Developer Settings.
	3. Click "Personal access tokens"
	4. Click "Tokens (classic)".  Don't use "Fine-grained tokens".
	5. Click "Generate new token" and select "Generate new token (classic)"
	6. Set the name and expiration to your liking.
	7. Select at least the "repo", "workflow", "admin:org/read:org" and "user" scopes.
	8. Click "Generate token"
	9. Copy the generated token to a safe place.  YOU CAN'T VIEW IT AGAIN.
2. Install "gh" from your distribution's package manager or download directly from [https://cli.github.com](https://cli.github.com)(https://cli.github.com/)
3. Run `gh auth login`
	1. Select "GitHub.com as the account
	2. Select "HTTPS" as the preferred protocol for Git operation
	3. Select "paste an authentication token" as the authentication method.
4. Run `gh auth setup-git` to allow git itself to use the gh authentication method.

### Fork the Repositories

Contributors must fork the [asterisk/asterisk](https://github.com/asterisk/asterisk) and [asterisk/testsuite](https://github.com/asterisk/testsuite) repositories into their own GitHub account. If you clone the asterisk/asterisk or asterisk/testsuite repositories directly to your development system you will NOT be able to submit pull requests from it.  If you have existing repositories cloned from Gerrit, please don't try to re-use the clone by changing the remotes.  Similarly, if you happen to already have a fork of the repos in your GitHub account, it's a good idea to delete those forks and re-create them.  Starting fresh will ensure you don't have issues later.

1. Run `gh repo fork asterisk/asterisk` and `gh repo fork asterisk/testsuite`
2. Run `gh repo clone <user>/asterisk` and `gh repo clone <user>/testsuite`

/// warning 
The `gh repo fork` command has a `--clone` option that's supposed to do both of the above steps at the same time however it rarely works and usually creates a mess. The reason is that after a fork operation *appears* to complete, it can take a few seconds before GitHub finishes background work during which time attempts to clone will fail. The `gh` tool doesn't account for this and tries to clone immediately which fails with a "repository not found" message.
///

Git Remotes will automatically be created for both your fork and the upstream repo.

In each of the clones, run `gh repo set-default`.  Select either asterisk/asterisk or asterisk/testsuite as appropriate.  They should be the defaults but check anyway. Also run `git config user.email` and `git config user.name` in each of the repos to make sure they're correct.  At a minimum, user.email should match one of the emails you've added to your GitHub account.

### Do Work

Checkout the **HIGHEST** VERSION branch to which your work will apply ('master', '20', '18', etc.), update it to match the upstream repo, then push it to your fork.

1. `git checkout master`
2. `git pull upstream master`
3. `git push`

Now, check out that branch to a branch with a new name.  For instance if you're working on issue 45 and your work will apply to the 18, 20 and master branches, check out the master branch and create a new branch from it:

1. `git checkout -b master-issue-45`

The name of the new branch can be anything but it does show up in the GitHub UI so including the base branch at least is a good idea.  That branch name will also be used if someone downloads your PR for testing.

If your work fixes a bug in a non-master branch that doesn't exist in the higher branches, start with the highest version branch that the fix does apply to.  For instance, if the fix applies to 20 and 18 but not master, base your new branch on 20.

/// warning 
You should never do work in the upstream branches like '18', '20', or 'master'.  Doing so will pollute those branches in your fork and will make updating them difficult.
///

Now make your change and test locally.

/// note 
You MUST not create entries in the doc/CHANGES-staging or doc/UPGRADE-staging directories as was done in the past. The change logs are now generated from the commit messages. See below.
///

### Commit

Commit messages should follow the guidelines established in [Commit Messages](/Development/Policies-and-Procedures/Commit-Messages). 

Sample Commit Message

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

### Test and check for Cherry-pick-ability

This should go without saying but test your change locally to make sure it does what you think it should and that it doesn't break anything else.  If it passes and it needs to be cherry-picked to other branches, test cherry-picking now.  Create a new branch off the cherry-pick target branch, cherry-pick your change into it then compile and test.  If it picks cleanly and passes your tests, you can just delete the branch as you won't be creating additional pull requests for it.  If it doesn't apply or pass the tests, you have two options...

1. Change the code in the original branch, amend the commit and re-cherry-pick and test as many times as needed to get it to pass in both branches, then you can delete the new branch.
2. Submit a separate pull request from the target branch using the process below.

You should always use option 1 when possible.  Unlike Gerrit, GitHub was never designed to handle pushing the same change to multiple branches.  There's no easy way to relate the pull requests and even the GitHub UI doesn't indicate what the target branch is.  This makes it labor intensive for us to manage.

### Create a Pull Request

When you've finished your work and committed, you can create a new pull request by running `gh pr create --fill --base 18`.  The `--fill` option sets the pull request description to the same as the commit message and the `--base` option indicates which asterisk branch the pull request is targeted for.  This is similar to running `git review 18` to create a new Gerrit review.  When prompted where the new branch should be pushed, choose your fork, NOT the upstream repo.

#### Multiple Commits
There are only two situations where you may have multiple commits in a single pull request:

##### Multiple commits that stand on their own
You may have multiple commits in a single PR if the the commits represent a progression of changes that can stand on their own.  For instance, a commit to add a feature to a core source file, then a commit against an application to use that new feature.  In this case, each commit will be merged as is, without squashing.  You must be prepared to do some juggling however should changes be requested to an earlier commit in the series.  For instance, if changes were requested to commit 1, you'd have to reset your working branch back to that commit, make your fixes, do a `git commit -a --amend`, reapply commit 2 on top of that amended commit, then do a `git push --force` to update the PR.

/// warning
You MUST add a comment with the exact content below to your PR otherwise the automation will flag your PR with a reminder that multiple commits are not normally allowed and will prevent it from being merged.
```
multiple-commits: standalone
```
///

##### Interim commits to facilitate code review
You may also have multiple commits in your PR if your PR is complex and you've been asked to make changes that might be hard for a reviewer to re-review.  For instance, if your initial commit contained multiple changes to multiple files and you've been requested to make a change like correcting indentation, it might be hard for a reviewer to figure out what changed if you made your changes and just did an amend and force push on your original commit because the changes might be buried in what was a large diff originally.

In this case, the multiple commits will NOT be allowed into the codebase as is.  You MUST ultimately squash your interim commits down to one commit before it will be approved for merging.

/// warning
You MUST add a comment with the exact content below to your PR otherwise the automation will flag your PR with a reminder that multiple commits are not normally allowed.

```
multiple-commits: interim
```
///

#### Cherry picking
If you want your change to be automatically cherry-picked to other branches, you'll need to add a comment to your pull request.  Head over to <https://github.com/asterisk/asterisk/pulls> and open your PR. Add a comment with a `cherry-pick-to: <branch>"` header line for each branch.  For example, if the PR is against the master branch and you want it cherry-picked down to 20 and 18, add a comment with the following:

```text
cherry-pick-to: 20
cherry-pick-to: 18
```

Each branch must be on a separate line and don't put anything else in the comment.  When all the PR tests and checks have passed, an Asterisk Core developer will trigger the cherry-pick test process which will look for that comment.  If the commit can't be cherry-picked cleanly to the branches you indicated or the tests fail, none of the commits will be merged.  This is why it's important for you to make sure your commit cherry-picks cleanly before submitting the first pull request.

If you don't need your PR automatically cherry-picked, please add a comment stating `cherry-pick-to: none`.  This saves us not having to ask if you want it cherry-picked and suppresses the automated reminder.

You have a minimum of two minutes from the time the PR is submitted before the automation will remind you to add either branch-specific entries or a `cherry-pick-to: none` entry.  In reality, that check is done when the submit tests are completed so you probably have at least 30 minutes.

/// note 
You can also add comments to a PR from the command line with `gh pr comment`. See the man page for more info.
///

/// warning
Don't add the `cherry-pick-to` lines to the commit message or the PR description.  They're only searched for in PR comments.
///

/// warning 
**If you change your mind and don't want your PR automatically cherry-picked, edit the comment and replace the "cherry-pick-to" lines with a single `cherry-pick-to: none` line** Don't use formatting or other means to say "nevermind". The automation might not understand.
///

#### Test against a Testsuite PR

If you've created a corresponding pull request in the Asterisk Testsuite, you can tell the automation to test your Asterisk PR using your Testsuite PR by adding a comment to the Asterisk PR with `testsuite-test-pr: <testsuite pr number>` as the content.  For example:

```text
testsuite-test-pr: 400
```

That entry would tell the automation to checkout the testsuite PR 400 before running the testsuite tests for the Asterisk PR. You can add the `testsuite-test-pr` entry to the same comment you created for the `cherry-pick-to` entries if you prefer.

/// warning
As with the `cherry-pick-to` entries, don't add the `testsuite-test-pr` entry to the commit message or the PR description.  They're only searched for in PR comments.
///

You only have about two minutes from the time the PR is submitted before the automation actually starts the tests so you'll need to add the comment rather quickly.  As noted above, you can easily add comments from the command line using `gh pr comment`.  If you don't make it in time or you haven't written the test yet, you can always add the comment then ping someone on the Asterisk team to recheck the PR.

/// note 
Due to time constraints, only tests in the tests/channels, tests/fax, tests/extra_gates and tests/rest_api directories are run for pull request testing.  If a test created by your Testsuite PR isn't in one of those directories, create a relative symlink to it in the tests/extra_gates directory and update the tests/extra_gates/tests.yml file to include it.  For example...

```
tests/apps/a_new_test
tests/extra_gates/a_new_test -> ../apps/a_new_test
```
Then, assuming `a_new_test` is a single test, add the following to tests/extra_tests/tests.yml:

```
    - test: 'a_new_test'
```

Of course, if `a_new_test` is a directory of tests, you'd add:

```
    - dir: 'a_new_test'
```

///

## Pull Request Review Process

As with Gerrit reviews, a new PR triggers a set of tests and checks.  If you browse to your PR and scroll to the bottom, you'll see the status of those checks listed.  There are some differences to Gerrit however.

### New Contributor License Agreement

Every contributor will be required to sign a new Contributor License Agreement before their first PR can be merged.  One of the PR checks will be "license/cla" which looks like this...

![](image2023-4-17-1442.png)

which indicates that you haven't signed it yet.  Click the "Details" link to be taken to the page that allows you to fill out the form and sign.  Acceptance is automatic so there should be no delay and you only have to do this once.  YOUR PR CANNOT BE MERGED UNTIL THIS CHECK IS COMPLETED.

### Automated Tests

GitHub gives us access to more resources for testing than we've ever had so instead of running the Unit tests at PR submission and the Gate/Testsuite tests when the change has been approved, we run both the Unit and Gate/Testsuite tests immediately upon submission.  The Unit tests run as a single job/check but the Gates are broken up into multiple jobs/checks so they can be run in parallel.  When each check is completed, a comment will be added to the PR with the result and each check will have it's own line in the checks summary a the bottom of the PR.  All checks must pass or be deemed "false alarms" before a PR can be merged.

### Reviewing a change

GitHub has two types of Pull Request comments.

#### General Comments

These are comments you leave on the main PR page.  They are just that...comments.  They have no bearing on whether the PR can be merged.  If you have general comments or questions about a PR,  this is where you leave them.  The Gerrit equivalent is clicking the "REPLY" button at the top of the review and leaving a comment without changing your vote.

#### Review Comments

These are comments you have about the code itself.  These are left by clicking on the 'Files changed" tab at the top of the PR, then...

* Clicking the 'Review changes" button to leave an overall comment and vote.  This is similar to clicking the "REPLY" button at the top of a Gerrit review and leaving a comment with a vote.
* Clicking on a specific line in a file to leave a single comment without a vote.  This is similar to clicking on a file in a Gerrit review, entering a comment on a specific line, but leaving your vote at "0" when clicking the "REPLY" button.  Unlike a general comment however, this type of comment creates a "conversation" which must be "resolved" before a PR can be merged.
* Clicking on a specific line in a file to leave a comment and starting a review where you will leave a vote.  This is similar to clicking on a file in a Gerrit review, entering a comment on a specific line, then setting your vote to +1 or -1 when clicking the "REPLY" button.

/// note
If you're not the submitter but you want to test a PR locally, you can do so easily with the gh tool:  
`gh pr checkout <pr_number>`
///

### Address Review Comments and Test Failures

If you need to make code changes to address comments or failures, the process is much like it is with Gerrit...

1. Make the changes locally in the branch you submitted the PR from.
2. When finished, do a `git commit -a --amend`
3. Push the commit to GitHub with `git push --force`

This will force push the commit to your fork first, then update the PR with the new commit and restart the testing process.

/// note
If you feel that amending and force pushing changes might make it har for a reviewer to detect what was changed/fixed, you can push interim commits.  See [Interim commits to facilitate code review](#interim-commits-to-facilitate-code-review) above.
///

### Cherry-Pick Tests

When an Asterisk Core Team member believes the PR is ready, they'll add a `cherry-pick-test` label to the PR that will jobs to run that check that the cherry-pick applies cleanly to the other branches and run the same automated tests that ran for the original PR.  These tests must pass (or be deemed false alarms) for the PR to be eligible for merging.

### Merge

When an Asterisk Core Team member believes the PR is ready for merging, they'll approve the merge which will cause the original PR to merge into its target branch and cause the change to be cherry-picked  into each of the cherry-pick target branches.
