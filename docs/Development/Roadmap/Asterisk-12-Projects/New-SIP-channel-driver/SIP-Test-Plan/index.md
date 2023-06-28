---
title: Overview
pageid: 21464335
---

The new chan_sip has a requirement that it must be tested as thoroughly as possible. Testing can be categorized into three main categories


Unit Tests
==========


Unit tests exist within Asterisk and are intended to exercise specific C code blocks within chan_sip. As an example, we might pass a multitude of different strings through a parser to be sure that the result is as expected and that giving bad or unexpected input does not result in anything catastrophic occurring.


Integration Tests
=================


Integration tests exist outside Asterisk in the test suite. Their goal is to test Asterisk's interaction with external elements. In this way, we can simulate higher-level concepts such as phone calls, registrations, and messaging.


One goal that the new chan_sip will strive for the best interoperability possible. On that front, there are two measures being taken


* Tests will strive to test specific behaviors observed with real SIP phones. More details will be revealed on how this will be done and how community members can help with this effort.
* Old resolved Asterisk issues will be reviewed. We will create tests that exercise what have been problem points in the past in Asterisk.


Manual Tests
============


In addition to automated tests, we will be performing manual tests that cannot easily be done in the test suite. These tests, their methodology, their expected results, and their actual results are documented here.

