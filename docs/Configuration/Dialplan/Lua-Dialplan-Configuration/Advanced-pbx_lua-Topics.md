---
title: Advanced pbx_lua Topics
pageid: 16548044
---

Behind the scenes, a number of things happen to make the integration of lua into Asterisk as seamless as possible. Some details of how this integration works can be found below.


`extensions.lua` Load Process
-----------------------------


The `extensions.lua` file is loaded into memory once when the pbx\_lua module is loaded or reloaded. The file is then read from memory and executed once for each channel that looks up or executes a lua based extension. Since the file is executed once for each channel, it may not be wise to do things like connect to external services directly from the main script or build your extensions table from a webservice or database.




---

  
This is probably a bad idea.  


```


-- my fancy extensions.lua

extensions = {}
extensions.default = {}

-- might be a bad idea, this will run each time a channel is created
data = query\_webservice\_for\_extensions\_list("site1")

for \_, e in ipairs(data) do
 extensions.default[e.exten] = function()
 app.dial("SIP/" .. e.sip\_peer, e.dial\_timeout)
 end
end


```


The `extensions` Table
----------------------


The `extensions` table is a standard lua table and can be defined however you like. The pbx\_lua module loads and sorts the table when it is needed. The keys in the table are context names and each value is another lua table containing extensions. Each key in the context table is an extension name and each value is an extension function.




---

  
  


```


extensions = {
 context\_table = {
 extension1 = function()
 end;
 extension2 = function()
 end;
 };
}


```


Where did the priorities go?
----------------------------


There are no priorities. Asterisk uses priorities to define the order in which dialplan operations occur. The pbx\_lua module uses functions to define extensions and execution occurs within the lua interpreter, priorities don't make sense in this context. To Asterisk, each pbx\_lua extension appears as an extension with one priority. Lua extensions can be referenced using the context name, extension, and priority 1, e.g. `Goto(default,1234,1)`. You would only reference extensions this way from outside of pbx\_lua (i.e. from `extensions.conf` or `extensions.ael`). From with in pbx\_lua you can just execute that extension's function. 




---

  
  


```

extensions.default["1234"]("default", "1234")

```


Lua Script Lifetime
-------------------


The same lua state is used for the lifetime of the Asterisk channel it is running on, so effectively, the script has the lifetime of the channel. This means you can set global variables in the lua state and retrieve them later from a different extension if necessary.


Apps, Functions, and Variables
------------------------------


*Details on accessing dialplan applications and functions and channel variables can be found in the [Interacting with Asterisk from Lua (apps, variables, and functions)](/Configuration/Dialplan/Lua-Dialplan-Configuration/Interacting-with-Asterisk-from-Lua-apps-variables-and-functions) page.*


 When accessing a dialplan application or function or a channel variable, a placeholder object is generated that provides the `:get()` and `:set()` methods.




---

  
channel variable: var is the placeholder object  


```


var = channel.my\_variable
var:set("my value")
value = var:get("my value")


```




---

  
dialplan function: fax\_modems is the placeholder object  


```


fax\_modems = channel.FAXOPT("module")

-- the function arguments are stored in the placeholder

fax\_modems:set("v17")
value = fax\_modems:get()


```




---

  
dialplan application: dial is the placeholder object  


```


dial = app.dial

-- the only thing we can do with it is execute it
dial("SIP/100")


```


There is a small cost in creating the placeholder objects so storing frequently used placeholder objects can be used as a micro optimization. This should never be necessary though and only provides benefits if you are running micro benchmarks.

