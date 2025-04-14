---
search:
  boost: 0.2
title: CODEC Bit Expansion
pageid: 4259984
---

CODEC Bit Expansion
===================

The code base up to and including Asterisk 1.6.2 has a basic limit of 32 codecs recognizable, due to the use of a 32-bit integer for the codec bitmask. We have expanded the number of available codecs from 32 to 64, through the use of an immutable type, called format_t. This should make future expansion to even more bits more easily done.

The design of this expansion has made some changes to the architecture of codecs in order to accomplish this task. I will attempt to enumerate them here.

The initial set of 32-bits were allocated as the first 16 to audio codecs, the next 8 to video codecs, and the remaining to text codecs (which are used for fax capabilities). Initially, there is an assumption in the code that all audio codecs are contiguous, followed by a contiguous set of video codecs. After the conversion, this assumption will no longer be true. The codec bits for the existing codecs will continue to be allocated as-is, and the additional codec bits should be allocated on an as-needed basis, with audio codecs occupying slots 32-47 and video codecs occupying slots 48-62 (with a 0-based offset). Slot 63 is reserved and should not be allocated; it is used in code as an end condition for iterating through the entire set of codecs.

The frame structure has been altered. Initially, the subclass held an integer whose meaning was specified by the frametype. If the frametype was AST_FRAME_VOICE, the subclass specified the audio codec. If the frametype was AST_FRAME_VIDEO, the subclass specified the video codec, with the 0-bit set to specify a key frame. This was done with a union on the subclass, where the "integer" union member specifies the traditional 32-bit subclass and the "codec" union member specifies the new 64-bit codec bitmask. This additionally guarantees that code compiled under the old scheme will need to be altered to compile under the new scheme, which helps avoid incorrect assumptions about the state of code which might otherwise compile without errors.

The IAX2 code initially used a 32-bit integer IE to specify both the codec as well as the preferred format. An additional IE has been added, which specifies a single byte version number as the initial part of the data. This version number is initially specified as 00 and requires 8 bytes to follow, specifying the 64-bit codec bitmask, in network-byte order. This schema should allow further codec expansion in the future without allocation of any additional IEs.

Little changes are required to support further codec expansion in the future, though the majority of the work has already been accomplished. Specifically, the bitwise operations that are immutable operations in the gcc compiler will need to be altered to handle larger bitmasks. Additionally, the constants that define specific codecs will need to be changed from integers to structures.
