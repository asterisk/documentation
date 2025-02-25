---
search:
  boost: 0.5
title: Dial
---

# Dial()

### Synopsis

Attempt to connect to another device or endpoint and bridge the call.

### Description

This application will place calls to one or more specified channels. As soon as one of the requested channels answers, the originating channel will be answered, if it has not already been answered. These two channels will then be active in a bridged call. All other channels that were requested will then be hung up.<br>

Unless there is a timeout specified, the Dial application will wait indefinitely until one of the called channels answers, the user hangs up, or if all of the called channels are busy or unavailable. Dialplan execution will continue if no requested channels can be called, or if the timeout expires. This application will report normal termination if the originating channel hangs up, or if the call is bridged and either of the parties in the bridge ends the call.<br>

If the **OUTBOUND\_GROUP** variable is set, all peer channels created by this application will be put into that group (as in 'Set(GROUP()=...'). If the **OUTBOUND\_GROUP\_ONCE** variable is set, all peer channels created by this application will be put into that group (as in 'Set(GROUP()=...'). Unlike **OUTBOUND\_GROUP**, however, the variable will be unset after use.<br>

``` title="Example: Dial with 30 second timeout"

same => n,Dial(PJSIP/alice,30)


```
``` title="Example: Parallel dial with 45 second timeout"

same => n,Dial(PJSIP/alice&PJIP/bob,45)


```
``` title="Example: Dial with 'g' continuation option"

same => n,Dial(PJSIP/alice,,g)
same => n,Log(NOTICE, Alice call result: ${DIALSTATUS})


```
``` title="Example: Dial with transfer/recording features for calling party"

same => n,Dial(PJSIP/alice,,TX)


```
``` title="Example: Dial with call length limit"

same => n,Dial(PJSIP/alice,,L(60000:30000:10000))


```
``` title="Example: Dial alice and bob and send NO_ANSWER to bob instead of ANSWERED_ELSEWHERE when alice answers"

same => n,Dial(PJSIP/alice&PJSIP/bob,,Q(NO_ANSWER))


```
``` title="Example: Dial with pre-dial subroutines"

[default]
exten => callee_channel,1,NoOp(ARG1=${ARG1} ARG2=${ARG2})
same => n,Log(NOTICE, I'm called on channel ${CHANNEL} prior to it starting the dial attempt)
same => n,Return()
exten => called_channel,1,NoOp(ARG1=${ARG1} ARG2=${ARG2})
same => n,Log(NOTICE, I'm called on outbound channel ${CHANNEL} prior to it being used to dial someone)
same => n,Return()
exten => _X.,1,NoOp()
same => n,Dial(PJSIP/alice,,b(default^called_channel^1(my_gosub_arg1^my_gosub_arg2))B(default^callee_channel^1(my_gosub_arg1^my_gosub_arg2)))
same => n,Hangup()


```
``` title="Example: Dial with post-answer subroutine executed on outbound channel"

[my_gosub_routine]
exten => s,1,NoOp(ARG1=${ARG1} ARG2=${ARG2})
same => n,Playback(hello)
same => n,Return()
[default]
exten => _X.,1,NoOp()
same => n,Dial(PJSIP/alice,,U(my_gosub_routine^my_gosub_arg1^my_gosub_arg2))
same => n,Hangup()


```
``` title="Example: Dial into ConfBridge using 'G' option"

same => n,Dial(PJSIP/alice,,G(jump_to_here))
same => n(jump_to_here),Goto(confbridge)
same => n,Goto(confbridge)
same => n(confbridge),ConfBridge(${EXTEN})


```
This application sets the following channel variables:<br>


* `DIALEDTIME` - This is the time from dialing a channel until when it is disconnected.<br>

* `DIALEDTIME_MS` - This is the milliseconds version of the DIALEDTIME variable.<br>

* `ANSWEREDTIME` - This is the amount of time for actual call.<br>

* `ANSWEREDTIME_MS` - This is the milliseconds version of the ANSWEREDTIME variable.<br>

* `RINGTIME` - This is the time from creating the channel to the first RINGING event received. Empty if there was no ring.<br>

* `RINGTIME_MS` - This is the milliseconds version of the RINGTIME variable.<br>

* `PROGRESSTIME` - This is the time from creating the channel to the first PROGRESS event received. Empty if there was no such event.<br>

* `PROGRESSTIME_MS` - This is the milliseconds version of the PROGRESSTIME variable.<br>

* `DIALEDPEERNAME` - The name of the outbound channel that answered the call.<br>

* `DIALEDPEERNUMBER` - The number that was dialed for the answered outbound channel.<br>

* `FORWARDERNAME` - If a call forward occurred, the name of the forwarded channel.<br>

* `DIALSTATUS` - This is the status of the call<br>

    * `CHANUNAVAIL` - Either the dialed peer exists but is not currently reachable, e.g. endpoint is not registered, or an attempt was made to call a nonexistent location, e.g. nonexistent DNS hostname.

    * `CONGESTION` - Channel or switching congestion occured when routing the call. This can occur if there is a slow or no response from the remote end.

    * `NOANSWER` - Called party did not answer.

    * `BUSY` - The called party was busy or indicated a busy status. Note that some SIP devices will respond with 486 Busy if their Do Not Disturb modes are active. In this case, you can use DEVICE\_STATUS to check if the endpoint is actually in use, if needed.

    * `ANSWER` - The call was answered. Any other result implicitly indicates the call was not answered.

    * `CANCEL` - Dial was cancelled before call was answered or reached some other terminating event.

    * `DONTCALL` - For the Privacy and Screening Modes. Will be set if the called party chooses to send the calling party to the 'Go Away' script.

    * `TORTURE` - For the Privacy and Screening Modes. Will be set if the called party chooses to send the calling party to the 'torture' script.

    * `INVALIDARGS` - Dial failed due to invalid syntax.

### Syntax


```

Dial(Technology/Resource&[Technology2/Resource2[&...]],[timeout,[options,[URL]]]])
```
##### Arguments


* `Technology/Resource`

    * `Technology/Resource` **required** - Specification of the device(s) to dial. These must be in the format of 'Technology/Resource', where _Technology_ represents a particular channel driver, and _Resource_ represents a resource available to that particular channel driver.<br>

    * `Technology2/Resource2[,Technology2/Resource2...]` - Optional extra devices to dial in parallel<br>
If you need more than one enter them as Technology2/Resource2&Technology3/Resource3&.....<br>

    * __Technology: DAHDI__<br>
DAHDI allows several modifiers to be specified as part of the resource.<br>
The general syntax is :<br>
Dial(DAHDI/pseudo[/extension])<br>
Dial(DAHDI/<channel#>[c|r<cadence#>|d][/extension])<br>
Dial(DAHDI/(g|G|r|R)<group#(0-63)>[c|r<cadence#>|d][/extension])<br>
The following modifiers may be used before the channel number:<br>

        * `g` - Search forward, dialing on first available channel in group (lowest to highest).<br>

        * `G` - Search backward, dialing on first available channel in group (highest to lowest).<br>

        * `r` - Round robin search forward, picking up from where last left off (lowest to highest).<br>

        * `R` - Round robin search backward, picking up from where last left off (highest to lowest).<br>
The following modifiers may be used after the channel number:<br>

        * `c` - Wait for DTMF digit '#' before providing answer supervision.<br>
This can be useful on outbound calls via FXO ports, as otherwise they would indicate answer immediately.<br>

        * `d` - Force bearer capability for ISDN/SS7 call to digital.<br>

        * `i` - ISDN span channel restriction.<br>
Used by CC to ensure that the CC recall goes out the same span. Also to make ISDN channel names dialable when the sequence number is stripped off. (Used by DTMF attended transfer feature.)<br>

        * `r` - Specifies the distinctive ring cadence number to use immediately after specifying this option. There are 4 default built-in cadences, and up to 24 total cadences may be configured.<br>
``` title="Example: Dial 555-1212 on first available channel in group 1, searching from highest to lowest"

same => n,Dial(DAHDI/g1/5551212)


```
``` title="Example: Ringing FXS channel 4 with ring cadence 2"

same => n,Dial(DAHDI/4r2)


```
``` title="Example: Dial 555-1212 on channel 3 and require answer confirmation"

same => n,Dial(DAHDI/3c/5551212)


```

    * __Technology: IAX2__<br>
The general syntax is:<br>
Dial(IAX2/[username[:password]@]peer[:port][/exten[@context]][/options]<br>
IAX2 optionally allows modifiers to be specified after the extension.<br>

        * `a` - Request auto answer (supporting equipment/configuration required)<br>

* `timeout` - Specifies the number of seconds we attempt to dial the specified devices.<br>
If not specified, this defaults to 136 years.<br>

* `options`

    * `A(x:y)` - Play an announcement to the called and/or calling parties, where _x_ is the prompt to be played to the called party and _y_ is the prompt to be played to the caller. The files may be different and will be played to each party simultaneously.<br>

        * `x` - The file to play to the called party<br>

        * `y` - The file to play to the calling party<br>


    * `a` - Immediately answer the calling channel when the called channel answers in all cases. Normally, the calling channel is answered when the called channel answers, but when options such as 'A()' and 'M()' are used, the calling channel is not answered until all actions on the called channel (such as playing an announcement) are completed. This option can be used to answer the calling channel before doing anything on the called channel. You will rarely need to use this option, the default behavior is adequate in most cases.<br>


    * `b(context^exten^priority)` - Before initiating an outgoing call, 'Gosub' to the specified location using the newly created channel. The 'Gosub' will be executed for each destination channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `B(context^exten^priority)` - Before initiating the outgoing call(s), 'Gosub' to the specified location using the current channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `C` - Reset the call detail record (CDR) for this call.<br>


    * `c` - If the Dial() application cancels this call, always set **HANGUPCAUSE** to 'answered elsewhere'<br>


    * `d` - Allow the calling user to dial a 1 digit extension while waiting for a call to be answered. Exit to that extension if it exists in the current context, or the context defined in the **EXITCONTEXT** variable, if it exists.<br>
NOTE: Many SIP and ISDN phones cannot send DTMF digits until the call is connected. If you wish to use this option with these phones, you can use the 'Answer' application before dialing.<br>


    * `D(called:calling:progress:mfprogress:mfwink:sfprogress:sfwink)` - Send the specified DTMF strings *after* the called party has answered, but before the call gets bridged. The _called_ DTMF string is sent to the called party, and the _calling_ DTMF string is sent to the calling party. Both arguments can be used alone. If _progress_ is specified, its DTMF is sent to the called party immediately after receiving a 'PROGRESS' message.<br>
See 'SendDTMF' for valid digits.<br>
If _mfprogress_ is specified, its MF is sent to the called party immediately after receiving a 'PROGRESS' message. If _mfwink_ is specified, its MF is sent to the called party immediately after receiving a 'WINK' message.<br>
See 'SendMF' for valid digits.<br>
If _sfprogress_ is specified, its SF is sent to the called party immediately after receiving a 'PROGRESS' message. If _sfwink_ is specified, its SF is sent to the called party immediately after receiving a 'WINK' message.<br>
See 'SendSF' for valid digits.<br>

        * `called`

        * `calling`

        * `progress`

        * `mfprogress`

        * `mfwink`

        * `sfprogress`

        * `sfwink`


    * `E` - Enable echoing of sent MF or SF digits back to caller (e.g. "hearpulsing"). Used in conjunction with the D option.<br>


    * `e` - Execute the 'h' extension for peer after the call ends<br>


    * `f(x)` - If _x_ is not provided, force the CallerID sent on a call-forward or deflection to the dialplan extension of this 'Dial()' using a dialplan 'hint'. For example, some PSTNs do not allow CallerID to be set to anything other than the numbers assigned to you. If _x_ is provided, force the CallerID sent to _x_.<br>

        * `x`


    * `F(context^exten^priority)` - When the caller hangs up, transfer the *called* party to the specified destination and *start* execution at that location.<br>
NOTE: Any channel variables you want the called channel to inherit from the caller channel must be prefixed with one or two underbars ('\_').<br>

        * `context`

        * `exten`

        * `priority` **required**


    * `F` - When the caller hangs up, transfer the *called* party to the next priority of the current extension and *start* execution at that location.<br>
NOTE: Any channel variables you want the called channel to inherit from the caller channel must be prefixed with one or two underbars ('\_').<br>
NOTE: Using this option from a Macro() or GoSub() might not make sense as there would be no return points.<br>


    * `g` - Proceed with dialplan execution at the next priority in the current extension if the destination channel hangs up.<br>


    * `G(context^exten^priority)` - If the call is answered, transfer the calling party to the specified _priority_ and the called party to the specified _priority_ plus one.<br>
NOTE: You cannot use any additional action post answer options in conjunction with this option.<br>

        * `context`

        * `exten`

        * `priority` **required**


    * `h` - Allow the called party to hang up by sending the DTMF sequence defined for disconnect in *features.conf*.<br>


    * `H` - Allow the calling party to hang up by sending the DTMF sequence defined for disconnect in *features.conf*.<br>
NOTE: Many SIP and ISDN phones cannot send DTMF digits until the call is connected. If you wish to allow DTMF disconnect before the dialed party answers with these phones, you can use the 'Answer' application before dialing.<br>


    * `i` - Asterisk will ignore any forwarding requests it may receive on this dial attempt.<br>


    * `I` - Asterisk will ignore any connected line update requests or any redirecting party update requests it may receive on this dial attempt.<br>


    * `k` - Allow the called party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `K` - Allow the calling party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `L(x:y:z)` - Limit the call to _x_ milliseconds. Play a warning when _y_ milliseconds are left. Repeat the warning every _z_ milliseconds until time expires.<br>
This option is affected by the following variables:<br>

        * `LIMIT_PLAYAUDIO_CALLER` - If set, this variable causes Asterisk to play the prompts to the caller.<br>

            * `YES` default: (true)

            * `NO`

        * `LIMIT_PLAYAUDIO_CALLEE` - If set, this variable causes Asterisk to play the prompts to the callee.<br>

            * `YES`

            * `NO` default: (true)

        * `LIMIT_TIMEOUT_FILE` - If specified, _filename_ specifies the sound prompt to play when the timeout is reached. If not set, the time remaining will be announced.<br>

            * `FILENAME`

        * `LIMIT_CONNECT_FILE` - If specified, _filename_ specifies the sound prompt to play when the call begins. If not set, the time remaining will be announced.<br>

            * `FILENAME`

        * `LIMIT_WARNING_FILE` - If specified, _filename_ specifies the sound prompt to play as a warning when time _x_ is reached. If not set, the time remaining will be announced.<br>

            * `FILENAME`

        * `x` **required** - Maximum call time, in milliseconds<br>

        * `y` - Warning time, in milliseconds<br>

        * `z` - Repeat time, in milliseconds<br>


    * `m(class)` - Provide hold music to the calling party until a requested channel answers. A specific music on hold _class_ (as defined in *musiconhold.conf*) can be specified.<br>

        * `class`


    * `M(macro^arg)` - Execute the specified _macro_ for the *called* channel before connecting to the calling channel. Arguments can be specified to the Macro using '\^' as a delimiter. The macro can set the variable **MACRO\_RESULT** to specify the following actions after the macro is finished executing:<br>
NOTE: You cannot use any additional action post answer options in conjunction with this option. Also, pbx services are run on the peer (called) channel, so you will not be able to set timeouts via the 'TIMEOUT()' function in this macro.<br>
WARNING: Be aware of the limitations that macros have, specifically with regards to use of the 'WaitExten' application. For more information, see the documentation for 'Macro()'.<br>
NOTE: Macros are deprecated, GoSub should be used instead, see the 'U' option.<br>

        * `MACRO_RESULT` - If set, this action will be taken after the macro finished executing.<br>

            * `ABORT` - Hangup both legs of the call

            * `CONGESTION` - Behave as if line congestion was encountered

            * `BUSY` - Behave as if a busy signal was encountered

            * `CONTINUE` - Hangup the called party and allow the calling party to continue dialplan execution at the next priority

            * `GOTO:\[\[<CONTEXT>\^\]<EXTEN>\^\]<PRIORITY>` - Transfer the call to the specified destination.

        * `macro` **required** - Name of the macro that should be executed.<br>

        * `arg[^arg...]` - Macro arguments<br>


    * `n(delete)` - This option is a modifier for the call screening/privacy mode. (See the 'p' and 'P' options.) It specifies that no introductions are to be saved in the *priv-callerintros* directory.<br>

        * `delete` - With _delete_ either not specified or set to '0', the recorded introduction will not be deleted if the caller hangs up while the remote party has not yet answered.<br>
With _delete_ set to '1', the introduction will always be deleted.<br>


    * `N` - This option is a modifier for the call screening/privacy mode. It specifies that if CallerID is present, do not screen the call.<br>


    * `o(x)` - If _x_ is not provided, specify that the CallerID that was present on the *calling* channel be stored as the CallerID on the *called* channel. This was the behavior of Asterisk 1.0 and earlier. If _x_ is provided, specify the CallerID stored on the *called* channel. Note that 'o($\{CALLERID(all)\})' is similar to option 'o' without the parameter.<br>

        * `x`


    * `O(mode)` - Enables *operator services* mode. This option only works when bridging a DAHDI channel to another DAHDI channel only. If specified on non-DAHDI interfaces, it will be ignored. When the destination answers (presumably an operator services station), the originator no longer has control of their line. They may hang up, but the switch will not release their line until the destination party (the operator) hangs up.<br>

        * `mode` - With _mode_ either not specified or set to '1', the originator hanging up will cause the phone to ring back immediately.<br>
With _mode_ set to '2', when the operator flashes the trunk, it will ring their phone back.<br>


    * `p` - This option enables screening mode. This is basically Privacy mode without memory.<br>


    * `P(x)` - Enable privacy mode. Use _x_ as the family/key in the AstDB database if it is provided. The current extension is used if a database family/key is not specified.<br>

        * `x`


    * `Q(cause)` - Specify the Q.850/Q.931 _cause_ to send on unanswered channels when another channel answers the call. As with 'Hangup()', _cause_ can be a numeric cause code or a name such as 'NO\_ANSWER', 'USER\_BUSY', 'CALL\_REJECTED' or 'ANSWERED\_ELSEWHERE' (the default if Q isn't specified). You can also specify '0' or 'NONE' to send no cause. See the *causes.h* file for the full list of valid causes and names.<br>
NOTE: chan\_sip does not support setting the cause on a CANCEL to anything other than ANSWERED\_ELSEWHERE.<br>

        * `cause` **required**


    * `r(tone)` - Default: Indicate ringing to the calling party, even if the called party isn't actually ringing. Pass no audio to the calling party until the called channel has answered.<br>

        * `tone` - Indicate progress to calling party. Send audio 'tone' from the *indications.conf* tonezone currently in use.<br>


    * `R` - Default: Indicate ringing to the calling party, even if the called party isn't actually ringing. Allow interruption of the ringback if early media is received on the channel.<br>


    * `S(x)` - Hang up the call _x_ seconds *after* the called party has answered the call.<br>

        * `x` **required**


    * `s(x)` - Force the outgoing CallerID tag parameter to be set to the string _x_.<br>
Works with the 'f' option.<br>

        * `x` **required**


    * `t` - Allow the called party to transfer the calling party by sending the DTMF sequence defined in *features.conf*. This setting does not perform policy enforcement on transfers initiated by other methods.<br>


    * `T` - Allow the calling party to transfer the called party by sending the DTMF sequence defined in *features.conf*. This setting does not perform policy enforcement on transfers initiated by other methods.<br>


    * `U(x^arg)` - Execute via 'Gosub' the routine _x_ for the *called* channel before connecting to the calling channel. Arguments can be specified to the 'Gosub' using '\^' as a delimiter. The 'Gosub' routine can set the variable **GOSUB\_RESULT** to specify the following actions after the 'Gosub' returns.<br>
NOTE: You cannot use any additional action post answer options in conjunction with this option. Also, pbx services are run on the *called* channel, so you will not be able to set timeouts via the 'TIMEOUT()' function in this routine.<br>

        * `GOSUB_RESULT`

            * `ABORT` - Hangup both legs of the call.

            * `CONGESTION` - Behave as if line congestion was encountered.

            * `BUSY` - Behave as if a busy signal was encountered.

            * `CONTINUE` - Hangup the called party and allow the calling party to continue dialplan execution at the next priority.

            * `GOTO:\[\[<CONTEXT>\^\]<EXTEN>\^\]<PRIORITY>` - Transfer the call to the specified destination.

        * `x` **required** - Name of the subroutine context to execute via 'Gosub'. The subroutine execution starts in the named context at the s exten and priority 1.<br>

        * `arg[^arg...]` - Arguments for the 'Gosub' routine<br>


    * `u(x)` - Works with the 'f' option.<br>

        * `x` **required** - Force the outgoing callerid presentation indicator parameter to be set to one of the values passed in _x_: 'allowed\_not\_screened' 'allowed\_passed\_screen' 'allowed\_failed\_screen' 'allowed' 'prohib\_not\_screened' 'prohib\_passed\_screen' 'prohib\_failed\_screen' 'prohib' 'unavailable'<br>


    * `w` - Allow the called party to enable recording of the call by sending the DTMF sequence defined for one-touch recording in *features.conf*.<br>


    * `W` - Allow the calling party to enable recording of the call by sending the DTMF sequence defined for one-touch recording in *features.conf*.<br>


    * `x` - Allow the called party to enable recording of the call by sending the DTMF sequence defined for one-touch automixmonitor in *features.conf*.<br>


    * `X` - Allow the calling party to enable recording of the call by sending the DTMF sequence defined for one-touch automixmonitor in *features.conf*.<br>


    * `z` - On a call forward, cancel any dial timeout which has been set for this call.<br>


* `URL` - The optional URL will be sent to the called party if the channel driver supports it.<br>

### See Also

* [Dialplan Applications RetryDial](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/RetryDial)
* [Dialplan Applications SendDTMF](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendDTMF)
* [Dialplan Applications Gosub](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications Macro](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Macro)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 