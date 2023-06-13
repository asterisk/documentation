---
title: Confluence Tips
pageid: 9076863
---

{numberedheadings}

{toc}

h1. Page Setup Tips

h2. Numbered Headings

To have the section headings automatically numbered, wrap the entire page in the {{\{numberedheadings\}}} macro.

For more information, see the home page for the [Numbered Headings|https://studio.plugins.atlassian.com/wiki/display/NUMHEAD/Numbered+Headings] plugin.

The numbered headings plugins expects that the headings are used in order (h1, h2, h3, etc.). If you skip levels, it will not number the headings.

h2. Table of Contents

Adding a table of contents to your page is easy. To do so, add the {{\{toc\}}} macro where you would like the table of contents to be inserted. This is useful in combination with numbered headings. Both are used on this page.

h1. Formatting Tips

h2. Configuration Examples

The {{\{code\}}} macro does a nice job with formatting a block for an Asterisk configuration example. Be sure to add a title, too by doing {{\{code:title=asterisk.conf\}}}. For example:

{code:title=asterisk.conf}
[section]

var=value
foo=bar
{code}

h2. Code Examples

The {{\{code\}}} macro supports a bunch of different programming languages. See the [notation guide|https://wiki.asterisk.org/wiki/renderer/notationhelp.action] for details. Tell the macro which programming language you're using ({{\{code:xml|title=example.xml\}}}) and it will do syntax highlighting for you. For a list of programming languages supported by this macro, see this page on the [newcode macro|https://studio.plugins.atlassian.com/wiki/display/NCODE/Confluence+New+Code+Macro].

{code:xml|title=example.xml}
<?xml version="1.0"?>

<menu name="Asterisk Module and Build Option Selection">
 <category name="MENUSELECT\_ADDONS" displayname="Add-ons (See README-addons.txt)" remove\_on\_change="addons/modules.link">
 <member name="app\_mysql" displayname="Simple Mysql Interface" remove\_on\_change="addons/app\_mysql.o addons/app\_mysql.so">
 <depend>mysqlclient</depend>
 <defaultenabled>no</defaultenabled>
 </member>
 </category>
</menu>
{code}

{code:java|title=example.java}
class Example {

public static void main(String args[])
{
 System.out.println("Hello World");
}

}
{code}

{code:cpp|title=example.cpp}
class Example {
public:
 Example();
 ~Example();

 void setFoo(int f);
 int getFoo(void) const;

private:
 int foo;
};
{code}

{numberedheadings}