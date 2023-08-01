---
title: Reference Count Debugging
pageid: 21463329
---





Overview
========

Asterisk makes extensive use of reference counted objects using the `astobj2` API. In certain classes of bugs, the reference count for an object may get erroneously increased - leading to an object never getting reclaimed when its lifetime has ended - or decreased - leading (in the best case) to `ERROR` messages being reported that a bad magic number has been detected or (in the worse case) invalid memory deallocation. Autodestruct warnings are another case that typically indicate a reference to a channel is still hanging around, preventing its destruction.

Below is an example 'bad magic number' log message:

```
astobj2.c: bad magic number for object 0xfb5230. Object is likely destroyed

```



In such cases, its often very useful to determine what in Asterisk manipulated the reference count on the object. The `astobj2` API supports creating a reference count log for all objects managed by the API.

In all cases, when providing the **refs** file to Asterisk developers for debugging purposes you should also be providing them with instructional steps, including configuration, that allows them to reproduce the issue consistently. See the [Asterisk Issue Guidelines](/Asterisk-Community/Asterisk-Issue-Guidelines) for more details on submitting an issue.




!!! note 
    These instructions apply to Asterisk versions 11.10.0, 13.0.0 or greater.

      
[//]: # (end-note)



Enabling Reference Count Logs in Asterisk 14+
=============================================

1. Set **refdebug=yes** in **asterisk.conf**.
2. Restart Asterisk.
3. Reproduce the issue for which you need reference count debug.
4. Shutdown Asterisk using **asterisk -rx 'core stop gracefully'**.  Other methods of shutdown produce hundreds or thousands of false positives.
5. **Run  */var/lib/asterisk/scripts/refcounter.py -f /var/log/asterisk/refs -n > /tmp/refs.txt****
6. Provide bug marshals with the /tmp/refs.txt file. That is, attach the **refs.txt** file to your JIRA issue.
7. Make a copy of /var/log/asterisk/refs so you have it if more information is needed.

Enabling Reference Count Logs
=============================

1. Enable **REF_DEBUG** under Compiler Flags in [menuselect](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options).
2. [Recompile](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source).
3. [Re-install Asterisk](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source).
4. Reproduce the issue for which you need reference count debug.
5. Shutdown Asterisk using **asterisk -rx 'core stop gracefully'**.  Other methods of shutdown produce hundreds or thousands of false positives.
6. **Run  */var/lib/asterisk/scripts/refcounter.py -f /var/log/asterisk/refs -n > /tmp/refs.txt****
7. Provide bug marshals with the /tmp/refs.txt file. That is, attach the **refs.txt** file to your JIRA issue.
8. Make a copy of /var/log/asterisk/refs so you have it if more information is needed.

Note /var/log/asterisk/refs is overwritten on each run of Asterisk.

On This PageUsing refcounter.py to process refs log
=======================================

Bug marshals can use the refcounter.py script to process and spot issues in a refs log when performing analysis.

refcounter.py can be found in  */var/lib/asterisk/scripts/** in the current versions of Asterisk.  For older versions you will find it in the Asterisk source directory **contrib/scripts/**.  Always use the '-n' option unless otherwise requested, without it the output is larger than the limit for JIRA attachments.

refcounter.py is only installed to /var/lib/asterisk/scripts/ in versions 11.14.0, 13.1.0 or higher.  It is also available from the Asterisk source contrib/scripts/refcounter.py.  The log can produce large amounts of data,

```
Usage: refcounter.py [options]
Options:
 -h, --help show this help message and exit
 -f FILEPATH, --file=FILEPATH
 The full path to the refs file to process
 -i, --suppress-invalid
 If specified, don't output invalid object references
 -l, --suppress-leaks If specified, don't output leaked objects
 -n, --suppress-normal
 If specified, don't output objects with a complete
 lifetime
 -s, --suppress-skewed
 If specified, don't output objects with a skewed
 lifetime

```



Interpreting a Raw Reference Count Log
======================================

Each change in the reference count value of an `ao2` object will generate one line of output in `/var/log/asterisk/refs`. This will look something like the following:

```
...
0x7f9dbc002048,+1,19256,chan_sip.c,8651,sip_alloc,\*\*constructor\*\*,allocate a dialog(pvt) struct
0x7f9dbc002048,+1,19256,chan_sip.c,8795,sip_alloc,1,link pvt into dialogs table
0x7f9dbc002048,+1,19256,chan_sip.c,4186,__sip_reliable_xmit,2,__sip_reliable_xmit: setting pkt->owner
0x7f9dbc002048,+1,19256,chan_sip.c,4352,sip_scheddestroy,3,setting ref as passing into ast_sched_add for __sip_autodestruct
0x7f9dbc002048,-1,19256,chan_sip.c,28226,handle_request_do,4,throw away dialog ptr from find_call at end of routine
0x7f9dbc002048,+1,19256,chan_sip.c,9248,find_call,3,pedantic ao2_find in dialogs
0x7f9dbc002048,-1,19256,chan_sip.c,4430,__sip_ack,4,unref pkt cur->owner dialog from sip ack before freeing pkt
0x7f9dbc002048,+1,19256,chan_sip.c,3373,pvt_set_needdestroy,3,link pvt into dialogs_needdestroy container
0x7f9dbc002048,-1,19256,chan_sip.c,28226,handle_request_do,4,throw away dialog ptr from find_call at end of routine
0x7f9dbc002048,+1,19256,chan_sip.c,3284,dialog_unlink_all,3,Let's bump the count in the unlink so it doesn't accidentally become dead before we are done
0x7f9dbc002048,-1,19256,chan_sip.c,3286,dialog_unlink_all,4,unlinking dialog via ao2_unlink
0x7f9dbc002048,-1,19256,chan_sip.c,3287,dialog_unlink_all,3,unlinking dialog_needdestroy via ao2_unlink
0x7f9dbc002048,-1,19256,chan_sip.c,3335,dialog_unlink_all,2,when you delete the autokillid sched, you should dec the refcount for the stored dialog ptr
0x7f9dbc002048,-1,19256,chan_sip.c,3352,dialog_unlink_all,\*\*destructor\*\*,Let's unbump the count in the unlink so the poor pvt can disappear if it is time
...

```

* The first column is the object address.
* The second column is the change to the reference count.
* The third column specifies what thread made the reference change.
* The forth, fifth and sixth columns specify the file, line and function that made the change.
* The seventh column specifies how many references existed before this change
* The final column is a text description of the reason for the reference.
