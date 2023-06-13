---
title: Writing a Python Test
pageid: 19008058
---

### This method of creating tests is deprecated.

#### We strongly recommend that you write your tests using test-config.yaml and pluggable modules rather than in Python. If you find yourself limited by the pluggable modules, we'd all be better off if you updated an existing module or created a new one to handle your scenario.

Overview
========

While the Asterisk Test Suite can execute a test written in any scripting language, [Python](http://www.python.org) has become the de facto language of choice. The Asterisk Test Suite contains a number of modules written in Python to help with writing tests; as such, we strongly encourage people to make use of the existing infrastructure - and, of course - add to it as necessary!

The following walkthrough produces a test similar to the *tests/skeleton\_test*, which is included in the Asterisk Test Suite and provides a template for a Python test. You can use that test as a starting point for tests that you write.

Developing a test can be broken down into the following steps:

1. Define the #Test Layout and Asterisk Configuration
2. Describe the test in Test-Config.yaml
3. Write the run-test script
4. Execute the test

This walkthrough will create a test (*sample*) that makes Asterisk playback tt-monkeys.

Test Layout and Asterisk Configuration
======================================

1. Create a new folder for the test in the appropriate location. In general, this will be a folder in the */tests* directory. You may want to provide a similar structure to Asterisk by grouping related tests together, e.g., application tests should have folder(s) under the */tests/apps* directory. For now, we'll assume that we're creating a test called *sample*, located in *tests/sample*.
2. In the *sample* folder, create the following:
	* A *run-test* file, which will contain the python script to execute. The file should have execute permissions, and should not have the ".py" extension. The Test Suite looks for files named run-test and executes them; the fact that we are choosing Python as our language is an implementation decision that the Test Suite does not care about.
	* *test-config.yaml*, which will contain the test information and its dependency properties
	* A *configs* directory. The *configs* directory should contain subfolder(s) for each instance of Asterisk that will be instantiated by the test, named *ast#*, where # is the 1-based index of the Asterisk instance. For now, create a single folder named *ast1*.
	* In each *ast#* subfolder, the Asterisk config files needed for the test. At a minimum, this will be *extensions.conf*.
	
	NoteThe asterisk class automatically creates an *asterisk.conf* file, and installs it along with other basic Asterisk configuration files (see the *configs* directory). You can override their behavior by providing your own *.conf.inc* files. Any configuration files not provided in the *configs* directory are installed from the subfolders for each test.
3. Edit your *extensions.conf* to perform some test in Asterisk. For our test, we'll simply check that we can dial into Asterisk and play back a sound file.

truetrue[default]
exten => s,1,NoOp()
same => n,Playback(tt-monkeys)
same => n,UserEvent(TestResult,result:pass)

At the end of this, you should have:

* A folder in *tests* named *sample*
* An empty file in *tests/sample* named *run-test*
* An empty file in *tests/sample* named *test-config.yaml*
* A subfolder in *sample* named *configs*
* A subfolder in *sample/configs* named *ast1*
* A populated *extensions.conf* in *sample/configs/ast1*

Describing the test in Test-Config.yaml
=======================================

Each test has a corresponding [yaml](http://yaml.org/) file that defines information about the test, the dependencies the test has, and other optional configuration information. The fields that should be filled out, at a minimum, are:

* testinfo:
	+ summary: A summary of the test
	+ description: A verbose description of exactly what piece and functionality of Asterisk is under test.
* properties:
	+ minversion: The minimum version of Asterisk that this test applies to
	+ dependencies:
		- python: Any python based dependencies. Often, this will be noted twice, once for 'twisted' and once for 'starpy'
		- custom: Custom dependencies, e.g., 'soundcard', 'fax', etc.
		- app: External applications that are needed, i.e., 'pjsua'

NoteSee the Test Suite's README.txt for all of the possible fields in a test configuration file

The *test-config.yaml* file for our *sample* test is below.

truetruetestinfo:
 summary: 'A sample test'
 description: |
 This test verifies that monkeys have taken over the phone system.

properties:
 minversion: '1.8'
 dependencies:
 - python : 'twisted'
 - python : 'starpy'
While we've created our test description, we haven't yet told the Test Suite of its existence. Upon startup, *runtests.py* checks *tests/tests.yaml* for the tests that exist. That file defines the folders that contain tests, where each folder contains another *tests.yaml* file that further defines tests and folders. In order for the Test Suite to find our sample test, open the *tests/tests.yaml* file and insert our test:

truetruetests:
 - test: 'example'
# We're inserting our sample test here:
 - test: 'sample'
 - test: 'dynamic-modules'
 - dir: 'manager'
# And so on...
Writing run-test
================

Now we start to actually write the meat of our test. Each test in the Test Suite is spawned as a separate process, and so each test needs an entry point. First, lets import a few libraries and write our main.

truepythontrue#!/usr/bin/env python
# vim: sw=3 et:
import sys
import os
import logging

from twisted.internet import reactor

sys.path.append("lib/python")
from asterisk.test\_case import TestCase

LOGGER = logging.getLogger(\_\_name\_\_)

def main():
 """
 Main entry point for the test. This will do the following:
 1. Instantiate the test object
 2. Tell the test object to start the Asterisk instances
 3. Run the twisted reactor. This will automatically call the test's run method when twisted is up and start the instances of Asterisk, and block until the twisted reactor exits.
 4. Check results. If the test passed, return 0; otherwise, return any other value (usually 1). The top level script checks the return code from the process it spawned to determine whether or not the test passed or failed.
 """

 test = SampleTest()
 reactor.run()

 if not test.passed:
 return 1

 return 0

if \_\_name\_\_ == "\_\_main\_\_":
 sys.exit(main() or 0)
There are a few things to note from this:

* We're going to use the twisted reactor for our test. This is usually useful as we typically will use asynchronous AMI events to drive the tests.
* We've told the python path where the Test Suite libraries are, and imported the TestCase class. Our test case class, SampleTest, will end up deriving from it.
* We have a logging object we can use to send statements to the Test Suite log file

Moving on!

Defining the Test Class
-----------------------

We'll need a test the inherits from TestCase. For now, we'll assume that the basic class provides our start\_asterisk and stop\_asterisk methods and that we don't need to override them (which is a safe assumption in most cases). We'll fill in some of these methods a bit more later.

truepythontrueclass SampleTest(TestCase):
 """
 A class that executes a very simple test, using TestCase to do most of the
 heavy lifting.
 """

 def \_\_init\_\_(self):
 super(SampleTest, self).\_\_init\_\_()
 """ You should always call the base class implementation of \_\_init\_\_ prior
 to initializing your test conditions here. Some useful variables the TestCase
 class provides:
 - passed - set to False initially. Set to True if your test passes.
 - ast - a list of Asterisk instance
 - ami - a list of StarPY manager (AMI) instances, corresponding to each Asterisk instance
 - reactor\_timeout - maximum time a test can execute before it is considered to fail. This
 prevents tests from hanging and never finishing. You can reset this timer using a call
 to TestCase.reset\_timeout

 In your initialization, you should usually set the reactor\_timeout if it should
 be something other than 30 (the default). You should also call create\_asterisk, which
 will create and initialize the Asterisk instances. You can specify as a parameter the number
 of Asterisk instances to create.
 """
 self.create\_asterisk()

 def run(self):
 """
 Run is called by the reactor when the test starts. It is the entry point for test execution,
 and will occur after Asterisk is started (so long as the instructions in this example are followed).
 Typically, after calling the base class implementation, connections over AMI are created. You
 can also interact with the started Asterisk instances here by referencing the ast list.
 """
 super(SampleTest, self).run()


 # Create a connection over AMI to the created Asterisk instance. If you need to communicate with
 # all of the instances of Asterisk that were created, specify the number of AMI connections to make.
 # When the AMI connection succeeds, ami\_connect will be called.
 self.create\_ami\_factory()

 def ami\_connect(self, ami):
 """
 This method is called by the StarPY manager class when AMI connects to Asterisk.

 Keyword Arguments:
 ami - The StarPY manager object that connected
 """
At the end of this, we have the following:

* A class that inherits from *TestCase*. In its constructor, it calls the base class constructor and creates an instance of Asterisk by calling the *TestCase.create\_asterisk()* method. The base class provides us a few attributes that are of particular use:
	+ *passed* - a boolean variable that we can set to True or False
	+ *ast* - a list of asterisk instances, that provide access to a running Asterisk application
	+ *ami* - a list of AMI connections corresponding to each asterisk instance
	+ *reactor\_timeout* - the amount of time (in seconds) that the twisted reactor will wait before it stops itself. This is used to prevent tests from hanging.
	+ *TestCase* has a method we can call called *create\_asterisk()*, that, well, creates instances of Asterisk. Yay!
	+ *TestCase* has another method we can call called *create\_ami\_factory()* that creates AMI connections to our previously created instances of Asterisk. We do this after the twisted reactor has started, so that Asterisk has a chance to start up.
* An entry point for the twisted reactor called *run()*. This calls the base class's implementation of the method, then spawns an AMI connection. Note that in our *main* method, we start up the created Asterisk instances prior to starting the twisted reactor - so when *run()* is called by twisted, Asterisk should already be started and ready for an AMI connection.
* A method, *ami\_connect*, that is called when an AMI connection succeeds. This same method is used for all AMI connections - so to tell which AMI connection you are receiving, we can check the *ami.id* property. Each AMI connection corresponds exactly to the instance of Asterisk in the *ast* list - so *ast[ami.id]* will reference the Asterisk instance associated with the *ami* object.

Making the Test do something
----------------------------

So, we have a test that will start up, spawn an instance of Asterisk, and connect to it over AMI. That's interesting, but doesn't really test anything. Based on our *extensions.conf*, we want to call the *s* extension in *default*, hopefully have monkeys possess our channel, and then check that the *UserEvent* fired off to determine if we passed. If we don't see the UserEvent, we should eventually fail. Lets start off by adding some code to *ami\_connect*.

truepythontruedef ami\_connect(self, ami):
 """
 This method is called by the StarPY manager class when AMI connects to Asterisk.

 Keyword Arguments:
 ami - The StarPY manager object that connected
 """
 LOGGER.info("Instructing monkeys to rise up and overthrow their masters")
 deferred = ami.originate(channel="Local/s@default",
 application="Echo")
 deferred.addErrback(self.handle\_originate\_failure)
What we've now instructed the test to do is, upon an AMI connection, originate a call to the *s* extension in context *default*, using a Local channel. starpy's *originate* method returns a deferred object, which lets us assign a callback handler in case of an error. We've used the TestCase class's *handleOriginateFailure* method for this, which will automagically fail our test for us if the originate fails.

Now we need something to handle the UserEvent when monkeys inevitably enslave our phone system. Let's add that to our *ami\_connect* method as well.

truepythontruedef ami\_connect(self, ami):
 """
 This method is called by the StarPY manager class when AMI connects to Asterisk.

 Keyword Arguments:
 ami - The StarPY manager object that connected
 """

 ami.registerEvent('UserEvent', self.user\_event)

 LOGGER.info("Instructing monkeys to rise up and overthrow their masters")
 deferred = ami.originate(channel="Local/s@default",
 application="Echo")
 deferred.addErrback(self.handle\_originate\_failure)

 def user\_event(self, ami, event):
 """
 Handler for the AMI UserEvent
 Keyword Arguements:
 ami - The StarPY AMI object corresponding to the received UserEvent
 event - The AMI event
 """
 if event['userevent'] != 'TestResult':
 return

 if event['result'] == "pass":
 self.passed = True
 LOGGER.info("Monkeys detected; test passes!")
 else:
 LOGGER.error("No monkeys found :-(")
 self.stop\_reactor()
Now we've registered for the UserEvent that should be raised from the dialplan after monkeys are played back. We make the assumption in the handler that we could have other UserEvents that return failure results - in our case, we don't have failure scenarios, but many tests do. Regardless, once we receive a user event we stop the twisted reactor, which will cause our test to be stopped and the results evaluated.

We should now be ready to run our test.

Running the test
================

From a console window, browse to the base directory of the Test Suite and type the following:

./runtests.py --test=tests/sample/
You should see something similar to the following:

Making sure Asterisk isn't running ...
Running ['tests/sample/run-test'] ...
Resetting translation matrix
Parsing /tmp/asterisk-testsuite/sample/ast1/etc/asterisk/logger.conf
Parsing /tmp/asterisk-testsuite/sample/ast1/etc/asterisk/logger.general.conf.inc
Parsing /tmp/asterisk-testsuite/sample/ast1/etc/asterisk/logger.logfiles.conf.inc
<?xml version="1.0" encoding="utf-8"?>
<testsuite errors="0" failures="0" name="AsteriskTestSuite" tests="1" time="18.83">
 <testcase name="tests/sample" time="18.83"/>
</testsuite>
We can inspect the log files created by the Test Suite for more information. The Test Suite makes two log files - full.txt and messages.txt - by default, DEBUG and higher are sent to full.txt, while INFO and higher are sent to mssages.txt. The following is a snippet from messages.txt - yours should look similar.

[Feb 07 17:04:51] INFO[6991]: asterisk.TestCase:86 \_\_init\_\_: Executing tests/sample
[Feb 07 17:04:51] INFO[6991]: asterisk.TestCase:135 create\_asterisk: Creating Asterisk instance 1
[Feb 07 17:04:52] INFO[6991]: asterisk.TestCase:208 start\_asterisk: Starting Asterisk instance 1
[Feb 07 17:04:52] INFO[6991]: asterisk.TestCase:159 create\_ami\_factory: Creating AMIFactory 1
[Feb 07 17:04:52] INFO[6991]: AMI:158 connectionMade: Connection Made
[Feb 07 17:04:52] INFO[6991]: AMI:172 onComplete: Login Complete: {'message': 'Authentication accepted', 'response': 'Success', 'actionid': 'mjordan-laptop-22006600-1'}
[Feb 07 17:04:52] INFO[6991]: asterisk.TestCase:297 \_\_ami\_connect: AMI Connect instance 1
[Feb 07 17:04:52] INFO[6991]: \_\_main\_\_:67 ami\_connect: Instructing monkeys to rise up and overthrow their masters
[Feb 07 17:05:09] INFO[6991]: \_\_main\_\_:85 user\_event: Monkeys detected; test passes!
[Feb 07 17:05:09] INFO[6991]: asterisk.TestCase:256 stop\_reactor: Stopping Reactor
[Feb 07 17:05:09] INFO[6991]: asterisk.TestCase:223 stop\_asterisk: Stopping Asterisk instance 1
Sample Test
===========

extensions.conf
---------------

truetrue[default]
exten => s,1,NoOp()
same => n,Playback(tt-monkeys)
same => n,UserEvent(TestResult,result:pass)
test-config.yaml
----------------

truetruetestinfo:
 summary: 'A sample test'
 description: |
 This test verifies that monkeys have taken over the phone system.

properties:
 minversion: '1.8'
 dependencies:
 - python : 'twisted'
 - python : 'starpy'
run-test
--------

truepythontrue#!/usr/bin/env python
# vim: sw=3 et:
'''Asterisk Test Suite Sample Test

Copyright (C) 2012, Digium, Inc.
Matt Jordan <mjordan@digium.com>

This program is free software, distributed under the terms of
the GNU General Public License Version 2.
'''

import sys
import os
import logging

from twisted.internet import reactor

sys.path.append("lib/python")
from asterisk.test\_case import TestCase

LOGGER = logging.getLogger(\_\_name\_\_)

class SampleTest(TestCase):
 """
 A class that executes a very simple test, using TestCase to do most of the
 heavy lifting.
 """

 def \_\_init\_\_(self):
 super(SampleTest, self).\_\_init\_\_()
 """ You should always call the base class implementation of \_\_init\_\_ prior
 to initializing your test conditions here. Some useful variables the TestCase
 class provides:
 - passed - set to False initially. Set to True if your test passes.
 - ast - a list of Asterisk instance
 - ami - a list of StarPY manager (AMI) instances, corresponding to each Asterisk instance
 - reactor\_timeout - maximum time a test can execute before it is considered to fail. This
 prevents tests from hanging and never finishing. You can reset this timer using a call
 to TestCase.reset\_timeout

 In your initialization, you should usually set the reactor\_timeout if it should
 be something other than 30 (the default). You should also call create\_asterisk, which
 will create and initialize the Asterisk instances. You can specify as a parameter the number
 of Asterisk instances to create.
 """
 self.create\_asterisk()

 def run(self):
 """
 Run is called by the reactor when the test starts. It is the entry point for test execution,
 and will occur after Asterisk is started (so long as the instructions in this example are followed).
 Typically, after calling the base class implementation, connections over AMI are created. You
 can also interact with the started Asterisk instances here by referencing the ast list.
 """
 super(SampleTest, self).run()

 # Create a connection over AMI to the created Asterisk instance. If you need to communicate with
 # all of the instances of Asterisk that were created, specify the number of AMI connections to make.
 # When the AMI connection succeeds, ami\_connect will be called.
 self.create\_ami\_factory()

 def ami\_connect(self, ami):
 """
 This method is called by the StarPY manager class when AMI connects to Asterisk.

 Keyword Arguments:
 ami - The StarPY manager object that connected
 """

 ami.registerEvent('UserEvent', self.user\_event)

 LOGGER.info("Instructing monkeys to rise up and overthrow their masters")
 deferred = ami.originate(channel="Local/s@default",
 application="Echo")
 deferred.addErrback(self.handle\_originate\_failure)

 def user\_event(self, ami, event):
 """
 Handler for the AMI UserEvent
 Keyword Arguements:
 ami - The StarPY AMI object corresponding to the received UserEvent
 event - The AMI event
 """
 if event['userevent'] != 'TestResult':
 return

 if event['result'] == "pass":
 self.passed = True
 LOGGER.info("Monkeys detected; test passes!")
 else:
 LOGGER.error("No monkeys found :-(")
 self.stop\_reactor()


def main():
 """
 Main entry point for the test. This will do the following:
 1. Instantiate the test object
 2. Tell the test object to start the Asterisk instances
 3. Run the twisted reactor. This will automatically call the test's run method when twisted is up and start the instances of Asterisk, and block until the twisted reactor exits.
 4. Check results. If the test passed, return 0; otherwise, return any other value (usually 1). The top level script checks the return code from the process it spawned to determine whether or not the test passed or failed.
 """

 test = SampleTest()
 reactor.run()

 if not test.passed:
 return 1

 return 0

if \_\_name\_\_ == "\_\_main\_\_":
 sys.exit(main() or 0)
