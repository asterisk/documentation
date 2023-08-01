---
title: AEL Context
---

Contexts in AEL represent a set of extensions in the same way that they do in extensions.conf.

```
context default {
}
```

A context can be declared to be "abstract", in which case, this declaration expresses the intent of the writer, that this context will only be included by another context, and not "stand on its own". The current effect of this keyword is to prevent "goto " statements from being checked.

```
abstract context longdist {
    _1NXXNXXXXXX => NoOp(generic long distance dialing actions in the US);
}
```
