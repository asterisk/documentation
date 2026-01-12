---
search:
  boost: 0.5
title: JACK
---

# JACK()

### Synopsis

Jack Audio Connection Kit

### Description

When executing this application, two jack ports will be created; one input and one output. Other applications can be hooked up to these ports to access audio coming from, or being send to the channel.<br>


### Syntax


```

JACK([options])
```
##### Arguments


* `options`

    * `s(name)`

        * `name` **required** - Connect to the specified jack server name<br>


    * `i(name)`

        * `name` **required** - Connect the output port that gets created to the specified jack input port<br>


    * `o(name)`

        * `name` **required** - Connect the input port that gets created to the specified jack output port<br>


    * `c(name)`

        * `name` **required** - By default, Asterisk will use the channel name for the jack client name.<br>
Use this option to specify a custom client name.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 