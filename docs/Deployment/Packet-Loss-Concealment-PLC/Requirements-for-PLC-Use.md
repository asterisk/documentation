---
title: Requirements for PLC Use
pageid: 5243116
---

The following are all required for PLC to be used:

1. Enable genericplc in the plc section of codecs.conf
2. If PLC is desired when two channels use the same codec, enable genericplc\_on\_equal\_codecs in the plc section of codecs.conf.  This forces transcoding via slin.
3. Enable (and potentially force) jitter buffers on channels
4. Two channels must be bridged together for PLC to be used (no Meetme or one-legged calls)
5. The audio must be translated between the two channels and must have slin as a step in the translation process.
