---
title: Pluggable Component Framework
pageid: 20185570
---

Motivation
==========

At its heart, the Asterisk Test Suite is a way of executing programs that test functionality in Asterisk. Historically, the Test Suite has implemented these tests in a variety of languages - Lua, bash, Python - but there is no hard rule that limits what is supported. If your implementation supports having an executable file named *run-test*, then it is acceptable by the Test Suite.

There are some problems that arise with this level of flexibility. Tests often have to do many of the same tasks: start and stop Asterisk, connect over AMI and originate calls, run AGI scripts, gather and report results, etc. For each language chosen, sets of libraries have grown to support these common activities. This has resulted in duplication of functionality between libraries written in different languages. Over time, some libraries have also received more attention than others as well, resulting in functionality that is only available in a particular language.

In the current state of the Asterisk Test Suite, we've focused our efforts on writing our tests in Python. There is no strict enforcement of this, but since we have developed a number of libraries to support test execution - and continue to expand and enhance those libraries - you may get more "bang for your buck" by writing tests in Python as well.

All of that said, even when a single implementation language is chosen, there is still a fair amount of repeated code throughout the Test Suite. Because tests support their own execution, they often have to implement similar mechanisms. Each test must have its own execution entry point, instantiate its own objects, do the minimum amount needed to get Asterisk running, etc. Between tests that cover similar functionality, there is even more repeated code. Moving shared code into libraries helps alleviate that to some extent, but even then some amount of duplication occurs.

!!! tip 
    For a list of all pluggable test objects and modules in the Test Suite, see the sample YAML files:

    <http://svn.asterisk.org/svn/testsuite/asterisk/trunk/sample-yaml/>

[//]: # (end-tip)

An Example - Two Traditional Tests Using SIPp
=============================================

As an example, consider two tests written in Python that run SIPp scenarios - **message_auth** and **message_disabled**.

##### message_auth

```bash title=" " linenums="1"
#!/usr/bin/env python
'''
Copyright (C) 2010, Digium, Inc.
Russell Bryant <russell@digium.com>

This program is free software, distributed under the terms of
the GNU General Public License Version 2.
'''

import sys
import os

sys.path.append("lib/python")

from twisted.internet import reactor
from asterisk.sipp import SIPpTest

WORKING_DIR = "sip/message_auth"
TEST_DIR = os.path.dirname(os.path.realpath(__file__))

SIPP_SCENARIOS = [
 {
 'scenario' : 'message_recv.xml',
 '-p' : '5062'
 },
 {
 'scenario' : 'message.xml',
 '-p' : '5061'
 }
]

def main():
 test = SIPpTest(WORKING_DIR, TEST_DIR, SIPP_SCENARIOS)
 reactor.run()
 if not test.passed:
 return 1

 return 0

if __name__ == "__main__":
 sys.exit(main())

```

##### message_disabled

```bash title=" " linenums="1"
#!/usr/bin/env python
'''
Copyright (C) 2010, Digium, Inc.
Russell Bryant <russell@digium.com>

This program is free software, distributed under the terms of
the GNU General Public License Version 2.
'''

import sys
import os

sys.path.append("lib/python")

from twisted.internet import reactor
from asterisk.sipp import SIPpTest

WORKING_DIR = "sip/message_disabled"
TEST_DIR = os.path.dirname(os.path.realpath(__file__))

SIPP_SCENARIOS = [
 {
 'scenario' : 'message.xml',
 }
]

def main():
 test = SIPpTest(WORKING_DIR, TEST_DIR, SIPP_SCENARIOS)
 reactor.run()
 if not test.passed:
 return 1

 return 0

if __name__ == "__main__":
 sys.exit(main())

```

Both of these are very straight-forward tests that simply execute their SIPp scenarios and base their pass/fail status on the result of those scenarios. Even still, there is repeated code:

* Duplicate entry points for execution
* Manipulation of the [twisted](http://twistedmatrix.com/trac/) reactor
* Instantiation of the test object, and reading of its result

In fact, if we look at what is unique, it consists only of the SIPp scenarios to run and the parameters passed to SIPp. Even the working and test directories can be inferred by higher level entities, or specified via configuration. If the only differences between tests can be expressed by configuration, why not do that?

A Pluggable Framework Implementation
====================================

These observations led to the development of a pluggable component framework for the Asterisk Test Suite. Tests that support this framework specify what components they need and their configuration in their *test-config.yaml* configuration files. A Python module, *test_runner.py*, is responsible for starting execution, instantiating the components and injecting their dependencies, starting the test, and reporting results. The actual "business logic" of the test itself is deferred to the components specified in the test configuration.

Components in the test configuration fall into two categories:

1. *test_object*: This is typically an object derived from the *test_case.TestCase* class and is responsible for managing Asterisk, its interfaces (AMI/FastAgi/ARI), holding the pass/fail status of the test, and generally orchestrating the entire test process. It is the central point that other pluggable modules typically attach to. A test may only have **on****e** test object.
2. *pluggable_module*: A piece of functionality that attaches to a *test_object* and provides some test functionality. This could be verifying that an AMI event is received, executing some callback when an AMI event is received, validating CDRs, or any test specific piece of code. A test may have any number of pluggable modules.

See the [test-config.yaml.sample](http://svn.asterisk.org/svn/testsuite/asterisk/trunk/sample-yaml/test-config.yaml.sample) file for an example of specifying a *test_object* and its pluggable modules.

Example - Two Pluggable Module Tests Using SIPp
===============================================

Looking again at the two tests using SIPp, we could discard both of their *run-test* script files, and instead express all of their intent simply in their *test-config.yaml* configuration files. Assuming the SIPpTest class was modified slightly to be able to parse the scenario information from the YAML file, one particular implementation of this could express those tests in the following manner:

##### message_auth

```
testinfo:
 summary: 'Test response to MESSAGE when out-of-call MESSAGE is disabled (or not supported)'
 description: |
 'Send Asterisk a MESSAGE and expect that it gets denied'

test-modules:
 test-object:
 config-section: test-object-config
 typename: 'sipp.SIPpTest'

test-object-config:
 pass-on-sipp-scenario: True
 scenarios:
 -
 scenario: 'message_recv.xml'
 -p: '5062'
 -
 scenario: 'message.xml'
 -p: '5061'

```

##### message_disabled

```
testinfo:
 summary: 'Test response to MESSAGE when out-of-call MESSAGE is disabled (or not supported)'
 description: |
 'Send Asterisk a MESSAGE and expect that it gets denied'

test-modules:
 test-object:
 config-section: test-object-config
 typename: 'sipp.SIPpTest'

test-object-config:
 pass-on-sipp-scenario: True
 scenarios:
 -
 scenario: 'message.xml'

properties:
 minversion: '1.8.0.0'
 dependencies:
 - app : 'sipp'
 tags:
 - SIP

```

All of this, hopefully, gives the following benefits:

* Less time to write a test, particularly if you have a large number of tests that cover related functionality, or your tests can leverage existing Python libraries
* Some more difficult concepts - such as asynchronous event programming using twisted - may be deferred to lower level libraries (bad pun)
* Quicker execution time, by taking advantage of byte code files compiled by the Python interpreter
* Shared functionality across tests
* Common implementation of similar functionality across tests, easing test maintenance
