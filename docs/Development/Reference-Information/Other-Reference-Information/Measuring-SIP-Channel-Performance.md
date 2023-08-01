---
title: Measuring SIP Channel Performance
pageid: 4259980
---

Measuring the SIP channel driver's Performance
==============================================


This file documents the methods I used to measure the performance of the SIP channel driver, in terms of maximum simultaneous calls and how quickly it could handle incoming calls.


Knowing these limitations can be valuable to those implementing PBX's in 'large' environments. Will your installation handle expected call volume?


Quoting these numbers can be totally useless for other installations. Minor changes like the amount of RAM in a system, the speed of the ethernet, the amount of cache in the CPU, the CPU clock speed, whether or not you log CDR's, etc. can affect the numbers greatly.


In my set up, I had a dedicated test machine running Asterisk, and another machine which ran sipp, connected together with  

ethernet.


The version of sipp that I used was sipp-2.0.1; however, I have reason to believe that other versions would work just as well.


On the asterisk machine, I included the following in my extensions.ael file:

```

context test11
{
 s => {
 Answer();
 while (1) {
 Background(demo-instruct);
 }
 Hangup();
 }
 _X. => {
 Answer();
 while (1) {
 Background(demo-instruct);
 }
 Hangup();
 }
}

```

Basically, incoming SIP calls are answered, and the demo-instruct sound file is played endlessly to the caller. This test depends on the calling party to hang up, thus allowing sipp to determine the length of a call.


The sip.conf file has this entry:

```

[asterisk02]
type=friend
context=test11
host=192.168.134.240 ;; the address of the host you will be running sipp on
user=sipp
directmedia=no
disallow=all
allow=ulaw

```

Note that it's pretty simplistic; no authentication beyond the host ip, and it uses ulaw, which is pretty efficient, low-cpu-intensive codec.


To measure the impact of incoming call traffic on the Asterisk machine, I run vmstat. It gives me an idea of the cpu usage by Asterisk. The most common failure mode of Asterisk at high call volumes, is that the CPU reaches 100% utilization, and then cannot keep up with the workload, resulting in timeouts and other failures, which swiftly compound and cascade, until gross failure ensues. Watch the CPU Idle % numbers.


I learned to split the testing into two modes: one for just call call processing power, in the which we had relatively few simultaneous calls in place, and another where we allow the the number of simultaneous calls to quickly reach a set maximum, and then rerun sipp, looking for the maximum.


Call processing power is measured with extremely short duration calls:

```

 ./sipp -sn uac 192.168.134.252 -s 12 -d 100 -l 256

```

The above tells sipp to call your asterisk test machine (192.168.134.252) at extension 12, each call lasts just .1 second, with a limit of 256 simultaneous calls. The simultaneous calls will be the rate/sec of incoming calls times the call length, so 1 simultaneous call at 10 calls/sec, and 45 at 450 calls/sec. Setting the limit to 256 implies you do not intend to test above 2560 calls/sec.


Sipp starts at 10 calls/sec, and you can slowly increase the speed by hitting '\*' or '+'. Watch your cpu utilization on the asterisk server. When you approach 100%, you have found your limit.


Simultaneous calls can be measured with very long duration calls:

```

./sipp -sn uac 192.168.134.252 -s 12 -d 100000 -l 270

```

This will place 100 sec duration calls to Asterisk. The number of simultaneous calls will increase until the maximum of 270 is reached. If Asterisk survives this number and is not at 100% cpu utilization, you can stop sipp and run it again with a higher -l argument.


By changing one Asterisk parameter at a time, you can get a feel for how much that change will affect performance. 

