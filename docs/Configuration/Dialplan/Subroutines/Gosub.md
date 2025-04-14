---
title: Gosub
pageid: 31097218
---

Overview
========

[`Gosub` is a dialplan application](/Latest_API/API_Documentation/Dialplan_Applications/Gosub). It replaces (is recommended in place of, and deprecates) the `Macro` application.

`Gosub` allows you to execute a specific block (context or section) of dialplan as well as pass and return information via arguments to/from the scope of the block. Whereas `Macro` has issues with nesting, `Gosub` does not and `Gosub` should be used wherever you would have used a `Macro`.

Other dialplan applications, such as `Dial` and `Queue` make use of `Gosub` functionality from within their applications. That means they allow you to perform actions like calling `Gosub` on the called party's channel from a `Dial`, or on a `Queue` member's channel after they answer. See the [Pre-Dial Handlers](/Configuration/Dialplan/Subroutines/Pre-Dial-Handlers) and [Pre-Bridge Handlers](/Configuration/Dialplan/Subroutines/Pre-Bridge-Handlers) sections for more information.

Defining a dialplan context for use with Gosub
==============================================

No special syntax is needed when defining the dialplan code that you want to call with `Gosub`, *unless* you want to return back to where you called `Gosub` from. In the case of wanting to return, then you should call the `[Return](/Latest_API/API_Documentation/Dialplan_Applications/Return)` application.

Here is an example of dialplan we could call with `Gosub` when we don't wish to return.

```
[my-gosub]
exten => s,1,Verbose("Here we are in a subroutine! Let's listen to some weasels")
 same => n,Playback(tt-weasels)

```

Here is an example where we do wish to return.

```
[my-gosub]
exten => s,1,Verbose("Here we are in a subroutine! Let's listen to some weasels")
 same => n,Playback(tt-weasels)
 same => n,Return()

```

Calling Gosub
=============

`Gosub` syntax is simple, you only need to specify the priority, and then optionally the context and extension plus any arguments you wish to use.

```
Gosub([[context,]exten,]priority[(arg1[,...][,argN])])

```

Here is an example within Asterisk dialplan.

```
[somecontext]
exten => 7000,1,Verbose("We are going to run a Gosub before Dialing!")
 same => n,Gosub(my-gosub,s,1)
 same => n,Dial(PJSIP/ALICE)

```

Here we are calling the `my-gosub` context at extension `s` , priority `1`.

Calling Gosub with arguments
============================

If you want to pass information into your `Gosub` routine then you need to use arguments.

Here is how we call `Gosub` with an argument. We are substituting the `EXTEN` channel variable for the first argument field (`ARG1`).

```
[somecontext]
exten => 7000,1,Verbose("We are going to run a Gosub before Dialing!")
 same => n,Gosub(my-gosub,s,1(${EXTEN}))
 same => n,Dial(PJSIP/ALICE)

```

Below we make use of `ARG1` in the `Verbose` message we print during the subroutine execution.

```
[my-gosub]
exten => s,1,Verbose("Here we are in a subroutine! This subroutine was called from extension ${ARG1}")
 same => n,Playback(tt-weasels)
 same => n,Return()

```

To use multiple arguments, simply separate them via commas when defining them in the `Gosub` call. Then within the `Gosub` reference them as `ARG1`, `ARG2`, `ARG3`, etc.
