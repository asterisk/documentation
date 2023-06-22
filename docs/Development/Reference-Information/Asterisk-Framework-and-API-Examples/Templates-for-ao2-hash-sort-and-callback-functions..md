---
title: Templates for ao2 hash, sort, and callback functions.
pageid: 25919686
---

The container comparison functions historically only had the following flag to optimize a container search: `OBJ_POINTER`.  Asterisk 11 added the additional flag to simplify places that requested code searches: `OBJ_KEY`.  Now with the ability to have sorted containers - such as red-black trees - a third flag is available: `OBJ_PARTIAL_KEY`.  These three flags cannot be used at the same time.

There is a lot of historical code that does simple bit tests and sets.  This code needs to be changed to take into account the fact that there are new search flags and must guard against their use if they are not supported by the container.  Most of the adjustments are needed by the `ao2_hash_fn` and `ao2_callback_fn` functions of the containers.

The following code templates should be used to implement the container callback functions.  The templates use string keys but can be adapted for different types of keys.

### Some slight renaming for consistency

A slight change to astobj2 for Asterisk 12 made these flags an enumerated flag field like the `OBJ_ORDER_xxx` field so the names can indicate they are related to each other.  The following are the new names:

* `OBJ_SEARCH_MASK` - Bit mask to isolate the bit field in the flags.
* `OBJ_SEARCH_NONE` - The arg pointer has no meaning to the astobj2 code.
* `OBJ_SEARCH_OBJECT` - The arg pointer points to an object that can be stored in the container.
* `OBJ_SEARCH_KEY` - The arg pointer points to a key value used by the container.
* `OBJ_SEARCH_PARTIAL_KEY` - The arg pointer points to a partial key value used by the container.

`OBJ_POINTER` is defined as `OBJ_SEARCH_OBJECT`

`OBJ_KEY` is defined as `OBJ_SEARCH_KEY`

`OBJ_PARTIAL_KEY` is defined as `OBJ_SEARCH_PARTIAL_KEY`

The old names are still available but deprecated until all code is converted to use the new names.

### Hash Function




---

  
  


```

int ao2\_hash\_fn(const void \*obj, int flags)
{
 const struct my\_object \*object;
 const char \*key;

 switch (flags & OBJ\_SEARCH\_MASK) {
 case OBJ\_SEARCH\_KEY:
 key = obj;
 break;
 case OBJ\_SEARCH\_OBJECT:
 object = obj;
 key = object->key;
 break;
 default:
 /\* Hash can only work on something with a full key. \*/
 ast\_assert(0);
 return 0;
 }
 return ast\_str\_hash(key);
}

```


### Sort Function




---

  
  


```

int ao2\_sort\_fn(const void \*obj\_left, const void \*obj\_right, int flags)
{
 const struct my\_object \*object\_left = obj\_left;
 const struct my\_object \*object\_right = obj\_right;
 const char \*right\_key = obj\_right;
 int cmp;

 switch (flags & OBJ\_SEARCH\_MASK) {
 case OBJ\_SEARCH\_OBJECT:
 right\_key = object\_right->username;
 /\* Fall through \*/
 case OBJ\_SEARCH\_KEY:
 cmp = strcmp(object\_left->username, right\_key);
 break;
 case OBJ\_SEARCH\_PARTIAL\_KEY:
 /\*
 \* We could also use a partial key struct containing a length
 \* so strlen() does not get called for every comparison instead.
 \*/
 cmp = strncmp(object\_left->username, right\_key, strlen(right\_key));
 break;
 default:
 /\* Sort can only work on something with a full or partial key. \*/
 ast\_assert(0);
 cmp = 0;
 break;
 }
 return cmp;
}

```


### Sorted vs. Unsorted Container Searching

The sort/hash comparison functions act as a filter before the `ao2_callback_fn` function is called.  Every object is matched first by the sort/hash functions.  This callback just adds additional discrimination between otherwise equal matches.  For most sorted container searches you won't need a special callback and can use the default to match everything by passing NULL for this function.

However, with OBJ\_CONTINUE, the sort/hash functions are only used to find the starting point in a container traversal of all objects.

This function should not return CMP\_STOP unless you never want a container search to find multiple objects with the OBJ\_MULTIPLE flag.

### Sorted container cmp function




---

  
  


```

/\*
 \* This callback function is exactly what you get when you pass
 \* NULL as the callback function.
 \*/
int ao2\_callback\_fn\_sorted\_cmp(void \*obj, void \*arg, int flags)
{
 return CMP\_MATCH;
}

```


Unsorted containers must do more work selecting objects since traversals will either traverse the whole container or one hash bucket.

### Unsorted container cmp function




---

  
  


```

int ao2\_callback\_fn\_unsorted\_cmp(void \*obj, void \*arg, int flags)
{
 const struct my\_object \*object\_left = obj;
 const struct my\_object \*object\_right = arg;
 const char \*right\_key = arg;
 int cmp;

 switch (flags & OBJ\_SEARCH\_MASK) {
 case OBJ\_SEARCH\_OBJECT:
 right\_key = object\_right->username;
 /\* Fall through \*/
 case OBJ\_SEARCH\_KEY:
 cmp = strcmp(object\_left->username, right\_key);
 break;
 case OBJ\_SEARCH\_PARTIAL\_KEY:
 /\*
 \* We could also use a partial key struct containing a length
 \* so strlen() does not get called for every comparison instead.
 \*/
 cmp = strncmp(object\_left->username, right\_key, strlen(right\_key));
 break;
 default:
 /\*
 \* What arg points to is specific to this traversal callback
 \* and has no special meaning to astobj2.
 \*/
 cmp = 0;
 break;
 }
 if (cmp) {
 return 0;
 }
 /\*
 \* At this point the traversal callback is identical to a sorted
 \* container.
 \*/
 return ao2\_callback\_fn\_sorted\_cmp(obj, arg, flags);
}

```


