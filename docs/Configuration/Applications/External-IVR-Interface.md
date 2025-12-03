---
title: External IVR Interface
pageid: 4260001
---

# Asterisk External IVR Interface

If you load `app_externalivr.so` in your Asterisk instance, you will have an `ExternalIVR` application available in your dialplan. This application implements a simple protocol for bidirectional communication with an external process, while simultaneously playing audio files to the connected channel (without interruption or blocking).

There are two ways to use `ExternalIVR`; you can execute an application on the local system or you can establish a socket connection to a TCP/IP socket server.

To execute a local application use the form:

```conf title="extensions.conf"
ExternalIVR(/full/path/to/application[(arguments)],options)

```

The arguments are optional, however if they exist they must be enclosed in parentheses. The external application will be executed in a child process, with its standard file handles connected to the Asterisk process as follows:

* `stdin` (0) - Events will be received on this handle
* `stdout` (1) - Commands can be sent on this handle
* `stderr` (2) - Messages can be sent on this handle

/// note
Use of `stderr` for message communication is discouraged because it is not supported by a socket connection.
///

To create a socket connection use the form:

```conf title="extensions.conf"
ExternalIVR(ivr://host[:port][(arguments)],options)
```

The host can be a fully qualified domain name or an IP address (both IPv4 and IPv6 are supported). The port is optional and, if not specified, is `2949` by default. The `ExternalIVR` application will connect to the specified socket server and establish a bidirectional socket connection, where events will be sent to the TCP/IP server and commands received from it.

The specific `ExternalIVR` options, [events](#events) and [commands](#commands) are detailed below.

Upon execution, if not specifically prevented by an option, the `ExternalIVR` application will answer the channel (if it's not already answered), create an audio generator, and start playing silence. When your application wants to send audio to the channel, it can send a [command](#commands) to add a file to the generator's playlist. The generator will then work its way through the list, playing each file in turn until it either runs out of files to play, the channel is hung up, or a command is received to clear the list and start with a new file. At any time, more files can be added to the list and the generator will play them in sequence.

While the generator is playing audio (or silence), any DTMF [events](#events) received on the channel will be sent to the child process. Note that this can happen at any time, since the generator, the child process and the channel thread are all executing independently. It is very important that your external application be ready to receive events from Asterisk at all times (without blocking), or you could cause the channel to become non-responsive.

If the child process dies, or the remote server disconnects, `ExternalIVR` will notice this and hang up the channel immediately (and also send a message to the log).

## `ExternalIVR` Options

* `n` - 'n'oanswer, don't answer an otherwise unanswered channel.
* `i` - 'i'gnore_hangup, instead of sending an `H` event and exiting `ExternalIVR` upon channel hangup, it instead sends an `I` event and expects the external application to exit the process.
* `d` - 'd'ead, allows the operation of `ExternalIVR` on channels that have already been hung up.

## Events

All events are newline-terminated (`\n`) strings and are sent in the following format:

```text
tag,timestamp[,data]
```

The tag can be one of the following characters:

* `0-9` - DTMF event for keys <kbd>0</kbd> through <kbd>9</kbd>
* `A-D` - DTMF event for keys <kbd>A</kbd> through <kbd>D</kbd>
* `*` - DTMF event for key <kbd>*</kbd>
* `#` - DTMF event for key <kbd>#</kbd>
* `H` - The channel was hung up by the connected party
* `E` - The script requested an exit
* `Z` - The previous command was unable to be executed. There may be a data element if appropriate, see specific commands below for details
* `T` - The play list was interrupted (see [`S` command])
* `D` - A file was dropped from the play list due to interruption (the data element will be the dropped file name) NOTE: this tag conflicts with the `D` DTMF event tag. The existence of the data element is used to differentiate between the two cases
* `F` - A file has finished playing (the data element will be the file name)
* `P` - A response to the [`P` command]
* `G` - A response to the [`G` command]
* `I` - An Inform message, meant to "inform" the client that something has occurred. (see Inform Messages below)

The timestamp will be a decimal representation of the standard Unix epoch-based timestamp, e.g., `284654100`.

## Commands

All commands are newline-terminated (`\n`) strings.

The child process can send one of the following commands:

* `S,filename`
* `A,filename`
* `I,TIMESTAMP`
* `H,message`
* `E,message`
* `O,option`
* `V,name=value[,name=value[,name=value]]`
* `G,name[,name[,name]]`
* `L,log_message`
* `P,TIMESTAMP`
* `T,TIMESTAMP`

The `S` command checks to see if there is a playable audio file with the specified name, and if so, clears the generator's playlist and places the file onto the list. Note that the playability check does not take into account transcoding requirements, so it is possible for the file not to be played even though it was found. If the file does not exist it sends a `Z` response with the data element set to the file requested. If the generator is not currently playing silence, then `T` and `D` events will be sent to signal the playlist interruption and notify it of the files that will not be played.

The `A` command checks to see if there is a playable audio file with the specified name, and if so, appends it to the generator's playlist. The same playability and exception rules apply as for the `S` command.

The `I` command stops any audio currently playing and clears the generator's playlist. The `I` command was added in Asterisk 11.

The `E` command logs the supplied message to the Asterisk log, stops the generator and terminates the `ExternalIVR` application, but continues execution in the dialplan.

The `H` command logs the supplied message to the Asterisk log, stops the generator, hangs up the channel and terminates the ExternalIVR application.

The `O` command allows the child to set/clear options in the ExternalIVR() application. The supported options are:

* `(no)autoclear` - Automatically interrupt and clear the playlist upon reception of DTMF input.

The `T` command will answer an unanswered channel. If it fails either answering the channel or starting the generator it sends a `Z` response of `Z,TIMESTAMP,ANSWER_FAILED` or `Z,TIMESTAMP,GENERATOR_FAILED` respectively.

The `V` command sets the specified channel variable(s) to the specified value(s).

The `G` command gets the specified channel variable(s). Multiple variables are separated by commas. Response is in `name=value` format.

The `P` command gets the parameters passed into `ExternalIVR` minus the options to `ExternalIVR` itself:

If `ExternalIVR` is executed as:

```conf title="extensions.conf"
ExternalIVR(/usr/bin/foo(arg1,arg2),n)

```

The response to the `P` command would be:

```text
P,TIMESTAMP,/usr/bin/foo,arg1,arg2

```

/// note 
This is the only way for a TCP/IP server to be able to get retrieve the arguments.
///

The `L` command puts a message into the Asterisk log.

/// note 
This is preferred to using `stderr` and is the only way for a TCP/IP server to log a message.
///

## Inform Messages

The only inform message that currently exists is a `HANGUP` message, in the form `I,TIMESTAMP,HANGUP` and is used to inform of a hangup when the `i` option is specified.

## Errors

Any newline-terminated (`\n`) output generated by the child process on its `stderr` handle will be copied into the Asterisk log.
