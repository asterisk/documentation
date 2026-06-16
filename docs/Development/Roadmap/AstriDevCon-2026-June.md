# AstriDevCon 2026 June

Sangoma invites developers who are interested in the future of Asterisk to join us at AstriDevCon.

**Date:** June 16, 2026

### Event day schedule

AstriDevCon is a mix of open and focused discussion all on topics within the realm of Asterisk development, primarily regarding current concerns that Asterisk faces and how to improve Asterisk for the future.

**Event started at 10:00 AM Eastern.**

**Event ended at 11:30 AM Eastern.**

#### Kickoff with J.Colp
- Josh requested input on manager testing for performance improvements.
- Different systems can have disparate impacts, so the more imput the better.

#### LLM Advisories and Project Workload
- The Asterisk project has been impacted by LLM-related security advisories and resulting workload.
- Bot-submitted code was called out as especially problematic; duplicate reports are also a burden.
- Kamailio is seeing similar issues.

#### RTT and Related Work
- RTT remains in the work queue.
- Henning indicated RTT is still needed soon due to legal support requirements.
- Character length overflow has improved, but streamline/stability issues remain.
- More commits are expected, and review/testing is difficult due to inconsistent implementations.

#### Codec Negotiation Fix
- A PR is expected from Henning for an older codec negotiation fix originally identified in 2020.

#### STIR/SHAKEN and Emergency Calling
- STIR/SHAKEN usage was described as minimal right now.
- Emergency call testing across EU and NA currently needs Kamailio in front of Asterisk for EU-compliant URI parsing.
- URI parsing was highlighted as security-sensitive and needing careful handling.

#### chan_websocket and External Media Questions
- Sven raised a chan_websocket concern about close behavior potentially being out of spec.
- The recent proxy PR may already improve socket closure behavior.
- Question raised: can destination be set on external media/channel create?
	- Not currently done that way for security reasons.
	- Related feature request: https://github.com/asterisk/asterisk-feature-requests/issues/84

#### RTCP Values and ARI Events
- Asterisk MES can produce calculated values that may be unexpected and problematic.
- Filtering implausible RTCP values from connected UAs was discussed resulting in unreliable data.
- Expanding RTCP events into ARI was discussed, with concern about ARI websocket event volume.
- Underlying JSON functions already exist; implementation appears partially complete.

#### Whisper/Spy Discussion
- Question raised whether Whisper changes would also affect Spy behavior; the recent audiohook changes were for Whisper hooks only.
- Request discussed to add a default silence stream in the Spy-only direction, but this may be the result of a separate issue.

#### Testing Requests
- Additional testing requested for https://github.com/asterisk/asterisk/pull/1967 to validate output audio accuracy.

#### RTT/DTMF Spying
- Sven requested support for RTT/DTMF spying.
- DTMF spying would be more straightforward as audihooks already process DTMF frames.
- Henning may open an issue for direct-to-file writing.
- RTT snooping is not directly possible with current audio-frame-based snoop behavior, but a frame-hook approach may be possible.

#### Recess
- Five-minute recess.

#### AI/LLM Discussion
- General AI/LLM discussion on the use of LLMs in development.  Mostly focused on their use for testing and code analysis.

#### Global Event Filtering
- Discussion on adding a hash table for global event filtering.
- Alternative discussed: vector of parsed names.

#### AllStarLink and IAX2 IPv6
- Allan N asked about AllStarLink (https://www.allstarlink.org/) use of IAX2.
- IPv6 support was described as existing but incomplete.

#### TLS and Certificate Questions
- TLS security levels were discussed, including checking standardized EU levels as reference.
- IP-based cert handling brought up due to their recent allowance by Let's Encrypt.
- Field type handling (raw octet stream) would need a code change to be compatible.
- Wildcard certificate issues when acting as a client were noted.
- Sipgate and others generally handle TLS/TCP through Kamailio.

#### Proxy/TCP Keepalive
- Proxy/TCP keepalive behavior was discussed, especially for mobile push-server models like Acrobits.

---
#### Recording Available at [downloads.asterisk.org](https://downloads.asterisk.org/astridevcon/2026/)

---

