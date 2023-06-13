---
title: Asterisk Developer Call - 07142011 - 1700 EST
pageid: 17203294
---

**Digium Developer Conference Bridge:**


Bridge:  15071


PIN:  35806


**Proposed Agenda:**


Welcome & Announcements:  Bryan Johns / Russell Bryant


* Introduction of Digium participants


Old Business:


None


New Business:


* AstriCon 2011
* Asterisk 1.8 development update
* Asterisk 1.10 development update


Asterisk 1.10 Beta Release Announcement for Reference


--BEGIN PASTE--  

Asterisk 1.10 is the next major release series of Asterisk. It will be a Standard support release, similar to Asterisk 1.6.2. For more information about support time lines for Asterisk releases, see the Asterisk versions page.


<https://wiki.asterisk.org/wiki/display/AST/Asterisk+Versions>


A short list of included features includes:


* T.38 gateway functionality has been added to res\_fax (and res\_fax\_spandsp).
* Protocol independent out-of-call messaging support. Text messages not associated with an active call can now be routed through the Asterisk dialplan. SIP and XMPP are supported so far.
* New highly optimized and customizable ConfBridge application capable of mixing audio at sample rates ranging from 8KHz-196KHz
* Addition of video\_mode option in confbridge.conf for the addition of basic video conferencing in the ConfBridge() dialplan application.
* Support for defining hints has been added to pbx\_lua.


* Replacement of Berkeley DB with SQLite for the Asterisk Database (AstDB).
* Much, much more!


A full list of new features can be found in the CHANGES file.


<http://svn.digium.com/view/asterisk/branches/1.10/CHANGES?view=checkout>


For a full list of changes in the current release, please see the ChangeLog:


<http://downloads.asterisk.org/pub/telephony/asterisk/ChangeLog-1.10.0-beta1>


Thank you for your continued support of Asterisk!  

--END PASTE--


Open Floor


Call to users to test various video endpoints with ConfBridge and report findings to the Wiki.


Notes:


1.8.5 was released earlier this week. Has a large number of important fixes.


First Asterisk 1.10 beta "real soon now." Preparing all of the binary modules first, so release either tomorrow or on Tuesday.  

Over the next few months we'll be looking for as much testing assistance as possible


In recent weeks in 1.10, T.38 gateway support has been merged and is ready to be tested. Video support, with several different modes, has been added to ConfBridge.


Discussion surrounding production use of 1.8 series. Question posed about use in production and stability. Responders on call indicated that while they have run into sporadic issues, there is nothing preventing them from using 1.8 effectively.

