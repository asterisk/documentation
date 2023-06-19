---
title: Modules
pageid: 4260026
---

All modules must have at least the following:


Load Module
-----------




---

  
  


```


static int load\_module():


```



---


Module loading including tests for configuration or dependencies. This function can return **AST\_MODULE\_LOAD\_FAILURE**, **AST\_MODULE\_LOAD\_DECLINE**, or **AST\_MODULE\_LOAD\_SUCCESS**. If a dependency or environment variable fails tests return **AST\_MODULE\_LOAD\_FAILURE**. If the module can not load the configuration file or other non-critical problem return **AST\_MODULE\_LOAD\_DECLINE**. On success return **AST\_MODULE\_LOAD\_SUCCESS**.


Example:




---

  
  


```


/\*!
 \* \brief Load the module
 \*
 \* Module loading including tests for configuration or dependencies.
 \* This function can return AST\_MODULE\_LOAD\_FAILURE, AST\_MODULE\_LOAD\_DECLINE,
 \* or AST\_MODULE\_LOAD\_SUCCESS. If a dependency or environment variable fails
 \* tests return AST\_MODULE\_LOAD\_FAILURE. If the module can not load the 
 \* configuration file or other non-critical problem return 
 \* AST\_MODULE\_LOAD\_DECLINE. On success return AST\_MODULE\_LOAD\_SUCCESS.
 \*/
static int load\_module(void)
{

 if (dependency\_does\_not\_exist) {
 return AST\_MODULE\_LOAD\_FAILURE;
 }

 if (configuration\_file\_does\_not\_exist) {
 return AST\_MODULE\_LOAD\_DECLINE;
 }

 return AST\_MODULE\_LOAD\_SUCCESS;
}


```



---


Unload Module
-------------




---

  
  


```


static int unload\_module():


```



---


The module will soon be unloaded. If any channels are using your features, you should give them a softhangup in an effort to keep the program from crashing. Generally, unload\_module is only called when the usecount is 0 or less, but the user can force unloading at their discretion, and thus a module should do its best to comply (although in some cases there may be no way to avoid a crash). This function should return 0 on success and non-zero on failure (i.e. it cannot yet be unloaded).


Example:




---

  
  


```


/\*!
 \* \brief Unload Module
 \*/
static int unload\_module(void)
{

 if (active\_use) {
 return -1;
 }

 return 0;
}


```



---


Module Information
------------------




---

  
  


```


AST\_MODULE\_INFO\_STANDARD(keystr, desc);
... or ...
AST\_MODULE\_INFO(keystr, flags\_to\_set, desc, load\_func, unload\_func, reload\_func, load\_pri);


```



---


**AST\_MODULE\_INFO\_STANDARD**


* keystr - Applicable license for module. In most cases this is ASTERISK\_GPL\_KEY.
* desc - Description of module.


**AST\_MODULE\_INFO**


* keystr
* flags\_to\_set
* desc
* load\_func
* unload\_func
* reload\_func
* load\_pri


