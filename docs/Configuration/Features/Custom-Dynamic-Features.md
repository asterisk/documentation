---
title: Custom Dynamic Features
pageid: 32375834
---

Overview
========

Asterisk allows you to define custom features mapped to Asterisk applications. You can then enable these features dynamically, on a per-channel basis by using a channel variable.

Defining the Features
=====================

Custom features are defined in the **applicationmap** section of the features.conf file.

Syntax:

[applicationmap]
<FeatureName> = <DTMF\_sequence>,<ActivateOn>[/<ActivatedBy>],<Application>[,<AppArguments>[,MOH\_Class]]
<FeatureName> = <DTMF\_sequence>,<ActivateOn>[/<ActivatedBy>],<Application>[,"<AppArguments>"[,MOH\_Class]]
<FeatureName> = <DTMF\_sequence>,<ActivateOn>[/<ActivatedBy>],<Application>([<AppArguments>])[,MOH\_Class]Syntax Fields:



| Field Name | Description |
| --- | --- |
| FeatureName | This is the name of the feature used when setting the DYNAMIC\_FEATURES variable to enable usage of this feature. |
| DTMF\_sequence | This is the key sequence used to activate this feature. |
| ActivateOn | This is the channel of the call that the application will be executed on. Valid values are "self" and "peer". "self" means run the application on the same channel that activated the feature. "peer" means run the application on the opposite channel from the one that has activated the feature. |
| ActivatedBy | ActivatedBy is no longer honored. The feature is activated by which channel DYNAMIC\_FEATURES includes the feature is on. Use a pre-dial handler to set different values for DYNAMIC\_FEATURES on the channels. Historic values are: "caller", "callee", and "both". |
| Application | This is the application to execute. |
| AppArguments | These are the arguments to be passed into the application. If you need commas in your arguments, you should use either the second or third syntax, above. |
| MOH\_Class | This is the music on hold class to play while the idle channel waits for the feature to complete. If left blank, no music will be played. |

Application Mapping
-------------------

The applicationmap is not intended to be used for all Asterisk applications. When applications are used in extensions.conf, they are executed by the PBX core. In this case, these applications are executed outside of the PBX core, so it does \*not\* make sense to use any application which has any concept of dialplan flow. Examples of this would be things like Goto, Background, WaitExten, and many more.  The exceptions to this are Gosub and Macro routines which must complete for the call to continue.

Enabling these features means that the PBX needs to stay in the media flow and media will not be re-directed if DTMF is sent in the media stream.

Example Feature Definitions:
----------------------------

Here we have defined a few custom features to give you an idea of how the configuration looks.

features.conf [applicationmap]
playmonkeys => #9,peer,Playback,tt-monkeys
retrieveinfo => #8,peer,Set(ARRAY(CDR(mark),CDR(name))=${ODBC\_FOO(${CALLERID(num)})})
pauseMonitor => #1,self/callee,Pausemonitor
unpauseMonitor => #3,self/callee,UnPauseMonitorExample feature descriptions:

* playmonkeys - Allow both the caller and callee to play tt-monkeys to the bridged channel.
* retrieveinfo - Set arbitrary channel variables, based upon CALLERID number (Note that the application argument contains commas)
* pauseMonitor - Allow the callee to pause monitoring on their channel.
* unpauseMonitor - Allow the callee to unpause monitoring on their channel.

Enabling Features
=================

After you define a custom feature in features.conf you must enable it on a channel by setting the DYNAMIC\_FEATURES channel variable.

DYNAMIC\_FEATURES accepts as an argument a list of hash-sign delimited feature names.

Example Usage:

extensions.conf Set(\_\_DYNAMIC\_FEATURES=playmonkeys#pauseMonitor#unpauseMonitor)Tip: Variable InheritanceThe two leading underscores allow these feature settings to be set on the outbound channels, as well.  Otherwise, only the original channel will have access to these features.

