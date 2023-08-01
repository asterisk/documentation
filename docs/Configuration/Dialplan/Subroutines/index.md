---
title: Overview
pageid: 28314892
---

Subroutines in Asterisk are defined similarly to standard dialplan [contexts](/Configuration/Dialplan/Contexts-Extensions-and-Priorities) and are referred to as [Macro](/Configuration/Dialplan/Subroutines/Macros)s and [Gosubs](/Configuration/Dialplan/Subroutines/Gosub./_AGI_Commands/gosub./_Dialplan_Applications/Gosub). They are invoked via the Macro and Gosub applications, but may also be invoked in the context of [Pre-Dial Handlers](/Configuration/Dialplan/Subroutines/Pre-Dial-Handlers), [Pre-Bridge Handlers](/Configuration/Dialplan/Subroutines/Pre-Bridge-Handlers) and [Hangup Handlers](/Configuration/Dialplan/Subroutines/Hangup-Handlers) via the use of flags and arguments within other applications.

