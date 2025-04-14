---
title: Modules
pageid: 4260026
---

All modules must have at least the following:

Load Module
-----------

```

static int load_module():

```

Module loading including tests for configuration or dependencies. This function can return **AST_MODULE_LOAD_FAILURE**, **AST_MODULE_LOAD_DECLINE**, or **AST_MODULE_LOAD_SUCCESS**. If a dependency or environment variable fails tests return **AST_MODULE_LOAD_FAILURE**. If the module can not load the configuration file or other non-critical problem return **AST_MODULE_LOAD_DECLINE**. On success return **AST_MODULE_LOAD_SUCCESS**.

Example:

```

/*!
 * \brief Load the module
 *
 * Module loading including tests for configuration or dependencies.
 * This function can return AST_MODULE_LOAD_FAILURE, AST_MODULE_LOAD_DECLINE,
 * or AST_MODULE_LOAD_SUCCESS. If a dependency or environment variable fails
 * tests return AST_MODULE_LOAD_FAILURE. If the module can not load the 
 * configuration file or other non-critical problem return 
 * AST_MODULE_LOAD_DECLINE. On success return AST_MODULE_LOAD_SUCCESS.
 */
static int load_module(void)
{

 if (dependency_does_not_exist) {
 return AST_MODULE_LOAD_FAILURE;
 }

 if (configuration_file_does_not_exist) {
 return AST_MODULE_LOAD_DECLINE;
 }

 return AST_MODULE_LOAD_SUCCESS;
}

```

Unload Module
-------------

```

static int unload_module():

```

The module will soon be unloaded. If any channels are using your features, you should give them a softhangup in an effort to keep the program from crashing. Generally, unload_module is only called when the usecount is 0 or less, but the user can force unloading at their discretion, and thus a module should do its best to comply (although in some cases there may be no way to avoid a crash). This function should return 0 on success and non-zero on failure (i.e. it cannot yet be unloaded).

Example:

```

/*!
 * \brief Unload Module
 */
static int unload_module(void)
{

 if (active_use) {
 return -1;
 }

 return 0;
}

```

Module Information
------------------

```

AST_MODULE_INFO_STANDARD(keystr, desc);
... or ...
AST_MODULE_INFO(keystr, flags_to_set, desc, load_func, unload_func, reload_func, load_pri);

```

**AST_MODULE_INFO_STANDARD**

* keystr - Applicable license for module. In most cases this is ASTERISK_GPL_KEY.
* desc - Description of module.

**AST_MODULE_INFO**

* keystr
* flags_to_set
* desc
* load_func
* unload_func
* reload_func
* load_pri
