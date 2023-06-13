---
title: cURL
pageid: 28314908
---

This page is under construction and may be incomplete or missing information in some areas. If you have questions, please wait until this notice is removed before asking, since it is possible your question will be answered by the time this page is completed.

 

Asterisk's ability to retrieve and store data to realtime backends is most commonly associated with relational databases. One of the lesser-known realtime backends available in Asterisk is [cURL](http://curl.haxx.se/). Using this realtime backend makes Asterisk use HTTP GET and POST requests in order to retrieve data from and store data to an HTTP server.

Justification
=============

If Asterisk is capable of using a relational database as a store for realtime data, then what is the need for using HTTP? There are several potential reasons:

* Your setup hinges on a web service such as Django or something else, and you would prefer that Asterisk go through this service instead of skirting it to get directly at the data.
* You are forced to use a database that Asterisk does not have a native backend for and whose ODBC support is subpar.
* A relational database carries too much overhead

Dependencies and Installation
=============================

Asterisk's realtime cURL backend is provided by the module `res_config_curl.so`. In order to build this module, you will first need to have the libcurl development library installed on your machine. If you wish to install the library from source, you can find it [here](http://curl.haxx.se/download.html). If you would rather use your Linux distribution's package management, then you should be able to download the development libraries that way instead.

If you use a distribution with aptitude-based packaging (Debian, Ubuntu, Mint, et al), then use this command to install:

apt-get install libcurl4-openssl-dev 

If you use a distribution with yum-based packaging (CentOS, RHEL, Fedora, et al), then use this command to install:

yum -y install libcurl-develBoth of the above commands assume that you have permission to install the packages. You may need to prepend the command with "sudo" in order to be able to install the packages.

Once you have the libcurl development libraries installed, you need to run Asterisk's configure script in order for Asterisk to detect the installed library:

$ ./configureIn addition to the libcurl development library, `res_config_curl.so` relies on two other modules within Asterisk: `res_curl.so` and `func_curl.so`. `res_curl.so` initializes the cURL library within Asterisk. `func_curl.so` provides dialplan functions ( `CURL` and `CURLOPT`) that are used directly by `res_config_curl.so`.

After running the configure script, run

$ make menuselectto select which modules to build. Ensure that you can select `res_curl` and `res_config_curl` from the "Resource Modules" menu and that you can select `func_curl` from the "Dialplan Functions" menu. Once you have ensured that these have been selected, save your changes ('x' key if using curses-based menuselect or select the "Save & Exit" option if using newt-based or gtk-based menuselect). After, you just need to run

$ make && make installin order to build Asterisk and install it on the system. You may need to prepend "sudo" to the "make install" command if there are permission problems when attempting to install. Once you have installed Asterisk, you can test that `res_config_curl.so` has been installed properly by starting Asterisk:

$ asterisk -cOnce Asterisk has started, type the following on the CLI:

\*CLI> module show like res\_config\_curl
Module Description Use Count Status
res\_config\_curl.so Realtime Curl configuration 0 Running
1 modules loaded

The output when you run the command should look like what is shown above. If it does, then Asterisk is capable of using cURL for realtime.

### Troubleshooting

If you encounter problems along the way, here are some tips to help you get back on track.

* If the required modules in Asterisk are unselectable when you run `make menuselect`, then Asterisk did not detect the libcurl development library on your machine. If you installed the libcurl development library in a nonstandard place, then when running Asterisk's configure script, specify `--with-curl=/path/to/library` so that Asterisk can know where to look.
* If you built the required Asterisk modules but the `res_config_curl.so` module is not properly loaded, then check your `modules.conf` file to ensure that the necessary modules are being loaded. If you are noloading any of the required modules, then `res_config_curl.so` will not be able to load. If you are loading modules individually, be sure to list `res_curl.so` and `func_curl.so` before `res_config_curl.so` in your configuration.

Configuration
=============

Unlike other realtime backends, Asterisk does not have a specific configuration file for the realtime cURL backend. Instead, Asterisk gets the information it needs by reading the `extconfig.conf` file that it typically uses for general static and dynamic realtime configuration. The name of the realtime engine that Asterisk uses for cURL is called "curl" in `extconfig.conf`. Here is a sample:

[settings]
voicemail = curl,http://myserver.com:8000/voicemail
sippeers = curl,http://myserver.com:8000/sippeers
queues = curl,http://myserver.com:8000/my\_queuesThe basic syntax when using cURL is:

realtime\_data = curl,<HTTP URL>There are no hard-and-fast rules on what URL you place here. In the above sample, each of the various realtime stores correspond to resources on the same HTTP server. However, it would be perfectly valid to specify completely different servers for different realtime stores. Notice also that there is no requirement for the name of the realtime store to appear in the HTTP URL. In the above example the "queues" realtime store maps to the resource "my\_queues" on the HTTP server.

Operations
==========

The way Asterisk performs operations on your data is to send HTTP requests to different resources on your HTTP server. For instance, let's say that, based on your `extconfig.conf` file, you have mapped the "queues" realtime store to http://myserver.com:8000/queues. Asterisk will append whatever realtime operation it wishes to perform as a resource onto the end of the URL that you have provided. If Asterisk wanted to perform the "single" realtime operation, then Asterisk would send an HTTP request to <http://myserver.com:8000/queues/single.>

If your server is able to provide a response, then your server should return that response as the body of a 200-class HTTP response. If the request is unservable, then an appropriate HTTP error code should be sent.

The operations, as well as what is expected in response, are defined below.

For the first five examples, we will be using external MWI as the sample realtime store that Asterisk will be interacting with. The realtime MWI store stores the following data for each object

* id: The name of the mailbox for which MWI is being provided
* msgs\_new: The number of new messages the mailbox currently has
* msgs\_old: The number of old messages the mailbox currently has

We will operate with the assumption that the following two objects exist in the realtime store:

* -
	+ id: "Dazed"
	+ msgs\_new: 5
	+ msgs\_old: 4
* -
	+ id: "Confused"
	+ msgs\_new: 6
	+ msgs\_old: 8

Our `extconfig.conf` file looks like this:

[settings]
mailboxes => curl,http://myserver.com:8000/mwi### single

The "single" resource is used for Asterisk to retrieve a single object from realtime.

Asterisk sends an HTTP POST request, using the body to indicate what data it wants. Here is an example of such a request:

POST /mwi/single HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 8
Content-Type: application/x-www-form-urlencoded
 
id=Dazed  In this case, the request from Asterisk wants a single object whose id is "Dazed". Given the data we have stored, we would respond like so:

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:23:21 GMT
Content-Length: 30
Content-Type: text/html
 
msgs\_new=5&msgs\_old=4&id=DazedThe parameters describing the requested mailbox are returned on a single line in the HTTP response body. The order that the parameters are listed in is irrelevant.

If a "single" query from Asterisk matches more than one entity, you may choose to either respond with an HTTP error or simply return one of the matching records. 

### multi

The "multi" resource is used to retrieve multiple objects from the realtime store.

Asterisk sends an HTTP POST request, using the body to indicate what data it wants. Here is an example of such a request:

POST /mwi/multi HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 13
Content-Type: application/x-www-form-urlencoded
 
id%20LIKE=%25The "multi" resource is one where Asterisk shows a weakness when not dealing with a relational database as its realtime backend. In this case, Asterisk has requested multiple rows with "id LIKE=%". What this means is that Asterisk wants to retrieve every object from the particular realtime store with an id equal to anything. Other queries Asterisk may send may be more like "foo LIKE=%bar%". In this case, Asterisk would be requesting all objects with a foo parameter that has "bar" as part of its value (so something with foo=barbara would match the query).

For this particular request, we would respond with the following:

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:40:58 GMT
Content-Length: 65
Content-Type: text/html
 
msgs\_new=5&msgs\_old=4&id=Dazed
msgs\_new=6&msgs\_old=8&id=ConfusedEach returned object is on its own line of the response.

### store

The "store" resource is used to save an object into the realtime store.

Asterisk sends an HTTP POST request, using the body to indicate what new object to store. Here is an example of such a request:

POST /mwi/store HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 30
Content-Type: application/x-www-form-urlencoded
 
id=Shocked&msgs\_old=5&msgs\_new=7In this case, Asterisk is attempting to store a new object with id "Shocked", 5 old messages and 7 new messages. Our realtime backend should reply with the number of objects stored.

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:46:54 GMT
Content-Length: 1
Content-Type: text/html
 
1Since we have stored one new object, we return "1" as our response.

If attempting to store an item that already exists in the database, you may either return an HTTP error or overwrite the old object with the new, depending on your policy.

### update

The "update" resource is used to change the values of parameters of objects in the realtime store.

Asterisk sends an HTTP POST request, using URL parameters to indicate what objects to update and using the body to indicate what values within those objects to update. Here is an example of such a request:

POST /mwi/update?id=Dazed HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 24
Content-Type: application/x-www-form-urlencoded
 
msgs\_old=25&msgs\_new=300In this case, the URL parameter "id=Dazed" tells us that Asterisk wants us to update all objects whose id is "Dazed". For any objects that match the criteria, we should update the number of old messages to 25 and the number of new messages to 300.

Our response indicates how many objects we updated. In this case, since we have updated one object, we respond with "1".

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:52:26 GMT
Content-Length: 1
Content-Type: text/html

1If there are no items that match the criteria, you may either respond with a "0" response body or return an HTTP error.

### destroy

The "destroy" resource is used to delete objects in the realtime store.

Asterisk sends an HTTP POST request, using the body to indicate what object to delete. Here is an example of such a request:

POST /mwi/destroy HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 9
Content-Type: application/x-www-form-urlencoded
 
id=DazedIn this case, Asterisk has requested that we delete the object with the id of "Dazed".

The body of our response indicates the number of items we deleted. Since we have deleted one object, we put "1" in our response body:

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:57:23 GMT
Content-Length: 1
Content-Type: text/html

1If asked to delete an object that does not exist, you may either respond with a "0" body or with an HTTP error.

### static

The "static" resource is used for static realtime requests.

Static realtime is a different realm from the more common dynamic realtime. Whereas dynamic realtime is restricted to certain configuration types that are designed to be used this way, static realtime uses a generic construct that can be substituted for any configuration file in Asterisk. The downside to static realtime is that Asterisk only ever interacts with the static realtime backend when the module that uses the configuration is reloaded. Internally, the Asterisk module thinks that it is reading its configuration from a configuration file, but under the hood, the configuration is actually retrieved from a realtime backend.

Static realtime "objects" are all the same, no matter what configuration file the static realtime store is standing in for. Object has been placed in quotation marks in that previous sentence because each static realtime object does not represent an entire configuration object, but rather represents a line in a configuration file. Here are the parameters for each static realtime object:

* id: A unique numerical id for the static realtime object
* filename: The configuration file that this static realtime object belongs to
* cat\_metric: Numerical id for a configuration category. Used by Asterisk to order categories for evaluation.
* category: Name of the configuration category
* var\_metric: Numerical id for a variable within a category. Used by Asterisk to order variables for evaluation.
* var\_name: Parameter name
* var\_val: Parameter value
* commented: If non-zero, indicates this object should be ignored

For our example, we will have the following objects stored in our static realtime store:

* -
	+ id: 0
	+ cat\_metric: 0
	+ var\_metric: 0
	+ filename: pjsip.conf
	+ category: alice
	+ var\_name: type
	+ var\_val: endpoint
	+ commented: 0
* -
	+ id: 1
	+ cat\_metric: 0
	+ var\_metric: 1
	+ filename: pjsip.conf
	+ category: alice
	+ var\_name: allow
	+ var\_val: ulaw
	+ commented: 0
* -
	+ id: 2
	+ cat\_metric: 0
	+ var\_metric: 2
	+ filename: pjsip.conf
	+ category: alice
	+ var\_name: context
	+ var\_val: fabulous
	+ commented: 0

This schema is identical to the `pjsip.conf` configuration file:

[alice]
type=endpoint
allow=ulaw
context=fabulous Asterisk uses an HTTP GET to request static realtime data, using a URL parameter to indicate which filename it cares about. Here is an example of such a request:

GET /astconfig/static?file=pjsip.conf HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*In this case, Asterisk wants all static realtime objects whose filename is "pjsip.conf". Note that the HTTP request calls the parameter "file", whereas the actual name of the parameter returned from the realtime store is called "filename".

Our response contains all matching static realtime objects:

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 19:13:41 GMT
Content-Length: 328
Content-Type: text/html

category=alice&commented=0&var\_metric=0&var\_name=type&var\_val=endpoint&id=0&filename=pjsip.conf&cat\_metric=0
category=alice&commented=0&var\_metric=1&var\_name=allow&var\_val=ulaw&id=1&filename=pjsip.conf&cat\_metric=0
category=alice&commented=0&var\_metric=2&var\_name=context&var\_val=fabulous&id=2&filename=pjsip.conf&cat\_metric=0Unlike other realtime responses, the static realtime response needs to present the data in a particular order:

* First order: by descending cat\_metric
* Second order: by ascending var\_metric
* Third: lexicographically by category name
* Fourth: lexicographically by variable name

Note that Asterisk only pays attention to the "cat\_metric", "var\_metric", "category", "var\_name", and "var\_value" you return here, but you are free to return the entire object if you want. Note that Asterisk will not pay attention to the "commented" field, so be sure not to return any objects that have a non-zero "commented" value.

In summary, static realtime is cumbersome, confusing, and not worth it. Stay clear unless you just really need to use it.

If your realtime store does not provide objects for the specified file, then you may either return an empty body or an HTTP error.

### require

The "require" resource is used by Asterisk to test that a particular parameter for a realtime object is of a type it expects.

Asterisk sends an HTTP POST with body parameters describing what type it expects for a specific parameter. Here is an example of such a request:

POST /queue\_members/require HTTP/1.1
User-Agent: asterisk-libcurl-agent/1.0
Host: localhost:8000
Accept: \*/\*
Content-Length: 42
Content-Type: application/x-www-form-urlencoded

paused=integer1%3A1&uniqueid=uinteger2%3A5Decoded, the body is "paused=integer1:1&uniqueid=uinteger2:5". The types that Asterisk can ask for are the following:

* An integer type can be indicated by any of the following
	+ integer1
	+ integer2
	+ integer3
	+ integer4
	+ integer8
* An unsigned integer type can be indicated by any of the following
	+ uinteger1
	+ uinteger2
	+ uinteger3
	+ uinteger4
	+ uinteger8
* char: A string
* date: A date
* datetime: A datetime
* float: a floating point number

It is undocumented what the meaning of the number after each of the "integer" and "uinteger" types means. If I'm guessing, it's the number of bytes allocated for the type.

The number after the colon for each parameter represents the minimum width, in digits for integer types and characters for char types, for each parameter.

In the example above, Asterisk is requiring that queue members' "paused" parameter be an integer type that can hold at least 1 digit and their "uniqueid" parameter be an unsigned integer type that can hold at least 5 digits.

 Note that the purpose of Asterisk requesting the "require" resource is because Asterisk is going to attempt to **send** data of the type indicated to the realtime store. When receiving such a request, it is completely up to how you are storing your data to determine how to respond. If you are using a schema-less store for your data, then trying to test for width and type for each parameter is pointless, so you may as well just return successfully. If you are using something that has a schema you can check, then you should be sure that your realtime store can accommodate the data Asterisk will send. If your schema cannot accommodate the data, then this is an ideal time to modify the data schema if it is possible.

Respond with a "0" body to indicate success or a "-1" body to indicate failure. Here is an example response:

HTTP/1.1 200 OK
Date: Sat, 15 Mar 2014 18:57:23 GMT
Content-Length: 1
Content-Type: text/html

0Other Information
=================

If you are interested in looking more in-depth into Asterisk's cURL realtime backend, you can find a reference example of an HTTP server in `contrib/scripts/dbsep.cgi` written by Tilghman Lesher, who also wrote Asterisk's realtime cURL support. This script works by converting the HTTP request from Asterisk into a SQL query for a relational database. The configuration for the database used in the `dbsep.cgi` script is detailed in the `configs/dbsep.conf.sample` file in the Asterisk source.

