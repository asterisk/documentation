---
title: Gerrit Usage
pageid: 32375063
---

Overview
========

The Asterisk project uses [Gerrit](https://gerrit.asterisk.org) for code reviews, continuous integration validation, and git management. When creating a patch to Asterisk or its various related projects, all patches should be pushed to Gerrit for review.

Use of Gerrit is beyond the scope of this wiki page - for in depth information, see the [Gerrit documentation](https://gerrit.asterisk.org/Documentation/index.html).

 

SSH Host Key Fingerprint
========================

Gerrit uses an internal ssh server on port 29418 for all git operations.  This is the current host key fingerprint,

As of 2021-08-26, the ssh host key fingerprint for gerrit.asterisk.org port 29418 is:
2048 SHA256:fVUWWssynxRxCRZWmHVWoQAqwYC4pODCwoRrMOqM3QM [gerrit.asterisk.org]:29418 (RSA) More instructions for using ssh are below.

 

Creating an Account
===================

Gerrit uses [OpenID](https://openid.asterisk.org) in conjunction with the Asterisk project's Atlassian infrastructure to provide single sign-on. If you already have an account in the Asterisk project infrastructure (such as [JIRA](https://issues.asterisk.org/jira)) and have signed a [Contributor License Agreement](https://issues.asterisk.org/jira/secure/DigiumLicense.jspa), you should be able to sign in to Gerrit automatically.

1. Create an account at [signup.asterisk.org](https://signup.asterisk.org/signup).
2. Sign a [Contributor License Agreement](https://issues.asterisk.org/jira/secure/DigiumLicense.jspa).

Until your Contributor License Agreement is approved, you will not be able to sign into the project OpenID provider or Gerrit.
3. Browse to [Gerrit](https://gerrit.asterisk.org), and click **Sign In**.
4. This will redirect to [openid.asterisk.org](https://openid.asterisk.org). Sign in with your Atlassian username/password.
5. Upon signing in successfully, you will need to authorize Gerrit to access your OpenID. When you have done so, you should be redirected back to Gerrit, and will be signed in.

Setting up your Gerrit Account
==============================

Upon logging in for the first time, you will need to perform the following:

1. Set your username for your account. This can be any username, although we highly recommend matching your Atlassian username. To set your username:
	1. Click on your name in the top-right corner.
	2. Click "Settings"
	3. Click "Profile" on the left side of the screen.
	4. In the top text box in the center, enter your user name, and confirm.
	
	Failure to set your username will result in clones using SSH failing, despite adding your SSH key. If you can not clone using SSH please ensure you have set your username.
2. Add your SSH public key.
On This Page2

 

 

 

Setting up your environment
===========================

Creating an SSH Alias
---------------------

Since access to [gerrit.asterisk.org](https://gerrit.asterisk.org) is likely to occur often if you're submitting patches, you may want to set up an SSH alias:

$ cat ~/.ssh/config
...
Host asterisk
 Hostname gerrit.asterisk.org
 Port 29418
 User {user}This will allow you to access the repository as shown below:

$ git clone asterisk:{repo}Install git-review
------------------

You can skip this step if you're only downloading patches for testing.

Most Gerrit users will be submitting patches for review and will need the `git review` command.  It's not normally installed by default when you install git so it must be installed separately.  The package is called `git-review` and should be available via most package managers.  If not, you can install it using pip: 

Install git-review from gitbash$ pip install git-reviewIt is recommended that you have git-review version 1.27.0 installed. You can check the installed version using "git review --version". If it is an old version you can install it using pip to receive the latest one. 

Prepare git
-----------

You can skip this step if you're only downloading patches for testing.

In every repository you plan on submitting patches from, you'll need to set your email to match that expected by Gerrit.  You can set it in each repository after you've cloned it or you can set it globally.

Set per repositorytext$ cd <repository>
$ git config --local --add user.email <your email>
$ git config --local --add user.name <your full name>Set globallytext$ git config --global --add user.email <your email>
$ git config --global --add user.name <your full name>Cloning from Gerrit
===================

While access to the underlying git repository is open to anyone via anonymous HTTP access, this guide will assume that you want to push changes up as well. For that, Gerrit uses SSH. If you are only looking to obtain the source code for a particular repository, clone it from the [Official Asterisk GitHub Mirror](https://github.com/asterisk/asterisk)

Clone the repository:

Clone using full SSH URLtext$ git clone ssh://{user}@gerrit.asterisk.org:29418/{repo}or

Clone using SSH aliastext$ git clone ssh://asterisk/{repo}You can also clone and check out a branch in one step

Clone asterisk and check out branch 13text$ git clone -b 13 ssh://asterisk/asterisk asterisk-13If you're only retrieving patches and don't need to submit, you can clone from https:

Clone using Anonymouns HTTPStext$ git clone https://gerrit.asterisk.org/asteriskTo push reviews to Gerrit, you'll need the commit hook that generates the Gerrit Change-Id and appends it to every commit message.  You can install the hook easily with git review.

Install the Gerrit commit hooktext$ git review -sIt's imperative that once a Change-Id is added to a review it's not changed.  Gerrit uses it to associate multiple commits with a single review and associate cherry-picks among branches.

Gerrit Review Submit Workflow
=============================

Now that the repository is set up, it's time to do some real work!  Let's say you have a change you wish to make against the Asterisk 13 branch.

Get an Asterisk Issue ID
------------------------

There should be an Asterisk issue open for every change you submit.  If you don't have one already, create a new issue at <https://issues.asterisk.org>.  Let's say you're using ASTERISK-12345.

Create a working branch in your repository
------------------------------------------

You'll want to keep the local branches that track remote branches, like 13, 14 and master, in a pristine condition so create a new working branch that's based on the remote branch you're making the change against.  Using the Asterisk issue id as the branch name will make things easier later on.  You should always start your change in the oldest branch to which the change will apply which is 13 in this example.

$ git checkout 13
$ git checkout -b ASTERISK-12345Do Some Work!
-------------

Test Your Work!
---------------

When you submit your review, it will automatically be built and the Asterisk unit tests run so to save re-work time, you should run the Asterisk unit tests against your changes before you submit.  To do so, configure asterisk with the `--enable-dev-mode` flag and enable `TEST_FRAMEWORK` in menuselect.  After installing Asterisk in your test environment (and you should have a test environment), you can run the tests from the Asterisk CLI with the `test execute all` command.  

If you have the Asterisk Testsuite installed, running the test suite is also recommended since it will be run against your change before the change is merged.  See  for more information.

Commit
------

You have to commit before you submit and the commit message is crucial.  For more information about commit messages, see .  You'll notice that when you edit the commit message, you'll see that the Gerrit Change-Id was automatically added to the end.  DON'T ALTER OR REMOVE IT!!  You'll see why this is important later.

Here's a quick sample commit message:  


res\_pjsip: Change something in res\_pjsip
 
This is where you should describe the change and any background information
that will help a reviewer or future developer understand the purpose of
the change.
 
ASTERISK-12345 #close
Reported-by: Someone other than you
 
Change-Id: I6dca12979f482ffb0450aaf58db0fe0f6d2e389
 Submit
------

Submitting is easy:  


Submit a patch for reviewtext$ git review 13 `13` represents the branch you're submitting this patch against.  The default is `master` so don't forget to specify it.  

If the submit is successful, you'll see a confirmation that looks like so:

remote: Processing changes: new: 1, refs: 1, done 
remote: 
remote: New Changes: 
remote: http://gerrit.asterisk.org/r/9999 new review 
remote: 
To ssh://gerrit.asterisk.org:29418/asterisk
 \* [new branch] HEAD -> refs/publish/13/9999

`9999` is the review number.  


Cherry Pick
-----------

If you're making your change to the Asterisk 13 or 14 branches, you'll probably need to cherry-pick your change to other branches.  For changes to 13, cherry-pick to 14 and master.  For changes to 14, cherry-pick to master.  The easiest way to do this is via the Gerrit web user interface.

1. Log into Gerrit at [https://gerrit.asterisk.org](https://https//gerrit.asterisk.org) and open your change.  Notice that the change topic is set to ASTERISK-12345.  This was automatically set because the name of the working branch you submitted from was ASTERISK-12345.   If it's not set correctly to the Asterisk issue id, set it now.   If you don't use the Asterisk issue id as the working branch name, you can set the topic when you submit using the `-t` option to `git review` as follows: `git review -t ASTERISK-12345` 13
2. Whenever possible, you should cherry pick from the oldest branch to the newest in order.  Click the Cherry Pick button and choose the destination branch.  Assuming the change was originally submitted against 13, choose 14 and click the Cherry Pick Change button.  Gerrit will create a new review for you against the destination branch.  Notice though that Gerrit altered the Topic by appending the destination branch.  You'll need to reset it to just the Asterisk issue id.  Once that's done, click Cherry Pick again and repeat the process for the master branch.  You'll get new review numbers for each cherry-pick of course.

You can cherry-pick a review from the command line if you so wish:

Cherry pick a review from the command line$ git review --cherrypick 9999 14 This will cherry pick review 9999 to the 14 branch.

Watch for verification
----------------------

As each review is created, Gerrit will automatically schedule a verification step with Jenkins (our continuous integration platform).  To pass the verification, Asterisk has to build successfully with your change and all unit tests must pass.  Passing is usually the signal to reviewers that it's a valid patch and they can spend time reviewing it.  If it fails, it's up to you to examine the results by following the links that Jenkins added to the comments and taking appropriate action.  
 

Respond to comments
-------------------

The worst thing you can do is push a review then not respond to comments!.  This tells reviewers that the review isn't important to you and the review will probably keep falling further back in the queue.

Next Steps
----------

If your review is accepted without the need for re-work, you need to nothing further.  Otherwise, read on.  


Updating a Review
=================

Making updates to a review is a bit tricky because you don't want to create new commits or new reviews with each update.  Here are the steps:

Pull down the current review
----------------------------

$ git review -d 9999This will create (or reuse) a branch named "review/<your\_name>/<topic>" and switch you to it.  In this example and assuming your name is "Joe Developer", the branch would be "review/joe\_developer/ASTERISK-12345".

Make and test your changes
--------------------------

If you wind up adding a file, don't forget to do a `git add <filename>` on the new file.

Amend the original commit
-------------------------

Amend a commit $ git commit -a --amendIt is **CRITICAL** that you amend your original commit and not create a new commit.  Failing to amend will generate a new Change-Id and will cause Gerrit to create a NEW review instead of creating a new patchset on the existing review.

Re-submit
---------

$ git review 13Don't forget the base branch.

Cherry Pick
-----------

As with the initial submit, cherry-pick to the other applicable branches. 

If you have to make multiple changes over the lifetime of the review, you should always download the same review, 9999 in this case.  This is because the branch name that gets generated for the review doesn't include the base branch.  In our example, let's say you got review 10000 when you cherry-picked 9999 to the 14 branch.  If you do `git review -d 9999` then later do `git review -d 10000`, you'll get a warning from git that the base branches aren't the same.  If this happens, check out another branch temporarily, delete the review branch, then download the review again.

$ git checkout 13
$ git branch -D reviews/joe\_developer/ASTERISK-12345
$ git review -d 10000Advanced Topics
===============

What do do when a cherry-pick fails, etc.  Coming Soon!

 

Troubleshooting
===============

git-review
----------

### Problem: attempting to run `git review -s` fails to find gerrit.

Solution: You may need to add an explicit git remote named "gerrit".

git remote add gerrit <ssh-url-to-the-gerrit-repo>### Problem:  Unable to login to [gerrit.asterisk.org](http://gerrit.asterisk.org)

Solution: Until your Contributor License Agreement is approved, you will not be able to sign into the project OpenID provider or Gerrit. See the "Creating an Account" section for instructions on how to resolve this.

### Problem: attempting to run `git review` results in something like the following:

Traceback (most recent call last):
 File "/usr/local/bin/git-review", line 11, in <module>
 sys.exit(main())
 File "/usr/local/lib/python2.6/dist-packages/git\_review/cmd.py", line 1132, in main
 (os.path.split(sys.argv[0])[-1], get\_version()))
 File "/usr/local/lib/python2.6/dist-packages/git\_review/cmd.py", line 180, in get\_version
 provider = pkg\_resources.get\_provider(requirement)
 File "/usr/lib/python2.6/dist-packages/pkg\_resources.py", line 176, in get\_provider
 return working\_set.find(moduleOrReq) or require(str(moduleOrReq))[0]
 File "/usr/lib/python2.6/dist-packages/pkg\_resources.py", line 648, in require
 needed = self.resolve(parse\_requirements(requirements))
 File "/usr/lib/python2.6/dist-packages/pkg\_resources.py", line 546, in resolve
 raise DistributionNotFound(req)
pkg\_resources.DistributionNotFound: git-reviewSolution: Run

$ sudo pip install --upgrade setuptoolson your command line

### Problem: attempting to run `git review` results in "unpack failed: error Missing tree":

Description:  There is an incompatibility between certain version of git and gerrit that causes this error when the commit to be pushed was amended and only the commit message changed.  
Solution:  Run git push manually with the --no-thin option:  


$ git push --no-thin asterisk:{repo} HEAD:refs/for/master### Problem:  Unable to unsubscribe from Gerrit notifications

Solution: You may have mistaken the Gerrit notifications on a mailing list for notifications associated with your account. Of course if the notifications are being received via a mailing list then you would need to unsubscribe from the entire mailing list to stop receiving related mailings.

Other possibilities are that you have multiple accounts or are receiving notifications via forwarding from another E-mail address.  


