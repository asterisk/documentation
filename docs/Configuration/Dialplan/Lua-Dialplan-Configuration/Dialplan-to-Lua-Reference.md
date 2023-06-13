---
title: Dialplan to Lua Reference
pageid: 16548022
---

Below is a quick reference that can be used to translate traditional `extensions.conf` dialplan concepts to their analog in `extensions.lua`.


extensions.conf|extensions.lua
Extension Patterns
------------------


Extension pattern matching syntax on logic works the same for `extensions.conf` and `extensions.lua`.



50%

extensions.conf
---------------



[users]
exten => \_1XX,1,Dial(SIP/${EXTEN})

exten => \_2XX,1,Voicemail(${EXTEN:1})

50%

extensions.lua
--------------



extensions = {}
extensions.users = {}

extensions.users["\_1XX"] = function(c, e)
 app.dial("SIP/" .. e)
end

extensions.users["\_2XX"] = function(c, e)
 app.voicemail("1" .. e:sub(2))
end


Context Includes
----------------



50%

extensions.conf
---------------



[users]
exten => 100,1,Noop
exten => 100,n,Dial("SIP/100")

[demo]
exten => s,1,Noop
exten => s,n,Playback(demo-congrats)

[default]
include => demo
include => users


50%

extensions.lua
--------------



extensions = {
 users = {
 [100] = function()
 app.dial("SIP/100")
 end;
 };

 demo = {
 ["s"] = function()
 app.playback(demo-congrats)
 end;
 };
 
 default = {
 include = {"demo", "users"};
 };
}

Loops
-----



50%

extensions.conf
---------------



exten => 100,1,Noop
exten => 100,n,Set(i=0)
exten => 100,n,While($[i < 10])
exten => 100,n,Verbose(i = ${i})
exten => 100,n,EndWhile

50%

extensions.lua
--------------



i = 0
while i < 10 do
 app.verbose("i = " .. i)
end

Variables
---------



50%

extensions.conf
---------------



exten => 100,1,Set(my\_variable=my\_value)
exten => 100,n,Verbose(my\_variable = ${my\_variable})

50%

extensions.lua
--------------



channel.my\_variable = "my\_value"
app.verbose("my\_variable = " .. channel.my\_variable:get())

Applications
------------



50%

extensions.conf
---------------



exten => 100,1,Dial("SIP/100",,m)

50%

extensions.lua
--------------



app.dial("SIP/100", nil, "m")

Macros/GoSub
------------


*Macros can be defined in pbx\_lua by naming a context 'macro-\*' just as in `extensions.conf`, but generally where you would use macros or gosub in `extensions.conf` you would simply use a function in lua.*



50%

extensions.conf
---------------



[macro-dial]
exten => s,1,Noop
exten => s,n,Dial(${ARG1})

[default]
exten => 100,1,Macro(dial,SIP/100)

50%

extensions.lua
--------------



extensions = {}
extensions.default = {}

function dial(resource)
 app.dial(resource)
end

extensions.default[100] = function()
 dial("SIP/100")
end

Goto
----


*While `Goto` is an extenstions.conf staple, it should generally be avoided in pbx\_lua in favor of functions.*



50%

extensions.conf
---------------



[default]
exten => 100,1,Goto(102,1)

exten => 102,1,Playback("demo-thanks")
exten => 102,n,Hangup

50%

extensions.lua
--------------



extensions = {}
extensions.default = {}

function do\_hangup()
 app.playback("demo-thanks")
 app.hangup()
end

extensions.default[100] = function()
 do\_hangup()
end



The `app.goto()` function will not work as expected in pbx\_lua in Asterisk 1.8. If you must use `app.goto()` you must manually return control back to asterisk using `return` from the dialplan extension function, otherwise execution will continue after the call to `app.goto()`. Calls to `app.goto()` should work as expected in Asterisk 10 but still should not be necessary in most cases.


In Asterisk 1.8, use return
function extension\_function(c, e)
 return app.goto("default", "100", 1)

 -- without that 'return' the rest of the function would execute normally
 app.verbose("Did you forget to use 'return'?")
end
