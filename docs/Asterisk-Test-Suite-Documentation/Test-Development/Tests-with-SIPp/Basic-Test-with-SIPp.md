---
title: Basic Test with SIPp
pageid: 20185291
---

Introduction
------------


When are you writing a "Basic" test with SIPp?


* When you only want to execute a SIPp scenario, and do not need any information from Asterisk itself to determine the pass/fail status of the test.
* When you have large numbers of related SIPp scenarios that do not need information from Asterisk.


Lets assume we would like to test a nominal SIP REGISTER request. A very simple SIPp scenario can be used for this purpose. Note that this only tests that Asterisk can receive a REGISTER request and reply back with a "200 OK" response, not whether or not Asterisk has created a SIP peer internally or performed any decisions based on the receiving of the REGISTER request.


SIPp Scenario
-------------



<?xml version="1.0" encoding="ISO-8859-1" ?>
<scenario name="UAC Register">

 <send retrans="500">
 <![CDATA[

 REGISTER sip:v4-in@[remote\_ip]:[remote\_port] SIP/2.0
 Via: SIP/2.0/[transport] [local\_ip]:[local\_port];branch=[branch]
 From: v4-in <sip:v4-in@[local\_ip]:[local\_port]>;tag=[pid]SIPpTag00[call\_number]
 To: <sip:v4-in@[remote\_ip]:[remote\_port]>
 Call-ID: [call\_id]
 CSeq: 1 REGISTER
 Contact: sip:v4-in@[local\_ip]:[local\_port]
 Max-Forwards: 70
 Subject: REGISTER Test
 Expires: 3600
 Content-Length: 0

 ]]>
 </send>

 <recv response="200" rtd="true" />
</scenario>

Asterisk Configuration
----------------------


Since the SIPp scenario is attempting a REGISTER request for v4-in, we must have a corresponding sip.conf configuration file defining the peer.



[general]
bindaddr=[::]:5060

[v4-in]
type=friend
host=dynamic

Asterisk Test Suite run-test
----------------------------


The Asterisk Test Suite provides a class, SIPpTest, that inherits from TestCase and will automatically run a set of SIPp scenarios. The class looks for the scenarios in the 'sipp' folder and will execute the scenarios in parallel on a single instance of Asterisk. The results of the test are directly related to the success/failure of the SIPp scenario - if all scenarios pass, the test passes; if any scenario fails, the test fails. Creating a *run-test* script that executes a SIPp scenario is thus exceedingly simple.



#!/usr/bin/env python

import sys
import os

sys.path.append("lib/python")

from twisted.internet import reactor
from asterisk.sipp import SIPpTest

WORKING\_DIR = "channels/SIP/sip\_register"
TEST\_DIR = os.path.dirname(os.path.realpath(\_\_file\_\_))

SIPP\_SCENARIOS = [
 {
 'scenario' : 'registerv4.xml'
 },
]


def main():
 test = SIPpTest(WORKING\_DIR, TEST\_DIR, SIPP\_SCENARIOS)
 reactor.run()
 if not test.passed:
 return 1

 return 0


if \_\_name\_\_ == "\_\_main\_\_":
 sys.exit(main())


Any number of scenarios can be passed to the SIPpTest. The class takes in as its third parameter a list of dictionaries, where each dictionary specifies a scenario to execute.


