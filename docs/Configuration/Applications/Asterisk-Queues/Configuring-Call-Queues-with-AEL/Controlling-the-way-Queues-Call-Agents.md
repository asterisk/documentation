---
title: Controlling the way Queues Call Agents
pageid: 5243037
---

Notice in the above, that the commands to manipulate agents in queues have "@agents" in their arguments. This is a reference to the agents context:




---

  
  


```


context agents { 
 // General sales queue 
 8010 => {
 Set(QUEUE\_MAX\_PENALTY=10); 
 Queue(sales-general,t); 
 Set(QUEUE\_MAX\_PENALTY=0); 
 Queue(sales-general,t); 
 Set(CALLERID(name)=EmptySalQ); 
 goto dispatch,s,1;
 } 
 // Customer Service queue 
 8011 => { 
 Set(QUEUE\_MAX\_PENALTY=10);
 Queue(customerservice,t); 
 Set(QUEUE\_MAX\_PENALTY=0);
 Queue(customerservice,t); 
 Set(CALLERID(name)=EMptyCSVQ);
 goto dispatch,s,1; 
 } 
 8013 => {
 Dial(iax2/sweatshop/9456@from-ecstacy);
 Set(CALLERID(name)=EmptySupQ); 
 Set(QUEUE\_MAX\_PENALTY=10); 
 Queue(support-dispatch,t); 
 Set(QUEUE\_MAX\_PENALTY=20); 
 Queue(support-dispatch,t);
 Set(QUEUE\_MAX\_PENALTY=0); // means no max 
 Queue(support-dispatch,t); 
 goto dispatch,s,1; 
 } 
 6121 => &callagent(${RAQUEL},${EXTEN}); 
 6165 => &callagent(${SPEARS},${EXTEN});
 6170 => &callagent(${ROCK},${EXTEN}); 
 6070 => &callagent(${SALINE},${EXTEN}); 
}


```



---


In the above, the variables ${RAQUEL}, etc stand for actual devices to ring that person's phone (like DAHDI/37). 


The 8010, 8011, and 8013 extensions are purely for transferring incoming callers to queues. For instance, a customer service agent might want to transfer the caller to talk to sales. The agent only has to transfer to extension 8010, in this case. 


Here is the callagent macro, note that if a person in the queue is called, but does not answer, then they are automatically removed from the queue.




---

  
  


```


macro callagent(device,exten) {
 if( ${GROUP\_COUNT(${exten}@agents)}=0 ) { 
 Set(OUTBOUND\_GROUP\_ONCE=${exten}@agents);
 Dial(${device},300,t);
 switch(${DIALSTATUS}) {
 case BUSY: 
 Busy(); 
 break;
 case NOANSWER:
 Set(queue-announce-success=0);
 goto queues-manip,O${exten},1; 
 default: 
 Hangup(); 
 break; 
 } 
 }
 else { 
 Busy(); 
 } 
}


```



---


In the callagent macro above, the ${exten} will be 6121, or 6165, etc, which is the extension of the agent. 


The use of the GROUP\_COUNT, and OUTBOUND\_GROUP follow this line of thinking. Incoming calls can be queued to ring all agents in the current priority. If some of those agents are already talking, they would get bothersome call-waiting tones. To avoid this inconvenience, when an agent gets a call, the OUTBOUND\_GROUP assigns that conversation to the group specified, for instance 6171@agents. The ${GROUP\_COUNT()} variable on a subsequent call should return "1" for that group. If GROUP\_COUNT returns 1, then the busy() is returned without actually trying to dial the agent.

