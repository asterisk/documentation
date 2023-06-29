---
title: Overview
pageid: 27820098
---

Overview
========

As an open source project, the Asterisk project welcomes contributions that enhance and improve the functionality of Asterisk. This page describes the process for submitting patches to Asterisk.




!!! note Read More!
    This page links to many other pages on the wiki that provide deeper explanations regarding reporting of issues, writing of patches, and participation in the Asterisk project. Please read the information on those linked pages! Having well tested, high quality patches proposed to the Asterisk project helps everyone.

      
[//]: # (end-note)



On This PageAdditional InformationSubmitting a Patch
==================

1. Create an account with the Asterisk project at <https://signup.asterisk.org>.
2. Sign a [Contributor License Agreement](https://github.com/asterisk/asterisk/issues/jira/secure/DigiumLicense.jspa) in the Asterisk issue tracker.
3. Create a new issue in the [Asterisk project issue tracker](https://github.com/asterisk/asterisk/issues) for the bug or new feature. Please read the [Asterisk Issue Guidelines](/Asterisk-Community/Asterisk-Issue-Guidelines) for information on filing an issue.
4. Obtain the Asterisk source code from [Gerrit](https://gerrit.asterisk.org). Since you'll need to put your patch up for review, make an account in Gerrit as well, following the instructions on [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage).
5. Create a new Git branch for your change, and implement your change.
6. Before submitting the patch, make sure your patch conforms to the Asterisk project [Coding Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Coding-Guidelines).
7. Submit the patch back to the project. There are two options:
	1. **Highly Preferred**: Submit the patch for code review to Gerrit, referencing the created issue in the `topic` field. Please follow the instructions on the [Code Review](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review) and [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage) pages for submitting the patch to Gerrit.
	2. **Not Preferred**: attach the patch to the issue in unified diff format, marking the patch as a code contribution.

Code Review
===========

After you contribute a patch, bug marshals will triage the issue per the [Issue Tracker Workflow](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Issue-Tracker-Workflow). If you have put the patch up for code review on Gerrit, the patch will be reviewed there and - if accepted - merged into the project and the issue closed.

If you have not put the patch up for code review, your issue will be handled by an Asterisk developer as time and resources permits.

All users who have signed a license contributor agreement have access to Gerrit and are encouraged to participate in the peer review process. This includes not only review of your patch, but review of other patches as well.

Some Frequently Asked Questions
-------------------------------

1. **Do I have to put my patch up for code review?**
2. **No one has looked at my review. What do I do now?**  
First, please be patient. There may be lots of peer reviews occurring, and it can take some time for members of the community to comment on a review.  
  
Second, help the reviewers by making sure that your patch is explained well, that the issue it solves/feature it provides is well understood, and that the patch is well tested. Unit tests and functional tests for the [Asterisk Test Suite](/Test-Suite-Documentation/Test-Development/Home/Asterisk-Test-Suite-Documentation) will help immensely, and may also be necessary for your patch to be included.  
  
Finally, get involved! Contributors who participate in other reviews and show a willingness to test and help out with other submissions will probably receive more attention themselves.  
  
When all else fails, ask for a review on the #asterisk-dev IRC channel or the [asterisk-dev](http://lists.digium.com/) mailing list. Sometimes, we all just need a gentle nudge.

 

