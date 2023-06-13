---
title: Routing Incoming Calls to Queues
pageid: 5243020
---

Then in extensions.ael, you can do these things:

The Main Menu  
 At Digium, incoming callers are sent to the "mainmenu" context, where they are greeted, and directed to the numbers they choose...

context mainmenu {
 includes {
 digium;
 queues-loginout;
 }
 0 => goto dispatch,s,1; 
 2 => goto sales,s,1;
 3 => goto customerservice,s,1;
 4 => goto dispatch,s,1;
 s => {
 Ringing();
 Wait(1);
 Set(attempts=0); 
 Answer(); 
 Wait(1); 
 Background(digium/ThankYouForCallingDigium);
 Background(digium/YourOpenSourceTelecommunicationsSupplier); 
 WaitExten(0.3);
 repeat: 
 Set(attempts=$[${attempts} + 1]); 
 Background(digium/IfYouKnowYourPartysExtensionYouMayDialItAtAnyTime); 
 WaitExten(0.1);
 Background(digium/Otherwise); 
 WaitExten(0.1); 
 Background(digium/ForSalesPleasePress2); 
 WaitExten(0.2);
 Background(digium/ForCustomerServicePleasePress3); 
 WaitExten(0.2);
 Background(digium/ForAllOtherDepartmentsPleasePress4); 
 WaitExten(0.2); 
 Background(digium/ToSpeakWithAnOperatorPleasePress0AtAnyTime); 
 if( ${attempts} < 2 ) { 
 WaitExten(0.3); 
 Background(digium/ToHearTheseOptionsRepeatedPleaseHold);
 }
 WaitExten(5);
 if( ${attempts} < 2 ) goto repeat; 
 Background(digium/YouHaveMadeNoSelection); 
 Background(digium/ThisCallWillBeEnded); 
 Background(goodbye); 
 Hangup(); 
 } 
}
The Contexts referenced from the queues.conf file

context sales {
 0 => goto dispatch,s,1;
 8 => Voicemail(${SALESVM});
 s => {
 Ringing();
 Wait(2); 
 Background(digium/ThankYouForContactingTheDigiumSalesDepartment); 
 WaitExten(0.3); 
 Background(digium/PleaseHoldAndYourCallWillBeAnsweredByOurNextAvailableSalesRepresentative); 
 WaitExten(0.3); 
 Background(digium/AtAnyTimeYouMayPress0ToSpeakWithAnOperatorOr8ToLeaveAMessage); 
 Set(CALLERID(name)=Sales); 
 Queue(sales-general,t); 
 Set(CALLERID(name)=EmptySalQ); 
 goto dispatch,s,1; 
 Playback(goodbye); 
 Hangup(); 
 } 
}
Please note that there is only one attempt to queue a call in the sales queue. All sales agents that are logged in will be rung.

context customerservice { 
 0 => {
 Set(CALLERID(name)=CSVTrans); 
 goto dispatch,s,1; 
 } 
 8 => Voicemail(${CUSTSERVVM}); 
 s => {
 Ringing(); 
 Wait(2); 
 Background(digium/ThankYouForCallingDigiumCustomerService); 
 WaitExten(0.3); 
 notracking: Background(digium/PleaseWaitForTheNextAvailableCustomerServiceRepresentative); 
 WaitExten(0.3); 
 Background(digium/AtAnyTimeYouMayPress0ToSpeakWithAnOperatorOr8ToLeaveAMessage); 
 Set(CALLERID(name)=Cust Svc); 
 Set(QUEUE\_MAX\_PENALTY=10); 
 Queue(customerservice,t);
 Set(QUEUE\_MAX\_PENALTY=0); 
 Queue(customerservice,t); 
 Set(CALLERID(name)=EmptyCSVQ); 
 goto dispatch,s,1; 
 Background(digium/NoCustomerServiceRepresentativesAreAvailableAtThisTime); 
 Background(digium/PleaseLeaveAMessageInTheCustomerServiceVoiceMailBox); 
 Voicemail(${CUSTSERVVM}); 
 Playback(goodbye); 
 Hangup(); 
 } 
}
Note that calls coming into customerservice will first be try to queue calls to those agents with a QUEUE\_MAX\_PENALTY of 10, and if none are available, then all agents are rung.

context dispatch {
 s => {
 Ringing();
 Wait(2); 
 Background(digium/ThankYouForCallingDigium); 
 WaitExten(0.3);
 Background(digium/YourCallWillBeAnsweredByOurNextAvailableOperator); 
 Background(digium/PleaseHold); 
 Set(QUEUE\_MAX\_PENALTY=10);
 Queue(dispatch,t); 
 Set(QUEUE\_MAX\_PENALTY=20); 
 Queue(dispatch,t); 
 Set(QUEUE\_MAX\_PENALTY=0);
 Queue(dispatch,t);
 Background(digium/NoOneIsAvailableToTakeYourCall); 
 Background(digium/PleaseLeaveAMessageInOurGeneralVoiceMailBox);
 Voicemail(${DISPATCHVM}); 
 Playback(goodbye); 
 Hangup(); 
 }
}
And in the dispatch context, first agents of priority 10 are tried, then 20, and if none are available, all agents are tried.

Notice that a common pattern is followed in each of the three queue contexts:

First, you set QUEUE\_MAX\_PENALTY to a value, then you call Queue(queue-name,option,...) (see the Queue application documetation for details)

In the above, note that the "t" option is specified, and this allows the agent picking up the incoming call the luxury of transferring the call to other parties.

The purpose of specifying the QUEUE\_MAX\_PENALTY is to develop a set of priorities amongst agents. By the above usage, agents with lower number priorities will be given the calls first, and then, if no-one picks up the call, the QUEUE\_MAX\_PENALTY will be incremented, and the queue tried   
 again. Hopefully, along the line, someone will pick up the call, and the Queue application will end with a hangup.

The final attempt to queue in most of our examples sets the QUEUE\_MAX\_PENALTY to zero, which means to try all available agents.

