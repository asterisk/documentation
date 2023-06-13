---
title: Special Dialplan Extensions
pageid: 28314883
---

Special Asterisk Dialplan Extensions
====================================

Here we'll list all of the special built-in dialplan extensions and their usage.

Other than special extensions, there is a special context "default" that is used when either a) an extension context is deleted while an extension is in use, or b) a specific starting extension handler has not been defined (unless overridden by the low level channel interface).

a: Assistant extension
----------------------

This extension is similar to the **o** extension, only it gets triggered when the caller presses the asterisk (\*) key while recording a voice mail message. This is typically used to reach an assistant.

e: Exception Catchall extension
-------------------------------

This extension will substitute as a catchall for any of the 'i', 't', or 'T' extensions, if any of them do not exist and catching the error in a single routine is desired. The function EXCEPTION may be used to query the type of exception or the location where it occurred.

h: Hangup extension
-------------------

When a call is hung up, Asterisk executes the **h** extension in the current context. This is typically used for some sort of clean-up after a call has been completed.

i: Invalid entry extension
--------------------------

If Asterisk can't find an extension in the current context that matches the digits dialed during the **Background()** or **WaitExten()** applications, it will send the call to the **i** extension. You can then handle the call however you see fit.

o: Operator extension
---------------------

If a caller presses the zero key on their phone keypad while recording a voice mail message, and the **o** extension exists, the caller will be redirected to the o extension. This is typically used so that the caller can press zero to reach an operator.

s: Start extension
------------------

When an analog call comes into Asterisk, the call is sent to the **s** extension. The s extension is also used in macros.

Please note that the **s** extension is **not** a catch-all extension. It's simply the location that analog calls and macros begin. In our example above, it simply makes a convenient extension to use that can't be easily dialed from the **Background()** and **WaitExten()** applications.

t: Response timeout extension
-----------------------------

When the caller waits too long before entering a response to the **Background()** or **WaitExten()** applications, and there are no more priorities in the current extension, the call is sent to the t extension.

T: Absolute timeout extension
-----------------------------

This is the extension that is executed when the 'absolute' timeout is reached. See "core show function TIMEOUT" for more information on setting timeouts.

 

