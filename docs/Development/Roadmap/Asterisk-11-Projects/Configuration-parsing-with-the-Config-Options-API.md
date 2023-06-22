---
title: Configuration parsing with the Config Options API
pageid: 19008617
---

### Introduction


Asterisk uses a standard config file format that is essentially:




---

  
  


```


[context]
variable=value


```


The file 'config.h' specifies a relatively simple API for parsing these config files. Configuration information can usually be reloaded by the Asterisk user via the Asterisk command-line or manager interfaces. These reloads run in a different thread than any created by the specific module being reloaded. It is very important to handle reloads in an atomic, thread-safe manner. To help ensure this, a new configuration API has been added on top of the config.h API: the Config Options API.


### Components


user-defined config snapshot object - This is an astobj2 object containing pointers to any global options and ao2 containers for configurable items.


aco\_info - Module-level config information.


aco\_file - Information about a specific config file and how to process it.


aco\_type - A mapping between categories in a config file and user-defined objects.


category - A section of a config field denoted by a bracketed name. A category named "general" might look like:




---

  
  


```


[general]
variable1 = value
variable2 = value2


```


aco\_option - A configuration variable of a specific option type. An option may have a default value and has a handler responsible for parsing the textual representation of the option's value and storing its type-specific config object.


option handler - A callback function responsible for parsing the textual representation of an option's value and storing it in a config object.


default option handler - An option handler for non-custom options that is used by the Config Options API code.


custom option handler - A module-specific option handler for custom options.


### Parsing overview


1. Define an ao2\_global\_obj hold global the active config snapshot object.



---

  
  


```

C
static AO2\_GLOBAL\_OBJ\_STATIC(globals);


```
2. Define a structure to contain any global settings or containers used for configurable items as well as an ao2 allocator and destructor function for it.



---

  
  


```

C
struct my\_config {
 struct my\_global\_cfg \*global;
 struct ao2\_container \*items;
};

static void my\_config\_destructor(void \*obj)
{
 struct my\_config \*cfg = obj;
 ao2\_cleanup(cfg->global);
 ao2\_cleanup(cfg->items);
}

static void \*my\_config\_alloc(void)
{
 struct my\_config \*cfg;
 if (!(cfg = ao2\_alloc(sizeof(\*cfg), my\_config\_destructor))) {
 return NULL;
 }
 if (!(cfg->global = my\_global\_cfg\_alloc())) {
 goto error;
 }
 if (!(cfg->items = ao2\_container\_alloc(BUCKETS, item\_hash\_fn, item\_cmp\_fn))) {
 goto error;
 }
 return cfg;
error:
 ao2\_ref(cfg, -1);
 return NULL;
}


```
3. Define config types to map config categories to the appropriate internal types



---

  
  


```

C
static struct aco\_type general\_options = {
 .type = ACO\_GLOBAL,
 .category\_allow = ACO\_WHITELIST,
 .category = "^general$",
 .item\_offset = offsetof(struct my\_config, global),
};

static struct aco\_type private\_options = {
 .type = ACO\_PRIVATE,
 .category\_allow = ACO\_BLACKLIST,
 .category = "^general$",
 .item\_alloc = my\_item\_alloc,
 .item\_find = my\_item\_find,
 .item\_offset = offsetof(struct my\_config, itemss),
};


```
4. Create an aco\_file for any config files that will be processed. Set the filename and aco\_types that are valid for the file.



---

  
  


```

C
struct aco\_file my\_conf = {
 .filename = "my.conf",
 .types = ACO\_TYPES(&general\_option, &private\_options),
};


```
5. Define module-level configuration parsing options in a config info struct



---

  
  


```

C
CONFIG\_INFO\_STANDARD(cfg\_info, globals, my\_config\_alloc,
 .files = ACO\_FILES(&my\_conf),
);


```
6. Initialize the aco\_info and register default and custom options with the config info struct



---

  
  


```

C
static int load\_module(void)
{
...
 if (aco\_info\_init(&cfg\_info)) {
 goto error;
 }
 aco\_option\_register(&cfg\_info, "bindaddr", my\_conf.types, "0.0.0.0:1234", OPT\_SOCKADDR\_T, PARSE\_PORT\_REQUIRE, FLDSET(struct my\_global\_cfg, bindaddr));
 aco\_option\_register(&cfg\_info, "description", my\_conf.types, NULL, OPT\_STRINGFIELD\_T, 0, STRFLDSET(struct my\_item, description));
...
}


```
7. Process the config via aco\_process\_config(), passing in whether or not this is a reload or not.



---

  
  


```

C
aco\_process\_config(&cfg\_info, 0);


```


### Using config data


A completely consistent snapshot of config data can be accessed via




---

  
  


```

C
void some\_func\_that\_accesses\_config\_data(void)
{
 RAII\_VAR(struct my\_config \*, cfg, ao2\_global\_obj\_ref(globals), ao2\_cleanup);
 RAII\_VAR(struct my\_item \*, item, NULL, ao2\_cleanup);
 if (!cfg) {
 return;
 }
 do\_stuff\_with(cfg->general->bindaddr);
 if (!(item = ao2\_find(cfg->items, "bob", 0))) {
 return;
 }
}


```




!!! info ""
    It is important to note that upon reload, items are completely rebuilt. If a configured item (like a SIP peer) needs to maintain state information between reloads, it is important that it be stored in an object separate from the item in an ao2 object. The item can store a pointer to this state information. When allocating a new item that requires this state information, do a search for the item in the active config and store a reference to to its state in the newly allocated item. If no item is found, allocate a new state object and store that reference in the item. See skel\_level\_alloc and skel\_find\_or\_create\_state in apps/app\_skel.c for an example.

      
[//]: # (end-info)



