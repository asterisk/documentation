---
title: Asterisk Versions
pageid: 7667733
---

There are multiple supported release series of Asterisk. Once a release series is made available, it is supported for some period of time. During this initial support period, releases include changes to fix bugs that have been reported and features that have been added following policy (features must not introduce backwards incompatible behavior and must include tests when possible). At some point, the release series will be deprecated and only maintained with fixes for security issues. Finally, the release will reach its End of Life, where it will no longer receive changes of any kind.

The type of release defines how long it will be supported. A Long Term Support (LTS) release will be fully supported for 4 years, with one additional year of maintenance for security fixes. Standard releases are supported for a shorter period of time, which will be at least one year of full support and an additional year of maintenance for security fixes.

The following table shows the release time lines for all releases of Asterisk, including those that have reached End of Life.



| Release Series | Release Type | Release Date | Security Fix Only | EOL | Current Status |
| --- | --- | --- | --- | --- |
| 1.2.x |   | [2005-11-21](http://lists.digium.com/pipermail/asterisk-announce/2005-November/000007.html) | 2007-08-07 | 2010-11-21 | EOL |
| 1.4.x | LTS | [2006-12-23](http://lists.digium.com/pipermail/asterisk-announce/2006-December/000046.html) | 2011-04-21 | 2012-04-21 | EOL |
| 1.6.0.x | Standard | [2008-10-01](http://lists.digium.com/pipermail/asterisk-announce/2008-October/000167.html) | 2010-05-01 | 2010-10-01 | EOL |
| 1.6.1.x | Standard | [2009-04-27](http://lists.digium.com/pipermail/asterisk-announce/2009-April/000184.html) | 2010-05-01 | 2011-04-27 | EOL |
| 1.6.2.x | Standard | [2009-12-18](http://lists.digium.com/pipermail/asterisk-announce/2009-December/000219.html) | 2011-04-21 | 2012-04-21 | EOL |
| 1.8.x | LTS | [2010-10-21](http://lists.digium.com/pipermail/asterisk-announce/2010-October/000277.html) | 2014-10-21 | 2015-10-21 | EOL |
| 10.x | Standard | [2011-12-15](http://lists.digium.com/pipermail/asterisk-announce/2011-December/000356.html) | 2012-12-15 | 2013-12-15 | EOL |
| 11.x | LTS | [2012-10-25](http://lists.digium.com/pipermail/asterisk-announce/2012-October/000427.html) | 2016-10-25 | 2017-10-25 | EOL |
| 12.x | Standard | [2013-12-20](http://lists.digium.com/pipermail/asterisk-announce/2013-December/000507.html) | 2014-12-20 | 2015-12-20 | EOL |
| 13.x | LTS | [2014-10-24](http://lists.digium.com/pipermail/asterisk-announce/2014-October/000565.html) | 2020-10-24 | 2021-10-24 | EOL |
| 14.x | Standard | [2016-09-26](http://lists.digium.com/pipermail/asterisk-dev/2016-September/075783.html) | 2017-09-26 | 2018-09-26 | EOL |
| 15.x | Standard | [2017-10-03](http://lists.digium.com/pipermail/asterisk-announce/2017-October/000684.html) | 2018-10-03 | 2019-10-03 | EOL |
| 16.x | LTS | [2018-10-09](http://lists.digium.com/pipermail/asterisk-announce/2018-October/000727.html) | 2022-10-09 | 2023-10-09 | Security Fix Only |
| 17.x | Standard | [2019-10-28](http://lists.digium.com/pipermail/asterisk-announce/2019-October/000757.html) | 2020-10-28 | 2021-10-28 | EOL |
| 18.x | LTS | [2020-10-20](http://lists.digium.com/pipermail/asterisk-announce/2020-October/000791.html) | 2024-10-20 | 2025-10-20 | Fully Supported |
| 19.x | Standard | 2021-11-02 | 2022-11-02 | 2023-11-02 | Security Fix Only |
| 20.x | LTS | 2022-10-19 | 2026-10-19 | 2027-10-19 | Fully Supported |
| 21.x | Standard | 2023-10-18 | 2025-10-18 | 2026-10-18 | Not Yet Released |

New releases of Asterisk will be made roughly once a year, alternating between standard and LTS releases. Within a given release series that is fully supported, bug fix updates are provided roughly every 4 to 6 weeks. For a release series that is receiving only maintenance for security fixes, updates are made on an as needed basis.

If you're not sure which one to use, choose either the latest release for the most up to date features, or the latest LTS release for a platform that may have less features, but will usually be around longer.

For developers, it is useful to be aware of when the next release branch will be created. Upon creation of the branch it becomes bound by the same policies as any release branch: no introduction of incompatible changes, no breaking of binary compatibility, and no substantial core changes. The creation of the release branch occurs the 2nd Wednesday of August. A reminder is sent a week before to the asterisk-dev mailing list on the 1st Wednesday of August. Once the release branch is created it will receive all bug fixes and feature changes which also go into the existing release branches. On the 2nd Wednesday of September an initial release candidate for the new version is created alongside release candidates for all other current supported release series. Additional release candidates will be created as needed based on fixes for issues reported. On the 3rd Wednesday of October full releases for all supported release series are created.

For additional information on policies please see the [Software Configuration Management Policies](/Software-Configuration-Management-Policies) wiki page.



|  |  |
| --- | --- |
| **Asterisk Release Branch Creation Reminder** | 1st Wednesday of August |
| **Asterisk Release Branch Creation** | 2nd Wednesday of August |
| **First Release Candidate of Asterisk Branch** | 2nd Wednesday of September |
| **First Release of Asterisk from Branch** | 3rd Wednesday of October |

