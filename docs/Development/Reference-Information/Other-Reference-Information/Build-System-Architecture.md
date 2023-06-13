---
title: Build System Architecture
pageid: 5243137
---

{numberedheadings}

{toc}

h1. Build Architecture

The asterisk build architecture relies on autoconf to detect the system configuration, and on a locally developed tool (menuselect) to select build options and modules list, and on gmake to do the build.

The first step, usually to be done soon after a checkout, is running "./configure", which will store its findings in two files:

\* include/asterisk/autoconfig.h
\*\* contains C macros, normally #define HAVE\_FOO or HAVE\_FOO\_H , for all functions and headers that have been detected at build time. These are meant to be used by C or C++ source files.

\* makeopts
\*\* contains variables that can be used by Makefiles. In addition to the usual CC, LD, ... variables pointing to the various build tools, and prefix, includedir ... which are useful for generic compiler flags, there are variables for each package detected. These are normally of the form FOO\_INCLUDE=... FOO\_LIB=... FOO\_DIR=... indicating, for each package, the useful libraries and header files.

The next step is to run "make menuselect", to extract the dependencies existing between files and modules, and to store build options.
menuselect produces two files, both to be read by the Makefile:

\* menuselect.makeopts
\*\* Contains for each subdirectory a list of modules that must be excluded from the build, plus some additional informatiom.

\* menuselect.makedeps
\*\* Contains, for each module, a list of packages it depends on. For each of these packages, we can collect the relevant INCLUDE and LIB files from makeopts. This file is based on information in the .c source code files for each module.

The top level Makefile is in charge of setting up the build environment, creating header files with build options, and recursively invoking the
subdir Makefiles to produce modules and the main executable.

The sources are split in multiple directories, more or less divided by module type (apps/ channels/ funcs/ res/ ...) or by function, for the main binary (main/ pbx/).

{warning}
This section is not complete...
{warning}

h1. Adding new modules

If your module is going in the {{addons/}} directory, you must edit {{addons/Makefile}} and add it to the list of modules assigned to the {{ALL\_C\_MODS}} variable. Once that is done, continue to the next steps. For any other directory, just continue.

h2. Modules with no dependencies

If your module has no dependencies on external libraries, it can be dropped into the appropriate directory and the build system will automatically detect it and build it for you. For example, if you write {{app\_custom.c}}, drop it in the {{apps/}} directory.

h2. Modules with dependencies

If your module has an external dependency, you have a bit more work to do to integrate it into the build system. First, you must determine whether the library you are using is used by any other Asterisk module. If not, you must add the library to the following files.

h3. {{./configure.ac}}

This is the source of the {{./configure}} script. There are \_many\_ examples to draw from in this file. Search for the two instances of {{ALSA}} in this file to find one of the simpler examples of checking for a library. If you do modify {{./configure.ac}}, you must run {{./bootstrap.sh}} to regenerate {{./configure}} and {{./include/asterisk/autoconfig.h.in}} (both of which must be checked in if submitting a patch). Also, if the library provides a pkg-config .pc file, you can use the {{AST\_PKG\_CONFIG\_CHECK}} macro instead of {{AST\_EXT\_LIB\_CHECK}}.

h3. {{./build\_tools/menuselect-deps.in}}

Add a line in this file for your new library. The configure script uses this file as input and outputs build\_tools/menuselect-deps. The {{menuselect}} utility reads in this file to know which libraries have been found on the system.

h3. {{./makeopts.in}}

Add {{LIBNAME\_LIB}} and {{LIBNAME\_INCLUDE}} lines into this file. The configure script will use this file as input and output the {{makeopts}} file. When this library is found, these lines will have the appropriate {{CFLAGS}} and {{LDFLAGS}} needed to build and link a module with the library. Follow the other examples that are already in this file for formatting.

h3. Update your module

Modules that have a dependency must have a special comment block in them that is used by the build system.

{code}
/\*\*\* MODULEINFO
 <depend>libname</depend>
 \*\*\*/
{code}

{numberedheadings}

