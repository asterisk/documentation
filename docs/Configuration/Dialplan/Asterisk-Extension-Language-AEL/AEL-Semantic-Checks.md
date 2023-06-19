---
title: AEL Semantic Checks
pageid: 4816911
---

AEL, after parsing, but before compiling, traverses the dialplan tree, and makes several checks:


* Macro calls to non-existent macros.
* Macro calls to contexts.
* Macro calls with argument count not matching the definition.
* application call to macro. (missing the '&')
* application calls to "GotoIf", "GotoIfTime", "while", "endwhile", "Random", and "execIf", will generate a message to consider converting the call to AEL goto, while, etc. constructs.
* goto a label in an empty extension.
* goto a non-existent label, either a within-extension, within-context, or in a different context, or in any included contexts. Will even check "sister" context references.
* All the checks done on the time values in the dial plan, are done on the time values in the ifTime() and includes times: o the time range has to have two times separated by a dash; o the times have to be in range of 0 to 24 hours. o The weekdays have to match the internal list, if they are provided; o the day of the month, if provided, must be in range of 1 to 31; o the month name or names have to match those in the internal list.
* (0.5) If an expression is wrapped in $[ ... ], and the compiler will wrap it again, a warning is issued.
* (0.5) If an expression had operators (you know, +,-,,/,issued. Maybe someone forgot to wrap a variable name?\*
* (0.12) check for duplicate context names.
* (0.12) check for abstract contexts that are not included by any context.
* (0.13) Issue a warning if a label is a numeric value.


There are a subset of checks that have been removed until the proposed AAL (Asterisk Argument Language) is developed and incorporated into Asterisk. These checks will be:


* (if the application argument analyzer is working: the presence of the 'j' option is reported as error.
* if options are specified, that are not available in an application.
* if you specify too many arguments to an application.
* a required argument is not present in an application call.
* Switch-case using "known" variables that applications set, that does not cover all the possible values. (a "default" case will solve this problem. Each "unhandled" value is listed.
* a Switch construct is used, which is uses a known variable, and the application that would set that variable is not called in the same extension. This is a warning only...
* Calls to applications not in the "applist" database (installed in /var/lib/asterisk/applist" on most systems).
* In an assignment statement, if the assignment is to a function, the function name used is checked to see if it one of the currently known functions. A warning is issued if it is not.


