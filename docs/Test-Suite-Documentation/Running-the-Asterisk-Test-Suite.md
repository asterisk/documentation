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

```bash title=" " linenums="1"
# ./runtests.py

Running tests for Asterisk SVN-trunk-r366462M
 ...

--> Running test 'tests/example' ...

Making sure Asterisk isn't running ...
Running ['tests/example/run-test'] ...

```



!!! note 
    Depending on permissions and the modules installed, you may need to run the runtests.py script with elevated permissions.

      
[//]: # (end-note)



Since this can take a long time to execute to completion - and may cover functionality you do not want to test - there are a variety of other ways to run tests as well.


Executing a single test
-----------------------


A single test can be executed using the *-t* command line option.

```bash title=" " linenums="1"
# ./runtests.py -t tests/dialplan

```



!!! note 
    You can determine what tests are available for execution by using the *-l* command line option.

      
[//]: # (end-note)



Executing a set of tests by tag
-------------------------------


Many tests in the Asterisk Test Suite have tags that group them according to functionality that they test. The tags currently in use by all executable tests in the Test Suite can be determined using the *-L* command line option:

```bash title=" " linenums="1"
# ./runtests.py -L
Available test tags:
 AGI AMI apps 
 bridge ccss CDR 
 chan_local chanspy confbridge 
 connected_line dial dialplan 
 dialplan_lua directory DTMF 
 fax fax_gateway fax_passthrough
 features gosub GoSub 
 IAX incomplete macro 
 mixmonitor page parking 
 pickup queues redirecting 
 SIP subroutine transfer
 voicemail 

```

All tests that have a tag can be executed using the *-g* command line option:

```bash title=" " linenums="1"
# ./runtests.py -g SIP

```

Multiple tags can be specified as well, using multiple invocations of the *-g* command line option. A test must satisfy each tag specified in order to be executed.

```bash title=" " linenums="1"
# ./runtests.py -g SIP -g CDR

```

Executing pre-defined sets of tests
-----------------------------------


Pre-defined sets of tests can be set up in the top level *test-config.yaml* configuration file. When the *runtests.py* script starts, it looks for the key in *global-settings/test-configuration*. The value specified for that key is used to look up test run specific settings. An example is shown below, where the *test-configuration* is set to *config-quick*.

```bash title=" " linenums="1"
# Global settings
global-settings:
 # The active test configuration. The value must match a subsequent key
 # in this file, which defines the global settings to apply to the test execution
 # run.
 test-configuration: config-quick

config-quick:

```

A test configuration can exclude tests from a run by using the *exclude-tests* key. Each value under that key is a test that will **not** be run when the *runtests.py* script executes.

```bash title=" " linenums="1"
# Exclude some long-running tests
config-quick:
 exclude-tests:
 - 'authenticate_invalid_password'
 - 'check_voicemail_callback'
 - 'check_voicemail_delete'
 - 'check_voicemail_dialout'
 - 'check_voicemail_envelope'
 - 'check_voicemail_new_user'
 - 'check_voicemail_nominal'
 - 'check_voicemail_reply'
 - 'leave_voicemail_external_notification'
 - 'leave_voicemail_nominal'
 - 'gateway_g711_t38'
 - 'gateway_mix1'
 - 'gateway_mix2'
 - 'gateway_mix3'
 - 'gateway_mix4'
 - 'gateway_native_t38'
 - 'gateway_native_t38_ced'
 - 'gateway_no_t38'
 - 'gateway_t38_g711'
 - 'gateway_timeout1'
 - 'gateway_timeout2'
 - 'gateway_timeout3'
 - 'gateway_timeout4'
 - 'gateway_timeout5'

```

