---
title: Lua Dialplan Tips and Tricks
pageid: 16548028
---

Long Running Operations (Autoservcie)
-------------------------------------

Before starting long running operations, an autoservice should be started using the `autoservice_start()` function. An autoservice will ensure that the user hears a continuous stream of audio while your lua code works in the background. This autoservice will automatically be stopped before executing applications and dialplan functions and will be restarted afterwards. The autoservice can be stopped using autoservice_stop() and the autoservice_status() function will return `true` if an autoservice is currently running.

```
app.startmusiconhold()

autoservice_start()
do_expensive_db_query()
autoservice_stop()

app.stopmusiconhold()

```



!!! info ""
    In Asterisk 10 an autoservice is automatically started for you by default.

      
[//]: # (end-info)



Defining Extensions Dynamically
-------------------------------

Since extensions are functions in pbx_lua, any function can be used, including closures. A function can be defined that returns extension functions and used to populate the extensions table.




---

  
extensions.lua  

```
extensions = {}
extensions.default = {}

function sip_exten(e)
 return function()
 app.dial("SIP/" .. e)
 end
end

extensions.default[100] = sip_exten(100)
extensions.default[101] = sip_exten(101)

```

Creating Custom Aliases for Built-in Constructs
-----------------------------------------------

If you don't like the `app` table being named 'app' or if you think typing 'channel' to access the `channel` table is too much work, you can rename them.




---

  
I prefer less typing  

```
function my_exten(context, extensions)
 c = channel
 a = app

 c.my_variable = "my new channel variable"
 a.dial("SIP/100")
end

```

Re-purposing The `print` Function
---------------------------------

Lua has a built in "print" function that outputs things to stdout, but for Asterisk, we would rather have the output go in the verbose log. To do so, we could rewrite the `print` function as follows.

```
function print(...)
 local msg = ""
 for i=1,select('#', ...) do
 if i == 1 then
 msg = msg .. tostring(select(i, ...))
 else
 msg = msg .. "\t" .. tostring(select(i, ...))
 end
 end

 app.verbose(msg)
end

```

Splitting Configuration into Multiple Files
-------------------------------------------

The `require` method can be used to load lua modules located in LUA_PATH.  The `dofile` method can be used to include any file by path name.

Using External Modules
----------------------

Lua modules can be loaded using the standard `require` lua method. Some of the functionality provided by various lua modules is already included in Asterisk (e.g. func_odbc provides what LuaSQL provides). It is generally better to use code built-in to Asterisk over external lua modules. Specifically, the func_odbc module uses a connection pool to provide database resources, where as with LuaSQL each channel would have to make a new connection to the database on its own.

Compile extensions.lua
----------------------

The `luac` program can be used to compile your `extensions.lua` file into lua bytecode. This will slightly increase performance as pbx_lua will no longer need to parse `extensions.lua` on load. The `luac` compiler will also detect and report any syntax errors. To use `luac`, rename your `extensions.lua` file and then run `luac` as follows.




---

  
Assume you name your extensions.lua file extensions.lua.lua  

```
luac -o extensions.lua extensions.lua.lua

```

The pbx_lua module automatically knows the difference between a lua text file and a lua bytecode file.

