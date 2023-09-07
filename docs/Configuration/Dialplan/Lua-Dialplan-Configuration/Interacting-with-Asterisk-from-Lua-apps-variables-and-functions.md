---
title: Interacting with Asterisk from Lua (apps, variables, and functions)
pageid: 16548029
---

Interaction with is done through a series of predefined objects provided by pbx_lua. The `app` table is used to access dialplan applications. Any asterisk application can be accessed and executed as if it were a function attached to the `app` table. Dialplan variables and functions are accessed and executed via the `channel` table.

!!! note Naming Conflicts Between Lua and Asterisk
    Asterisk applications, variables or functions whose names conflict with Lua reserved words or contain special characters must be referenced using the `[]` operator. For example, Lua 5.2 introduced the `goto` control statement which conflicts with the Asterisk `goto` dialplan application. So...
    
[//]: # (end-note)

!!! warning
    The following will cause pbx_lua.so to fail to load with Lua 5.2 or later because `goto` is a reserved word.

```
app.goto("default", 1000, 1)  
```

!!! tip 
    The following will work with all Lua versions...
```
app["goto"] ("default", 1000, 1)
```

## Dialplan Applications

---
extensions.lua  

```
app.playback("please-hold")
app.dial("SIP/100", nil, "m")

```

Any dialplan application can be executed using the `app` table. Application names are case insensitive. Arguments are passed to dialplan applications just as arguments are passed to functions in lua. String arguments must be quoted as they are lua strings. Empty arguments may be passed as `nil` or as empty strings.

## Channel Variables
  
### Set a Variable  

```
channel.my_variable = "my_value"

```

After this the channel variable `${my_variable`} contains the value "my_value".


### Read a Variable  

```
value = channel.my_variable:get()

```

Any channel variable can be read and set using the `channel` table. Local and global lua variables can be used as they normally would and are completely unrelated to channel variables.

!!! warning 
    The following construct will NOT work.
[//]: # (end-warning)

```
value = channel.my_variable -- does not work as expected (value:get() could be used to get the value after this line)
```

!!! tip 
    If the variable name is an Lua reserved word or contains characters that Lua considers special use the `[]` operator to access them.
[//]: # (end-tip)

```
channel["my_variable"] = "my_value"
value = channel["my_variable"]:get()

```

## Dialplan Functions

### Write a Dialplan Function  

```
channel.FAXOPT("modems"):set("v17,v27,v29")

```

### Read a Dialplan Function  

```
value = channel.FAXOPT("modems"):get()

```

Note the use of the `:` operator with the `get()` and `set()` methods.


!!! tip 
    If the function name is an Lua reserved word or contains characters that Lua considers special use the `[]` operator to access them.
[//]: # (end-tip)

```
channel["FAXOPT(modems)"] = "v17,v27,v29"
value = channel["FAXOPT(modems)"]:get()
```

!!! warning 
    The following constructs will NOT work.
[//]: # (end-warning)

```
channel.FAXOPT("modems") = "v17,v27,v29" -- syntax error
value = channel.FAXOPT("modems") -- does not work as expected (value:get() could be used to get the value after this line)

```

!!! info ""
    Dialplan function names are case sensitive.

      
[//]: # (end-info)

