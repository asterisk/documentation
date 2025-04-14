---
title: AEL Procedural Interface and Internals
pageid: 4620471
---

AEL first parses the extensions.ael file into a memory structure representing the file. The entire file is represented by a tree of "pval" structures linked together. 

This tree is then handed to the semantic check routine. 

Then the tree is handed to the compiler. 

After that, it is freed from memory. 

A program could be written that could build a tree of pval structures, and a pretty printing function is provided, that would dump the data to a file, or the tree could be handed to the compiler to merge the data into the asterisk dialplan. The modularity of the design offers several opportunities for developers to simplify apps to generate dialplan data.
