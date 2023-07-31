---
title: Using the Configuration Framework
pageid: 21463337
---

Overview
========


This wiki page describes using parts of the new Configuration Framework introduced in [Asterisk 11](/Asterisk-11-Documentation), and the motivation behind its creation.




!!! info ""
    NOTE
    All source code in this article is for demonstration purposes only.

      
[//]: # (end-info)



Configuration Loading Overview
==============================


[Modules](/Types-of-Asterisk-Modules) in Asterisk - be they applications, functions, channel drivers, supplementary resources, etc. - are responsible for managing their own resources and responding to operations initiated by the Asterisk core. During module load and reload operations, a large part of this responsibility consists of loading and parsing the module's configuration information from an Asterisk compatible configuration file or, optionally, an [Asterisk Realtime Architecture (ARA) backend](/Realtime-Database-Configuration).


The act of loading and parsing configuration information from either source typically involves doing the following operations:


1. Load the information from the backing storage into an `ast_config` configuration object.
2. If the configuration supports global values, set each global variable's value by either retrieving individual values one at a time or by browsing all supported values.
3. If the configuration supports multiple in-memory objects (users, endpoints, mailboxes, etc.), browse each item that configures the in-memory object and create the object in the module. This may also entail disposing of the current in-memory object and replacing it with the new information.


As we'll see, while performing these operations there are some common pitfalls that many modules in Asterisk fall into.




!!! info ""
    NOTE
    We'll disregard configuration information retrieved from an Asterisk Realtime Architecture (ARA) backend, and instead assume that the configuration information is read from static Asterisk configuration files. ARA is complex enough to deserve its own set of pages.

      
[//]: # (end-info)



Traditional Configuration Loading in Asterisk
=============================================


A Basic Configuration
---------------------


Let's assume that we want to configure a module `my_module` from the configuration file `my_module.conf`. We need to populate three variables in `my_module`, which are global values in the module:


* `foobar` - a Boolean value, whose default value should be "true".
* `foo` - an integer value ranging between `-32` and `32`.
* `bar` - some string value that we know should not exceed 64 characters.


Our configuration file `my_module.conf` may look something like this:




---

  
my_module.conf  


```


[general]
foobar = True
foo = 1
bar = Some string value


```


So that's fairly straight forward. How would we consume it in a module in Asterisk?


my_module Resource Management
------------------------------


A `my_module` that uses these values may look something like the following. We'll start with the basic structure, and then explore the actual loading and parsing of the configuration.




---

  
  


```

Cmy_module
#include "asterisk.h"

ASTERISK_FILE_VERSION(__FILE__, "$Revision: XXXXXX $")

#include "asterisk/module.h"
#include "asterisk/config.h"
#include "asterisk/config_options.h"

/*! \brief An integer value, ranging from -32 to 3 */
static int global_foo;

/*! \brief Some string valu */
static char global_bar[64];

/*! \brief A boolean valu */
static int global_foobar;

#define DEFAULT_FOOBAR 1

#define MIN_FOO -32

#define MAX_FOO 32

/*! \internal \brief Log the current module value */
static void log_module_values(void)
{
 /* Assume that something will call this functio */
 ast_verb(0, "Module values: foo=%d; bar=%s; foobar=%d\n,
 global_foo,
 global_bar,
 global_foobar);
}

/*! \internal \brief reload handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */
static int reload_module(void)
{
 if (load_configuration(1)) {
 return AST_MODULE_LOAD_DECLINE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

/*! \internal \brief load handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */
static int load_module(void)
{
 if (load_configuration(0)) {
 return AST_MODULE_LOAD_DECLINE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

/*! \internal \brief unload handle */
static int unload_module(void)
{
 /* If there was memory to reclaim, we'd do it her */
 return 0;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, AST_MODFLAG_LOAD_ORDER, "my_module",
 .load = load_module,
 .unload = unload_module,
 .reload = reload_module,
 .load_pri = AST_MODPRI_DEFAULT,
);


```


That's fairly simple. So, what do we have?


* Three variables - `foo`, `bar`, and `foobar` that correspond to the values in our configuration file `my_module.conf`.
* A default value defined for `foobar` and range values defined for `foo`.
* A function `log_module_values` that uses the three values by logging them to the Asterisk logging subsystem.
* Handlers for each of the module operations that can be initiated by the Asterisk core, `load`, `reload`, and `unload`.
* The `load` and `reload` handlers defer their work to a function that we haven't defined yet - `load_configuration`.


So, let's see what `load_configuration` might look like.




---

  
  


```

Cmy_module - load_configuration
/*!
 * \internal \brief Load the configuration information
 * \param reload If non-zero, this is a reload operation; otherwise, it is an initial module load
 * \retval 0 on success
 * \retval non-zero on error
 */
static int load_configuration(int reload)
{
 struct ast_config \*cfg;
 char \*cat = NULL;
 struct ast_variable \*var;
 struct ast_flags config_flags = { reload ? CONFIG_FLAG_FILEUNCHANGED : 0 };
 int res = 0;

 cfg = ast_config_load("my_module.conf", config_flags);
 if (!cfg) {
 ast_log(AST_LOG_WARNING, "Config file my_module.conf failed to load\n");
 return 1;
 } else if (cfg == CONFIG_STATUS_FILEINVALID) {
 ast_log(AST_LOG_WARNING, "Config file my_module.conf is invalid\n");
 return 1;
 } else if (cfg == CONFIG_STATUS_FILEUNCHANGED) {
 return 0;
 }

 /* Set the default value */
 global_foobar = DEFAULT_FOOBAR;

 /* We could theoretically use ast_variable_retrieve, but since
 that can traverse all of the variables in a category on each call,
 its often better to just traverse the variables in a context
 in a single pass */
 while ((cat = ast_category_browse(cfg, cat))) {

 /* Our config file only has a general section for no */
 if (strcasecmp(cat, "general")) {
 continue;
 }

 var = ast_variable_browse(cfg, cat);
 while (var) {
 if (!strcasecmp(var->name, "foo")) {
 int foo_temp;
 if (sscanf(var->value, "%30d", &foo_temp) != 1) {
 ast_log(AST_LOG_WARNING, "Failed to parse foo value [%s]\n", var->value);
 res = 1;
 goto cleanup;
 }
 if (foo_temp < MIN_FOO || foo_temp > MAX_FOO) {
 ast_log(AST_LOG_WARNING, "Invalid value %d for foo: must be between %d and %d\n",
 foo_temp, MIN_FOO, MAX_FOO);
 res = 1;
 goto cleanup;
 }
 global_foo = foo_temp;
 } else if (!strcasecmp(var->name, "bar")) {
 ast_copy_string(global_bar, var->value, sizeof(global_bar));
 } else if (!strcasecmp(var->name, "foobar")) {
 foobar = ast_true(var->value) ? 1 : 0;
 } else {
 ast_log(AST_LOG_WARNING, "Unknown configuration key %s\n", var->name);
 }
 var = var->next;
 }
 }

cleanup:
 ast_config_destroy(cfg);
 return res;
}


```


The function `load_configuration` boils down to two operations:


1. **Load the Asterisk configuration file** `**my_module.conf**`. Whether or not we're reloading makes a difference here - if we're reloading, the configuration subsystem will let us know that nothing in the configuration file has changed if the file has not been modified, which means we don't have to go through the mechanics of changing the values in the module. Once we know we have a good configuration object - and that we have to load the values due to a change - we proceed to the next step.
2. **Load the configuration values into memory**. This consists of iterating over each context in the configuration file, and, for each context, the variables in that context. Since we only have one context `[general]` in the configuration file, if we encounter a context with any other name, we skip it. Note that the business logic for each of the variables is embedded in this section of code. This includes setting the default value of `foobar`, as well as making sure that `foo` is a valid integer value and within the accepted ranges. If anything would result in an invalid module configuration, we bail by jumping to the cleanup label, disposing of the configuration and returning an error.


While this looks pretty good, there are a few problems with it that a bad configuration can exploit. Worse, even 'normal' operations can cause problems! Let's see how.


A Problem Configuration
-----------------------


First, let's assume that our module is loaded and running with the configuration in the previous section. A system administrator updates the configuration file `my_module.conf` with the following values:




---

  
A Bad my_module.conf  


```


[general]
foobar = False
foo = Oh snap I'm not an integer
bar = I'm a new string value


```


Since `foo` is a string and not an integer, the `load_configuration` function will fail and cause the module reload operation to be declined. Ideally, if that happens, none of the values in the module should change - we don't want operations currently using the module to start having weird behavior just because an administrator entered some invalid data. What would the actual state of the module be?


Well, since the variables will most likely be parsed in the order that they appear in the `[general]` section, the first variable parsed will be `foobar`. Its value will be changed from `1` to `0`. So far so good. Unfortunately, the next variable parsed is `foo`, and it most definitely is not an integer. The call to `sscanf` will fail, causing the configuration loading to stop. This results in the module having half of the configuration loaded into memory, while the other half has been left untouched:




---

  
Resulting Values in the Module after the Failed Load  


```


foobar = False
foo = 1
bar = Some string value


```


Yikes.


There are of course some things we could do to alleviate this.


1. We could decide to try and restore the state of the variables in `my_module` if an error is detected.
2. We could parse the configuration values into a temporary object, and only set the values of the module once all of the application level logic has been passed.


Both of these approaches naturally tend to lead towards storing the configuration values in a struct, as opposed to individual variables. Unfortunately, there are some other problems that even this approach won't completely solve.


Another Problem - Threading During Reloads
------------------------------------------


Remember that both the **CLI** and **AMI** can initiate a reload - and those happen on a different thread of execution than the thread executing the dialplan! In fact, there is a very good chance that any reload operation will happen on a different thread than whatever thread executes the logic in your module.


So, what happens if someone calls `log_module_values` while a reload is happening? The answer is "that depends" - but you can bet that it won't be pretty. You may get the values before the reload, after the reload, or some combination thereof. Worse, you can run into all sorts of strange (and difficult to debug) problems if the `ast_copy_string` of `bar` occurs at the same time as `ast_verb`, as both items will be attempting to modify/read the contents of the array at the same time.


In more complex modules where the configuration information is stored on the heap, this can lead to all sorts of strange problems - items that get removed from a configuration will no longer exist, pointers will point to NULL (if you're lucky, garbage if you're not), and general mayhem can ensue. Not pretty.


We could, of course, put some locking in to help. What would that look like?




---

  
  


```

Cmy_module with Locking
/*! \brief An integer value, ranging from -32 to 3 */
static int global_foo;

/*! \brief Some string valu */
static char global_bar[64];

/*! \brief A boolean valu */
static int global_foobar;

AST_MUTEX_DEFINE_STATIC(config_lock);

#define DEFAULT_FOOBAR 1

#define MIN_FOO -32

#define MAX_FOO 32

/*! \internal \brief Log the current module value */
static void log_module_values(void)
{
 /* Assume that something will call this functio */
 ast_mutex_lock(&config_lock);
 ast_verb(0, "Module values: foo=%d; bar=%s; foobar=%d\n,
 global_foo,
 global_bar,
 global_foobar);
 ast_mutex_unlock(&config_lock);
}

/*!
 * \internal \brief Load the configuration information
 * \param reload If non-zero, this is a reload operation; otherwise, it is an initial module load
 * \retval 0 on success
 * \retval non-zero on error
 */
static int load_configuration(int reload)
{
 struct ast_config \*cfg;
 char \*cat = NULL;
 struct ast_variable \*var;
 struct ast_flags config_flags = { reload ? CONFIG_FLAG_FILEUNCHANGED : 0 };
 int res = 0;

 cfg = ast_config_load("my_module.conf", config_flags);
 if (!cfg) {
 ast_log(AST_LOG_WARNING, "Config file my_module.conf failed to load\n");
 return 1;
 } else if (cfg == CONFIG_STATUS_FILEINVALID) {
 ast_log(AST_LOG_WARNING, "Config file my_module.conf is invalid\n");
 return 1;
 } else if (cfg == CONFIG_STATUS_FILEUNCHANGED) {
 return 0;
 }

 /* \*\*\* LOCK ADDED \*\*\ */
 ast_config_lock(&config_lock);

 /* Set the default value */
 global_foobar = DEFAULT_FOOBAR;

 /* We could theoretically use ast_variable_retrieve, but since
 that can traverse all of the variables in a category on each call,
 its often better to just traverse the variables in a context
 in a single pass */
 while ((cat = ast_category_browse(cfg, cat))) {

 /* Our config file only has a general section for no */
 if (strcasecmp(cat, "general")) {
 continue;
 }

 var = ast_variable_browse(cfg, cat);
 while (var) {
 if (!strcasecmp(var->name, "foo")) {
 int foo_temp;
 if (sscanf(var->value, "%30d", &foo_temp) != 1) {
 ast_log(AST_LOG_WARNING, "Failed to parse foo value [%s]\n", var->value);
 res = 1;
 goto cleanup;
 }
 if (foo_temp < MIN_FOO || foo_temp > MAX_FOO) {
 ast_log(AST_LOG_WARNING, "Invalid value %d for foo: must be between %d and %d\n",
 foo_temp, MIN_FOO, MAX_FOO);
 res = 1;
 goto cleanup;
 }
 global_foo = foo_temp;
 } else if (!strcasecmp(var->name, "bar")) {
 ast_copy_string(global_bar, var->value, sizeof(global_bar));
 } else if (!strcasecmp(var->name, "foobar")) {
 foobar = ast_true(var->value) ? 1 : 0;
 } else {
 ast_log(AST_LOG_WARNING, "Unknown configuration key %s\n", var->name);
 }
 var = var->next;
 }
 }

cleanup:
 /* \*\*\* UNLOCK ADDED \*\*\ */
 ast_config_unlock(&config_lock);
 ast_config_destroy(cfg);
 return res;
}

/* ... module callback handlers .. */


```


So, that's a little bit better, and now we can guarantee that a reload won't mess with `log_module_values`. That's nice, but now we have to put a lock around every access to `foo`, `bar`, and `foobar`. That can get tricky - and expensive - very quickly. And it doesn't solve the previous problem of inconsistent module state when an off nominal reload occurs.


This also ends up being a lot for a developer to keep straight. If only there was an API that helped us with all of this...


Introducing: the Configuration Framework
========================================


The examples above illustrate why we looked at writing a new layer of abstraction on top of Asterisk's configuration file loading and parsing. While the existing mechanisms provided a consistent way of loading a configuration file into memory, they didn't provide a way of mapping that configuration information to an in-memory representation of that data suitable for consumption by any module. Worse, rampant concurrency problems and off nominal code path handling have caused headaches for system administrators and developers alike.


So, we set off with the following goals:


1. Create a consistent mechanism for parsing configuration information into a module.
2. Provide a thread-safe mechanism for loading configuration information into memory.
3. Prevent errors in configuration from creating inconsistent state in a module.
4. Allow operations currently 'in-flight' to finish with the configuration information they started with.


The Configuration Framework in Asterisk 11 provides meets these goals, although things are going to appear a little different.  The module developer has to do a little more work initially in setting up the in-memory objects and providing mappings for those values back to an Asterisk configuration file. The very flexible nature of Asterisk configuration files - and how modules interpret those files - also meant that the Configuration Framework had to be flexible. So we'll take this slow.


my_module using the Configuration Framework
--------------------------------------------


All configuration information is stored in a reference counted object using Asterisk's `astobj2` API. That object can be replaced in a thread-safe manner with a new configuration information object, as we'll see later. Since the object is reference counted, as long as a consumer of the configuration information holds a reference to that object, it will continue to use the configuration information it started with, even if the configuration information is reloaded.




---

  
  


```

Cmy_module's In-Memory Configuration Object
#define DEFAULT_FOOBAR "True"

#define MIN_FOO -32

#define MAX_FOO 32

/*! \brief The global options available for this module
 * \note This replaces the individual static variables that were previously present
 */
struct global_options {
 int foo; /*< Some integer value between -32 and 3 */
 char bar[64]; /*< Some string valu */
 int foobar; /*< Some boolean valu */
};

/*! \brief All configuration objects for this module
 * \note If we had more than just a single set of global options, we would have
 * other items in this struct
 */
struct module_config {
 struct global_options \*general; /*< Our global setting */
}

/*! \brief A container that holds our global module configuratio */
static AO2_GLOBAL_OBJ_STATIC(module_configs);

/*! \brief A mapping of the module_config struct's general settings to the context
 * in the configuration file that will populate its value */
static struct aco_type general_option {
 .name = "general",
 .type = ACO_GLOBAL,
 .item_offset = offsetof(struct module_config, general),
 .category = "^general$",
 .category_match = ACO_WHITELIST,
};


```


So, that looks different! Let's run down what we have.


1. Our global configuration information is now stored in struct `global_options`. That struct has `foo`, `bar`, and `foobar` members that correspond to the static variables we previously had defined.
2. The global configuration information is stored in another struct, `module_config`. It has a pointer to an instance of struct `global_options`. If we had more information other than global information (such as users or endpoints), we might have more items in this struct.
3. `AO2_GLOBAL_OBJ_STATIC` is a new macro that creates a special struct that can hold a single item. It also gives us a lock on the object, providing the Configuration Framework a way to safely access, replace, and remove the information stored inside of it.
4. `aco_type` is the first instance of a special type of object that the Configuration Framework provides. It gives us a way to map our general configuration information - stored in `module_config`'s `general` pointer - to a context in the Asterisk configuration file. This defines for the Configuration Framework how information is extracted from the configuration file. Looking at each individual field in the struct:
	* `.type = ACO_GLOBAL`. Two types are allowed here - either `ACO_GLOBAL` or `ACO_ITEM`. `ACO_GLOBAL` implies that global information should be extracted and populated one time out of a configuration file, `ACO_ITEM` implies that the information should be extracted multiple times into multiple items.
	* `item_offset = offsetof(struct module_config, general)`. This uses the `offsetof` keyword to map the configuration information that will be extracted into the appropriate object - in this case, the object pointed to by the `general` field in the `module_config` struct.
	* `category = "^general$"`. A regular expression matching the category to parse out. In this case, `"^general$"` will match the context with a string name of 'general'.
	* `category_match = ACO_WHITELIST`. This means that only contexts that match the regular expression specified by the `category` will be processed. Alternatively, this option can be specified as a blacklist using `ACO_BLACKLIST`.


So now we have a mapping of our module configuration, and the in-memory representation of the global settings stored in context `[general]` to an object that will process that mapping for us. So what's next?


Well, as we mentioned previously, the configuration objects are going to be `ao2` objects, using the `astobj2` API. Let's define the constructor and destructor functions for the `module_config` `ao2` object.




---

  
  


```

Cmodule_config Constructor/Destructor
static void \*module_config_alloc(void);
static void module_config_destructor(void \*obj);

/*! \internal \brief Create a module_config objec */
static void \*module_config_alloc(void)
{
 struct module_config \*cfg;

 if (!(cfg = ao2_alloc(sizeof(\*cfg), module_config_destructor))) {
 return NULL;
 }
 if (!(cfg->general = ao2_alloc(sizeof(\*cfg->general), NULL))) {
 ao2_ref(cfg, -1);
 return NULL;
 }

 return cfg;
}

/*! \internal \brief Dispose of a module_config objec */
static void module_config_destructor(void \*obj)
{
 struct module_config \*cfg = obj;
 ao2_cleanup(cfg->general);
}


```


Note that as part of creating the `module_config` object, we also create the general settings object. Because we want the lifetime of the general settings to be tied to the lifetime of the `module_config` object, we explicitly handle its destruction in `module_config_destructor`, rather than pass a destructor function to `ao2_alloc` when we create it.


Now, we can associate our general configuration mapping object `general_option` with a configuration file that will provide the data.




---

  
  


```

CTying the Mapping Object to a Config File
/*! \brief A configuration file that will be processed for the modul */
static struct aco_file module_conf = {
 .filename = "my_module.conf", /*!< The name of the config fil */
 .types = ACO_TYPES(&general_option), /*!< The mapping object types to be processe */
};

CONFIG_INFO_STANDARD(cfg_info, module_configs, module_config_alloc,
 .files = ACO_FILES(&module_conf),
);

static struct aco_type \*general_options[] = ACO_TYPES(&general_option);


```


That isn't a lot of code, but what is there does a lot of powerful stuff. Let's go down the list:


1. `aco_file` defines a mapping of a configuration file to the mapping types that should be applied to that file. The Configuration Framework will consume the `aco_file` objects and process each file passed to it, populate the in-memory objects based on the mappings that are associated with that file.
2. We notify the Configuration Framework of our top level objects using the CONFIG_INFO_STANDARD macro. This:
	* Defines a handle `cfg_info` to access the Configuration Framework.
	* Associates the special `module_configs` container with the constructor, `module_config_alloc`, that will put the module configuration object into the container.
	* Specifies the files to process when the configuration for the module is loaded/reloaded. In this case, this happens to be the file specified by the `module_conf` object.
3. Finally, we have `general_options`, which is a special array that will be used when we register items to extract. We'll see this in use later.


We're finally ready to start doing some loading! But wait... where's the application level logic for our various variables? And how do we extract them from the Configuration Framework?


Rather than have a separate function that provides the application logic with the parsing, we instead tell the Configuration Framework how to extract each configuration value out of the configuration file, and what logic we want applied to it. We do all of this when we first load the module, as shown below.




---

  
  


```

CLoading my_module Using the Configuration Framework
/*! \internal \brief load handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */
static int load_module(void)
{
 if (aco_info_init(&cfg_info)) {
 goto load_error;
 }

 aco_option_register(&cfg_info, "foo", /* Extract configuration item "foo */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 NULL, /* Don't supply a default valu */
 OPT_INT_T, /* Interpret the value as an intege */
 PARSE_IN_RANGE, /* Accept values in a rang */
 FLDSET(struct global_options, foo), /* Store the value in member foo of a global_options struc */
 MIN_FOO, /* Use MIN_FOO as the minimum value of the allowed rang */
 MAX_FOO); /* Use MAX_FOO as the maximum value of the allowed rang */

 aco_option_register(&cfg_info, "bar", /* Extract configuration item "bar */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 NULL, /* Don't supply a default valu */
 OPT_CHAR_ARRAY_T, /* Interpret the value as a character arra */
 0, /* No interpretation flags are neede */
 CHARFLDSET(struct global_options, bar)); /* Store the value in member bar of a global_options struc */

 aco_option_register(&cfg_info, "foobar", /* Extract configuration item "foobar */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 DEFAULT_FOOBAR, /* Supply default value DEFAULT_FOOBA */
 OPT_BOOL_T, /* Interpret the value as a boolea */
 1, /* Use ast_true to set the value of fooba */
 FLDSET(struct global_options, foobar)); /* Store the value in member foobar of a global_options struc */

 if (aco_process_config(&cfg_info, 0)) {
 goto load_error;
 }

 return AST_MODULE_LOAD_SUCCESS;

load_error:
 aco_info_destroy(&cfg_info);
 return AST_MODULE_LOAD_DECLINE;
}


```


Recall that `foo` has to be an integer between `-32` and `32`, and that `foobar` should be a boolean value with a default value of `1`. Using the Configuration Framework, we've specified how we want those parameters to be extracted in `aco_option_register`. Once we've registered the configuration items to be extracted, all of the configuration parsing and loading into the in-memory objects is handled by `aco_process_config`. Once `aco_process_config` is finished, the `module_configs` `ao2` container will have an instance of `module_config` inside of it populated with the configuration information from the configuration file `my_module.conf`.


Now how would we use our in-memory object? And what about reloads?




---

  
  


```

CReloads and Using the Configuration Information
/*! \internal \brief Log the current module value */
static void log_module_values(void)
{
 RAII_VAR(struct module_config \*, cfg, ao2_global_obj_ref(module_configs), ao2_cleanup);

 if (!cfg || !cfg->general) {
 ast_log(LOG_ERROR, "Rut roh - something blew away our configuration!);
 return;
 }

 /* Assume that something will call this functio */
 ast_verb(0, "Module values: foo=%d; bar=%s; foobar=%d\n,
 cfg->general->foo,
 cfg->general->bar,
 cfg->general->foobar);
 }

/*! \internal \brief reload handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */
static int reload_module(void)
{
 if (aco_process_config(&cfg_info, 1)) {
 return AST_MODULE_LOAD_DECLINE;
 }

 return 0;
}


```


Let's take those in reverse order.


1. So, reloads are much easier, and thread-safe to boot. All we have to do is call `aco_process_config` and tell it (in the second parameter) that we're performing a reload. This will reload the module's configuration and - if it succeeds - safely swap out the config in the `module_configs` object. If it fails, the previous configuration is left alone so that any operations currently using the module can finish up without having bad data lying around.
2. Using the configuration information is a bit trickier, but not by much. We use a new macro `RAII_VAR` to safely get the `module_config` instance out of the `module_configs` object. Once we have the `module_config` object, we should (because we're practicing defensive coding, and we should always be careful) check whether or not we got valid data. If we did, we're free to use the values in our function. Plus, since `module_config` is reference counted, we 'own' that instance for as long as we want it. If a reload happens while we're logging out the current configuration values, its not a problem - our instance won't be changed and won't be disposed of until we leave the scope of `log_module_values`.


Note that due to some careful use of `C` extensions, the `RAII_VAR` macro sets up the clean-up of the reference counted objects for us, so that when execution leaves the scope of the `log_module_values` function, the object's references are all cleaned up properly! That makes it much easier to simply return out of the function if an off nominal condition is detected, or if the function has multiple exit points.


The `unload` handler is shown below with the complete `my_module` source code.


Complete my_module
-------------------




---

  
  


```

Cmy_module.c

#include "asterisk.h"

ASTERISK_FILE_VERSION(__FILE__, "$Revision: XXXXXX $")

#include "asterisk/module.h"
#include "asterisk/config.h"
#include "asterisk/config_options.h"

#define DEFAULT_FOOBAR "True"

#define MIN_FOO -32

#define MAX_FOO 32

/*! \brief The global options available for this module
 * \note This replaces the individual static variables that were previously present
 */
struct global_options {
 int foo; /*< Some integer value between -32 and 3 */
 char bar[64]; /*< Some string valu */
 int foobar; /*< Some boolean valu */
};

/*! \brief All configuration objects for this module
 * \note If we had more than just a single set of global options, we would have
 * other items in this struct
 */
struct module_config {
 struct global_options \*general; /*< Our global setting */
};

/*! \brief A container that holds our global module configuratio */
static AO2_GLOBAL_OBJ_STATIC(module_configs);

/*! \brief A mapping of the module_config struct's general settings to the context
 * in the configuration file that will populate its value */
static struct aco_type general_option = {
 .name = "general",
 .type = ACO_GLOBAL,
 .item_offset = offsetof(struct module_config, general),
 .category = "^general$",
 .category_match = ACO_WHITELIST,
};

static void \*module_config_alloc(void);
static void module_config_destructor(void \*obj);

/*! \brief A configuration file that will be processed for the modul */
static struct aco_file module_conf = {
 .filename = "my_module.conf", /*!< The name of the config fil */
 .types = ACO_TYPES(&general_option), /*!< The mapping object types to be processe */
};

CONFIG_INFO_STANDARD(cfg_info, module_configs, module_config_alloc,
 .files = ACO_FILES(&module_conf),
);

static struct aco_type \*general_options[] = ACO_TYPES(&general_option);

/*! \internal \brief Create a module_config objec */
static void \*module_config_alloc(void)
{
 struct module_config \*cfg;

 if (!(cfg = ao2_alloc(sizeof(\*cfg), module_config_destructor))) {
 return NULL;
 }
 if (!(cfg->general = ao2_alloc(sizeof(\*cfg->general), NULL))) {
 ao2_ref(cfg, -1);
 return NULL;
 }

 return cfg;
}

/*! \internal \brief Dispose of a module_config objec */
static void module_config_destructor(void \*obj)
{
 struct module_config \*cfg = obj;
 ao2_cleanup(cfg->general);
}

/*! \internal \brief Log the current module value */
static void log_module_values(void)
{
 RAII_VAR(struct module_config \*, cfg, ao2_global_obj_ref(module_configs), ao2_cleanup);

 if (!cfg || !cfg->general) {
 ast_log(LOG_ERROR, "Rut roh - something blew away our configuration!");
 return;
 }

 /* Assume that something will call this functio */
 ast_verb(0, "Module values: foo=%d; bar=%s; foobar=%d\n",
 cfg->general->foo,
 cfg->general->bar,
 cfg->general->foobar);
 }

/*! \internal \brief load handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */
static int load_module(void)
{
 if (aco_info_init(&cfg_info)) {
 goto load_error;
 }

 aco_option_register(&cfg_info, "foo", /* Extract configuration item "foo */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 NULL, /* Don't supply a default valu */
 OPT_INT_T, /* Interpret the value as an intege */
 PARSE_IN_RANGE, /* Accept values in a rang */
 FLDSET(struct global_options, foo), /* Store the value in member foo of a global_options struc */
 MIN_FOO, /* Use MIN_FOO as the minimum value of the allowed rang */
 MAX_FOO); /* Use MAX_FOO as the maximum value of the allowed rang */

 aco_option_register(&cfg_info, "bar", /* Extract configuration item "bar */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 NULL, /* Don't supply a default valu */
 OPT_CHAR_ARRAY_T, /* Interpret the value as a character arra */
 0, /* No interpretation flags are neede */
 CHARFLDSET(struct global_options, bar)); /* Store the value in member bar of a global_options struc */

 aco_option_register(&cfg_info, "foobar", /* Extract configuration item "foobar */
 ACO_EXACT, /* Match the exact configuration item nam */
 general_options, /* Use the general_options array to find the object to populat */
 DEFAULT_FOOBAR, /* Supply default value DEFAULT_FOOBA */
 OPT_BOOL_T, /* Interpret the value as a boolea */
 1, /* Use ast_true to set the value of fooba */
 FLDSET(struct global_options, foobar)); /* Store the value in member foobar of a global_options struc */

 if (aco_process_config(&cfg_info, 0)) {
 goto load_error;
 }

 return AST_MODULE_LOAD_SUCCESS;

load_error:
 aco_info_destroy(&cfg_info);
 return AST_MODULE_LOAD_DECLINE;
}

/*! \internal \brief reload handler
 * \retval AST_MODULE_LOAD_SUCCESS on success
 * \retval AST_MODULE_LOAD_DECLINE on failure
 */

static int reload_module(void)
{
 if (aco_process_config(&cfg_info, 1)) {
 return AST_MODULE_LOAD_DECLINE;
 }

 return 0;
}

/*! \internal \brief unload handle */
static int unload_module(void)
{
 aco_info_destroy(&cfg_info);
 return 0;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, AST_MODFLAG_LOAD_ORDER, "my_module",
 .load = load_module,
 .unload = unload_module,
 .reload = reload_module,
 .load_pri = AST_MODPRI_DEFAULT,
);



```


Conclusions
===========


And... that's it! Using the Configuration Framework, we've successfully solved the threading problems that were present in the previous `my_module` implementation, as well as prevented errors that can occur when a configuration file has erroneous data. As always, there's no free lunch - there's a bit more work to be done in setting up the mappings between the in-memory objects and their representation in the configuration file - but taken all together, the benefits the Configuration Framework provides are enormous.


There's a lot more to the Configuration Framework than what is described here. The framework lets you:


* Define items using a wide variety of types, including several Asterisk specific types (such as stringfields).
* Define callbacks for individual configuration items that allow you to apply custom application logic when the item is parsed.
* Define callbacks for different stages of configuration parsing.
* Populate multiple types of objects from different sections in a configuration file.
* Handle multiple configuration files for a single module.


And much, much more. The `app_skel` application has been rewritten for Asterisk 11 and demonstrates some of the more complex capabilities that the Configuration Framework provides. Some modules were also migrated over to using the new framework, and new modules in Asterisk 11 - such as `chan_motif` - also make use of it for their configuration management.


Going forward, we hope that all new modules in Asterisk make use of the new framework to minimize the race conditions and other bugs that can occur when loading configuration information.

