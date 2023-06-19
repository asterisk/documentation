---
title: ARI Feature Wish-list
pageid: 32375021
---

 

 

70%Overview
========

The ARI Feature Wish-List has been setup to help collect ideas from the wider ARI community. If you're using ARI to build applications or developing an ARI framework, we're interested in your thoughts, suggestions and feedback. You can contribute by either posting a comment or by joining the conversation in the #asterisk-dev or #asterisk-ari channels over on freenode. Remember, unless you want to write the feature yourself, there's no guarantee it will be done.

On this Page


JIRA Feature Requests
=====================

key,summary,type,created,updated,due,assignee,reporter,priority,status,resolutionDigium/Asterisk JIRAee634d14-2067-31b4-9ca3-00e0845ec070project=ASTERISK and (type="Improvement" or type="New Feature") and status != Closed and status != Complete and labels in ("ARI") 20

Non-JIRA Feature Requests
=========================

Don't see your Wish-List request below? Ask in #asterisk-ari on freenode.

 



| Feature | Short Description | Submitted | JIRA # | Status |
| --- | --- | --- | --- | --- |
| ARI TTS/ASR Support | See: [Re: Asterisk 14 Project - ARI and generic Text To Speech](/Asterisk+14+Project+-+ARI+and+generic+Text+To+Speech?focusedCommentId=30279243#comment-30279243) | 14/3/2015 |  |  |
| HTTP Media Playback | Play media directly from a URL. See [Asterisk 14 Project - URI Media Playback](/Asterisk-14-Project-URI-Media-Playback) | 16/3/2015 | ~~[ASTERISK-25654](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25925)~~ | Done |
| Media Playlists | Play a sequence of media resources via a single request. See [Asterisk 14 Project - Media Playlists](/Asterisk-14-Project-Media-Playlists) | 16/3/2015 | ~~[ASTERISK-26022](https://gerrit.asterisk.org/#/q/topic:ASTERISK-26022 "Search for changes on this topic")~~ | Done |
| Early bridge | Bridge answered channels (inbound) and unanswered channels (outbound), passing media from outbound channels to inbound channels. Allow for unanswered outbound channels to be placed directly into an early bridge. This would allow for early media in "dial" operations in ARI. | 16/3/2015 | ~~[ASTERISK-25889](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25889)~~~~[ASTERISK-25925](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25925)~~ | Done |
| Session Progress Handling | Ability for ARI to raise an event when a channel receives Session Progress (183) | 19/11/2015 | ~~[ASTERISK-25925](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25925)~~ | Done |
| Recorded file retrieval | Allow files in the StoredRecordings resource to be retrieved from the HTTP server. | 16/3/2015 |  |  |
| Channel dialplan request | Allow ARI to "request" a channel in the dialplan to be placed into a Stasis application and/or be moved to a new location in the dialplan. Similar to the AMI Redirect action. | 16/3/2015 |  |  |
| "All" subscriptions | Allow ARI to make subscriptions to all bridges/channels/endpoints. In particular, this is needed for bridges, as they are not tied explicitly to a Stasis application. | 16/3/2015 | ~~[ASTERISK-24870](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-24870)~~ | Done |
| PBX Stasis | Instead of having a Stasis application, have certain dialplan contexts be "owned" an an external ARI application. Channels that enter that context are immediately handed off to an application. The application would immediately be subscribed to all channels within that context. Note that this would need the 'all bridges' subscription noted above. | 16/3/2015 |  |  |
| Security events | Allow for subscriptions to security events through the applications resource. Raise events as appropriate. | 16/3/2015 |  |  |
| Asterisk control | Improve the /asterisk resource to allow for more system control, i.e., restarts, logger manipulation, module reloading, etc. | 16/3/2015 | ~~[ASTERISK-25173](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25173)~~ | Done |
| Endpoint injection | For endpoints that could feasibly support it, i.e., PJSIP, allow for endpoints to be 'pushed' into memory via ARI. This would allow for endpoints to be created through the REST API. | 16/3/2015 | ~~[ASTERISK-25238](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-25238)~~ | Done |
| Config file updates | Allow any configuration file in Asterisk to be updated via ARI. | 16/3/2015 |  |  |
| Stasis dialplan result variable | Set a channel variable on a channel if it can't get placed into a Stasis dialplan application. | 16/3/2015 | ~~[ASTERISK-24802](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-24802)~~ | Done |
| Increase HTTP max content length | The HTTP max content length is currently 4k. That limits some of the requests that can be made. | 16/3/2015 | ~~[ASTERISK-24883](https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-24883)~~ | Done |
| Add/Remove Sounds | Allow ARI to be used to push new sounds to asterisk storage over HTTP and also deleted | 16/3/2015 |  |  |
| ARI Debug | Allow ARI debug information at console, like sip set debug, we could have: ari set debug on/off. Could show details about messages passed between application and asterisk. Could be filtered by Stasis app too, e.g. "ari set debug <appname> on" | 05/05/2015 |  | Done |
| ari show applications | Ability to list applications from the console. Show details like IP of application websocket endpoint, duration, missed msg's(?) | 01/08/2016 |  | Done |
| Bridged DTMF Pass-through | Expose ability to set pass-through behavior of DTMF on bridges at bridge creation or when a channel is added to a bridge | 05/08/2016 |  |  |
| Connection without user | Allow ARI requests to be initiated without requiring authentication or a user | 15/08/2016 |  |  |
| Set Presence State | The ability to set presencestate information via ARI would be immensely helpful for those developing custom apps that need to integrate Asterisk media functionality with external chat apps, etc. | 15/09/2016 |  |  |
| Multi-Channel Recording | Recorded to multi-channel wav with a channel for each leg of a bridge. WAV format spec supports up to 18 channels. It would be greatly useful for audio analysis | 15/09/2016 |  |   |
| On Connection End | When a call is active and the ARI connection dies, add an option to be able to send the call to a dialplan location or be able to set it within the ARI connection JSON |  |  |  |

