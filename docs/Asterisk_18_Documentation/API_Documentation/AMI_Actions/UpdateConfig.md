---
search:
  boost: 0.5
title: UpdateConfig
---

# UpdateConfig

### Synopsis

Update basic configuration.

### Description

This action will modify, create, or delete configuration elements in Asterisk configuration files.<br>


### Syntax


```


Action: UpdateConfig
ActionID: <value>
SrcFilename: <value>
DstFilename: <value>
Reload: <value>
PreserveEffectiveContext: <value>
Action-000000: <value>
Cat-000000: <value>
Var-000000: <value>
Value-000000: <value>
Match-000000: <value>
Line-000000: <value>
Options-000000: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `SrcFilename` - Configuration filename to read (e.g. *foo.conf*).<br>

* `DstFilename` - Configuration filename to write (e.g. *foo.conf*)<br>

* `Reload` - Whether or not a reload should take place (or name of specific module).<br>

* `PreserveEffectiveContext` - Whether the effective category contents should be preserved on template change. Default is true (pre 13.2 behavior).<br>

* `Action-000000` - Action to take.<br>
0's represent 6 digit number beginning with 000000.<br>

    * `NewCat`

    * `RenameCat`

    * `DelCat`

    * `EmptyCat`

    * `Update`

    * `Delete`

    * `Append`

    * `Insert`

* `Cat-000000` - Category to operate on.<br>
0's represent 6 digit number beginning with 000000.<br>

* `Var-000000` - Variable to work on.<br>
0's represent 6 digit number beginning with 000000.<br>

* `Value-000000` - Value to work on.<br>
0's represent 6 digit number beginning with 000000.<br>

* `Match-000000` - Extra match required to match line.<br>
0's represent 6 digit number beginning with 000000.<br>

* `Line-000000` - Line in category to operate on (used with delete and insert actions).<br>
0's represent 6 digit number beginning with 000000.<br>

* `Options-000000` - A comma separated list of action-specific options.<br>

    * `NewCat` - One or more of the following...<br>

        * `allowdups` - Allow duplicate category names.<br>

        * `template` - This category is a template.<br>

        * `inherit="template[,...]"` - Templates from which to inherit.<br>
<br>
The following actions share the same options...<br>

    * `RenameCat`

    * `DelCat`

    * `EmptyCat`

    * `Update`

    * `Delete`

    * `Append`

    * `Insert` - <br>

        * `catfilter="<expression>[,...]"` - <br>
A comma separated list of _name\_regex_=_value\_regex_ expressions which will cause only categories whose variables match all expressions to be considered. The special variable name 'TEMPLATES' can be used to control whether templates are included. Passing 'include' as the value will include templates along with normal categories. Passing 'restrict' as the value will restrict the operation to ONLY templates. Not specifying a 'TEMPLATES' expression results in the default behavior which is to not include templates.<br>
catfilter is most useful when a file contains multiple categories with the same name and you wish to operate on specific ones instead of all of them.<br>
0's represent 6 digit number beginning with 000000.<br>

### See Also

* [AMI Actions GetConfig](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/GetConfig)
* [AMI Actions GetConfigJSON](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/GetConfigJSON)
* [AMI Actions CreateConfig](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/CreateConfig)
* [AMI Actions ListCategories](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/ListCategories)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 