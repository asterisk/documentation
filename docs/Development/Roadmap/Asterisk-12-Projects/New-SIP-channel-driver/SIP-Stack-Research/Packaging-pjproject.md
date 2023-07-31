---
title: Packaging pjproject
pageid: 22085786
---




# Introduction

\*pjproject\* is a collection of libraries and utilities for building and testing SIP applications. Asterisk currently "bundles" a copy of pjproject, however this is undesirable for a variety of reasons. However, the pjproject constituents are not available as packages for common Linux distributions or as suitable pre-compiled binaries for popular target platforms. The Asterisk community would benefit from the existence of these packages and so is motivated to, at the very least, contribute to the creation of a package-ready \*pjproject\* distribution and an initial set of packages for CentOS and a distribution that supports the installation of header files and libraries according to a given platform's standards and best practices. Given that \*pjsip\* (the SIP implementation library included in \*pjproject\*) is currently the _first choice_ as a basis for the next generation SIP channel driver to be included in Asterisk 12, it is appropriate to address packaging \*pjproject\* now.

_Note: Research for this page was done by Brent Eagles._

# Getting Started

Recognizing the importance to Asterisk and the Asterisk community, Digium is endeavoring to take the lead by committing resources to the initial phases of packaging \*pjproject\*. Seeing as "why" has already answered, let us address some of the other typical questions.

## What is Going to Be Done

It is reasonable that initial packaging efforts focus on a select number of targets that will:
* be representative of typical packaging efforts
* be relevant to existing activities of the developers doing the work, in this case Digium.

With this in consideration, the current effort will focus on runtime and developer RPMs for CentOS and a source archive with a build system that supports creating shared libraries for the relevant \*pjproject\* libraries and installation targets for runtime and developer installs. The runtime RPM and install targets include the shared libraries that make up the runtime functionality of the relevant \*pjproject\* libraries. The developer RPM and install targets install the header files and any additional resources required to build Asterisk. Installing the developer package or portions of \*pjproject\* are not required for _running_ Asterisk. In addition binary RPMs, a source RPM (SRPM) must also be created to support subsequent packaging efforts and updates to \*pjproject\* that may be necessary in the related time frame.

Please note that the goal of the initial packaging effort is to focus only on the portions of \*pjproject\* that are relevant to Asterisk. Currently those are:
* PJSIP
* PJNATHelper
* PJLib
* PJSIPSIMPLE
* PJSIPUA
* PJLIBUtil
* PJMedia

In addition to packaging \*pjproject\*, the Asterisk build system will be modified to build against an installed \*pjproject\* instead of a bundled copy as it is now. The `install_prereq` script will also be modified to download, build and install \*pjproject\* if necessary.

### pjproject Work Required

#### The Current Build System

The \*pjproject\* build system is a sort of autoconf/makefile hybrid. Compiler and linker flags, etc. are stored in files named according to their intended target system. The values required for generating the names for the files are calculated during the configure step. The makefiles then include an "options" file that is a hash of the option file type and one of the variables calculated when "configure" was run. The values may be overridden at build type by modifying one or more files specifically set aside for this purpose: e.g. user.mak, config_site.h.
{note}Overriding "defines" and build time variables has seem rather hit-or-miss at times. Usually the issue ends up being that another value (or values) must also be modified.{note}
The existing build system \*may\* be a suitable foundation for building for packages with certain modifications.

#### Library Types

To satisfy LGPL and packaging requirements, the libraries need to be constructed as shared libraries and the executable images linked against them.

#### Target Names

\*pjproject\* target names are constructed from the library name and details about the target. Whatever the motive, this naming scheme is not consistent with the typical library or executable naming schemes used on the target distributions. The naming makes it rather difficult to build against as a third party library as the naming algorithm must be replicated in the client build system. Installation target names typically do not include system details and also have version numbers and with major version and unversioned symbolic links to the current shared library version.

#### Third Party Libraries

\*pjproject\* contains some third party contributions for codec's etc.. There may be licensing concerns if these contributions are required by Asterisk or the \*pjproject\* packages. This may mean "unbundling" third party libraries and creating packages for the ones that are required by Asterisk if they do not exist.

#### Build Hygiene

The pjproject build tends to be rather full of warnings, etc. Package maintainers may prefer to see this cleaned up. It certainly would not hurt. If the current build system is to be used as a foundation, then build issues need to be resolved such as bugs in dependency generation or build system corruption when builds are interrupted.

{info}Resolving these issues tends not to be difficult. However, considering the number of libraries, verification of the build system and installation is time consuming.{info}
## Where is it Going to Happen

A new git repository will host a copy of \*pjproject\* that is being packaged as well as the required build system modifications, RPM spec file and any required shell scripts. Once completed, the \*pjproject\* archive will be made available for download and the RPMs will be available from the Asterisk YUM repository.

# Next Steps

There a multiple possible directions that may be taken once the initial packaging effort is complete. Ideally the build system contributions would be adopted upstream to the \*pjproject\* authors and maintainers (Teluu). Packaging work for additional distributions should be significantly advanced by the efforts of the initial phases, allowing other interested contributors to take the lead in creating and maintaining other packages.
