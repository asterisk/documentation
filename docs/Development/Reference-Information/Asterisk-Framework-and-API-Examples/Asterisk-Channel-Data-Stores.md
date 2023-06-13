---
title: Asterisk Channel Data Stores
pageid: 4259988
---

Asterisk Channel Data Stores
============================


##### What is a data store?


A data store is a way of storing complex data (such as a structure) on a channel so it can be retrieved at a later time by another application, or the same application.


If the data store is not freed by said application though, a callback to a destroy function occurs which frees the memory used by the data in the data store so no memory loss occurs.


##### A datastore info structure



static const struct example\_datastore {
 .type = "example",
 .destroy = callback\_destroy
};

This is a needed structure that contains information about a datastore, it's used by many API calls.


##### How do you create a data store?


1. Use ast\_datastore\_alloc function to return a pre-allocated structure  

 Ex: datastore = ast\_datastore\_alloc(&example\_datastore, "uid");  

 This function takes two arguments: (datastore info structure, uid)


2. Attach data to pre-allocated structure.  

 Ex: datastore->data = mysillydata;


3. Add datastore to the channel  

 Ex: ast\_channel\_datastore\_add(chan, datastore);  

 This function takes two arguments: (pointer to channel, pointer to data store)


Full Example:



void callback\_destroy(void \*data)
{
 ast\_free(data);
}

struct ast\_datastore \*datastore = NULL;
datastore = ast\_datastore\_alloc(&example\_datastore, NULL);
datastore->data = mysillydata;
ast\_channel\_datastore\_add(chan, datastore);

NOTE
Because you're passing a pointer to a function in your module, you'll want to include this in your use count. When allocated increment, when destroyed decrement.


##### How do you remove a data store?


1. Find the data store  

 Ex: datastore = ast\_channel\_datastore\_find(chan, &example\_datastore, NULL);  

 This function takes three arguments: (pointer to channel, datastore info structure, uid)


2. Remove the data store from the channel  

 Ex: ast\_channel\_datastore\_remove(chan, datastore);  

 This function takes two arguments: (pointer to channel, pointer to data store)


3. If we want to now do stuff to the data on the data store


4. Free the data store (this will call the destroy call back)  

 Ex: ast\_channel\_datastore\_free(datastore);  

 This function takes one argument: (pointer to data store)


##### How do you find a data store?


1. Find the data store  

 Ex: datastore = ast\_channel\_datastore\_find(chan, &example\_datastore, NULL);  

 This function takes three arguments: (pointer to channel, datastore info structure, uid)

