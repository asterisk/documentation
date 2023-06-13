---
title: Party ID Interception Macros and Routines
pageid: 31097220
---

Interception routines
=====================

interception\_routines

As Interception routines are implemented internally using the Gosub application, all routines should end with an explicit call to the Return application.

The interception routines give the administrator an opportunity to alter connected line and redirecting information before the channel driver is given the information. If the routine does not change a value then that is what is going to be passed to the channel driver.

The tag string available in CALLERID, CONNECTEDLINE, and REDIRECTING is useful for the interception routines to provide some information about where the information originally came from.

The 'i' option of the CONNECTEDLINE dialplan function should always be used in the CONNECTED\_LINE interception routines. The interception routine always passes the connected line information on to the channel driver when the routine returns. Similarly, the 'i' option of the REDIRECTING dialplan function should always be used in the REDIRECTING interception routines.

Note that Interception routines do not attempt to draw a distinction between caller/callee. As it turned out, it was not a good thing to distinguish since transfers make a mockery of caller/callee.

* ${REDIRECTING\_SEND\_SUB}  
 Subroutine to call before sending a redirecting update to the party.
* ${REDIRECTING\_SEND\_SUB\_ARGS}  
 Arguments to pass to ${REDIRECTING\_CALLEE\_SEND\_SUB}.
* ${CONNECTED\_LINE\_SEND\_SUB}  
 Subroutine to call before sending a connected line update to the party.
* ${CONNECTED\_LINE\_SEND\_SUB\_ARGS}  
 Arguments to pass to ${CONNECTED\_LINE\_SEND\_SUB}.

Interception macros
===================

WARNINGInterception macros have been deprecated in Asterisk 11 due to deprecation of Macro. Users of the interception functionality should plan to migrate to Interception routines.

The interception macros give the administrator an opportunity to alter connected line and redirecting information before the channel driver is given the information. If the macro does not change a value then that is what is going to be passed to the channel driver.

The tag string available in CALLERID, CONNECTEDLINE, and REDIRECTING is useful for the interception macros to provide some information about where the information originally came from.

The 'i' option of the CONNECTEDLINE dialplan function should always be used in the CONNECTED\_LINE interception macros. The interception macro always passes the connected line information on to the channel driver when the macro exits. Similarly, the 'i' option of the REDIRECTING dialplan function should always be used in the REDIRECTING interception macros.

* ${REDIRECTING\_CALLEE\_SEND\_MACRO}  
 Macro to call before sending a redirecting update to the callee. This macro may never be needed since the redirecting updates should only go from the callee to the caller direction. It is available for completeness.
* ${REDIRECTING\_CALLEE\_SEND\_MACRO\_ARGS}  
 Arguments to pass to ${REDIRECTING\_CALLEE\_SEND\_MACRO}.
* ${REDIRECTING\_CALLER\_SEND\_MACRO}  
 Macro to call before sending a redirecting update to the caller.
* ${REDIRECTING\_CALLER\_SEND\_MACRO\_ARGS}  
 Arguments to pass to ${REDIRECTING\_CALLER\_SEND\_MACRO}.
* ${CONNECTED\_LINE\_CALLEE\_SEND\_MACRO}  
 Macro to call before sending a connected line update to the callee.
* ${CONNECTED\_LINE\_CALLEE\_SEND\_MACRO\_ARGS}  
 Arguments to pass to ${CONNECTED\_LINE\_CALLEE\_SEND\_MACRO}.
* ${CONNECTED\_LINE\_CALLER\_SEND\_MACRO}  
 Macro to call before sending a connected line update to the caller.
* ${CONNECTED\_LINE\_CALLER\_SEND\_MACRO\_ARGS}  
 Arguments to pass to ${CONNECTED\_LINE\_CALLER\_SEND\_MACRO}.
