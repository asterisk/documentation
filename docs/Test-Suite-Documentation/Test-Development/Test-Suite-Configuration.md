---
title: Test Suite Configuration
pageid: 20185462
---

Configuration
=============

Configuration in the Test Suite is done in YAML. This is typically done in two different YAML files:

1. *tests.yaml* - These files define which tests to run, and additional directories that tests can be found in. A *tests.yaml* file always contains the the keyword **tests**, which contains a sequence of directories to search for more tests in and test directories to execute.
2. *test-config.yaml* - The configuration for a single test.

Tests are discovered by the *runtests.py* script during run time of the Asterisk Test Suite. When it starts, the *runtests* script parses the top-most tests [YAML](http://www.yaml.org/) file, *tests/tests.yaml*, to determine what tests are in the Test Suite. The *tests.yaml* file can either specify a directory to search in for more tests, or a specific test directory to add to the list of available tests. If a search directory is specified, the *runtests* script looks for another *tests.yaml* file in that directory, and parses it to look for more tests. This recursive process continues until no more *tests.yaml* files are found.

Test directories specified in a *tests.yaml* file are processed in the following way:

1. If a test directory contains an executable *run-test* script, that script is opened as a separate process. This script can be written in any language. If the process returns a value of 0, the test passes; any other value is considered a test failure.  NOTE: This method of running tests is deprecated.
2. If no *run-test* script is in the test directory, an instance of *test_runner.TestRunner* is spawned instead. The test directory is passed to *TestRunner* as the test to execute.



Rather than list all supported configuration parameters (which would quickly be out of date), test developers are encouraged to consult the sample YAML included with the Test Suite:

<https://github.com/asterisk/testsuite/tree/master/sample-yaml>



