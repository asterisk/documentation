---
search:
  boost: 0.5
title: AGI
---

# AGI()

### Synopsis

Executes an AGI compliant application.

### Description

Executes an Asterisk Gateway Interface compliant program on a channel. AGI allows Asterisk to launch external programs written in any language to control a telephony channel, play audio, read DTMF digits, etc. by communicating with the AGI protocol.<br>

The following variants of AGI exist, and are chosen based on the value passed to _command_:<br>


* `AGI` - The classic variant of AGI, this will launch the script specified by _command_ as a new process. Communication with the script occurs on 'stdin' and 'stdout'. If the full path to the script is not provided, the *astagidir* specified in *asterisk.conf* will be used.<br>

* `FastAGI` - Connect Asterisk to a FastAGI server using a TCP connection. The URI to the FastAGI server should be given in the form '\[scheme\]://host.domain\[:port\]\[/script/name\]', where _scheme_ is either 'agi' or 'hagi'.<br>
In the case of 'hagi', an SRV lookup will be performed to try to connect to a list of FastAGI servers. The hostname in the URI must be prefixed with '\_agi.\_tcp'. prior to the DNS resolution. For example, if you specify the URI 'hagi://agi.example.com/foo.agi' the DNS query would be for '\_agi.\_tcp.agi.example.com'. You will need to make sure this resolves correctly.<br>

* `AsyncAGI` - Use AMI to control the channel in AGI. AGI commands can be invoked using the 'AMI' action, with a variety of AGI specific events passed back over the AMI connection. AsyncAGI should be invoked by passing 'agi:async' to the _command_ parameter.<br>

/// note
As of '1.6.0', this channel will not stop dialplan execution on hangup inside of this application. Dialplan execution will continue normally, even upon hangup until the AGI application signals a desire to stop (either by exiting or, in the case of a net script, by closing the connection). A locally executed AGI script will receive 'SIGHUP' on hangup from the channel except when using 'DeadAGI' (or when the channel is already hungup). A fast AGI server will correspondingly receive a 'HANGUP' inline with the command dialog. Both of these signals may be disabled by setting the **AGISIGHUP** channel variable to 'no' before executing the AGI application. Alternatively, if you would like the AGI application to exit immediately after a channel hangup is detected, set the **AGIEXITONHANGUP** variable to 'yes'.
///

``` title="Example: Start the AGI script /tmp/my-cool-script.sh, passing it the contents of the channel variable FOO"

same => n,AGI(/tmp/my-cool-script.sh,${FOO})


```
``` title="Example: Start the AGI script my-cool-script.sh located in the astagidir directory, specified in asterisk.conf"

same => n,AGI(my-cool-script.sh)


```
``` title="Example: Connect to the FastAGI server located at 127.0.0.1 and start the script awesome-script"

same => n,AGI(agi://127.0.0.1/awesome-script)


```
``` title="Example: Start AsyncAGI"

same => n,AGI(agi:async)


```
This application sets the following channel variable upon completion:<br>


* `AGISTATUS` - The status of the attempt to the run the AGI script text string, one of:<br>

    * `SUCCESS`

    * `FAILURE`

    * `NOTFOUND`

    * `HANGUP`

### Syntax


```

AGI(command,arg1,[arg2[,...]])
```
##### Arguments


* `command` - How AGI should be invoked on the channel.<br>

* `args` - Arguments to pass to the AGI script or server.<br>

    * `arg1` **required**

    * `arg2[,arg2...]`

### See Also

* [AMI Actions AGI](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/AGI)
* [AMI Events AsyncAGIStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIStart)
* [AMI Events AsyncAGIEnd](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIEnd)
* [Dialplan Applications EAGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/EAGI)
* [Dialplan Applications DeadAGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/DeadAGI)
* {{asterisk.conf}}


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 