---
title: CLI Syntax and Help Commands
pageid: 28315594
---

Command Syntax and Availability
===============================

Commands follow a general syntax of **<module name> <action type> <parameters>**.

For example:

* **sip show peers** - returns a list of chan\_sip loaded peers
* **voicemail show users** - returns a list of app\_voicemail loaded users
* **core set debug 5** - sets the core debug to level 5 verbosity.




---

**Note:**  Commands are provided by the core, or by Asterisk modules. If the component that provides the commands is not loaded, then the commands it provides won't be available.

  



---


Asterisk does support command aliases. You can find information in the [Asterisk CLI Configuration](/Asterisk-CLI-Configuration) section.

Finding Help at the CLI
=======================

Command-line Completion
-----------------------

The Asterisk CLI supports command-line completion on all commands, including many arguments. To use it, simply press the **<Tab>** key at any time while entering the beginning of any command. If the command can be completed unambiguously, it will do so, otherwise it will complete as much of the command as possible. Additionally, Asterisk will print a list of all possible matches, if possible.

On this Page


Listing commands and showing usage
----------------------------------

Once on the console, the 'help' alias (for 'core show help') may be used to see a large list of commands available for use.




---

  
  


```

\*CLI> help
! -- Execute a shell command
acl show -- Show a named ACL or list all named ACLs
ael reload -- Reload AEL configuration
...

```



---


The 'help' alias may also be used to obtain more detailed information on how to use a particular command and listing sub-commands. For example, if you type 'help core show', Asterisk will respond with a list of all commands that start with that string. If you type 'help core show version', specifying a complete command, Asterisk will respond with a usage message which describes how to use that command. As with other commands on the Asterisk console, the help command also responds to tab command line completion.




---

  
  


```

\*CLI> help core show
core show applications [like|describing] -- Shows registered dialplan applications
core show application -- Describe a specific dialplan application
...

```



---




---

  
  


```

\*CLI> help core show version
Usage: core show version
 Shows Asterisk version information.

```



---


Help for functions, applications and more
-----------------------------------------

A big part of working with Asterisk involves making use of Asterisk applications and functions. Often you'll want to know usage details for these, including their overall behavior or allowed arguments and parameters.

The command  **`core show application <application name>`**  or similarly  **`core show function <function name>`** will show you the usage and arguments.




---

  
  


```

\*CLI> core show application Wait
 -= Info about application 'Wait' =- 
[Synopsis]
Waits for some time.

[Description]
This application waits for a specified number of <seconds>.

[Syntax]
Wait(seconds)

[Arguments]
seconds
 Can be passed with fractions of a second. For example, '1.5' will
 ask the application to wait for 1.5 seconds.

```



---


Module Configuration Help
-------------------------

A very useful addition to Asterisk's help and documentation features is the command **`config show help`**. This command provides detailed information about configuration files, option sections in those files, and options within the sections.




---

  
  


```

\*CLI> help config show help
Usage: config show help [<module> [<type> [<option>]]]
 Display detailed information about module configuration.
 \* If nothing is specified, the modules that have
 configuration information are listed.
 \* If <module> is specified, the configuration types
 for that module will be listed, along with brief
 information about that type.
 \* If <module> and <type> are specified, detailed
 information about the type is displayed, as well
 as the available options.
 \* If <module>, <type>, and <option> are specified,
 detailed information will be displayed about that
 option.
 NOTE: the help documentation is partially generated at run
 time when a module is loaded. If a module is not loaded,
 configuration help for that module may be incomplete.

```



---


For example maybe we see the 'callerid' option in a pjsip.conf file sent to us from a friend. We want to know what that option configures. If we know that pjsip.conf is provided by the res\_pjsip module then we can find help on that configuration option.




---

  
  


```

\*CLI> config show help res\_pjsip endpoint callerid
[endpoint]
callerid = [(null)] (Default: n/a) (Regex: False)

CallerID information for the endpoint

 Must be in the format 'Name <Number>', or only '<Number>'. 

```



---


