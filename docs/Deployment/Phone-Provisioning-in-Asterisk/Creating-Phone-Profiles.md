---
title: Creating Phone Profiles
pageid: 5243051
---

A phone profile is basically a list of files that a particular group of phones needs to function. For most phone types there are files that are identical for all phones (firmware, for instance) as well as a configuration file that is specific to individual phones. res_phoneprov breaks these two groups of files into static files and dynamic files, respectively. A sample profile:

```

[polycom] 
staticdir => configs/ 
mime_type => text/xml 
setvar => CUSTOM_CONFIG=/var/lib/asterisk/phoneprov/configs/custom.cfg 
static_file => bootrom.ld,application/octet-stream 
static_file => bootrom.ver,plain/text 
static_file => sip.ld,application/octet-stream 
static_file => sip.ver,plain/text 
static_file => sip.cfg 
static_file => custom.cfg 
${TOLOWER(${MAC})}.cfg => 000000000000.cfg 
${TOLOWER(${MAC})}-phone.cfg => 000000000000-phone.cfg config/
${TOLOWER(${MAC})} => polycom.xml 
${TOLOWER(${MAC})}-directory.xml => 000000000000-directory.xml

```

A static_file is set by specifying the file name, relative to AST_DATA_DIR/phoneprov. The mime-type of the file can optionally be specified after a comma. If staticdir is set, all static files will be relative to the subdirectory of AST_DATA_DIR/phoneprov specified. 


Since phone-specific config files generally have file names based on phone-specifc data, dynamic filenames in res_phoneprov can be defined with Asterisk dialplan function and variable substitution. In the above example, ${TOLOWER(${MAC})}.cfg = 000000000000.cfg would define a relative URI to be served that matches the format of MACADDRESS.cfg, all lower case. A request for that file would then point to the template found at AST_DATA_DIR/phoneprov/000000000000.cfg. The template can be followed by a comma and mime-type. Notice that the dynamic filename (URI) can contain contain directories. Since these files are dynamically generated, the config file itself does not reside on the filesystem-only the template. To view the generated config file, open it in a web browser. If the config file is XML, Firefox should display it. Some browsers will require viewing the source of the page requested. 


A default mime-type for the profile can be defined by setting mime-type. If a custom variable is required for a template, it can be specified with setvar. Variable substitution on this value is done while building the route list, so ${USERNAME} would expand to the username of the users.conf user that registers the dynamic filename. 




!!! note 
    Any dialplan function that is used for generation of dynamic file names MUST be loaded before res_phoneprov. Add "preload = modulename.so" to modules.conf for required functions. In the example above, "preload = func_strings.so" would be required.

      
[//]: # (end-note)



