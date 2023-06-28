---
title: Media Overhaul
pageid: 4260120
---



# Project Requirements

{warning}
This section is incomplete.
{warning}

## Relevant Problems That Exist Today

\* Codec negotiation (both with Asterisk, and across a bridge)
\*\* Support for audio codecs with attributes (SILK)
\*\* Support for video codecs with attributes
\* Limitation on the number of codecs Asterisk can support
\* Translation paths are audio specific (with no concept of attributes)
\* There is no way to renegotiate codecs after a call is up
\* Conferencing is limited to 8 kHz
\* There is no way to easily get Asterisk to pass through a media type that it does not understand (proprietary data)
\* Once Asterisk supports codecs with attributes, users will need to be able to specify codecs with attributes
\* Asterisk is not able to handle a call with more than one audio/video/text stream (only one stream per type).
\* Asterisk has no RTCP support relevant to audio and video synchronization
\* Asterisk does not support Gtalk video

## Phase 1 Requirements

Rework media representation completely across all of Asterisk, while maintaining existing functionality. Only add functionality that is required to exercise what has been done.

\* Design a new way to represent codecs
\*\* translation interface
\*\* capabilities
\*\* ast_frame handling
\*\* Initial call setup codec negotiation
\*\* everything that touches media ...
\* Exercise what we have done so far
\*\* Add support for SILK (and its attributes)
\*\* Add support for H.264 attributes
\* Custom format definitions with attributes (for setting preferences)

## Phase Later Requirements

\* Codec re-negotiation
\* Improved conferencing (dynamic sample rate support)
\* Video transcoding (an implementation that proves it works)
\* A&V sync in RTCP (research required)
\* GTalk Video Support
\* Support for unknown media types for pass-through (research required)
\* Support for more than one stream of the same type (audio/video/text)

