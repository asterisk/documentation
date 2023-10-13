 ---
title: Checking Asterisk Requirements
pageid: 4817512
---

## Configuring Asterisk

Now it's time to compile and install Asterisk. Let's change to the directory which contains the Asterisk source code.

```
[root@server]# cd /usr/local/src/asterisk-14.X.Y

```

Next, we'll run a command called **./configure**, which will perform a number of checks on the operating system, and get the Asterisk code ready to compile on this particular server.

```
[root@server asterisk-14.X.Y]# ./configure

```

This will run for a couple of minutes, and warn you of any missing system libraries or other dependencies. Unless you've installed all of the [System Requirements](/Operation/System-Requirements) for your version of Asterisk, the **configure** script is likely to fail. If that happens, resolve the missing dependency manually, or use the [install_prereq](#using-install_prereq) script to resolve all of the dependencies on your system.

Once a dependency is resolved, run **configure** again to make sure the missing dependency is fixed.


!!! tip **  If you have many missing dependencies, you may find yourself running **configure
    a lot. If that is the case, you'll do yourself a favour by checking the [System Requirements](/Operation/System-Requirements) or installing all dependencies via the `install_prereq` script.

      
[//]: # (end-tip)


On this PageUpon successful completion of **./configure**, you should see a message that looks similar to the one shown below. (Obviously, your host CPU type may be different than the below.)

```
              .$$$$$$$$$$$$$$$=..     
            .$7$7..        .7$$7:.   
 .$7$7.. .7$$7:.
 .$$:. ,$7.7
 .$7. 7$$$$ .$$77
 ..$$. $$$$$ .$$$7
 ..7$ .?. $$$$$ .?. 7$$$.
 $.$. .$$$7. $$$$7 .7$$$. .$$$.
 .777. .$$$$$$77$$$77$$$$$7. $$$,
 $$$~ .7$$$$$$$$$$$$$7. .$$$.
.$$7 .7$$$$$$$7: ?$$$.
$$$ ?7$$$$$$$$$$I .$$$7
$$$ .7$$$$$$$$$$$$$$$$ :$$$.
$$$ $$$$$$7$$$$$$$$$$$$ .$$$.
$$$ $$$ 7$$$7 .$$$ .$$$.
$$$$ $$$$7 .$$$.
7$$$7 7$$$$ 7$$$
 $$$$$ $$$
 $$$$7. $$ (TM)
 $$$$$$$. .7$$$$$$ $$
 $$$$$$$$$$$$7$$$$$$$$$.$$$$$$
 $$$$$$$$$$$$$$$$.

configure: Package configured for:&nbsp;
configure: OS type &nbsp;: linux-gnu
configure: Host CPU : x86_64
configure: build-cpu:vendor:os: x86_64 : unknown : linux-gnu :
configure: host-cpu:vendor:os: x86_64 : unknown : linux-gnu :

```



!!! tip Cached Data** The **./configure
    command caches certain data to speed things up if it's invoked multiple times. To clear all the cached data, you can use the following command to completely clear out any cached data from the Asterisk build system.
[//]: # (end-tip)


  
  

```
[root@server asterisk-14.X.Y]# make distclean
  



---


You can then re-run **./configure**.

```


## Using install_prereq

The **install_prereq** script is included with every release of Asterisk in the `contrib/scripts` subdirectory. The script has the following options:

* **test** - print only the libraries to be installed.
* **install** - install package dependencies only. Depending on your distribution of Linux, version of Asterisk, and capabilities you wish to use, this may be sufficient.
* **install-unpackaged** - install dependencies that don't have packages but only have tarballs. You may need these dependencies for certain capabilities in Asterisk.




!!! warning 
    You should always use your operating system's package management tools to ensure that your system is running the latest software **before** running `install_prereq`. Ubuntu 14's libsnmp-dev package, for instance, has an issue where it will attempt to remove critical system packages if the system isn't updated before an attempt is made to install that package.

      
[//]: # (end-warning)

```
[root@server asterisk-14.X.Y]# cd contrib/scripts

[root@server asterisk-14.X.Y/contrib/scripts]# ./install_prereq install

[root@server asterisk-14.X.Y/contrib/scripts]# ./install_prereq install-unpackaged

```

