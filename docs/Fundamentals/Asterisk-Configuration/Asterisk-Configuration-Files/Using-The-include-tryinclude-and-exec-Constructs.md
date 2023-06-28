---
title: Using The include, tryinclude and exec Constructs
pageid: 4817459
---

include, tryinclude and exec
============================




!!! info ""
    You might have arrived here looking for [Include Statements](/Configuration/Dialplan/Include-Statements) specific to Asterisk dialplan.

      
[//]: # (end-info)



There are two other constructs we can use within all of our configuration files. They are **#include** and **#exec**.

The **#include** construct tells Asterisk to read in the contents of another configuration file, and act as though the contents were at this location in this configuration file. The syntax is **#include filename**, where **filename** is the name of the file you'd like to include. This construct is most often used to break a large configuration file into smaller pieces, so that it's more manageable. The asterisk/star character will be parsed in the path, allowing for the inclusion of an entire directory of files. If the target file specified does not exist, then Asterisk will not load the module that contains configuration with the #include directive.

The **#tryinclude** construct is the same as #include except it won't stop Asterisk from loading the module when the target file does not exist.

The **#exec** takes this one step further. It allows you to execute an external program, and place the output of that program into the current configuration file. The syntax is **#exec program**, where **program** is the name of the program you'd like to execute.

The **#exec**, **#include**, and #**tryinclude** constructs do not work in the following configuration files:

* asterisk.conf
* modules.conf

 




!!! note 
    #### Enabling #exec Functionality

    The #exec construct is not enabled by default, as it has some risks both in terms of performance and security. To enable this functionality, go to the **asterisk.conf** configuration file (by default located in */etc/asterisk*) and set **execincludes=yes** in the **[options]** section. By default both the **[options]** section heading and the **execincludes=yes** option have been commented out, you you'll need to remove the semicolon from the beginning of both lines.

      
[//]: # (end-note)



Examples
--------

Let's look at example of both constructs in action. This is a generic example meant to illustrate the syntax usage inside a configuration file.




```javascript title=" " linenums="1"
[section-name]
setting=true
#include otherconfig.conf ; include another configuration file
#include my_other_files/\*.conf ; include all .conf files in the subdirectory my_other_files
#exec otherprogram ; include output of otherprogram

```


You can use #tryinclude if there is any chance the target file may not exist and you still want Asterisk to load the configuration for the module.

Here is a more realistic example of how #exec might be used with real-world commands.




```bash title=" " linenums="1"
#exec /usr/bin/curl -s http://example.com/mystuff > /etc/asterisk/mystuff
#include mystuff

```


