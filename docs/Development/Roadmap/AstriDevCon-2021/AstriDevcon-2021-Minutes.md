---
title: AstriDevcon 2021 Minutes
pageid: 47875175
---

AstriDevCon 2021 Minutes
========================

### Attendance

Ben Ford - Alabama, Sangoma Ast Dev, Stir Shaken!   
BJ Weschke - New Jersey, Wonders Corp, 16&18 w/AMI  
Daniel Collins - East Tennessee, USAM   
Florian Floimair - Austria, Commend, now on 18, wants to know direction  
Franck Danard - France, Sangoma FreePBX Dev, PMS  
George Joseph - Colorado, Sangoma Ast Dev (wants to know who is using unsupported asterisk!)  
Igor Goncharovsky -   
James Finstrom - (joined PM)  
Jared Smith - (joined PM)  
Joran Vinzens - Germany, SIPGate UK - 11&18 w/AMI ARI AGI  
Josh Colp - Atlantic Canada, Ast tech lead Sangoma  
JP Loh - Philippines, Contractor for an Ontario Business Phones Company  
Kevin Harwell - Alabama, Sangoma Ast Dev  
Lorenzo Emilitri - Switzerland work from Norway, QueueMetrics, Ast in Contact manager  
Lorne Gaetz - Atlantic Canada, Sangoma, Longtime FPBX tinkerer, PM for OSS projects  
Malcom Davenport - Alabama, Sangoma PM  
Mark Peterson - Denmark, Unicel patching from 1.8->18  
Matt Brooks - Alabama, Sangoma, FreePBX and PBXact Cloud  
Matt Frederickson - Director OSS, Sangoma  
Michael Bradeen - Colorado, Sangoma Ast Dev  
Michael Cargile - DialGroup, OS call center app. Moved to pjsip on 16  
Michael Young - New Hampshire, Rocky Linux  
Pascal Cadotte - Canada, Developer for Wazoo platform, pjsip migration  
Sylvain Boily - Quebec City, Wazoo Communication, Developing Unified Communication Platform w/ Ast 18  
Torrey Searle - Bandwidth International, Long term user  
Walter Moon - Sangoma FreePBX Dev Team, Digium phone apps API  
Yitzchak Pachtman - Israel, NY Based IT MSP, Ast & FreePBX for 5 years (Pitzkey)

### Lunch set to 12:30 Eastern (90 minutes)

### **Minutes**

10AM - Matt Frederickson, introductions

  


10:35 - Matt Frederickson, Asterisk 19 Update

* 13, 17 EOL (shout out 13, 7 years!)
* 16 & 18 8 bug fix releases
* Allowed new features into release branches (must include tests)
* Testuite has been key to new releases
* 9100 posts, 625 new contributors
* 19 released! 348 reviews, 50 contributors!
* Standard Releases, 1 year 1 year
* LTS, 4 yrs bug fixes, 1 additional for security
* OPENSIPit helped uncover issues in S/S and multiple Auth headers in PJSIP
* STIR/SHAKEN support
+ RSA and ECDSA
+ X509 support
+ Fixed issues with certs
+ Switched to b64 URL encoding
+ Added Date header

* Speech to Text
+ In the past, added external media support for ARI
+ New, similar to ARI but with dialplan apps and functions
+ Allow providers to allow conversion to be done outside of Asterisk
+ JSON and Websocket based protocol to connect to Asterisk (allows use of SDKs)
+ Asterisk c Module will provide interaction between translator and dialplan apps

* RTCP
+ Critical for video
+ Extended test coverage
+ New tests helped flush out issues

* PJSIP transport improvements
+ Partial reload allowed

* Formalized Module Deprecation Policy
+ Proposal of deprecation to dev mailing list
+ First removed in standard release, followed by LTS, then previous branches updated
+ New Wiki page is now definitive

* Miscellaneous Fun!
+ Force video bitrate in ConfBridge
+ Improved PJSIP registrar logging
+ OPTIONS now has optional auth
+ STUN attribute can be disabled
+ MIN, MAX math
+ PJSIP\_Headers function
+ App\_dial A now allows playing to caller
+ Originate can set vars on originated channel

* Reminders
+ 13&17 EOL
+ 16 LTS
+ Please move to pjsip, chan sip will not be built in 19 by default!
+ Keep an eye on the new module and versions wiki!

  


11AM - Set Agenda

* Give update on Policy - Josh
* Discuss releases and numbering - George
* Moving away from Atlassian - Josh
* Codec Handling - Joran
* Photo
* ConfBridge audio quality - Pascal
* Existing in a cloud environment - Josh
* DDos - Josh
* E911 - MAB
* Inbound/Outbound media matching - Florian
* Multiple ARI subscriptions / proxy - Joran
* Dynamic features in holding bridge - Pitzkey
* Timeouts on Stasis applications - Joran
* Asterisk 20? - Sylvain
* Conference Join announcement options - MC
* Chan pjsip retrieve/inject multipart MIME - Torrey

  
  


11:15 - J Colp, Project Policy update

* Thus far has been organic, not formal
* Module Deprecation Policy
+ Added for Asterisk 19
+ Occurs on standard releases
+ Notification in older branches
+ Update wiki, focus on as much notice as possible

* C API Deprecation
+ Upgrade and release notes
+ Start on next standard release

* New Feature Policy
+ Only accept features that benefit and can be supported
+ Denies against modules that are on the way out
+ Formalizes the testing requirements
+ Find a balance between user base and reviewers time

* Bug Fix / Improvement
+ Formalizes desire for testing
+ States that change may be reverted if it causes a regression

* Major happens in standard
    * Test!!!
    * What other new policies should be added?
    + “Out of Tree” Modules, package manager?
    + Good discussion of providing a place for contributions to live without being official

    * Should we have the option to deny improvements as well?
    + Is changing a default an improvement?
    + Could easily come with the same risks

      


    11:50 - G Joseph, Releases and numbering in flight

    * Going straight to 22?
    + Tie to year and skip the last few years

    * Does it help or hurt having multiple LTS?
    + Picking one branch for review before moving on
    + LTS reliability?
    + Is the stability due to LTS or because there were a number of stability improvements that occurred at the same time?

      


    12:10 - Joran, Codec Handling

    * Where did things land?
    + Busy year from Sangoma Development
    + Still in development
    + E911 deadlines
    + Is still on the list for development

      


    12:20 - BJ, Question about SWP JIRAs (11321)

      


    12:30 - Break for Lunch

      


    2PM - Taco Talk

      


    2:05 - Pascal, Audio quality issues with confbridge

    * 1on1 Calls Google Chrome was compensating for packet loss
    * Initial determination is that compensation is usually done on the write side, but this is not possible after it has already been mixed
    * Jitter buffer would have to be set on the read side, or on the internal write

      


    2:20 - J Colp, Atlassian move 

    * Force of move to cloud, not possible with asterisk community
    * Trouble tickets and wiki in particular
    * Possible move to github
    + Well documented
    + Makes movement easy
    + Automated CLA

    * Gitlab?
    * Wiki transition will require further research
    * Question on what to do with old, closed tickets after migration
    + 30K, too many to move, but…
    + Would be good to still have searching for definitive fixes
    + How to move open tickets to the new system and have users mapped properly.

    * Bugzilla, Tuleap, explore other issue trackers

      


    2:40 - J Colp, Working better in a cloud environment

    * Off system storage (S3?)
    + Scalable back-end storage
    + Voicemail, call recording (URL playback&recording), MoH
    + Could the new Speech methods help stream to off-box (if made sufficiently generic?)

    * Move to more ARI based solutions
    * Aggregate threat handling
    + Is fail2ban enough?
    + Run kamilio on same host as asterisk

    * Sharing asterisk database information between clusters
    + State information is more complicated for a B2BUA than a proxy
    + Limit over-use of astdb

    * Distributed provisioning
    + Mostly higher level
    + Push configuration (ala pjsip?)
    + Tools like ansible

    * Aggregate monitoring
    + AMI, SIP OPTIONS
    + Prometheus
    + Look at bridges, channel counts, playback/recording
    + Taskprocessor queues, open file handles, open ports
    + Peers
    + RTP / RTCP
    + Error rates

      


    3:30 - 15 minute break

      


    3:45 - M Bradeen, e911

    * What are the actual requirements?
    + Pidi flow additional headers (dynamic location in xml)
    + Jloaction header

    * NG 112 EU, similar to US
    * Add a dialplan app to check an IP against a known list and return location information

      


    4PM - Joran, Multiple entities subscribing to an ARI application

    * Ensure you always hit an application in case the stasis topic is not watched
    * Load balance or redundancy between registered applications.

      


    4:05 - Yitzchak, Dynamic features in holding bridges (parked call) 

    * Allow a caller to exit park to go to an operator, VM, etc.
    * Allow dynamic features, such as changing MoH
    * No DTMF receiver attached
    * Pull limited Queue functionality into parked calls

      


    4:15 - Yitxchak, controlling MoH from another channel or AMI

    * FreePBX using chanspy overlays announcement on MoH
    * Interrupting MoH can be done but then the other periodic announcements get unreliable.

      


    4:20 - Joran, Timeouts on a Stasis application

    * To prevent a call hanging due to the application hanging.
    * Prefer to not to have to wait for SIP level timers.

      


    4:40 - J Colp, DDoS

    * Rate limiting individual accounts
    * Pjsip global settings can help mitigate, blacklist past certain configurable parameters
    * Greylist registration, request second registration
    * Sliding scale of response, bigger fish requires more coverage and cost

      


    5:05 - Sylvan, Asterisk 20(22)?

    * E911 - pidi flow
    * Speech to text
    * Planning to come soon after Astricon
    * Wish list
    + Making ARI more robust?
    + AMR-WB?  Other codecs?
    + MS teams?

      


    5:20 - M Cargile, Pre-join warning to conference (vs post-join)

    * Alert existing participants before a caller joins
    * Work-arounds with connecting a local channel ahead of time, but would like to have it as an in-app option.
    * Patches welcome ;)
    * ARI all the things

      


    5:25 - Torrey, Adding custom MIME body

    * Can be adapted from Pidi Flow work

      


    5:30 - ARI ALL THE THINGS

      


    5:35 - Pitzkey final question, 

    * GoSUB loops to validate user
    * Place outgoing call to user getting variables from previous call
    + Store in AGI script?

      


    5:50 - Wrap up!

      
