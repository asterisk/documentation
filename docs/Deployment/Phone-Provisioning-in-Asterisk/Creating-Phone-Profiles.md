---
title: Creating Phone Profiles
pageid: 5243051
---

A phone profile is basically a list of files that a particular group of phones needs to function. For most phone types there are files that are identical for all phones (firmware, for instance) as well as a configuration file that is specific to individual phones. res\_phoneprov breaks these two groups of files into static files and dynamic files, respectively. A sample profile:



[polycom] 
staticdir => configs/ 
mime\_type => text/xml 
setvar => CUSTOM\_CONFIG=/var/lib/asterisk/phoneprov/configs/custom.cfg 
static\_file => bootrom.ld,application/octet-stream 
static\_file => bootrom.ver,plain/text 
static\_file => sip.ld,application/octet-stream 
static\_file => sip.ver,plain/text 
static\_file => sip.cfg 
static\_file => custom.cfg 
${TOLOWER(${MAC})}.cfg => 000000000000.cfg 
${TOLOWER(${MAC})}-phone.cfg => 000000000000-phone.cfg config/
${TOLOWER(${MAC})} => polycom.xml 
${TOLOWER(${MAC})}-directory.xml => 000000000000-directory.xml

A static\_file is set by specifying the file name, relative to AST\_DATA\_DIR/phoneprov. The mime-type of the file can optionally be specified after a comma. If staticdir is set, all static files will be relative to the subdirectory of AST\_DATA\_DIR/phoneprov specified. 


Since phone-specific config files generally have file names based on phone-specifc data, dynamic filenames in res\_phoneprov can be defined with Asterisk dialplan function and variable substitution. In the above example, ${TOLOWER(${MAC})}.cfg = 000000000000.cfg would define a relative URI to be served that matches the format of MACADDRESS.cfg, all lower case. A request for that file would then point to the template found at AST\_DATA\_DIR/phoneprov/000000000000.cfg. The template can be followed by a comma and mime-type. Notice that the dynamic filename (URI) can contain contain directories. Since these files are dynamically generated, the config file itself does not reside on the filesystem-only the template. To view the generated config file, open it in a web browser. If the config file is XML, Firefox should display it. Some browsers will require viewing the source of the page requested. 


A default mime-type for the profile can be defined by setting mime-type. If a custom variable is required for a template, it can be specified with setvar. Variable substitution on this value is done while building the route list, so ${USERNAME} would expand to the username of the users.conf user that registers the dynamic filename. 



Any dialplan function that is used for generation of dynamic file names MUST be loaded before res\_phoneprov. Add "preload = modulename.so" to modules.conf for required functions. In the example above, "preload = func\_strings.so" would be required.

