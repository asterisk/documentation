---
title: Asterisk Call Files
pageid: 4259976
---

# Asterisk Call Files

Asterisk has the ability to initiate a call from outside of the normal methods such as the dialplan, manager interface, or spooling interface.

Using the call file method, you must give Asterisk the following information:

* How to perform the call, similar to the Dial() application
* What to do when the call is answered

With call files you submit this information simply by creating a file with the required syntax and placing it in the `outgoing` spooling directory, located by default in `/var/spool/asterisk/outgoing/` (this is configurable in `asterisk.conf`).

The `pbx_spool.so` module watches the spooling directly, either using an event notification system supplied by the operating system such as `[inotify](http://en.wikipedia.org/wiki/Inotify)` or `[kqueue](http://en.wikipedia.org/wiki/Kqueue)`, or by polling the directory each second when one of those notification systems is unavailable. When a new file appears, Asterisk initiates a new call based on the file's contents.


!!! warning "Creating Files in the Spool Directory"
    Do **not** write or create the call file directly in the `outgoing` directory, but always create the file in another directory of the same filesystem and then move the file to the `outgoing` directory, or Asterisk may read a partial file.
[//]: # (end-warning)

!!! note "NFS Considerations"
    By default, Asterisk will prefer to use `inotify` or `kqueue` where available. When the spooling directory is on a remote server and is mounted via NFS, the `inotify` method will fail to work. You can force Asterisk to use the older polling method by passing the `--without-inotify` flag to `configure` during compilation (e.g. `./configure --without-inotify`).
[//]: # (end-note)

## Call File Syntax

The call file consists of <Key>: <value> pairs; one per line.

Comments are indicated by a '#' character that begins a line, or follows a space or tab character. To be consistent with the configuration files in Asterisk, comments can also be indicated by a semicolon. However, the multiline comments (;----;) used in Asterisk configuration files are not supported. Semicolons can be escaped by a backslash.


The following keys-value pairs are used to specify how setup a call:


* `Channel: <channel>` - The channel to use for the new call, in the form **technology/resource** as in the Dial application. This value is required.
* `Callerid: <callerid>` - The caller id to use.
* `WaitTime: <number>` - How many seconds to wait for an answer before the call fails (ring cycle). Defaults to 45 seconds.
* `MaxRetries: <number>` - Number of retries before failing, not including the initial attempt. Default = 0 e.g. don't retry if fails.
* `RetryTime: <number>` - How many seconds to wait before retry. The default is 300 (5 minutes).
* `Account: <account>` - The account code for the call. This value will be assigned to CDR(accountcode)


When the call answers there are two choices: 


1. Execute a single application, or
2. Execute the dialplan at the specified context/extension/priority.


## To execute an application:

* `Application: <appname>` - The application to execute
* `Data: <args>` - The application arguments

### To start executing applications in the dialplan:

* `Context: <context>` - The context in the dialplan
* `Extension: <exten>` - The extension in the specified context
* `Priority: <priority>` - The priority of the specified extension; (numeric or label)
* `Setvar: <var=value>` - You may also assign values to variables that will be available to the channel, as if you had performed a Set(var=value) in the dialplan. More than one Setvar: may be specified.

The processing of the call file ends when the call is answered and terminated; when the call was not answered in the initial attempt and subsequent retries; or if the call file can't be successfully read and parsed.

To specify what to do with the call file at the end of processing:

* `Archive: <yes|no>` - If "no" the call file is deleted. If set to "yes" the call file is moved to the "outgoing\_done" subdirectory of the Asterisk spool directory. The default is to delete the call file.

If the call file is archived, Asterisk will append to the call file:

* `Status: <exitstatus>` - Can be "Expired", "Completed" or "Failed"

Other lines generated by Asterisk:

Asterisk keep track of how many retries the call has already attempted, appending to the call file the following key-pairs in the form:

```
StartRetry: <pid> <retrycount> (<time>)
EndRetry: <pid> <retrycount> (<time>)
```

With the main process ID (pid) of the Asterisk process, the retry number, and the attempts start and end times in time\_t format.


## Directory locations

* `<astspooldir>/outgoing` - The outgoing dir, where call files are put for processing
* `<astspooldir>/outgoing_done` - The archive dir
* `<astspooldir>` - Is specified in asterisk.conf, usually /var/spool/asterisk

## How to schedule a call

Call files that have the time of the last modification in the future are ignored by Asterisk. This makes it possible to modify the time of a call file to the wanted time, move to the outgoing directory, and Asterisk will attempt to create the call at that time.
