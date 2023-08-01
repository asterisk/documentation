---
title: Installing Blink SIP client
pageid: 27200094
---

Overview
========

I wanted to provide some brief instructions on installing the Blink SIP client on Linux since it is useful for running the [Secure Calling Tutorial](/Deployment/Secure-Calling/Secure-Calling-Tutorial).

How to install Blink on Ubuntu 12.04 Precise Pangolin
=====================================================

Install some dependencies
-------------------------

1. \*Get latest Python 2.X
2. Setup repo from here: <http://projects.ag-projects.com/projects/documentation/wiki/Repositories>
3. In your terminal, run the following commands

```
sudo apt-get update
sudo apt-get install python-sipsimple python-gnutls python-eventlib python-application python-cjson python-eventlet python-qt4 python-twisted-core python-zope.interface

```
If you have issues see: <http://sipsimpleclient.org/projects/sipsimpleclient/wiki/SipInstallation>

Download and install Blink
--------------------------

1. Download Blink source code from <http://download.ag-projects.com/BlinkQt>
2. In your terminal, extract the tar.gz file contents to a folder and then **cd** to that folder in the terminal
3. Change directory into the Blink folder and run **sudo python setup.py install**

```
root@newtonr-laptop:/usr/src/blink-0.6.0# sudo python setup.py install
running install
running build
running build_py
running build_scripts
running install_lib
running install_scripts
changing mode of /usr/local/bin/blink to 755
running install_data
running install_egg_info
Removing /usr/local/lib/python2.7/dist-packages/blink-0.6.0.egg-info
Writing /usr/local/lib/python2.7/dist-packages/blink-0.6.0.egg-info

```
Run Blink!
----------

1. From the command line, run Blink by executing blink.  

```
root@newtonr-laptop:/usr/src/blink-0.6.0# blink
using set_wakeup_fd
"sni-qt/6493" WARN 08:11:15.444 void StatusNotifierItemFactory::connectToSnw() Invalid interface to SNW_SERVICE 

```
2. Blink should launch and show up within your graphical desktop.






!!! note 
    Blink doesn't appear to support call forwarding or call transfers, so don't expect to do anything too fancy!

      
[//]: # (end-note)



