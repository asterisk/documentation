---
title: Party ID Interception Macros and Routines
pageid: 31097220
---

## Interception routines

!!! note 
    As Interception routines are implemented internally using the [Gosub](/Latest_API/API_Documentation/Dialplan_Applications/Gosub) application, all routines should end with an explicit call to the [Return](/Latest_API/API_Documentation/Dialplan_Applications/Return) application.

[//]: # (end-note)

The interception routines give the administrator an opportunity to alter [connected line and redirecting information](/Configuration/Functions/Manipulating-Party-ID-Information) before the channel driver is given the information. If the routine does not change a value then that is what is going to be passed to the channel driver.

The tag string available in CALLERID, CONNECTEDLINE, and REDIRECTING is useful for the interception routines to provide some information about where the information originally came from.

The 'i' option of the CONNECTEDLINE dialplan function should always be used in the CONNECTED_LINE interception routines. The interception routine always passes the connected line information on to the channel driver when the routine returns. Similarly, the 'i' option of the REDIRECTING dialplan function should always be used in the REDIRECTING interception routines.

!!! info ""
    Note that Interception routines do not attempt to draw a distinction between caller/callee. As it turned out, it was not a good thing to distinguish since transfers make a mockery of caller/callee.

[//]: # (end-info)

* ${REDIRECTING_SEND_SUB}
* ${REDIRECTING_SEND_SUB_ARGS}
* ${CONNECTED_LINE_SEND_SUB}  
 Subroutine to call before sending a connected line update to the party.
* ${CONNECTED_LINE_SEND_SUB_ARGS}  
 Arguments to pass to ${CONNECTED_LINE_SEND_SUB}.

## Interception macros

!!! warning WARNING
    Interception macros have been deprecated in Asterisk 11 due to deprecation of [Macro](/Latest_API/API_Documentation/Dialplan_Applications/Macro). Users of the interception functionality should plan to migrate to [Interception routines](#interception-routines).

[//]: # (end-warning)

The interception macros give the administrator an opportunity to alter [connected line and redirecting information](/Configuration/Functions/Manipulating-Party-ID-Information) before the channel driver is given the information. If the macro does not change a value then that is what is going to be passed to the channel driver.

The tag string available in CALLERID, CONNECTEDLINE, and REDIRECTING is useful for the interception macros to provide some information about where the information originally came from.

The 'i' option of the CONNECTEDLINE dialplan function should always be used in the CONNECTED_LINE interception macros. The interception macro always passes the connected line information on to the channel driver when the macro exits. Similarly, the 'i' option of the REDIRECTING dialplan function should always be used in the REDIRECTING interception macros.

* ${REDIRECTING_CALLEE_SEND_MACRO}
* ${REDIRECTING_CALLEE_SEND_MACRO_ARGS}
* ${REDIRECTING_CALLER_SEND_MACRO}  
 Macro to call before sending a redirecting update to the caller.
* ${REDIRECTING_CALLER_SEND_MACRO_ARGS}  
 Arguments to pass to ${REDIRECTING_CALLER_SEND_MACRO}.
* ${CONNECTED_LINE_CALLEE_SEND_MACRO}  
 Macro to call before sending a connected line update to the callee.
* ${CONNECTED_LINE_CALLEE_SEND_MACRO_ARGS}  
 Arguments to pass to ${CONNECTED_LINE_CALLEE_SEND_MACRO}.
* ${CONNECTED_LINE_CALLER_SEND_MACRO}  
 Macro to call before sending a connected line update to the caller.
* ${CONNECTED_LINE_CALLER_SEND_MACRO_ARGS}  
 Arguments to pass to ${CONNECTED_LINE_CALLER_SEND_MACRO}.
