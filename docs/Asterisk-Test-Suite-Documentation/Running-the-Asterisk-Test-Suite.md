---
title: Running the Asterisk Test Suite
pageid: 20185280
---

The Asterisk Test Suite uses a python script, ***runtests.py***, to execute the tests within the suite. The *runtests.py* script is responsible for determining what tests exist in the Test Suite and managing their execution. 


There are a number of ways the Asterisk Test Suite can be executed:


* Execute all tests
* Execute a single test
* Execute a set of tests that share common tags
* Execute a pre-defined set of tests


Executing all tests
-------------------


The simplest way of executing tests, all tests in the Test Suite can be run by simply calling the *runtests.py* script with no arguments.



# ./runtests.py

Running tests for Asterisk SVN-trunk-r366462M
 ...

--> Running test 'tests/example' ...

Making sure Asterisk isn't running ...
Running ['tests/example/run-test'] ...


Depending on permissions and the modules installed, you may need to run the runtests.py script with elevated permissions.


Since this can take a long time to execute to completion - and may cover functionality you do not want to test - there are a variety of other ways to run tests as well.


Executing a single test
-----------------------


A single test can be executed using the *-t* command line option.



# ./runtests.py -t tests/dialplan


You can determine what tests are available for execution by using the *-l* command line option.


Executing a set of tests by tag
-------------------------------


Many tests in the Asterisk Test Suite have tags that group them according to functionality that they test. The tags currently in use by all executable tests in the Test Suite can be determined using the *-L* command line option:



# ./runtests.py -L
Available test tags:
 AGI AMI apps 
 bridge ccss CDR 
 chan\_local chanspy confbridge 
 connected\_line dial dialplan 
 dialplan\_lua directory DTMF 
 fax fax\_gateway fax\_passthrough
 features gosub GoSub 
 IAX incomplete macro 
 mixmonitor page parking 
 pickup queues redirecting 
 SIP subroutine transfer
 voicemail 

All tests that have a tag can be executed using the *-g* command line option:



# ./runtests.py -g SIP

Multiple tags can be specified as well, using multiple invocations of the *-g* command line option. A test must satisfy each tag specified in order to be executed.



# ./runtests.py -g SIP -g CDR

Executing pre-defined sets of tests
-----------------------------------


Pre-defined sets of tests can be set up in the top level *test-config.yaml* configuration file. When the *runtests.py* script starts, it looks for the key in *global-settings/test-configuration*. The value specified for that key is used to look up test run specific settings. An example is shown below, where the *test-configuration* is set to *config-quick*.




# Global settings
global-settings:
 # The active test configuration. The value must match a subsequent key
 # in this file, which defines the global settings to apply to the test execution
 # run.
 test-configuration: config-quick

config-quick:


A test configuration can exclude tests from a run by using the *exclude-tests* key. Each value under that key is a test that will **not** be run when the *runtests.py* script executes.




# Exclude some long-running tests
config-quick:
 exclude-tests:
 - 'authenticate\_invalid\_password'
 - 'check\_voicemail\_callback'
 - 'check\_voicemail\_delete'
 - 'check\_voicemail\_dialout'
 - 'check\_voicemail\_envelope'
 - 'check\_voicemail\_new\_user'
 - 'check\_voicemail\_nominal'
 - 'check\_voicemail\_reply'
 - 'leave\_voicemail\_external\_notification'
 - 'leave\_voicemail\_nominal'
 - 'gateway\_g711\_t38'
 - 'gateway\_mix1'
 - 'gateway\_mix2'
 - 'gateway\_mix3'
 - 'gateway\_mix4'
 - 'gateway\_native\_t38'
 - 'gateway\_native\_t38\_ced'
 - 'gateway\_no\_t38'
 - 'gateway\_t38\_g711'
 - 'gateway\_timeout1'
 - 'gateway\_timeout2'
 - 'gateway\_timeout3'
 - 'gateway\_timeout4'
 - 'gateway\_timeout5'


