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


aco_info - Module-level config information.


aco_file - Information about a specific config file and how to process it.


aco_type - A mapping between categories in a config file and user-defined objects.


category - A section of a config field denoted by a bracketed name. A category named "general" might look like:




---

  
  


```


[general]
variable1 = value
variable2 = value2


```


aco_option - A configuration variable of a specific option type. An option may have a default value and has a handler responsible for parsing the textual representation of the option's value and storing its type-specific config object.


option handler - A callback function responsible for parsing the textual representation of an option's value and storing it in a config object.


default option handler - An option handler for non-custom options that is used by the Config Options API code.


custom option handler - A module-specific option handler for custom options.


### Parsing overview


1. Define an ao2_global_obj hold global the active config snapshot object.



---

  
  


```

C
static AO2_GLOBAL_OBJ_STATIC(globals);


```
2. Define a structure to contain any global settings or containers used for configurable items as well as an ao2 allocator and destructor function for it.



---

  
  


```

C
struct my_config {
 struct my_global_cfg \*global;
 struct ao2_container \*items;
};

static void my_config_destructor(void \*obj)
{
 struct my_config \*cfg = obj;
 ao2_cleanup(cfg->global);
 ao2_cleanup(cfg->items);
}

static void \*my_config_alloc(void)
{
 struct my_config \*cfg;
 if (!(cfg = ao2_alloc(sizeof(\*cfg), my_config_destructor))) {
 return NULL;
 }
 if (!(cfg->global = my_global_cfg_alloc())) {
 goto error;
 }
 if (!(cfg->items = ao2_container_alloc(BUCKETS, item_hash_fn, item_cmp_fn))) {
 goto error;
 }
 return cfg;
error:
 ao2_ref(cfg, -1);
 return NULL;
}


```
3. Define config types to map config categories to the appropriate internal types



---

  
  


```

C
static struct aco_type general_options = {
 .type = ACO_GLOBAL,
 .category_allow = ACO_WHITELIST,
 .category = "^general$",
 .item_offset = offsetof(struct my_config, global),
};

static struct aco_type private_options = {
 .type = ACO_PRIVATE,
 .category_allow = ACO_BLACKLIST,
 .category = "^general$",
 .item_alloc = my_item_alloc,
 .item_find = my_item_find,
 .item_offset = offsetof(struct my_config, itemss),
};


```
4. Create an aco_file for any config files that will be processed. Set the filename and aco_types that are valid for the file.



---

  
  


```

C
struct aco_file my_conf = {
 .filename = "my.conf",
 .types = ACO_TYPES(&general_option, &private_options),
};


```
5. Define module-level configuration parsing options in a config info struct



---

  
  


```

C
CONFIG_INFO_STANDARD(cfg_info, globals, my_config_alloc,
 .files = ACO_FILES(&my_conf),
);


```
6. Initialize the aco_info and register default and custom options with the config info struct



---

  
  


```

C
static int load_module(void)
{
...
 if (aco_info_init(&cfg_info)) {
 goto error;
 }
 aco_option_register(&cfg_info, "bindaddr", my_conf.types, "0.0.0.0:1234", OPT_SOCKADDR_T, PARSE_PORT_REQUIRE, FLDSET(struct my_global_cfg, bindaddr));
 aco_option_register(&cfg_info, "description", my_conf.types, NULL, OPT_STRINGFIELD_T, 0, STRFLDSET(struct my_item, description));
...
}


```
7. Process the config via aco_process_config(), passing in whether or not this is a reload or not.



---

  
  


```

C
aco_process_config(&cfg_info, 0);


```


### Using config data


A completely consistent snapshot of config data can be accessed via




---

  
  


```

C
void some_func_that_accesses_config_data(void)
{
 RAII_VAR(struct my_config \*, cfg, ao2_global_obj_ref(globals), ao2_cleanup);
 RAII_VAR(struct my_item \*, item, NULL, ao2_cleanup);
 if (!cfg) {
 return;
 }
 do_stuff_with(cfg->general->bindaddr);
 if (!(item = ao2_find(cfg->items, "bob", 0))) {
 return;
 }
}


```




!!! info ""
    It is important to note that upon reload, items are completely rebuilt. If a configured item (like a SIP peer) needs to maintain state information between reloads, it is important that it be stored in an object separate from the item in an ao2 object. The item can store a pointer to this state information. When allocating a new item that requires this state information, do a search for the item in the active config and store a reference to to its state in the newly allocated item. If no item is found, allocate a new state object and store that reference in the item. See skel_level_alloc and skel_find_or_create_state in apps/app_skel.c for an example.

      
[//]: # (end-info)



