---
title: Overview
pageid: 16548006
---

Asterisk supports the ability to write dialplan instructions in the [Lua](http://lua.org) programming language. This method can be used as an alternative to or in combination with [extensions.conf](/Configuration/Dialplan) and/or [AEL](/Configuration/Dialplan/Asterisk-Extension-Language-AEL). PBX lua allows users to use the full power of lua to develop telephony applications using Asterisk. Lua dialplan configuration is done in the `extensions.lua` file.




!!! info "Dependencies"
    To use pbx_lua, the lua development libraries must be installed before Asterisk is configured and built. You can get these libraries directly from <http://lua.org>, but it is easier to install them using your distribution's package management tool. The package is probably named liblua5.1-dev, liblua-dev, or lua-devel depending on your linux distribution.

      
[//]: # (end-info)



PBX Lua Basics
--------------

The `extensions.lua` file is used to configure PBX lua and is a lua script (as opposed to being a standard asterisk configuration file). Any thing that is proper lua code is allowed in this file. Asterisk expects to find a global table named '`extensions`' when the file is loaded. This table can be generated however you wish. The simplest way is to define all of the extensions in line, but for more complex dialplans alternative methods may be necessary.

Each extension is a lua function that is executed when a channel lands on that extension. The extension function is passed the current context and extension as the first two arguments. These can be safely ignored if desired. There are no priorities (each extension function is treated as priority 1 by the rest of Asterisk). Patterns are allowed just as in `extensions.conf` and the matching order is identical.




---

  
extensions.lua  


```

extensions = {
 default = {
 ["100"] = function(context, extension)
 app.playback("please-hold")
 app.dial("SIP/100", 60)
 end;

 ["101"] = function(c, e)
 app.dial("SIP/101", 60)
 end;
}


```


The `extensions.lua` file can be reloaded by reloading the pbx_lua module.




---

  
  


```

\*CLI> module reload pbx_lua


```


If there are errors in the file, the errors will be reported and the existing extensions.lua file will remain in use. Channels that existed before the reload command was issued will also continue to use the existing extensions.lua file.




!!! info ""
    Runtime errors are logged and the channel on which the error occurred is hung up.

      
[//]: # (end-info)



