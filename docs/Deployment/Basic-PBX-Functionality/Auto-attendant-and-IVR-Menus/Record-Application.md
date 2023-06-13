---
title: Record Application
pageid: 4817379
---

For creating your own auto-attendant or IVR menus, you're probably going to want to record your own custom prompts. An easy way to do this is with the **Record()** application. The **Record()** application plays a beep, and then begins recording audio until you press the hash key (**#**) on your keypad. It then saves the audio to the filename specified as the first parameter to the application and continues on to the next priority in the extension. If you hang up the call before pressing the hash key, the audio will not be recorded. For example, the following extension records a sound prompt called **custom-menu** in the **gsm** format in the **en/** sub-directory, and then plays it back to you.


javascriptexten => 6597,1,Answer(500)
 same => n,Record(en/custom-menu.gsm)
 same => n,Wait(1)
 same => n,Playback(custom-menu)
 same => n,Hangup()
Recording FormatsWhen specifiying a file extension when using the **Record()** application, you must choose a file extension which represents one of the supported file formats in Asterisk. For the complete list of file formats supported in your Asterisk installation, type **core show file formats** at the Asterisk command-line interface.


You've now learned the basics of how to create a simple auto-attendant menu. Now let's build a more practical menu for callers to be able to reach Alice or Bob or the dial-by-name directory.


####  Procedure 216.1. Building a Practical Auto-Attendant Menu


1. Add an extension 6599 to the [docs:users] context which sends the calls to a new context we'll build called [docs:day-menu]. Your extension should look something like:
	* javascriptexten=>6599,1,Goto(day-menu,s,1)
2. Add a new context called **[docs:day-menu]**, with the following contents:
	* javascript[day-menu]
	exten => s,1,Answer(500)
	same => n(loop),Background(custom-menu)
	same => n,WaitExten()
	
	exten => 1,1,Goto(users,6001,1)
	
	exten => 2,1,Goto(users,6002,1)
	
	exten => 9,1,Directory(vm-demo,users,fe)
	exten => \*,1,VoiceMailMain(@vm-demo)
	
	exten => i,1,Playback(option-is-invalid) 
	same => n,Goto(s,loop)
	
	exten => t,1,Playback(are-you-still-there)
	same => n,Goto(s,loop)


1. Dial extension **6597** to record your auto-attendant sound prompt. Your sound prompt should say something like "Thank you for calling! Press one for Alice, press two for Bob, or press 9 for a company directory". Press the hash key (**#**) on your keypad when you're finished recording, and Asterisk will play it back to you. If you don't like it, simply dial extension **6597** again to re-record it.
2. Dial extension **6599** to test your auto-attendant menu.


In just a few lines of code, you've created your own auto-attendant menu. Feel free to experiment with your auto-attendant menu before moving on to the next section.

