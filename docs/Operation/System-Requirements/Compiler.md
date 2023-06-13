---
title: Compiler
pageid: 4817502
---

The compiler is a program that takes source code (the code written in the C programming language in the case of Asterisk) and turns it into a program that can be executed. Currently, Asterisk version 1.8 and later depend on extensions offered by the **GCC** compiler for its RAII\_VAR macro implementation, so **GCC** must be used to compile Asterisk. There are currently efforts under way to make Asterisk compatible with Clang's equivalent extensions.

If the **GCC** compiler isn't already installed on your machine, simply use appropriate package management system on your machine to install it. You'll also want to install **GCC**'s C++ compiler (g++) as well since certain Asterisk modules require it.

