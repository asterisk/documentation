---
search:
  boost: 0.5
title: cdr
---

# cdr: Call Detail Record configuration

This configuration documentation is for functionality provided by cdr.

## Overview

CDR is Call Detail Record, which provides logging services via a variety of pluggable backend modules. Detailed call information can be recorded to databases, files, etc. Useful for billing, fraud prevention, compliance with Sarbanes-Oxley aka The Enron Act, QOS evaluations, and more.<br>


## Configuration File: cdr.conf

### [general]: Global settings applied to the CDR engine.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [batch](#batch)| Boolean| 0| false| Submit CDRs to the backends for processing in batches| |
| [congestion](#congestion)| Boolean| | false| Log congested calls.| |
| [debug](#debug)| Boolean| | false| Enable/disable verbose CDR debugging.| |
| [enable](#enable)| Boolean| 1| false| Enable/disable CDR logging.| |
| [endbeforehexten](#endbeforehexten)| Boolean| 1| false| Don't produce CDRs while executing hangup logic| |
| [initiatedseconds](#initiatedseconds)| Boolean| 0| false| Count microseconds for billsec purposes| |
| [safeshutdown](#safeshutdown)| Boolean| 1| false| Block shutdown of Asterisk until CDRs are submitted| |
| [scheduleronly](#scheduleronly)| Boolean| 0| false| Post batched CDRs on their own thread instead of the scheduler| |
| [size](#size)| Unsigned Integer| 100| false| The maximum number of CDRs to accumulate before triggering a batch| |
| [time](#time)| Unsigned Integer| 300| false| The maximum time to accumulate CDRs before triggering a batch| |
| [unanswered](#unanswered)| Boolean| 0| false| Log calls that are never answered and don't set an outgoing party.| |


#### Configuration Option Descriptions

##### batch

Define the CDR batch mode, where instead of posting the CDR at the end of every call, the data will be stored in a buffer to help alleviate load on the asterisk server.<br>


/// warning
Use of batch mode may result in data loss after unsafe asterisk termination, i.e., software crash, power failure, kill -9, etc.
///


##### congestion

Define whether or not to log congested calls. Setting this to "yes" will report each call that fails to complete due to congestion conditions.<br>


##### debug

When set to 'True', verbose updates of changes in CDR information will be logged. Note that this is only of use when debugging CDR behavior.<br>


##### enable

Define whether or not to use CDR logging. Setting this to "no" will override any loading of backend CDR modules.<br>


##### endbeforehexten

As each CDR for a channel is finished, its end time is updated and the CDR is finalized. When a channel is hung up and hangup logic is present (in the form of a hangup handler or the 'h' extension), a new CDR is generated for the channel. Any statistics are gathered from this new CDR. By enabling this option, no new CDR is created for the dialplan logic that is executed in 'h' extensions or attached hangup handler subroutines. The default value is 'yes', indicating that a CDR will be generated during hangup logic.<br>


##### initiatedseconds

Normally, the 'billsec' field logged to the CDR backends is simply the end time (hangup time) minus the answer time in seconds. Internally, asterisk stores the time in terms of microseconds and seconds. By setting initiatedseconds to 'yes', you can force asterisk to report any seconds that were initiated (a sort of round up method). Technically, this is when the microsecond part of the end time is greater than the microsecond part of the answer time, then the billsec time is incremented one second.<br>


##### safeshutdown

When shutting down asterisk, you can block until the CDRs are submitted. If you don't, then data will likely be lost. You can always check the size of the CDR batch buffer with the CLI `cdr status` command. To enable blocking on submission of CDR data during asterisk shutdown, set this to 'yes'.<br>


##### scheduleronly

The CDR engine uses the internal asterisk scheduler to determine when to post records. Posting can either occur inside the scheduler thread, or a new thread can be spawned for the submission of every batch. For small batches, it might be acceptable to just use the scheduler thread, so set this to 'yes'. For large batches, say anything over size=10, a new thread is recommended, so set this to 'no'.<br>


##### size

Define the maximum number of CDRs to accumulate in the buffer before posting them to the backend engines. batch must be set to 'yes'.<br>


##### time

Define the maximum time to accumulate CDRs before posting them in a batch to the backend engines. If this time limit is reached, then it will post the records, regardless of the value defined for size. batch must be set to 'yes'.<br>


/// note
Time is expressed in seconds.
///


##### unanswered

Define whether or not to log unanswered calls that don't involve an outgoing party. Setting this to "yes" will make calls to extensions that don't answer and don't set a side B channel (such as by using the Dial application) receive CDR log entries. If this option is set to "no", then those log entries will not be created. Unanswered calls which get offered to an outgoing line will always receive log entries regardless of this option, and that is the intended behavior.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 