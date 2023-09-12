# Dialplan Security

First and foremost remember this:

!!! danger "Extension Isolation"

    Use the extension contexts to isolate outgoing or toll services from any incoming connections.

You should consider that if any channel, incoming line, etc. can enter
an extension context that it has the capability of accessing any
extension within that context.

Therefore, you should **not** allow access to outgoing or toll
services in contexts that are accessible (especially without a
password) from incoming channels, be they IAX channels, FX or other
trunks, or even untrusted stations within your network. In particular,
never ever put outgoing toll services in the "default" context. To
make things easier, you can include the "default" context within other
private contexts by using:

```
include => default
```

in the appropriate section. A well designed PBX might look like this:

```
[longdistance]
exten => _91NXXNXXXXXX,1,Dial(DAHDI/g2/${EXTEN:1})
include => local

[local]
exten => _9NXXNXXX,1,Dial(DAHDI/g2/${EXTEN:1})
include => default

[default]
exten => 6123,1,Dial(DAHDI/1)
```

!!! tip "Remove Demo Contexts"

    Do not forget to take the `demo` context out of your default
    context. There isn't really a security reason, it just will keep
    people from wanting to play with your Asterisk setup remotely.
