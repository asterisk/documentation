---
title: Adding to an existing section
pageid: 4817461
---

If you want to add settings to an existing section of a configuration file (either later in the file, or when using the **#include** and **#exec** constructs), add a plus sign in parentheses after the section heading, as shown below:

```javascript title=" " linenums="1"
[section-name]
setting1=value1

[section-name](+)
setting2=value2

```

This example shows that the **setting2** setting was added to the existing section of the configuration file.

If the section you're adding to appears more than once in the config, such as an endpoint and aor named the same in a pjsip.conf file, the section added to will be the first one defined unless you add a filter qualifier.

Without a qualifier:




---

  
This will fail because default_expiration isn't valid for an endpoint  

```
[101]
type=endpoint
allow=ulaw

[101]
type=aor
default_expiration=3600

[101](+)
default_expiration=1200

```



With qualifiers:




---

  
This works because the filters ensure that the additions are to the correct objects.  

```
[101]
type=endpoint
allow=ulaw
 
[101]
type=aor
default_expiration=3600
 
[101](+type=aor)
default_expiration=1200

[101](+type=endpoint)
allow=g722

```



You're not limited to filtering by the type parameter and you can even use regular expressions in the name or value.




---

  
A weird and not so useful example  

```
[101]
type=endpoint
allow=ulaw
 
[101]
type=aor
default_expiration=3600
 
[101](+default_.\*=36[0-9][0-9])
default_expiration=1200

[101](+type=endpoint)
allow=g722

```

You can also include multiple filters.




---

  
Another weird and not so useful example  

```
[101]
type=endpoint
allow=ulaw
 
[101]
type=aor
default_expiration=3600
 
[101](+type=aor&default_.\*=36[0-9][0-9])
default_expiration=1200

[101](+type=endpoint)
allow=g722

```

And finally, you can elect to include or restrict parameters inherited from templates in the search.




---

  
The final weird and not so useful example. This will NOT match because default_expiration is defined in the parent template.  

```
[101]
type=endpoint
allow=ulaw

[aor_template](!)
type=aor
default_expiration=3600

[101](aor_template)
 
[101](+TEMPLATES=restrict&default_.\*=36[0-9][0-9])
default_expiration=1200

[101](+type=endpoint)
allow=g722

```









