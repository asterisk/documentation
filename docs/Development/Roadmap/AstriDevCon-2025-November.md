# AstriDevCon 2025 November

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon.

**Date:** November 19, 2025

### Event day schedule

AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future.

**Event started at 10:00 AM Eastern.**

**Event ended at 11:30 AM Eastern.**

#### Kickoff with J.Colp
- Talk and discussion about Josh's new Taskpool project.
    - PJSIP implementation has been complicated.
    - Pull Request will be up for review soon.
    - No testers for the newest release candidates, but Ben Kolendry has tried the current version.
    - `core show taskprocessors` - no stasis endpoint entries currently.

#### Performance Profiling with G.Joseph
- Profiling project of Asterisk to see where performance is impacted and what can be improved.
- Variable substitution causes a high impact (this was also seen during the taskpool project.)
- `strcmp` is the biggest culprit for instruction use
- In almost every test, the biggest CPU users were not call processing, but logs, CDRs, CELs, Manager Reports, etc.
- Restults to be published along with the repo with the test scripts used to generate the reports.
- Startup and Shutdown are NOT included in the results.
- Screening was performed into pjproject as well.
- ast_Str_substitute_variables and another (basically the same) function are the biggest hitters.
- String comparisongs are a focus point.
- Tested `extensions.conf` vs `extensions.lua`

#### ARI and chan_websocket, outbound sockets for ARI apps
- Sven Kube has tried it.  It worked fine initially, but there were some correlation issues and concerns.
- Outgoing connections, attempts on retry were discussed
    - Failover, load distribution.
    - Connections could move to a different application server.

#### Astricon Discussion
- Astricon 2026 will be in Pasadena, California, part of SCALE.
- Fees are $80 for SCALE with an additional $50 for Astricon.
    - Down significantly from the last few years.
- Submissions are still open!
- Current discussions include performance, FreePBX, AI and more!

#### Channel Storage locking
- Mixmonitor's iterator for a channel could cause the channel to go away while iterating.
- Issue should be resolved.

#### Discussion on the potential to add more C++
- Scope is the main concern
#### No Geolocation users currently (at least present for this session)
#### STIR/SHAKEN
- Similar situation as Geolocation.
- Little to no enthusiasm general about STIR/SHAKEN as a whole.
---
#### Recording Available at [downloads.asterisk.org](https://downloads.asterisk.org/astridevcon/2025/)

---

