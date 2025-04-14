---
title: AEL Hints and Bugs
pageid: 4816918
---

The safest way to check for a null strings is to say $[ "${x}" = "" ] The old way would do as shell scripts often do, and append something on both sides, like this: $[ ${x}foo = foo ]. The trouble with the old way, is that, if x contains any spaces, then problems occur, usually syntax errors. It is better practice and safer wrap all such tests with double quotes! Also, there are now some functions that can be used in a variable reference, ISNULL(), and LEN(), that can be used to test for an empty string: ${ISNULL(${x})} or $[ ${LEN(${x})} = 0 ]. 

Assignment vs. Set(). Keep in mind that setting a variable to value can be done two different ways. If you choose say 'x=y;', keep in mind that AEL will wrap the right-hand-side with $[]. So, when compiled into extension language format, the end result will be 'Set(x=$[y])'. If you don't want this effect, then say "Set(x=y);" instead.
