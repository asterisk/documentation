---
title: Basic SLA Configuration Example
pageid: 4816942
---

This is an example of the most basic SLA setup. It uses the automatic dialplan generation so the configuration is minimal.   

sla.conf:




---

  
  


```


[line1]
type=trunk 
device=DAHDI/1 
autocontext=line1 

[line2] 
type=trunk 
device=DAHDI/2 
autocontext=line2 

[station] 
type=station 
trunk=line1 
trunk=line2 
autocontext=sla_stations 

[station1](station) 
device=SIP/station1 

[station2](station) 
device=SIP/station2 

[station3](station) 
device=SIP/station3


```


With this configuration, the dialplan is generated automatically. The first DAHDI channel should have its context set to "line1" and the second should be set to "line2" in dahdi.conf. In sip.conf, station1, station2, and station3 should all have their context set to "sla_stations".   





---

  
  


```


[line1] 
exten => s,1,SLATrunk(line1) 

[line2] 
exten => s,2,SLATrunk(line2) 

[sla_stations] 
exten => station1,1,SLAStation(station1) 
exten => station1_line1,hint,SLA:station1_line1 
exten => station1_line1,1,SLAStation(station1_line1) 
exten => station1_line2,hint,SLA:station1_line2 
exten => station1_line2,1,SLAStation(station1_line2) 
exten => station2,1,SLAStation(station2) 
exten => station2_line1,hint,SLA:station2_line1 
exten => station2_line1,1,SLAStation(station2_line1) 
exten => station2_line2,hint,SLA:station2_line2 
exten => station2_line2,1,SLAStation(station2_line2) 
exten => station3,1,SLAStation(station3) 
exten => station3_line1,hint,SLA:station3_line1 
exten => station3_line1,1,SLAStation(station3_line1) 
exten => station3_line2,hint,SLA:station3_line2 
exten => station3_line2,1,SLAStation(station3_line2)


```


