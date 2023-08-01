---
title: About the Sounds Tools
pageid: 5243125
---

The following sections will describe the sound tools in more detail and explain what they are used for in the sounds package creation process.


### audiofilter


The audiofilter application is used to "tune" the sound files in such a way that they sound good when being used while in a compressed format. The values in the scripts for creating the sound files supplied in repotools is essentially a high-pass filter that drops out audio below 100Hz (or so). 


(There is an ITU specification that states for 8KHz audio that is being compressed frequencies below a certain threshold should be removed because they make the resulting compressed audio sound worse than it should.) 


The audiofilter application is used by the 'converter' script located in the scripts subdirectory of repotools/sound_tools. The values being passed to the audiofilter application is as follows:

```

audiofilter -n 0.86916 -1.73829 0.86916 -d 1.00000 -1.74152 0.77536

```

The two options -n and -d are 'numerator' and 'denominator'. Per the author, Jean-Marc Valin, "These values are filter coefficients (-n means numerator, -d is denominator) expressed in the z-transform domain. There represent an elliptic filter that I designed with Octave such that 'the result sounds good'."


### makeg722


The makeg722 application is used by the 'converters' script to generate the G.722 sound files that are shipped with Asterisk. It starts with the RAW sound files and then converts them to G.722.


### scripts


The scripts folder is where all the magic happens. These are the scripts that the Asterisk open source team use to build the packaged audio files for the various formats that are distributed with Asterisk.


* chkcore - used to check that the contents of core-sounds-lang.txt are in sync
* chkextra - same as above, but checks the extra sound files
* mkcore - script used to generate the core sounds packages
* mkextra - script used to generate the extra sounds packages
* mkmoh - script used to generate the music on hold packages
* converters - script used to convert the master files to various formats


