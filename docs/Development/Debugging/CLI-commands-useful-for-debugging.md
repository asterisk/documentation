---
title: CLI commands useful for debugging
pageid: 22087961
---

Example output on this page is from Asterisk 11.

### core show locks

Warning!Compiling with DEBUG\_THREADS can reduce the performance of Asterisk. Primarily in terms of CPU consumption.

This command is not available until you compile with DEBUG\_THREADS and it is generally preferred that you also compile with BETTER\_BACKTRACES to get the most useful output.

If compiled with at least DEBUG\_THREADS enabled and if you have glibc, then issuing the "core show locks" CLI command will give lock information output as well as a backtrace of the stack which led to the lock calls.

See the Getting a Backtrace (Asterisk versions < 13.14.0 and 14.3.0) page for an example on why you might use this command.

Examples: (both a lock during a feature code attended transfer)

Example output with DEBUG\_THREADS onlyubuntu\*CLI> core show locks

=======================================================================
=== Currently Held Locks ==============================================
=======================================================================
===
=== <pending> <lock#> (<file>): <lock type> <line num> <function> <lock name> <lock addr> (times locked)
===
=== Thread ID: 0x7f13ea9ed700 (pbx\_thread started at [ 6612] pbx.c ast\_pbx\_start())
=== ---> Lock #0 (features.c): RDLOCK 3304 ast\_rdlock\_call\_features &features\_lock 0x815660 (1)
 asterisk(ast\_bt\_get\_addresses+0xe) [0x4fa57e]
 asterisk(\_\_ast\_rwlock\_rdlock+0xc3) [0x4f7a93]
 asterisk() [0x4c4639]
 asterisk() [0x4c5378]
 asterisk() [0x4c5841]
 asterisk(ast\_bridge\_call+0x8ec) [0x4ced2c]
 /usr/lib/asterisk/modules/app\_dial.so(+0xbe0c) [0x7f13f7d72e0c]
 /usr/lib/asterisk/modules/app\_dial.so(+0xcd96) [0x7f13f7d73d96]
 asterisk(pbx\_exec+0x123) [0x526a53]
 asterisk() [0x531381]
 asterisk() [0x536998]
 asterisk() [0x5381eb]
 asterisk() [0x57a384]
 /lib/x86\_64-linux-gnu/libpthread.so.0(+0x7e9a) [0x7f143ada1e9a]
 /lib/x86\_64-linux-gnu/libc.so.6(clone+0x6d) [0x7f143bed0cbd]
=== -------------------------------------------------------------------
===
=======================================================================
Example output with DEBUG\_THREADS and BETTER\_BACKTRACESubuntu\*CLI> core show locks

=======================================================================
=== Currently Held Locks ==============================================
=======================================================================
===
=== <pending> <lock#> (<file>): <lock type> <line num> <function> <lock name> <lock addr> (times locked)
===
=== Thread ID: 0x7f44b6cda700 (pbx\_thread started at [ 6612] pbx.c ast\_pbx\_start())
=== ---> Lock #0 (features.c): RDLOCK 3304 ast\_rdlock\_call\_features &features\_lock 0x816680 (1)
 main/logger.c:1541 ast\_bt\_get\_addresses() (0x4fa6c0+E)
 main/lock.c:888 \_\_ast\_rwlock\_rdlock() (0x4f7b20+C3)
 main/features.c:3453 builtin\_feature\_get\_exten()
 main/features.c:3598 feature\_interpret\_helper()
 main/features.c:3727 feature\_interpret()
 main/features.c:4676 ast\_bridge\_call() (0x4ce590+8EC)
 apps/app\_dial.c:3045 dial\_exec\_full()
 apps/app\_dial.c:3129 dial\_exec()
 main/pbx.c:1590 pbx\_exec() (0x527270+123)
 main/pbx.c:4665 pbx\_extension\_helper()
 main/pbx.c:6256 \_\_ast\_pbx\_run()
 main/pbx.c:6554 decrease\_call\_count()
 main/utils.c:1093 dummy\_start()
 :0 start\_thread()
 libc.so.6 clone() (0x7f45082eac50+6D)
=== -------------------------------------------------------------------
===
=======================================================================
### core show taskprocessors

List instantiated task processors and statistics

Example command outputubuntu\*CLI> core show taskprocessors

 +----- Processor -----+--- Processed ---+- In Queue -+- Max Depth -+
 app\_queue 8 0 0
 core\_event\_dispatcher 29 0 1
 app\_voicemail 0 0 0
 pbx-core 11 0 0
 ast\_msg\_queue 0 0 0
 CCSS core 0 0 0
 iax2\_transmit 0 0 0
 +---------------------+-----------------+------------+-------------+
 7 taskprocessors
Example command output (Asterisk 13)\*CLI> core show taskprocessors
Processor Processed In Queue Max Depth Low water High water
app\_voicemail 0 0 0 450 500
ast\_msg\_queue 0 0 0 450 500
CCSS\_core 0 0 0 450 500
iax2\_transmit 0 0 0 450 500
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
subp:PJSIP/ast\_trunk-00000023 3 0 1 450 500
subp:PJSIP/ekiga-00000021 3 0 1 450 500
subp:PJSIP/linphone-00000022 3 0 1 450 500
subp:PJSIP/sipp-00000020 3 0 1 450 500
subp:PJSIP/weblooper-00000024 6 0 1 450 500
118 taskprocessors### core show threads

Shows running threads!  Doesn't require any compilation flags to be set.

Example command outputubuntu\*CLI> core show threads
0x7f869a7fb700 25102 netconsole started at [ 1442] asterisk.c listener()
0x7f869a877700 25100 tps\_processing\_function started at [ 471] taskprocessor.c ast\_taskprocessor\_get()
0x7f869a8f3700 25099 do\_monitor started at [ 5743] chan\_unistim.c restart\_monitor()
0x7f869a96f700 25098 tps\_processing\_function started at [ 471] taskprocessor.c ast\_taskprocessor\_get()
0x7f869a9eb700 25097 process\_clearcache started at [ 2267] pbx\_dundi.c start\_network\_thread()
0x7f869aa67700 25096 process\_precache started at [ 2266] pbx\_dundi.c start\_network\_thread()
0x7f869aae3700 25095 network\_thread started at [ 2265] pbx\_dundi.c start\_network\_thread()
0x7f869ab5f700 25094 cleanup started at [ 414] pbx\_realtime.c load\_module()
0x7f869abdb700 25093 lock\_broker started at [ 509] func\_lock.c load\_module()

... <snip>
### core show fd

This command is not available until you compile Asterisk with DEBUG\_FD\_LEAKS (found under compiler flags in menuselect).

Shows file descriptors open by Asterisk.

newtonr-laptop\*CLI> core show fd
Current maxfiles: unlimited
 3 utils.c:2310 (ast\_utils\_init ): open("/dev/urandom",0)
 5 asterisk.c:1626 (ast\_makesocket ): socket(PF\_UNIX,SOCK\_STREAM,"tcp")
 6 logger.c:316 (make\_logchannel ): fopen("/var/log/asterisk/messages","a")
 7 logger.c:316 (make\_logchannel ): fopen("/var/log/asterisk/full","a")
 9 tcptls.c:585 (ast\_tcptls\_server\_start ): socket(PF\_INET,SOCK\_STREAM,"tcp")
 15 netsock.c:120 (ast\_netsock\_bindaddr ): socket(PF\_INET,SOCK\_DGRAM,"udp")
 16 chan\_sip.c:32197 (reload\_config ): socket(PF\_INET,SOCK\_DGRAM,"udp")
 17 chan\_skinny.c:8502 (config\_load ): socket(PF\_INET,SOCK\_STREAM,"tcp")
 21 pbx\_dundi.c:5022 (load\_module ): socket(PF\_INET,SOCK\_DGRAM,"udp")
 22 chan\_unistim.c:6795 (reload\_config ): socket(PF\_INET,SOCK\_DGRAM,"udp")
 23 asterisk.c:4489 (main ): pipe({23,24})
 24 asterisk.c:4489 (main ): pipe({23,24}) 

 

