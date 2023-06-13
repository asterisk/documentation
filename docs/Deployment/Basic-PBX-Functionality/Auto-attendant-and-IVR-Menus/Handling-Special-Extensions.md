---
title: Handling Special Extensions
pageid: 4817377
---

We have the basics of an auto-attendant created, but now let's make it a bit more robust. We need to be able to handle special situations, such as when the caller enters an invalid extension, or doesn't enter an extension at all. Asterisk has a set of special extensions for dealing with situations like there. They all are named with a single letter, so we recommend you don't create any other extensions named with a single letter. You can read about all the Special Dialplan Extensions on the wiki.

 



---

Let's add a few more lines to our **[docs:demo-menu]** context, to handle invalid entries and timeouts. Modify your **[docs:demo-menu]** context so that it matches the one below:

javascript[demo-menu]
exten => s,1,Answer(500)
 same => n(loop),Background(press-1&or&press-2)
 same => n,WaitExten()

exten => 1,1,Playback(you-entered)
 same => n,SayNumber(1)
 same => n,Goto(s,loop)

exten => 2,1,Playback(you-entered)
 same => n,SayNumber(2)
 same => n,Goto(s,loop)

exten => i,1,Playback(option-is-invalid)
 same => n,Goto(s,loop)

exten => t,1,Playback(are-you-still-there)
 same => n,Goto(s,loop)Now dial your auto-attendant menu again (by dialing extension **6598**), and try entering an invalid option (such as **3**) at the auto-attendant menu. If you watch the Asterisk command-line interface while you dial and your verbosity level is three or higher, you should see something similar to the following:

-- Executing [6598@users:1] Goto("SIP/demo-alice-00000008", "demo-menu,s,1") in new stack
-- Goto (demo-menu,s,1)
-- Executing [s@demo-menu:1] Answer("SIP/demo-alice-00000008", "500") in new stack
-- Executing [s@demo-menu:2] BackGround("SIP/demo-alice-00000008", "press-1&or&press-2") in new stack
-- <SIP/demo-alice-00000008> Playing 'press-1.gsm' (language 'en')
-- <SIP/demo-alice-00000008> Playing 'or.gsm' (language 'en')
-- <SIP/demo-alice-00000008> Playing 'press-2.gsm' (language 'en')
-- Invalid extension '3' in context 'demo-menu' on SIP/demo-alice-00000008
-- Executing [i@demo-menu:1] Playback("SIP/demo-alice-00000008", "option-is-invalid") in new stack
-- <SIP/demo-alice-00000008> Playing 'option-is-invalid.gsm' (language 'en')
-- Executing [i@demo-menu:2] Goto("SIP/demo-alice-00000008", "s,loop") in new stack
-- Goto (demo-menu,s,2)
-- Executing [s@demo-menu:2] BackGround("SIP/demo-alice-00000008", "press-1&or&press-2") in new stack
-- <SIP/demo-alice-00000008> Playing 'press-1.gsm' (language 'en')
-- <SIP/demo-alice-00000008> Playing 'or.gsm' (language 'en')
-- <SIP/demo-alice-00000008> Playing 'press-2.gsm' (language 'en')If you don't enter anything at the auto-attendant menu and instead wait approximately ten seconds, you should hear (and see) Asterisk go to the **t** extension as well.

