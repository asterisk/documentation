---
title: Asterisk Main Configuration File
pageid: 4620296
---

The asterisk.conf file
======================

asterisk.conf is used to configure the locations of directories and files used by Asterisk, as well as options relevant to the core of Asterisk.

[Link to the asterisk.conf.sample](http://svnview.digium.com/svn/asterisk/trunk/configs/asterisk.conf.sample?view=markup) file in the Asterisk trunk subversion repo. The information below could become out of date, so always check the relevant sample file in our version control system.

asterisk.conf has two primary contexts, shown below with some descriptions about their content.

A Note on Includes
------------------

[Includes](/Fundamentals/Asterisk-Configuration/Asterisk-Configuration-Files/Using-The-include-tryinclude-and-exec-Constructs) in this file will only work with absolute paths, as the configuration in this file is setting the relative paths that would be used in includes set in other files.

Directories Context
-------------------

```
[directories](!)
astetcdir => /etc/asterisk
astmoddir => /usr/lib/asterisk/modules
astvarlibdir => /var/lib/asterisk
astdbdir => /var/lib/asterisk
astkeydir => /var/lib/asterisk
astdatadir => /var/lib/asterisk
astagidir => /var/lib/asterisk/agi-bin
astspooldir => /var/spool/asterisk
astrundir => /var/run/asterisk
astlogdir => /var/log/asterisk
astsbindir => /usr/sbin

```

The directories listed above are explained in detail in the [Directory and File Structure](/Fundamentals/Directory-and-File-Structure) page.

Options Context
---------------

Some additional annotation for each configuration option is included inline.

!!! note 
    TODO: Match this up with what is current in the sample, and update both.

[//]: # (end-note)

```
 [options] 
;Under "options" you can enter configuration options 
;that you also can set with command line options 
; Verbosity level for logging (-v) verbose = 0 
; Debug: "No" or value (1-4) 
debug = 3 

; Background execution disabled (-f) 
nofork=yes | no 

; Always background, even with -v or -d (-F) 
alwaysfork=yes | no 

; Console mode (-c) 
console= yes | no 

; Execute with high priority (-p) 
highpriority = yes | no 

; Initialize crypto at startup (-i) 
initcrypto = yes | no 

; Disable ANSI colors (-n) 
nocolor = yes | no 

; Dump core on failure (-g) 
dumpcore = yes | no 

; Run quietly (-q) 
quiet = yes | no 

; Force timestamping in CLI verbose output (-T) 
timestamp = yes | no 

; User to run asterisk as (-U) NOTE: will require changes to 
; directory and device permissions 
runuser = asterisk 

; Group to run asterisk as (-G) 
rungroup = asterisk 

; Enable internal timing support (-I) 
internal_timing = yes | no 

; Language Options 
documentation_language = en | es | ru 

; These options have no command line equivalent 

; Cache record() files in another directory until completion 
cache_record_files = yes | no 
record_cache_dir = <dir> 

; Build transcode paths via SLINEAR 
transcode_via_sln = yes | no 

; send SLINEAR silence while channel is being recorded 
transmit_silence_during_record = yes | no 

; The maximum load average we accept calls for 
maxload = 1.0 

; The maximum number of concurrent calls you want to allow 
maxcalls = 255 

; Stop accepting calls when free memory falls below this amount specified in MB 
minmemfree = 256 

; Allow #exec entries in configuration files 
execincludes = yes | no 

; Don't over-inform the Asterisk sysadm, he's a guru 
dontwarn = yes | no 

; System name. Used to prefix CDR uniqueid and to fill \${SYSTEMNAME} 
systemname = <a_string> 

; Should language code be last component of sound file name or first? 
; when off, sound files are searched as <path>/<lang>/<file> 
; when on, sound files are search as <lang>/<path>/<file> 
; (only affects relative paths for sound files) 
languageprefix = yes | no 

; Locking mode for voicemail 
; - lockfile: default, for normal use 
; - flock: for where the lockfile locking method doesn't work 
; eh. on SMB/CIFS mounts 
lockmode = lockfile | flock 

; Entity ID. This is in the form of a MAC address. It should be universally 
; unique. It must be unique between servers communicating with a protocol 
; that uses this value. The only thing that uses this currently is DUNDi, 
; but other things will use it in the future. 
; entityid=00:11:22:33:44:55 

[files]
; Changing the following lines may compromise your security 
; Asterisk.ctl is the pipe that is used to connect the remote CLI
; (asterisk -r) to Asterisk. Changing these settings change the 
; permissions and ownership of this file. 
; The file is created when Asterisk starts, in the "astrundir" above. 
;astctlpermissions = 0660 
;astctlowner = root 
;astctlgroup = asterisk 
;astctl = asterisk.ctl

```
