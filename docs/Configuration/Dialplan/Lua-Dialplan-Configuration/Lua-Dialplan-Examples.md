---
title: Lua Dialplan Examples
pageid: 16548020
---

Some example `extensions.lua` files can be found below. They demonstrate various ways to organize extensions.


Less Clutter
------------


Instead of defining every extension inline, you can use this method to create a neater `extensions.lua` file. Since the extensions table and each context are both normal lua tables, you can treat them as such and build them piece by piece.




---

  
extensions.lua  


```


-- this function serves as an extension function directly
function call\_user(c, user)
 app.dial("SIP/" .. user, 60)
end

-- this function returns an extension function
function call\_sales\_queue(queue)
 return function(c, e)
 app.queue(queue)
 end
end

e = {}

e.default = {}
e.default.include = {"users", "sales"}

e.users = {}
e.users["100"] = call\_user
e.users["101"] = call\_user

e.sales = {}
e.sales["5000"] = call\_sales\_queue("sales1")
e.sales["6000"] = call\_sales\_queue("sales2")

extensions = e


```


Less Clutter v2
---------------


In this example, we use a fancy function to register extensions.




---

  
extensions.lua  


```


function register(context, extension, func)
 if not extensions then
 extensions = {}
 end

 if not extensions[context] then
 extensions[context] = {}
 end

 extensions[context][extension] = func
end

function include(context, included\_context)
 if not extensions then
 extensions = {}
 end

 if not extensions[context] then
 extensions[context] = {}
 end

 if not extensions[context].include then
 extensions[context].include = {}
 end

 table.insert(extensions[context].include, included\_context)
end

-- this function serves as an extension function directly
function call\_user(c, user)
 app.dial("SIP/" .. user, 60)
end

-- this function returns an extension function
function call\_sales\_queue(queue)
 return function(c, e)
 app.queue(queue)
 end
end

include("default", "users")
include("default", "sales")

register("users", "100", call\_user)
register("users", "101", call\_user)

register("sales", "5000", call\_sales\_queue("sales1"))
register("sales", "6000", call\_sales\_queue("sales2"))
register("sales", "7000", function()
 app.queue("sales3")
end)



```


