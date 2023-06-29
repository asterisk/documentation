---
title: Asterisk Issue Guidelines
pageid: 19726406
---




Purpose of the Asterisk issue tracker
-------------------------------------

The [Asterisk Issue Tracker on GitHub](https://github.com/asterisk/asterisk/issues) is used to track bugs and miscellaneous (documentation) elements within the Asterisk project. The issue tracker is designed to manage reports on both [core and extended components](/Asterisk-Community/Asterisk-Module-Support-States) of the Asterisk project.

The primary use of the issue tracker is to track bugs, where "bug" means anything that causes unexpected or detrimental results in the Asterisk system. The secondary purpose is to track some of the miscellaneous issues surrounding Asterisk, such as documentation, commentary and feature requests or improvements with associated patches.

Feature requests without patches are generally not accepted through the issue tracker. Instead, they are discussed openly on the mailing lists and Asterisk IRC channels. Please read the ["How to request a feature"](/Asterisk-Community/Asterisk-Issue-Guidelines) section of this article.

#### What the issue tracker is not used for:

* **Information Requests**: (How does X parameter work?)  
See the forums, mailing lists, IRC channels, or this wiki. For even more information, see <http://www.asterisk.org/community>
* **Support requests**: (My phone doesn't register! My database connectivity doesn't work! How do I get it to work?)  
Search and ask on the forums, mailing lists, and IRC. Again, see <http://www.asterisk.org/community> for more information.
* **Random wishes and feature requests with no patch:** (I want Asterisk to support <insert obscure protocol or gadget>, but I don't know how to code!)  
See the [How to request a feature section](#feature_request) for more information on requesting a feature.
* **Business development requests** (I will pay you to make Asterisk support fancy unicorn protocol!)  
Please head to the asterisk-biz mailing list at <http://lists.digium.com>. If what you want is a specific feature or bug fixed, you may want to consider [requesting a bug bounty](/Development/Asterisk-Bug-Bounties).
* and...




!!! warning 
    Security vulnerability issues must NEVER be reported as regular bugs in the issue tracker. Instead they must be reported at [Security Vulnerabilities](https://github.com/asterisk/asterisk/security/advisories/new). You can reach this page by navigating to <https://github.com/asterisk/asterisk> and clicking the "Security" tab at the top of the page.

      
[//]: # (end-warning)



 

#### Why should you read this?

The steps here will help you provide all the information the Asterisk team needs to solve your issue. Issues with clear, accurate, and complete information are often solved much faster than issues lacking the necessary information.




Bug Reporting Check List
------------------------




!!! warning
    Before filing a bug report...
    Your issue may not be a bug or could have been fixed already. Run through the check list below to verify you have done your due diligence.

      
[//]: # (end-warning)



* **Are** **you reporting a suspected security vulnerability?**
* **Are you are on a supported version of Asterisk?**
* **Are you using the latest version of your Asterisk branch?**
* **Are you using the latest third party software, firmware, model, etc?**
* **Have you asked for help in the community? (mailing lists, IRC, forums)**  
You can locate all these services here: <http://www.asterisk.org/community>
* **Have you searched the Asterisk documentation in case this behavior is expected?**  
Search the [Asterisk wiki](//) for the problem or messages you are experiencing.
* **Have you searched the Asterisk bug tracker to see if an issue is already filed for this potential bug?**  
Search the [Asterisk Issue Tracker on GitHub](https://github.com/asterisk/asterisk/issues) for the issue you are seeing. You can search for issues by selecting **Issues -> Search for Issues** in the top menu bar.
* **Can you reproduce the problem?**  
Problems that can't be reproduced can often be difficult to solve, and your issue may be closed if you or the bug marshals cannot reproduce the problem. If you can't find a way to simulate or reproduce the issue, then it is advisable to configure your system such that it is [capturing relevant debug](/Operation/Logging/Collecting-Debug-Information) during the times failure occurs. Yes, that could mean running debug for days or weeks if necessary.

Submitting the bug report
-------------------------

You'll report the issue through the tracker (<https://github.com/asterisk/asterisk/issues>)

1. **Sign up for an GitHub account**  
If you don't already have a GitHub account, sign up for one now at <https://github.com>.
2. **Create a new issue in the tracker**  
Navigate to <https://github.com/asterisk/asterisk/issues> and click on the 'New Issue" button at the top right, then choose an appropriate issue type. The following are the supported issue types:


	* Bug
	* New feature
	* Improvement
	* Report a security vulnerability (note, this WILL take you to the secure reporting facility mentioned in the warning above)
3. **Fill out the issue form**  
For a bug you must include the following information:


	* **Concise and descriptive summary**
	
	
		+ Accurate and descriptive, not prescriptive. Provide the facts of what is happening and leave out assumptions as to what the issue might be.
		+ Good example: "Crash occurs when exactly twelve SIP channels hang up at the same time inside of a queue"
		+ Bad Examples: "asterisk crashes" , "problem with queue", "asterisk doesn't work", "channel hangups cause crash"
	* **Operating System detail** (Linux distribution, kernel version, architecture etc)
	* **Asterisk version** (exact branch and point release, such as 1.8.12.0)
	* **Information on any third party software involved in the scenario** (database software, libraries, etc)
	* **Frequency and timing of the issue** (does this occur constantly, is there a trigger? Every 5 minutes? seemingly random?)
	* **Symptoms** described in specific detail ("No audio in one direction on only inbound calls", "choppy noise on calls where trans-coding takes place")
	* **Steps required to reproduce the issue** (tell the developer exactly how to reproduce the issue, just imagine you are making steps for a manual)
	* **Workarounds in detail with specific steps** (if you found a workaround for a serious issue, please include it for others who may be affected)
	* **Debugging output** - You'll almost always want to include extensions.conf, and config files for any involved component of Asterisk. Depending on the issue you may also need the following:
	
	
		+ For crashes, provide a backtrace generated from an Asterisk core dump. See [Getting a Backtrace](/Development/Debugging/Getting-a-Backtrace) for more information.
		+ For apparent deadlocks, you may need to enable the compile time option `DEBUG_THREADS`. A backtrace may also be necessary. See [Getting a Backtrace](/Development/Debugging/Getting-a-Backtrace) for more information.
		+ For memory leaks or memory corruptions, [Valgrind](/Valgrind) may be necessary. Valgrind can detect memory leaks and memory corruptions, although it does result in a substantial performance impact.
		+ For debugging most problems, a properly generated debug log file will be needed. See [CLI commands useful for debugging](/Development/Debugging/CLI-commands-useful-for-debugging) and [Collecting Debug Information](/Operation/Logging/Collecting-Debug-Information) for more information. Note that for issues involving SIP, IAX2, or other channel drivers, you should enable that driver's enhanced debug mode through the CLI before collecting information. A pcap demonstrating the problem may also be needed.
		
		
		
		
		---
		
		**Tip:**  Be courteous. Do not paste long debug output in the description or a comment, instead please **attach** any debugging output as text files and reference them by file name.
		
		  
		
		
		
		---
4. **Submit the Issue**

#### How you can speed up bug resolution

Follow the [checklist](#bug_report_checklist) and include all information that bug marshals require. Watch for emails where a bug marshal may ask for additional data and help the developers by testing any patches or possible fixes for the issue. A developer **cannot** fix your issue until they have sufficient data to reproduce - or at the very least understand - the problem.

#### Reasons your report may be closed without resolution

If your bug:

* Is solely the result of a configuration error
* Is a request for Asterisk support
* Has incomplete information
* Cannot be reproduced

it may be closed immediately by a bug marshal. If you believe this to be in error, please comment on the issue with the reason why you feel the issue is still a bug. You may also contact bug marshals directly in the #asterisk-bugs IRC channel. If that fails, bring it up on the mailing list(s) and it will be sorted out by the community.

#### Working with Bug Marshals

If insufficient commentary or debug information was given in the ticket then bug marshals will request additional information from the reporter. If there are questions posted as follow-ups to your bug or patch, please try to answer them - the system automatically sends email to you for every update on a bug you reported. If the original reporter of the patch/bug does not reply within some period of time (usually 14 days) and there are outstanding questions, the bug/patch may get closed out, which would be unfortunate. The developers have a lot on their plate and only so much time to spend managing inactive issues with insufficient information.

If your bug was closed, but you get additional debug or data later on, you can always contact a bug marshal in #asterisk-bugs on irc.freenode.net to have them re-open the issue.




How to request a feature or improvement
------------------------

Feature or improvement requests without patches are not kept on the primary issue tracker. A [second issue tracker](https://github.com/asterisk/asterisk-feature-requests) is maintained for this purpose on Github. There is no guarantee that any request filed on this issue tracker will be implemented.

New features and major architecture changes are often discussed at the [AstriDevCon](/Development/Roadmap/AstriDevCon) event held before Astricon.

If you really need the feature, but are not a programmer, you'll need to find someone else to write the code for you. Luckily, there are many talented Asterisk developers out there that can be contacted on the [asterisk-biz](http://lists.digium.com) mailing list. You can also offer a bounty for a bug or new feature - see [Asterisk Bug Bounties](/Development/Asterisk-Bug-Bounties) for more information.

Patch and Code Submission
-------------------------

Patches for all issues are always welcome. Issues with patches are typically resolved much faster than those without. Please see the [Code Contribution Process](/Development/Policies-and-Procedures/Code-Contribution) for information on submitting a patch to the Asterisk project.

Frequently Asked Questions
--------------------------

#### What makes a useful bug report?

There are some key qualities to keep in mind. These should be reflected in your bug report and will increase the chance of your bug being fixed!

* Specific: Pertaining to a certain, clearly defined issue with data to provide evidence of said issue
* Reproducible: Not random - you have some idea when this issue occurs and how to make it happen again
* Concise: Brief but comprehensive. Don't provide an essay on what you think is wrong. Provide only the facts and debug output that supports them.

#### How can I speed up my issue resolution?

1. Follow the guidelines on this patch! Having good, accurate information that helps bug marshals reproduce the issue typically leads to much faster issue resolution.
2. Provide a patch! Issues with patches are also generally resolved much faster. If you can't write a patch, there are many smart, talented developers in the Asterisk community who may be worth helping you. You can contract with them on the [asterisk-biz](http://lists.digium.com) mailing list, or offer a [bug bounty](/Development/Asterisk-Bug-Bounties).

 

