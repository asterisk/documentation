
# Asterisk Security Vulnerabilities

The Asterisk project takes the issue of its users security seriously. If you believe you have found a security vulnerability in the Asterisk software itself, please follow the steps on this wiki page to report the security vulnerability to the Asterisk Development Team.

/// note 
The Asterisk project does not produce or work on the underlying tools the project uses, such as Github. For security vulnerabilities found in these the report should be directed to the company or project that creates it. We *will* however accept reports related to the configuration of those tools.
///

## What Can Be Reported?

1. Issues relating to the Asterisk source code or usage.
2. Issues in the configuration of a tool the Asterisk project uses.

## Reporting a Security Vulnerability

All security vulnerabilities must be reported via the Asterisk GitHub project repository using the
"[Report a vulnerability](https://github.com/asterisk/asterisk/security/advisories/new)" button under the repository's "[Security](https://github.com/asterisk/asterisk/security)" tab.
This method restricts the report to the reporter and Asterisk staff.

/// warning | Do NOT use the public Issue Tracker!
The [Asterisk Issue Tracker](https://github.com/asterisk/asterisk/issues) is a public site, and all bug reports against Asterisk can be viewed openly by the public. While this results in a transparent, open process - which is good - reporting a security vulnerability on the issue tracker without properly selecting "[Report a vulnerability](https://github.com/asterisk/asterisk/security/advisories/new)" makes the report immediately public and makes the entire Asterisk user community vulnerable.
///

#### Do NOT use the "Start a temporary private fork" security advisory feature! 

Private forks created from security advisories are severly limited by GitHub
and cannot run the workflows necessary for validation and testing. Once a security
advisory is accepted, reporters will be given instructions on how to submit or test
a fix pull request.

## Release scheduling

Security vulnerabilities are treated seriously by the developer community, and the Asterisk Development Team always attempts to address vulnerabilities in a timely fashion. Sometimes, external influences may impact when a security release can be made; feel free to comment on the security vulnerability to discuss the schedule for a security release for your issue.

## Past Security Vulnerabilities

Past security vulnerability reports are available in several places...

* On the [asterisk.org web site](http://www.asterisk.org/downloads/security-advisories)
* On the projects GitHub repository unser the "[Security](https://github.com/asterisk/asterisk/security)" tab.
  (reports for 2023 and later).
* On the [Asterisk downloads](http://downloads.asterisk.org/pub/security/) site. (reports for 2022 and earlier)

All security vulnerabilities are also issued a CVE number and can be queried in the [CVE](http://cve.mitre.org/) database.

## Rewards

The Asterisk project does not provide rewards for the submission of security vulnerabilities. Recognition is provided for Asterisk code security vulnerabilities by being named as part of the release notes and security advisory. For security vulnerabilities in infrastructure or non-Asterisk code recognition is not guaranteed and is determined on a case by case basis.
