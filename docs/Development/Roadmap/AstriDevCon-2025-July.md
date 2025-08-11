# AstriDevCon 2025 July

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon.

**Date:** July 30, 2025

### Event day schedule

AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future.

**Event started at 10:00 AM Eastern.**

**Event ended at 12:00 PM Eastern.**

#### Kickoff
**J. Colp:**
- Discussion of new ARI features, focused on websocket development.

#### Near Future Plans
- Performance improvements
- New TaskProcessor options (Josh)

#### Regulatory & Technical Topics
- Will we get Real Time Text support? (Henning)
- Stir Shaken across the EU only works within a national boundary.
    Caller ID is suppressed when moving across borders
    [Reference](https://transnexus.com/blog/2024/shaken-in-france/)
- Use of AI in development discussion.
- Blockchain plug-in for Kamailio?

#### Deprecation Discussion
- What should be deprecated from the current code base?
    - Nothing currently on the list...
    - Possible options:
        - `res_xmpp`
        - `H323`
        - `res_snmp`
- Add an option to just build core modules
- Add an experimental Support level

#### WebRTC & Infrastructure
- WebRTC demand is increasing and standardizing around Chromium
- Containerization is still limited to test/building, not used in core infrastructure

#### Statistics & Monitoring
- Statistics monitoring – what should be added?
    - RTPEngine has Control for pulling statistics in their project
    - Automatic alerts based on triggers/thresholds (particularly for taskprocessors)?
    - RTCP reporting in ARI?
    - ARI for back-end statistics could be useful
    - Potential for a further statistics module
- Prometheus module generates a new metric for each channel/bridge, causes huge load on database
    [Reference](https://justpaste.it/i0rgg)
    - A statistics route on `/asterisk`, should this be selective on what is requested or all?

#### PR & Issues
- ACN PR request for update and review
    [PR #285](https://github.com/asterisk/asterisk/pull/285)
    - Incoming may work but outgoing does not
    - Breaks T.38 testsuite tests
    - At least one customer encountered crashes, workaround applied (not a real fix)
    - Would have to be merged by September to make the next LTS

#### Codecs
- Any plan for mobile codecs in Asterisk?
    - Not currently
    - AMR-WB, EVS
- Are there any patent concerns?
    - Yes, particularly with EVS
    - Would likely need to license and make it a commercial binary
---
#### Recording Available at [downloads.asterisk.org](https://downloads.asterisk.org/astridevcon/2025/) (audio only)

---

