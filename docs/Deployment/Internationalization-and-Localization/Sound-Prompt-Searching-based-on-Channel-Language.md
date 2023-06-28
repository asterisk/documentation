---
title: Sound Prompt Searching based on Channel Language
pageid: 4817332
---

**How Asterisk Searches for Sound Prompts Based on Channel Language**

Each channel in Asterisk can be assigned a language by the channel driver. The channel's language code is split, piece by piece (separated by underscores), and used to build paths to look for sound prompts. Asterisk then uses the first file that is found.

This means that if we set the language to en_GB_female_BT, for example, Asterisk would search for files in:

.../sounds/en_GB_female_BT

.../sounds/en_GB_female

.../sounds/en_GB

.../sounds/en

.../sounds

This scheme makes it easy to add new sound prompts for various language variants, while falling back to a more general prompt if there is no prompt recorded in the more specific variant.

