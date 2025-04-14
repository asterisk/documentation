---
title: CLI commands useful for debugging
pageid: 22087961
---

Example output on this page is from Asterisk 11.

### core show locks

!!! warning Warning!
    Compiling with DEBUG_THREADS can reduce the performance of Asterisk. Primarily in terms of CPU consumption.

[//]: # (end-warning)

This command is not available until you compile with [DEBUG_THREADS](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) and it is generally preferred that you also compile with [BETTER_BACKTRACES](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) to get the most useful output.

If compiled with at least DEBUG_THREADS enabled and if you have glibc, then issuing the "core show locks" CLI command will give lock information output as well as a backtrace of the stack which led to the lock calls.

See the [Getting a Backtrace (Asterisk versions < 13.14.0 and 14.3.0)](/Development/Debugging/Getting-a-Backtrace-Asterisk-versions-13.14.0-and-14.3.0) page for an example on why you might use this command.

Examples: (both a lock during a feature code attended transfer)

Example output with DEBUG_THREADS only

```
ubuntu*CLI> core show locks

=======================================================================
=== Currently Held Locks ==============================================
=======================================================================
===
=== <pending> <lock#> (<file>): <lock type> <line num> <function> <lock name> <lock addr> (times locked)
===
=== Thread ID: 0x7f13ea9ed700 (pbx_thread started at [ 6612] pbx.c ast_pbx_start())
=== ---> Lock #0 (features.c): RDLOCK 3304 ast_rdlock_call_features &features_lock 0x815660 (1)
 asterisk(ast_bt_get_addresses+0xe) [0x4fa57e]
 asterisk(__ast_rwlock_rdlock+0xc3) [0x4f7a93]
 asterisk() [0x4c4639]
 asterisk() [0x4c5378]
 asterisk() [0x4c5841]
 asterisk(ast_bridge_call+0x8ec) [0x4ced2c]
 /usr/lib/asterisk/modules/app_dial.so(+0xbe0c) [0x7f13f7d72e0c]
 /usr/lib/asterisk/modules/app_dial.so(+0xcd96) [0x7f13f7d73d96]
 asterisk(pbx_exec+0x123) [0x526a53]
 asterisk() [0x531381]
 asterisk() [0x536998]
 asterisk() [0x5381eb]
 asterisk() [0x57a384]
 /lib/x86_64-linux-gnu/libpthread.so.0(+0x7e9a) [0x7f143ada1e9a]
 /lib/x86_64-linux-gnu/libc.so.6(clone+0x6d) [0x7f143bed0cbd]
=== -------------------------------------------------------------------
===
=======================================================================

```

Example output with DEBUG_THREADS and BETTER_BACKTRACES

```
ubuntu*CLI> core show locks

=======================================================================
=== Currently Held Locks ==============================================
=======================================================================
===
=== <pending> <lock#> (<file>): <lock type> <line num> <function> <lock name> <lock addr> (times locked)
===
=== Thread ID: 0x7f44b6cda700 (pbx_thread started at [ 6612] pbx.c ast_pbx_start())
=== ---> Lock #0 (features.c): RDLOCK 3304 ast_rdlock_call_features &features_lock 0x816680 (1)
 main/logger.c:1541 ast_bt_get_addresses() (0x4fa6c0+E)
 main/lock.c:888 __ast_rwlock_rdlock() (0x4f7b20+C3)
 main/features.c:3453 builtin_feature_get_exten()
 main/features.c:3598 feature_interpret_helper()
 main/features.c:3727 feature_interpret()
 main/features.c:4676 ast_bridge_call() (0x4ce590+8EC)
 apps/app_dial.c:3045 dial_exec_full()
 apps/app_dial.c:3129 dial_exec()
 main/pbx.c:1590 pbx_exec() (0x527270+123)
 main/pbx.c:4665 pbx_extension_helper()
 main/pbx.c:6256 __ast_pbx_run()
 main/pbx.c:6554 decrease_call_count()
 main/utils.c:1093 dummy_start()
 :0 start_thread()
 libc.so.6 clone() (0x7f45082eac50+6D)
=== -------------------------------------------------------------------
===
=======================================================================

```

### core show taskprocessors

List instantiated task processors and statistics

Example command output

```
ubuntu*CLI> core show taskprocessors

 +----- Processor -----+--- Processed ---+- In Queue -+- Max Depth -+
 app_queue 8 0 0
 core_event_dispatcher 29 0 1
 app_voicemail 0 0 0
 pbx-core 11 0 0
 ast_msg_queue 0 0 0
 CCSS core 0 0 0
 iax2_transmit 0 0 0
 +---------------------+-----------------+------------+-------------+
 7 taskprocessors

```

Example command output (Asterisk 13)

```
*CLI> core show taskprocessors
Processor Processed In Queue Max Depth Low water High water
app_voicemail 0 0 0 450 500
ast_msg_queue 0 0 0 450 500
CCSS_core 0 0 0 450 500
iax2_transmit 0 0 0 450 500
pjsip/default-0000000a 4 0 1 450 500
pjsip/default-0000000b 3 0 1 450 500
pjsip/default-0000000c 3 0 1 450 500
pjsip/default-0000000d 3 0 1 450 500
pjsip/default-0000000e 3 0 1 450 500
pjsip/default-0000000f 3 0 1 450 500
pjsip/default-00000010 3 0 1 450 500
pjsip/default-00000011 3 0 1 450 500
pjsip/distributor-00000025 0 0 0 450 500
pjsip/distributor-00000026 0 0 0 450 500
pjsip/distributor-00000027 0 0 0 450 500
pjsip/distributor-00000028 0 0 0 450 500
pjsip/distributor-00000029 0 0 0 450 500
...
subp:PJSIP/203-0000001f 3 0 1 450 500
subp:PJSIP/ast_trunk-00000023 3 0 1 450 500
subp:PJSIP/ekiga-00000021 3 0 1 450 500
subp:PJSIP/linphone-00000022 3 0 1 450 500
subp:PJSIP/sipp-00000020 3 0 1 450 500
subp:PJSIP/weblooper-00000024 6 0 1 450 500
118 taskprocessors

```

### core show threads

Shows running threads!  Doesn't require any compilation flags to be set.

Example command output

```
ubuntu*CLI> core show threads
0x7f869a7fb700 25102 netconsole started at [ 1442] asterisk.c listener()
0x7f869a877700 25100 tps_processing_function started at [ 471] taskprocessor.c ast_taskprocessor_get()
0x7f869a8f3700 25099 do_monitor started at [ 5743] chan_unistim.c restart_monitor()
0x7f869a96f700 25098 tps_processing_function started at [ 471] taskprocessor.c ast_taskprocessor_get()
0x7f869a9eb700 25097 process_clearcache started at [ 2267] pbx_dundi.c start_network_thread()
0x7f869aa67700 25096 process_precache started at [ 2266] pbx_dundi.c start_network_thread()
0x7f869aae3700 25095 network_thread started at [ 2265] pbx_dundi.c start_network_thread()
0x7f869ab5f700 25094 cleanup started at [ 414] pbx_realtime.c load_module()
0x7f869abdb700 25093 lock_broker started at [ 509] func_lock.c load_module()

... <snip>

```

### core show fd

This command is not available until you compile Asterisk with [DEBUG_FD_LEAKS](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) (found under compiler flags in menuselect).

Shows file descriptors open by Asterisk.

```
newtonr-laptop*CLI> core show fd
Current maxfiles: unlimited
 3 utils.c:2310 (ast_utils_init ): open("/dev/urandom",0)
 5 asterisk.c:1626 (ast_makesocket ): socket(PF_UNIX,SOCK_STREAM,"tcp")
 6 logger.c:316 (make_logchannel ): fopen("/var/log/asterisk/messages","a")
 7 logger.c:316 (make_logchannel ): fopen("/var/log/asterisk/full","a")
 9 tcptls.c:585 (ast_tcptls_server_start ): socket(PF_INET,SOCK_STREAM,"tcp")
 15 netsock.c:120 (ast_netsock_bindaddr ): socket(PF_INET,SOCK_DGRAM,"udp")
 16 chan_sip.c:32197 (reload_config ): socket(PF_INET,SOCK_DGRAM,"udp")
 17 chan_skinny.c:8502 (config_load ): socket(PF_INET,SOCK_STREAM,"tcp")
 21 pbx_dundi.c:5022 (load_module ): socket(PF_INET,SOCK_DGRAM,"udp")
 22 chan_unistim.c:6795 (reload_config ): socket(PF_INET,SOCK_DGRAM,"udp")
 23 asterisk.c:4489 (main ): pipe({23,24})
 24 asterisk.c:4489 (main ): pipe({23,24})

```
