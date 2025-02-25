---
search:
  boost: 0.5
title: EVAL_EXTEN
---

# EVAL_EXTEN()

### Synopsis

Evaluates the contents of a dialplan extension and returns it as a string.

### Description

The EVAL\_EXTEN function looks up a dialplan entry by context,extension,priority, evaluates the contents of a Return statement to resolve any variable or function references, and returns the result as a string.<br>

You can use this function to create simple user-defined lookup tables or user-defined functions.<br>

``` title="Example: Custom dialplan functions"

[call-types]
exten => _1NNN,1,Return(internal)
exten => _NXXNXXXXXX,1,Return(external)

[udf]
exten => calleridlen,1,Return(${LEN(${CALLERID(num)})})

[default]
exten => _X!,1,Verbose(Call type ${EVAL_EXTEN(call-types,${EXTEN},1)} - ${EVAL_EXTEN(udf,calleridlen,1)})


```
Any variables in the evaluated data will be resolved in the context of that extension. For example, '$\{EXTEN\}' would refer to the EVAL\_EXTEN extension, not the extension in the context invoking the function. This behavior is similar to other applications, e.g. 'Gosub'.<br>

``` title="Example: Choosing which prompt to use"

same => n,Read(input,${EVAL_EXTEN(prompts,${CALLERID(num)},1)})

[prompts]
exten => _X!,1,Return(default)
exten => _20X,1,Return(welcome)
exten => _2XX,1,Return(${DB(promptsettings/${EXTEN})})
exten => _3XX,1,Return(${ODBC_MYFUNC(${EXTEN})})


```
Extensions on which EVAL\_EXTEN is invoked are not different from other extensions. However, the application at that extension is not executed. Only the application data is parsed and evaluated.<br>

A limitation of this function is that the application at the specified extension isn't actually executed, and thus unlike a Gosub, you can't pass arguments in the EVAL\_EXTEN function.<br>


### Syntax


```

EVAL_EXTEN(context,extensions,priority)
```
##### Arguments


* `context`

* `extensions`

* `priority`

### See Also

* [Dialplan Functions EVAL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/EVAL)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 