---
title: Macros
pageid: 31097216
---

Overview
========

Macros are very similar in function to the  application **which deprecates Macro**. This information is here for historical purposes and you should really use Gosub wherever you would have previously used Macro.

Macro is a dialplan application that facilitates code-reuse within the dialplan. That is, a macro, once defined can be called from almost anywhere else within the dialplan using the Macro application or else via flags and arguments for other applications that allow calling macros. 

Other dialplan applications, such as Dial and Queue make use of Macro functionality from within their applications. That means, they allow you to perform actions like calling Macro (or Gosub) on the called party's channel from a Dial, or on a Queue member's channel after they answer. See the [Pre-Dial Handlers](https://wiki.asterisk.org/wiki/display/AST/Pre-Dial+Handlers) and [Pre-Bridge Handlers](https://wiki.asterisk.org/wiki/display/AST/Pre-Bridge+Handlers) sections for more information.

Variables and arguments available within a Macro
================================================

The calling extension, context, and priority are stored in **MACRO\_EXTEN**, **MACRO\_CONTEXT** and **MACRO\_PRIORITY** respectively. Arguments become **ARG1**, **ARG2**, etc in the macro context. If you Goto out of the Macro context, the Macro will terminate and control will be returned at the location of the Goto. If **MACRO\_OFFSET** is set at termination, Macro will attempt to continue at priority **MACRO\_OFFSET + N + 1** if such a step exists, and **N + 1** otherwise.

Defining a dialplan context for use with Macro
==============================================

Macros look like a typical dialplan context, except for two factors:

* Macros must be named with the 'macro-' prefix.
* Macros must use the 's' extension.

[macro-announcement]
exten = s,1,NoOp()
 same = n,Playback(tt-weasels)Calling a Macro
===============

Macro syntax is simple, you only need to specify the priority, and then optionally the context and extension plus any arguments you wish to use.

Macro(name,[arg1],[argN])Here is an example within Asterisk dialplan.

[somecontext]
exten = 7000,1,Verbose("We are going to run a Macro before Dialing!")
same = n,Macro(announcement)
same = n,Dial(PJSIP/ALICE)As you can see we are calling the 'announcement' macro at context 'macro-announcement', extension 's' , priority '1'.

Calling Macro with arguments
============================

Other than the predefined variables mentioned earlier on this page, if you want to pass information into your Macro routine then you need to use arguments.

Here is how we call Macro with an argument. We are substituting the EXTEN channel variable for the first argument field (ARG1).

[somecontext]
exten = 7000,1,Verbose("We are going to run a Macro before Dialing!")
same = n,Macro(announcement,${EXTEN})
same = n,Dial(PJSIP/ALICE)Below notice that make use of ARG1 in the Verbose message we print during the subroutine execution.

[macro-announcement]
exten = s,1,Verbose("Here we are in a subroutine! This subroutine was called from extension ${ARG1}")
same = s,n,Playback(tt-weasels)
same = s,n,Return()To use multiple arguments, simply separate them via commas when defining them in the Macro call. Then within the Macro reference them as ARG1, ARG2, ARG3, etc.

