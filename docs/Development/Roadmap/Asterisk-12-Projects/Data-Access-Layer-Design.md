---
title: Data Access Layer Design
pageid: 22085706
---

General
-------

The Asterisk Data Access Layer is a unifying API that combines configuration files, realtime, and the astdb to allow persistent object creation, retrieval, updating, and deletion. The user of this API simply executes each action using the DAL API and the underlying implementations take care of their specific details without the user having to worry about it.

Defining the Object
-------------------

Each object is defined as a structure with object specific fields. A unique integer for each object type must also be specified. It is recommended that an enum be used for this.

Initializing the DAL
--------------------

### Creating a DAL instance

The DAL uses a data structure to hold information about the object types and providers available. This is allocated using the ast_dal_create API call. This returns a reference counted object. All further API calls happen using this object. If this API call fails to return a DAL instance the memory allocation has failed.

### Adding providers

A provider is the interface between the DAL instance and persistence mechanisms. Before any CRUD API calls can happen at least one provider must be added to the DAL instance. Note that a provider **can** be added multiple times with differing configurations.

#### Configuration File

The configuration file provider uses the existing configuration framework to read in a configuration file, parse it, and produce objects. Note that this is strictly a read-only provider at this time. This provider can be added to a DAL instance using the ast_dal_add_config API call. The API call takes the DAL instance and configuration file. Parsing of the configuration file only occurs at load or reload time. Created objects are kept in an astobj2 container for immediate lookup during a retrieve API call.

#### AstDB

The AstDB provider uses the sqlite database within Asterisk to persist information. This is useful for persisting information which is only relevant to the Asterisk instance itself. This provider can be added to a DAL instance using the ast_dal_add_astdb API call. Reading from the astdb only occurs at load or reload time. Writing to the astdb occurs when create, update, or delete are invoked. Like the configuration file provider the objects are kept in an astobj2 container for immediate lookup during a retrieve API call.

#### Realtime

The realtime provider uses the realtime API to provide database access to any realtime supported database. This is useful for persisting information which should be shared between multiple Asterisk instances. This provider can be added to a DAL instance using the ast_dal_add_realtime API call. The API call takes the DAL instance and realtime family. This provider does **not** keep any objects in memory.

### Registering object types

Object types are registered using the ast_dal_add_object_type API call. The unique integer identifier for the object type must be passed in as well as the configuration framework type structure. Internally the DAL instance keeps a container of registered object types. These registered object types also contain information about what fields are present and the respective callback to go from the value within the field back to a string.

### Registering configuration options

Configuration options are registered using the ast_dal_option_register or ast_dal_option_register_custom API call. Arguments are similar to the configuration framework calls but the custom API call includes an additional function for translating from the field value to a string.

Allocating an Object
--------------------

To allocate an object the ast_dal_alloc API call is invoked with the object type and an identifier. If no identifier is provided a unique one is generated. The API call allocates the object using the function passed in when registering the object type and also initializes the object with its defaults. The object returned is an ao2 ref counted object. The object returned is **not** part of the DAL instance until the ast_dal_create API call has been invoked. This allows any field within the object to be modified until that time.

Creating an Object
------------------

To create an object in the DAL layer the ast_dal_create API call is invoked with an allocated object. The object is translated into an ast_config structure with key value pairs using appropriate handlers and is then passed to a responsible DAL provider. The DAL provider uses the ast_config structure to persist the object in an implementation specific manner. 

Retrieving an Object
--------------------

To retrieve an object in the DAL layer two API calls are available: ast_dal_retrieve and ast_dal_retrieve_multiple.

Both API calls take the object type and search criteria.

The ast_dal_retrieve API call will return only the first object found matching the search criteria.  

The ast_dal_retrieve_multiple API call will return a container of all objects found. If no objects are found no container is returned. The returned container must have its reference count decreased using ao2_ref when no longer used.

Objects returned are always copies and can be modified.

!!! note 
    After examining the usage of configuration and persistent objects within Asterisk the vast majority is simply retrieval, with no creation/deletion/updating. This makes me think that the behavior of returning a copy should be available as a flag.

[//]: # (end-note)

Search criteria allows specifying the specific unique identifier for an object OR specific fields with expected values. The search criteria gets passed to the underlying providers so they have the most information available to efficiently retrieve the object.

Updating an Object
------------------

To update an object it is passed into the ast_dal_update API call. Depending on the provider handling the object one of two things can happen:

1. The existing unmodified object is retrieved and a change set produced between them both. This change set is handled in an implementation specific manner by the provider.  

Both of these options exist because the underlying persistence mechanism may be shared. When shared a change set may not accurately reflect all of the required changes by the time it is committed. This is overcome by committing the entire state of the object itself.

Deleting an Object
------------------

To delete an object it is passed into the ast_dal_delete API call. The unique identifier for the object is retrieved from it and then passed to its provider which deletes it in an object specific manner. This does require that the caller have the object that is to be deleted.

Destroying the DAL instance
---------------------------

As the DAL instance is reference counted releasing the last reference to it will cause it to be destroyed. This will terminate all registered DAL providers and registered objects.
