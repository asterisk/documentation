---
title: Configuration of users.conf
pageid: 5243056
---

The asterisk-gui sets up extensions, SIP/IAX2 peers, and a host of other settings. User-specific settings are stored in users.conf. If the asterisk-gui is not being used, manual entries to users.conf can be made.


### The [general] section


There are only two settings in the general section of users.conf that apply to phone provisioning: localextenlength which maps to template variable EXTENSION\_LENGTH and vmexten which maps to the VOICEMAIL\_EXTEN variable.


### Individual Users


To enable auto-provisioning of a phone, the user in users.conf needs to have:




---

  
  


```


... 
autoprov=yes
macaddress=deadbeef4dad
profile=polycom


```


The profile is optional if a default\_profile is set in phoneprov.conf. The following is a sample users.conf entry, with the template variables commented next to the settings:




---

  
  


```


[6001]
callwaiting = yes 
context = numberplan-custom-1 
hasagent = no 
hasdirectory = yes 
hasiax = no 
hasmanager = no 
hassip = yes 
hasvoicemail = yes 
host = dynamic 
mailbox = 6001 
threewaycalling = yes 
deletevoicemail = no 
autoprov = yes 
profile = polycom 
directmedia = no 
nat = no 
fullname = User Two ; ${DISPLAY\_NAME} 
secret = test ; ${SECRET} 
username = 6001 ; ${USERNAME} 
macaddress = deadbeef4dad ; ${MAC} 
label = 6001 ; ${LABEL} 
cid\_number = 6001 ; ${CALLERID}


```


The variables above, are the user-specfic variables that can be substituted into dynamic filenames and config templates.

