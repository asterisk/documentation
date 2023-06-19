---
title: Review Board Usage
pageid: 4816917
---




---


**Information: Historical Page** The Asterisk project used Review Board for code review when Subversion was used for source control. After to moving to Git, Gerrit is now used for Code Reviews.

Please see the [Gerrit Usage](/Gerrit-Usage) page for more information on using Gerrit for code review.

  



---


 

Usage Guidelines
================

[JIRA](https://github.com/asterisk/asterisk/issues/jira/) and [Review Board](https://reviewboard.asterisk.org) are both utilities that the Asterisk development community uses to help track and review code being written for Asterisk. Patches should generally be first attached to an issue in JIRA, as this will ensure that the issue is tracked appropriately and that proper attribution occurs. Review Board is a code review tool to help developers review a patch for submission.

This page provides guidelines for using Review Board.

Review Board Access
===================

Users who have an accepted [Digium License Agreement](/Digium-License-Agreement) are automatically granted access to Review Board. Your same username/password will work for logging into Review Board as it does for the other Asterisk community sites.

Posting Code to Review Board
============================




---

**Note:**  It is acceptable for a contributor to post patches to Review Board before they are complete to get some feedback on the approach being taken. However, if the code is not yet ready to be merged, it must be documented as such.

A review request with a patch proposed for merging should have documented testing and should not have blatant [Coding Guidelines](/Coding-Guidelines) violations. If a patch has substantial issues, the review will be closed and you will be asked to re-submit it once it conforms to the project guidelines.

  



---


Using post-review
-----------------

The easiest way to post a patch to Review Board is by using the rbt tool. Install it using `easy_install`.




---

**Note:**  If you do not already have `easy_install`, install the `python-setuptools` package.

  



---




---

  
  


```

 $ sudo easy\_install -U RBTools


```



---


Essentially, rbt is a script that will take the output of `svn diff` and create a review request out of it for you. Once you have a working copy with the changes you expect in the output of `svn diff`, run the following command:




---

  
  


```

 $ rbt post [-r <review-board-id>]


```



---


If it complains about not knowing which Review Board server to use, add the server option:




---

  
  


```

 $ rbt --server=https://reviewboard.asterisk.org


```



---


### Dealing with New Files

I have one final note about an oddity with using post-review. If you maintain your code in a team branch, and the new code includes new files, there are some additional steps you must take to get post-review to behave properly.

You would start by getting your changes applied to a trunk working copy:




---

  
  


```

 $ cd .../trunk


```



---


Then, apply the changes from your branch:




---

  
  


```

 $ svn merge .../trunk .../team/group/my\_new\_code


```



---


Now, the code is merged into your working copy. However, for a new file, subversion treats it as a copy of existing content and not new content, so new files don't show up in `svn diff` at this point. To get it to show up in the diff, use the following commands so svn treats it as new content and publishes it in the diff:




---

  
  


```

 $ svn revert my\_new\_file.c
 $ svn add my\_new\_file.c


```



---


Now, it should work, and you can run "rbt" as usual.

Posting a review request manually
---------------------------------

On the main Reviewboard page, at the top of the page you'll find a link titled ["New Reviewboard Request"](https://reviewboard.asterisk.org/r/new/). Click the link and simply follow the prompts.

One important item to fill out before submitting the request is either the **Reviewers** field or the **Groups** field. 

![](reviewboard_groups.png)

You can list specific individuals in the Reviewers field, or preferably you can just add **"****asterisk-dev"** to the Groups field. Doing this will make sure others get notified of the new request.

Updating Patch on Existing Review Request
-----------------------------------------

Most of the time, a patch on Review Board will require multiple iterations before other sign off on it being ready to be merged. To update the diff for an existing review request, you can use post-review and the -r option. Apply the current version of the diff to a working copy as described above, and then run the following command:




---

  
  


```

 $ rbt post -r <review request number>


```



---


