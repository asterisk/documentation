---
title: Creating Dialplan Extensions
pageid: 4817416
---

The last things we need to do to enable Alice and Bob to call each other is to configure a couple of extensions in the dialplan.




!!! info ""
    ##### What is an Extension?

    When dealing with Asterisk, the term extension does not represent a physical device such as a phone. An extension is simply a set of actions in the dialplan which may or may not write a physical device. In addition to writing a phone, an extensions might be used for such things auto-attendant menus and conference bridges. In this guide we will be careful to use the words phone or device when referring to the physical phone, and extension when referencing the set of instructions in the Asterisk dialplan.

      
[//]: # (end-info)



Let's take a quick look at the dialplan, and then add two extensions.

Open **extensions.conf**, and take a quick look at the file. Near the top of the file, you'll see some general-purpose sections named [general] and [globals]. Any sections in the dialplan beneath those two sections is known as a [**context**](/Configuration/Dialplan/Contexts-Extensions-and-Priorities). The sample **extensions.conf** file has a number of other contexts, with names like [demo] and [default].

We cover the concept of contexts more in [Dialplan](/Configuration/Dialplan), but for now you should know that each phone or outside connection in Asterisk points at a single context. If the dialed extension does not exist in the specified context, Asterisk will reject the call. That means it is important to understand that the **context** option in your sip.conf or pjsip.conf configuration is what tells Asterisk to direct the call from the endpoint to the context we build in the next step.

Go to the bottom of your **extensions.conf** file, and add a new context named **[from-internal]**.

##### Naming Your Dialplan Contexts

There's nothing special about the name **from-internal** for this context. It could have been named **strawberry_milkshake**, and it would have behaved exactly the same way. It is considered best practice, however, to name your contexts for the types of extensions that are contained in that context. Since this context contains extensions that will be dialing from inside the network, we'll call it from-internal.

Underneath that context name, we'll create an extesion numbered **6001** which attempts to ring Alice's phone for twenty seconds, and an extension **6002** which attempts to rings Bob's phone for twenty seconds.

```javascript title=" " linenums="1"
[from-internal]
exten=>6001,1,Dial(SIP/demo-alice,20)
exten=>6002,1,Dial(SIP/demo-bob,20)

```



!!! note 
    Each channel driver can have its own way of dialling it. The above example is for use when dialing chan_sip extensions. If you are using PJSIP then you would dial "PJSIP/demo-alice" and "PJSIP/demo-bob" respectively.

      
[//]: # (end-note)





After adding that section to **extensions.conf**, go to the Asterisk command-line interface and tell Asterisk to reload the dialplan by typing the command **dialplan reload**. You can verify that Asterisk successfully read the configuration file by typing **dialplan show from-internal** at the CLI.

```
server\*CLI> dialplan show from-internal
[ Context 'from-internal' created by 'pbx_config' ]
 '6001' => 1. Dial(SIP/demo-alice,20) [pbx_config]
 '6002' => 1. Dial(SIP/demo-bob,20) [pbx_config]

-= 2 extensions (2 priorities) in 1 context. =- 

```

Now we're ready to make a test call!




!!! tip 
    Learn more about dialplan format in the [Contexts, Extensions, and Priorities](/Configuration/Dialplan/Contexts-Extensions-and-Priorities) section.

      
[//]: # (end-tip)



