---
title: Coding Guidelines
pageid: 3702830
---

INLINE


# Introduction

This document gives some basic indication on how the asterisk code is structured. Please read it to the end to understand in detail how the asterisk code is organized, and to know how to extend asterisk or contribute new code.

We are looking forward to your contributions to Asterisk - the Open Source PBX\! As Asterisk is a large and in some parts very time-sensitive application, the code base needs to conform to a common set of coding rules so that many developers can enhance and maintain the code. Code also needs to be reviewed and tested so that it works and follows the general architecture and guide-lines, and is well documented.

Asterisk is published under a dual-licensing scheme by Digium. To be accepted into the codebase, all non-trivial changes must be licensed to Digium. For more information, see the electronic license agreement on [https://github.com/asterisk/asterisk/issues/](https://github.com/asterisk/asterisk/issues/).

Asterisk uses [Gerrit|https://www.gerritcodereview.com/] to manage code submissions for new features and bug fixes. Read the [Gerrit Usage] page for more details.

# Guidelines

## General Rules

* Indent code using tabs, not spaces.

* All code, filenames, function names and comments must be in ENGLISH.

* Don't annotate your changes with comments like "/\\* JMG 4/20/04 \ */"; Comments should explain what the code does, not when something was changed or who changed it. If you have done a larger contribution, make sure that you are added to the CREDITS file.

* Don't make unnecessary whitespace changes throughout the code if that is not the goal of the task at hand.
    * If you do want to make whitespace and formatting changes, submit them to the tracker as separate patches that only include whitespace and formatting changes.

* Don't use C+\+ type (//) comments.

* Try to match the existing formatting of the file you are working on.

* Use spaces instead of tabs when aligning in-line comments or #defines (this makes your comments aligned even if the code is viewed with another tabsize)


## File structure and header inclusion

Every C source file should start with a proper copyright and a brief description of the content of the file. Following that, you should immediately put the following lines:

```
#include "asterisk.h"

```

"asterisk.h" resolves OS and compiler dependencies for the basic set of unix functions (data types, system calls, basic I/O libraries) and the basic Asterisk APIs.

Next, you should #include extra headers according to the functionality that your file uses or implements. For each group of functions that you use there is a common header, which covers OS header dependencies and defines the 'external' API of those functions (the equivalent of 'public' members of a class). As an example:

* asterisk/module.h
    * if you are implementing a module, this should be included in one of the files that are linked with the module.

* asterisk/io.h
    * access to extra file I/O functions (stat, fstat, playing with directories etc)

* asterisk/network.h
    * basic network I/O - all of the socket library, select/poll, and asterisk-specific (usually either thread-safe or reentrant or both) functions to play with socket addresses.

* asterisk/app.h
    * parsing of application arguments

* asterisk/channel.h
    * struct ast_channel and functions to manipulate it

For more information look at the headers in include/asterisk/. These files are usually self-sufficient, i.e. they recursively #include all the extra headers they need.

The equivalent of 'private' members of a class are either directly in the C source file, or in files named asterisk/mod_\*.h to make it clear that they are not for inclusion by generic code.

Keep the number of header files small by not including them unnecessarily. Don't cut&paste list of header files from other sources, but only include those you really need. Apart from obvious cases (e.g. module.h which is almost always necessary) write a short comment next to each #include to explain why you need it.

## Declaration of functions and variables

* Do not declare variables mid-block (e.g. like recent GNU compilers support) since it is harder to read and not portable to GCC 2.95 and others.

* Functions and variables that are not intended to be used outside the module must be declared static. If you are compiling on a Linux platform that has the 'dwarves' package available, you can use the 'pglobal' tool from that package to check for unintended global variables or functions being exposed in your object files. Usage is very simple:

```
$ pglobal \-vf <path to .o file>
```
* When reading integer numeric input with scanf (or variants), do _NOT_ use '%i' unless you specifically want to allow non-base-10 input; '%d' is always a better choice, since it will not silently turn numbers with leading zeros into base-8.

* Strings that are coming from input should not be used as the format argument to any printf-style function.

## Structure alignment and padding

On many platforms, structure fields (in structures that are not marked 'packed') will be laid out by the compiler with gaps (padding) between them, in order to satisfy alignment requirements. As a simple example:

```
struct foo {
 int bar;
 void \*xyz;
}

```

On nearly every 64-bit platform, this will result in 4 bytes of dead space between 'bar' and 'xyz', because pointers on 64-bit platforms must be aligned on 8-byte boundaries. Once you have your code written and tested, it may be worthwhile to review your structure definitions to look for problems of this nature. If you are on a Linux platform with the 'dwarves' package available, the 'pahole' tool from that package can be used to both check for padding issues of this type and also propose reorganized structure definitions to eliminate it. Usage is quite simple; for a structure named 'foo', the command would look something like this:

```
$ pahole \--reorganize \--show_reorg_steps \-C foo <path to module>
```
The 'pahole' tool has many other modes available, including some that will list all the structures declared in the module and the amount of padding in each one that could possibly be recovered.

## Use the internal API

Make sure you are aware of the string and data handling functions that exist within Asterisk to enhance portability and in some cases to produce more secure and thread-safe code. Check utils.c/utils.h for these.

If you need to create a detached thread, use the ast_pthread_create_detached() normally or ast_pthread_create_detached_background() for a thread with a smaller stack size. This reduces the replication of the code to handle the pthread_attr_t structure.

## Code formatting

Roughly, Asterisk code formatting guidelines are generally equivalent to the following:

{warning}Running the indent command on an existing module may result in drastic alterations to it or indentation that is actually incorrect. It is recommended that if you are making changes to existing code that you manually indent. If you would like to fix the indentation of an existing module this should be done as a separate review.{warning}

```
# indent -i4 -ts4 -br -brs -cdw -lp -ce -nbfda -npcs -nprs -npsl -nbbo -saf -sai -saw -cs -l90 foo.c
```
this means in verbose:
```
 -i4: indent level 4
 -ts4: tab size 4
 -br: braces on if line
 -brs: braces on struct decl line
 -cdw: cuddle do while
 -lp: line up continuation below parenthesis
 -ce: cuddle else
 -nbfda: dont break function decl args
 -npcs: no space after function call names
 -nprs: no space after parentheses
 -npsl: dont break procedure type
 -nbbo: dont prefer to break long lines before boolean operators
 -saf: space after for
 -sai: space after if
 -saw: space after while
 -cs: space after cast
 -l90: line length 90 columns
```
Function calls and arguments should be spaced in a consistent way across the codebase.
```
 GOOD: foo(arg1, arg2);
 BAD: foo(arg1,arg2);
 BAD: foo (arg1, arg2);
 BAD: foo( arg1, arg2 );
 BAD: foo(arg1, arg2,arg3);
```
Don't treat keywords (if, while, do, return) as if they were functions; leave space between the keyword and the expression used (if any). For 'return', don't even put parentheses around the expression, since they are not required.

There is no shortage of whitespace characters :-) Use them when they make the code easier to read. For example:

```
 for (str=foo;str;str=str->next)

```
is harder to read than

```
 for (str = foo; str; str = str->next)

```
Following are examples of how code should be formatted.

### Functions:

```
int foo(int a, char \*s)
{
 return 0;
}

```

### If statements:
{newcode:C}
if (foo) {
 bar();
} else {
 blah();
}
{newcode}

### Case statements:

```
switch (foo) {
case BAR:
 blah();
 break;
case OTHER:
 other();
 break;
}

```

### No nested statements without braces

```
for (x = 0; x < 5; x++)
 if (foo)
 if (bar)
 baz();

```

Instead, do:

```
for (x = 0; x < 5; x++) {
 if (foo) {
 if (bar) {
 baz();
 }
 }
}

```

Always use braces around the statements following an if/for/while construct, even if not strictly necessary, as it reduces future possible problems.

Don't build code like this:

```
if (foo) {
 /* .... 50 lines of code .. */
} else {
 result = 0;
 return;
}

```
Instead, try to minimize the number of lines of code that need to be indented, by only indenting the shortest case of the 'if' statement, like so:

```
if (!foo) {
 result = 0;
 return;
}

.... 50 lines of code ....

```

When this technique is used properly, it makes functions much easier to read and follow, especially those with more than one or two 'setup' operations that must succeed for the rest of the function to be able to execute.

## Labels/goto are acceptable

Proper use of this technique may occasionally result in the need for a label/goto combination so that error/failure conditions can exit the
function while still performing proper cleanup. This is not a bad thing\! Use of goto in this situation is encouraged, since it removes the need
for excess code indenting without requiring duplication of cleanup code.

## Do not cast 'void \\*'

Do not explicitly cast 'void \\*' into any other type, nor should you cast any other type into 'void \\*'. Implicit casts to/from 'void \\*' are explicitly allowed by the C specification. This means the results of malloc(), calloc(), alloca(), and similar functions do not _ever_ need to be cast to a specific type, and when you are passing a pointer to (for example) a callback function that accepts a 'void \\*' you do not need to cast into that type.

## Function naming

All public functions (those not marked 'static'), must be named "ast_<something>" and have a descriptive name.

As an example, suppose you wanted to take a local function "find_feature", defined as static in a file, and used only in that file, and make it public, and use it in other files. You will have to remove the "static" declaration and define a prototype in an appropriate header file (usually in include/asterisk). A more specific name should be given, such as "ast_find_call_feature".

## Variable function argument parsing

Functions with a variable amount of arguments need a 'sentinel' when called. Newer GNU C compilers are fine if you use NULL for this. Older versions (pre 4) don't like this. You should use the constant SENTINEL. This one is defined in include/asterisk/compiler.h

## Variable naming

### Global variables

Name global variables (or local variables when you have a lot of them or are in a long function) something that will make sense to aliens who
find your code in 100 years. All variable names should be in lower case, except when following external APIs or specifications that normally
use upper\- or mixed-case variable names; in that situation, it is preferable to follow the external API/specification for ease of understanding.

Make some indication in the name of global variables which represent options that they are in fact intended to be global.
e.g.: `static char global_something{`}`\[80\]`

## Don't use unnecessary typedef's

Don't use 'typedef' just to shorten the amount of typing; there is no substantial benefit in this:
\{\{struct foo \{ int bar; \}; typedef struct foo foo_t;\}\}

In fact, don't use 'variable type' suffixes at all; it's much preferable to just type 'struct foo' rather than 'foo_s'.

## Use enums instead of #define where possible

Use enums rather than long lists of #define-d numeric constants when possible; this allows structure members, local variables and function arguments to be declared as using the enum's type. For example:

```
enum option {
 OPT_FOO = 1,
 OPT_BAR = 2,
 OPT_BAZ = 4,
};

static enum option global_option;

static handle_option(const enum option opt)
{
 ...
}

```

Note: The compiler will _not_ force you to pass an entry from the enum as an argument to this function; this recommendation serves only to make
the code clearer and somewhat self-documenting. In addition, when using switch/case blocks that switch on enum values, the compiler will warn you if you forget to handle one or more of the enum values, which can be handy.

## String handling

Don't use strncpy for copying whole strings; it does not guarantee that the output buffer will be null-terminated. Use ast_copy_string instead, which is also slightly more efficient (and allows passing the actual buffer size, which makes the code clearer).

Don't use ast_copy_string (or any length-limited copy function) for copying fixed (known at compile time) strings into buffers, if the buffer is something that has been allocated in the function doing the copying. In that case, you know at the time you are writing the code whether the buffer is large enough for the fixed string or not, and if it's not, your code won't work anyway\! Use strcpy() for this operation, or directly set the first two characters of the buffer if you are just trying to store a one character string in the buffer. If you are trying to 'empty' the buffer, just store a single NULL character ('\0') in the first byte of the buffer; nothing else is needed, and any other method is wasteful.

In addition, if the previous operations in the function have already determined that the buffer in use is adequately sized to hold the string
you wish to put into it (even if you did not allocate the buffer yourself), use a direct strcpy(), as it can be inlined and optimized to simple
processor operations, unlike ast_copy_string().

## String conversions

When converting from strings to integers or floats, use the sscanf function in preference to the atoi and atof family of functions, as sscanf detects errors. Always check the return value of sscanf to verify that your numeric variables successfully scanned before using them. Also, to avoid a potential libc bug, always specify a maximum width for each conversion specifier, including integers and floats. A good length for both integers and floats is 30, as this is more than generous, even if you're using doubles or long integers.

## Use of functions

For the sake of uclibc, do not use index, bcopy or bzero; use strchr(), memset(), and memmove() instead. uclibc can be configured to supply these functions, but we can save these users time and consternation if we abstain from using these functions.

When making applications, always ast_strdupa(data) to a local pointer if you intend to parse the incoming data string.

```
 if (data) {
 mydata = ast_strdupa(data);
 }

```

Use the argument parsing macros to declare arguments and parse them, i.e.:

```
 AST_DECLARE_APP_ARGS(args,
 AST_APP_ARG(arg1);
 AST_APP_ARG(arg2);
 AST_APP_ARG(arg3);
 );
 parse = ast_strdupa(data);
 AST_STANDARD_APP_ARGS(args, parse);

```

Make sure you are not duplicating any functionality already found in an API call somewhere. If you are duplicating functionality found in
another static function, consider the value of creating a new API call which can be shared.

## Handling of pointers and allocations

### Use const on pointer arguments if possible

Use const on pointer arguments which your function will not be modifying, as this allows the compiler to make certain optimizations. In general, use 'const' on any argument that you have no direct intention of modifying, as it can catch logic/typing errors in your code when you use the argument variable in a way that you did not intend.

### Do not create your own linked list code - reuse\!

As a common example of this point, make an effort to use the lockable linked-list macros found in include/asterisk/linkedlists.h. They are
efficient, easy to use and provide every operation that should be necessary for managing a singly-linked list (if something is missing,
let us know\!). Just because you see other open-coded list implementations in the source tree is no reason to continue making new copies of
that code... There are also a number of common string manipulation and timeval manipulation functions in asterisk/strings.h and asterisk/time.h;
use them when possible.

### Allocations for structures

When allocating/zeroing memory for a structure, use code like this:

```
struct foo \*tmp;

...

tmp = ast_calloc(1, sizeof(\*tmp));

```

Avoid the combination of ast_malloc() and memset(). Instead, always use ast_calloc(). This will allocate and zero the memory in a single operation. In the case that uninitialized memory is acceptable, there should be a comment in the code that states why this is the case.

Using sizeof(\*tmp) instead of sizeof(struct foo) eliminates duplication of the 'struct foo' identifier, which makes the code easier to read and also ensures that if it is copy-and-pasted it won't require as much editing.

The ast_\\* family of functions for memory allocation are functionally the same. They just add an Asterisk log error message in the case that the allocation fails for some reason. This eliminates the need to generate custom messages throughout the code to log that this has occurred.

### String Duplications

The functions strdup and strndup can \*not\* accept a NULL argument. This results in having code like this:

```
 if (str) {
 newstr = strdup(str);
 } else {
 newstr = NULL;
 }

```
However, the ast_strdup and ast_strdupa functions will happily accept a NULL
argument without generating an error. The same code can be written as:

```
 newstr = ast_strdup(str);

```
Furthermore, it is unnecessary to have code that malloc/calloc's for the length of a string (+1 for the terminating '\0') and then using strncpy to copy the copy the string into the resulting buffer. This is the exact same thing as using ast_strdup.

## CLI Commands

New CLI commands should be named using the module's name, followed by a verb and then any parameters that the command needs. For example:
```
\*CLI> iax2 show peer <peername>
```
not
```
\*CLI> show iax2 peer <peername>
```
## New dialplan applications/functions

There are two methods of adding functionality to the Asterisk dialplan: applications and functions. Applications (found generally in
the apps/ directory) should be collections of code that interact with a channel and/or user in some significant way. Functions (which can be
provided by any type of module) are used when the provided functionality is simple... getting/retrieving a value, for example. Functions should also be used when the operation is in no way related to a channel (a computation or string operation, for example).

Applications are registered and invoked using the ast_register_application function; see the apps/app_skel.c file for an example.

Functions are registered using 'struct ast_custom_function' structures and the ast_custom_function_register function.

## Doxygen API Documentation Guidelines

When writing Asterisk API documentation the following format should be followed. Do not use the javadoc style.

```
/*!
 * \brief Do interesting stuff.
 *
 * \param thing1 interesting parameter 1.
 * \param thing2 interesting parameter 2.
 *
 * This function does some interesting stuff.
 *
 * \retval zero on success
 * \retval -1 on error.
 */
int ast_interesting_stuff(int thing1, int thing2)
{
 return 0;
}

```

Notice the use of the \param, \brief, and \return constructs. These should be used to describe the corresponding pieces of the function being documented. Also notice the blank line after the last \param directive. All doxygen comments must be in one /*\! \ */ block. If the function or struct does not need an extended description it can be left out.

Please make sure to review the doxygen manual and make liberal use of the \a, \code, \c, \b, \note, \li and \e modifiers as appropriate.

When documenting a 'static' function or an internal structure in a module, use the \internal modifier to ensure that the resulting documentation explicitly says 'for internal use only'.

When adding new API you should also attach a \since note because this will indicate to developers that this API did not exist before this version. It also has the benefit of making the resulting HTML documentation to group the changes for a single version.

Structures should be documented as follows.

```
/*!
 * \brief A very interesting structure.
 */
struct interesting_struct
{
 /*! \brief A data member */
 int member1;

 int member2; /*!< \brief Another data member */
}

```
Note that /\\*\! \ */ blocks document the construct immediately following them unless they are written, /\\*\!< \ */, in which case they document the construct preceding them.

It is very much preferred that documentation is not done inline, as done in the previous example for member2. The first reason for this is that it tends to encourage extremely brief, and often pointless, documentation since people try to keep the comment from making the line extremely long. However, if you insist on using inline comments, please indent the documentation with spaces\! That way, all of the comments are properly aligned, regardless of what tab size is being used for viewing the code.

## Creating new manager events?

If you create new AMI events, please read [AST:Asterisk Manager Interface (AMI)]. Do not re-use existing headers for new purposes, but please re-use existing headers
for the same type of data.

Manager events that signal a status are required to have one event name, with a status header that shows the status. The old style, with one event named "ThisEventOn" and another named "ThisEventOff", is no longer approved.

Check [AST:Asterisk Manager Interface (AMI)] for more information on manager and existing headers. Please update the page, [AST:Some Standard AMI Headers], if you add new headers.



