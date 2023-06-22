---
title: Asterisk Security Vulnerabilities
pageid: 27199866
---

The Asterisk project takes the issue of its users security seriously. If you believe you have found a security vulnerability in the Asterisk software itself, please follow the steps on this wiki page to report the security vulnerability to the Asterisk Development Team.




!!! note 
    The Asterisk project does not produce or work on the underlying tools the project uses, such as Github. For security vulnerabilities found in these the report should be directed to the company or project that creates it. We *will* however accept reports related to the configuration of those tools.

      
[//]: # (end-note)





!!! warning The Issue Tracker is Public!
    The [Asterisk Issue Tracker](https://github.com/asterisk/asterisk/issues) is a public site, and all bug reports against Asterisk can be viewed openly by the public. While this results in a transparent, open process - which is good - reporting a security vulnerability on the issue tracker without properly selecting "[Report a vulnerability](https://github.com/asterisk/asterisk/security/advisories/new)" on the [New Issue page](https://github.com/asterisk/asterisk/issues/new/choose) makes the entire Asterisk user community vulnerable.

    Reporting a vulnerability will automatically restrict who can view the information. If you have any difficulties with that we'll help; please follow the instructions here and e-mail the team at [security@asterisk.org.](mailto:security@asterisk.org)

      
[//]: # (end-warning)



 

What Can Be Reported?
=====================

1. Issues relating to the Asterisk source code or usage.
2. Issues in the configuration of a tool the Asterisk project uses.

 

Reporting a Security Vulnerability
==================================

1. Send an e-mail to the Asterisk Development Team by e-mailing [security@asterisk.org.](mailto:security@asterisk.org) Include the following:
	1. A summary of the suspected vulnerability, e.g., 'Remotely exploitable buffer overflow in the FOO channel driver'
	2. A detailed explanation of how the vulnerability can be exploited and/or reproduced. Test drivers/cases that can be used to demonstrate the vulnerability are highly appreciated.
2. A developer will respond to your inquiry. If you'd like, e-mails can be signed and/or encrypted.
3. Once the developer confirms the security vulnerability is discussed and confirmed you will be asked to report a vulnerability on the Asterisk issue tracker. **You must use the "[Report a vulnerability](https://github.com/asterisk/asterisk/security/advisories/new)" option on the [New Issue page](https://github.com/asterisk/asterisk/issues/new/choose) or the information will be publicly disclosed.**

Security vulnerabilities are treated seriously by the developer community, and the Asterisk Development Team always attempts to address vulnerabilities in a timely fashion. Sometimes, external influences may impact when a security release can be made; feel free to e-mail the developer assigned to the issue or [security@asterisk.org](mailto:security@asterisk.org) to discuss the schedule for a security release for your issue.

 

Past Security Vulnerabilities
=============================

Past security vulnerability reports are available on the [asterisk.org web site](http://www.asterisk.org/downloads/security-advisories) and on the [Asterisk downloads](http://downloads.asterisk.org/pub/security/) site.

All security vulnerabilities are also issued a CVE number and can be queried in the [CVE](http://cve.mitre.org/) database.

Rewards
=======

The Asterisk project does not provide rewards for the submission of security vulnerabilities. Recognition is provided for Asterisk code security vulnerabilities by being named as part of the release notes and security advisory. For security vulnerabilities in infrastructure or non-Asterisk code recognition is not guaranteed and is determined on a case by case basis.

