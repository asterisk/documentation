---
title: Documentation Improvements
pageid: 5242888
---

Improvements Overview
=====================


### To-Do


* Create a place for AMI event documentation, likely in the Asterisk XML docs. Make them available via the Asterisk CLI and Wiki.
* Create a simplified set of sample configuration files and PBX starter configuration files


### In Progress


* Create a script that can export the wiki into PDF and plain text for inclusion with release tarballs.
	+ The [Confluence API](http://confluence.atlassian.com/display/CONFDEV/Remote+API+Specification) includes an exportSpace() API call that should do the trick.


### Done


* Migrate documentation from the doc/ directory to this wiki.
* Create a tool that syncs the built-in XML based documentation for applications, functions, etc. to this wiki


XML to Wiki
===========


To get the reference information for applications, functions, etc. into the wiki, we need a tool that will keep what is in the source tree in sync with the wiki. The XML documentation in Asterisk should be the master, meaning that the content should never be modified in the wiki directly. The documentation should be imported into the following pages, which are all child pages of [Asterisk Command Reference](/Asterisk-Command-Reference):


[Asterisk Command Reference](/Asterisk-Command-Reference)
For example, the Dial() application should get its own page that is a child of [Asterisk 1.8 Dialplan Applications](/Asterisk-1.8-Dialplan-Applications).


##### Development


The development of this tool should be done against a development instance of Confluence. An evaluation license can be used for that purpose. The APIs for Confluence are documented [here](http://confluence.atlassian.com/display/CONFDEV/Remote+API+Specification). Confluence has a set of REST APIs that are the newest development interface and will eventually be the preferred interface for development. However, the REST APIs do not yet support creating and updating pages. It is a read-only API. This tool will need to use the Confluence remote API, instead.


The programming language and supporting libraries are left as an option to the implementor.


##### Usage


The "astxmltowiki" tool should take the following arguments:


* path/to/core-en_US.xml
	+ Asterisk XML documentation file


The tool should also take the following options:


* *username* / *password*
	+ for confluence authentication
	+ if not specified, request it interactively at the command line
* *server*
	+ for the confluence URL
	+ default to <https://myth.asterisk.org>


##### High level operation


This is the general operation of the tool, expressed in psuedo code.




---

  
  


```


for each application/function/AGI command/AMI action {
 if page does not exist {
 create page
 }

 translate XML documentation into Confluence wiki syntax

 update page with new content
}


```


##### Wiki Syntax


Use the following pages for development of the wiki syntax template to use for each command reference type. While there is already a first pass on the wiki templates to be used on these pages, feel free to tweak it further.


* [Dialplan Application Template Page](/Dialplan-Application-Template-Page)
* [Dialplan Function Template Page](/Dialplan-Function-Template-Page)
* [AMI Action Template Page](/AMI-Action-Template-Page)
* [AGI Command Template Page](/AGI-Command-Template-Page)


##### Other Formatting Notes


In addition to the structural elements of the XML documentation which can be mapped into the templates, there are some other formatting elements used in the Asterisk XML documentation that need to be mapped to wiki syntax.


* <para>
	+ A paragraph.
* <literal>
	+ Literal (fixed-width). Wrap in 
	
	
	
	---
	
	  
	  
	
	
	```
	
	{{curly braces}}
	
	```
	
	
	
	---
	
	
	
	 and it will `look like this`.
* <emphasis>
	+ Make these italics by wrapping the next with underscores. It will *look like this*.
* <replaceable>
	+ ...
* <directory>
	+ Do nothing.
* <astcli>
	+ ...


##### Asterisk Versioning


Every page should include a note that identifies which version of Asterisk the documentation was imported from. There should *not* be more than one instance of a page for a particular application by version. Instead, we need to improve the documentation XML format to include the ability to tag elements with a version when they were first introduced. Once the mechanism for doing this has been decided, the base version for all documentation in this wiki will need to be Asterisk 1.8. From there, we can start tagging new additions with a version number of 10.

