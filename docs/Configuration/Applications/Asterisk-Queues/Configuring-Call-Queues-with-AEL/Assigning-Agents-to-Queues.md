---
title: Assigning Agents to Queues
pageid: 5243024
---

In this example dialplan, we want to be able to add and remove agents to handle incoming calls, as they feel they are available. As they log in, they are added to the queue's agent list, and as they log out, they are removed. If no agents are available, the queue command will terminate, and it is the duty of the dialplan to do something appropriate, be it sending the incoming caller to voicemail, or trying the queue again with a higher QUEUE_MAX_PENALTY.


Because a single agent can make themselves available to more than one queue, the process of joining multiple queues can be handled automatically by the dialplan.


##### Agents Log In and Out

```

context queues-loginout {
 6092 => {
 Answer(); 
 Read(AGENT_NUMBER,agent-enternum); 
 VMAuthenticate(${AGENT_NUMBER}@default,s); 
 Set(queue-announce-success=1); 
 goto queues-manip,I${AGENT_NUMBER},1; 
 } 
 6093 => { 
 Answer(); 
 Read(AGENT_NUMBER,agent-enternum); 
 Set(queue-announce-success=1); 
 goto queues-manip,O${AGENT_NUMBER},1;
 }
}

```

In the above contexts, the agents dial 6092 to log into their queues, and they dial 6093 to log out of their queues. The agent is prompted for their agent number, and if they are logging in, their passcode, and then they are transferred to the proper extension in the queues-manip context. The queues-manip context does all the actual work:

```

context queues-manip {
 // Raquel Squelch 
 _[IO]6121 => {
 &queue-addremove(dispatch,10,${EXTEN}); 
 &queue-success(${EXTEN}); 
 }
 // Brittanica Spears
 _[IO]6165 => {
 &queue-addremove(dispatch,20,${EXTEN}); 
 &queue-success(${EXTEN}); 
 }
 // Rock Hudson
 _[IO]6170 => {
 &queue-addremove(sales-general,10,${EXTEN}); 
 &queue-addremove(customerservice,20,${EXTEN});
 &queue-addremove(dispatch,30,${EXTEN});
 &queue-success(${EXTEN}); 
 }
 // Saline Dye-on 
 _[IO]6070 => {
 &queue-addremove(sales-general,20,${EXTEN});
 &queue-addremove(customerservice,30,${EXTEN});
 &queue-addremove(dispatch,30,${EXTEN});
 &queue-success(${EXTEN}); 
 }
}

```

In the above extensions, note that the queue-addremove macro is used to actually add or remove the agent from the applicable queue, with the applicable priority level. Note that agents with a priority level of 10 will be called before agents with levels of 20 or 30. 


In the above example, Raquel will be dialed first in the dispatch queue, if she has logged in. If she is not, then the second call of Queue() with priority of 20 will dial Brittanica if she is present, otherwise the third call of Queue() with MAX_PENALTY of 0 will dial Rock and Saline simultaneously. 


Also note that Rock will be among the first to be called in the sales-general queue, and among the last in the dispatch queue. As you can see in main menu, the callerID is set in the main menu so they can tell which queue incoming calls are coming from. 


The call to queue-success() gives some feedback to the agent as they log in and out, that the process has completed.

```

macro queue-success(exten) {
 if( ${queue-announce-success} > 0 ) {
 switch(${exten:0:1}) {
 case I:
 Playback(agent-loginok);
 Hangup();
 break;
 case O:
 Playback(agent-loggedoff);
 Hangup();
 break;
 }
 }
}

```

The queue-addremove macro is defined in this manner:

```

macro queue-addremove(queuename,penalty,exten) {
 switch(${exten:0:1}) {
 case I: // Login 
 AddQueueMember(${queuename},Local/${exten:1}@agents,${penalty});
 break; 
 case O: // Logout
 RemoveQueueMember(${queuename},Local/${exten:1}@agents); 
 break;
 case P: // Pause
 PauseQueueMember(${queuename},Local/${exten:1}@agents); 
 break;
 case U: // Unpause
 UnpauseQueueMember(${queuename},Local/${exten:1}@agents); 
 break;
 default: // Invalid
 Playback(invalid); 
 break;
 }
}

```

Basically, it uses the first character of the exten variable, to determine the proper actions to take. In the above dial plan code, only the cases I or O are used, which correspond to the Login and Logout actions.

