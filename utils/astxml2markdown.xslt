<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ast="ast"
xmlns:str="http://exslt.org/strings"
extension-element-prefixes="ast str"
>

<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:variable name="tabsize" select="'4'" />
<xsl:variable name="bulletchar" select="'*'" />

<xsl:template match="text()"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="application">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text><xsl:value-of select="@name"/><xsl:text>()</xsl:text>
    <xsl:choose>
        <xsl:when test="@module">
        <xsl:text> - [</xsl:text><xsl:value-of select="@module"/><xsl:text>\]</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>### Synopsis&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="description">
        <xsl:text>### Description&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="description"/>
    </xsl:if>
    <xsl:text>### Syntax&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="syntax">
        <xsl:with-param name="type">application</xsl:with-param>
        <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="see-also"/>
</xsl:template>

<xsl:template match="function">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text><xsl:value-of select="@name"/><xsl:text>()</xsl:text>
    <xsl:choose>
        <xsl:when test="@module">
            <xsl:text> - [</xsl:text><xsl:value-of select="@module"/><xsl:text>\]</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>### Synopsis&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:text>### Description&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="description"/>
    <xsl:text>### Syntax&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="syntax">
        <xsl:with-param name="type">function</xsl:with-param>
        <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="see-also"/>
</xsl:template>

<xsl:template match="agi">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="translate(@name, $smallcase, $uppercase)"/><xsl:text>
---

# </xsl:text><xsl:value-of select="translate(@name, $smallcase, $uppercase)"/>
    <xsl:choose>
        <xsl:when test="@module">
        <xsl:text> - [</xsl:text><xsl:value-of select="@module"/><xsl:text>\]</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>### Synopsis&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:text>### Description&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="description"/>
    <xsl:text>### Syntax&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="syntax">
        <xsl:with-param name="type">agi</xsl:with-param>
        <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="see-also"/>
</xsl:template>

<xsl:template match="manager">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text><xsl:value-of select="@name"/>
    <xsl:choose>
        <xsl:when test="@module">
        <xsl:text> - [</xsl:text><xsl:value-of select="@module"/><xsl:text>\]</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>### Synopsis&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:text>### Description&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="description"/>
    <xsl:text>### Syntax&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="syntax">
        <xsl:with-param name="type">manager</xsl:with-param>
        <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="see-also"/>
</xsl:template>

<xsl:template match="managerEvent">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text><xsl:value-of select="@name"/>
    <xsl:choose>
        <xsl:when test="@module">
        <xsl:text> - [</xsl:text><xsl:value-of select="@module"/><xsl:text>\]</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates select="managerEventInstance">
        <xsl:with-param name="name" select="@name"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="managerEventInstance">
    <xsl:param name="name"/>
    <xsl:text>### Synopsis&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="description">
        <xsl:text>### Description&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="description"/>
    </xsl:if>
    <xsl:text>### Syntax&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="syntax">
        <xsl:with-param name="type">managerEvent</xsl:with-param>
        <xsl:with-param name="name" select="$name"/>
    </xsl:apply-templates>
    <xsl:text>### Class&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="substring(@class, 12)"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="see-also"/>
</xsl:template>

<xsl:template match="configInfo">
     <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:if test="synopsis">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="synopsis"/>
    </xsl:if>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:text>This configuration documentation is for functionality provided by </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>.</xsl:text>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="description">
        <xsl:text>## Overview</xsl:text>
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:apply-templates select="description"/>
    </xsl:if>
    <xsl:apply-templates select="configFile"/>
</xsl:template>

<xsl:template match="configFile">
    <xsl:text>## </xsl:text>
    <xsl:text>Configuration File: </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates select="configObject"/>
</xsl:template>

<xsl:template match="configObject">
    <xsl:text>### </xsl:text>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>]: </xsl:text>
    <xsl:apply-templates select="synopsis"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="since">
        <xsl:text>### Since&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="description"/>
    <xsl:if test="count(configOption) &gt; 0">
        <xsl:text>#### Configuration Option Reference</xsl:text>
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:text>| Option Name | Type | Default Value | Regular Expression | Description | Since |&#10;</xsl:text>
        <xsl:text>|:---|:---|:---|:---|:---|:---| &#10;</xsl:text>
    </xsl:if>
    <xsl:for-each select="configOption">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select=".">
            <xsl:with-param name="object_name" select="@name"/>
            <xsl:with-param name="summary" select="'true'"/>
        </xsl:apply-templates>
    </xsl:for-each>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:choose>
        <xsl:when test="configOption/description">
            <xsl:text>#### Configuration Option Descriptions</xsl:text>
            <xsl:text>&#10;&#10;</xsl:text>
            <xsl:for-each select="configOption">
                <xsl:sort select="@name"/>
                <xsl:apply-templates select=".">
                    <xsl:with-param name="object_name" select="@name"/>
                    <xsl:with-param name="summary" select="'false'"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:when>
    </xsl:choose>
            
</xsl:template>

<xsl:template match="configOption/@*">
    <xsl:param name="description"/>
    <xsl:param name="object_name"/>
    <xsl:text>| </xsl:text>
    <xsl:if test="string-length(.) &gt; 0">
        <xsl:if test="$description">
            <xsl:text>[</xsl:text>
        </xsl:if>
        <xsl:value-of select="translate(.,'\%!@${}&amp;^[]|+', '')"/>
        <xsl:if test="$description">
            <xsl:text>](#</xsl:text>
            <xsl:value-of select="translate(.,'\%!@${}&amp;^[]|+', '')"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="configOption">
    <xsl:param name="object_name"/>
    <xsl:param name="summary"/>
    <xsl:if test="$summary='true'">
        <xsl:apply-templates select="@name">
            <xsl:with-param name="description" select="description"/>
            <xsl:with-param name="object_name" select="$object_name"/>
        </xsl:apply-templates>
        <xsl:if test="not(@type)">
            <xsl:text>| </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="@type"/>

        <xsl:if test="not(@default)">
            <xsl:text>| </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="@default"/>

        <xsl:if test="not(@regex)">
            <xsl:text>| </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="@regex"/>

        <xsl:text>| </xsl:text>
        <xsl:apply-templates select="synopsis"/>
        <xsl:text>| </xsl:text>
        <xsl:apply-templates select="since"/>
        <xsl:text>|&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="$summary='false'">
        <xsl:if test="description">
            <xsl:text>##### </xsl:text>
            <xsl:value-of select="translate(@name,'\%!@{}$&amp;^[]|+','')"/>
            <xsl:text>&#10;&#10;</xsl:text>
            <xsl:if test="since">
                    <xsl:text>Since: </xsl:text>
                    <xsl:apply-templates select="since" />
                    <xsl:text>&#10;&#10;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="description"/>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="module">
    <xsl:text>---
search:
  boost: 0.5
title: </xsl:text><xsl:value-of select="@name"/><xsl:text>
---

# </xsl:text><xsl:value-of select="@name"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>## Support Level </xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="support_level"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="deprecated_in">
        <xsl:text>## Deprecated In </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="deprecated_in"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="removed_in">
        <xsl:text>## Removed In </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="removed_in"/>
        <xsl:text>&#10;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="synopsis">
    <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="since">
    <xsl:for-each select="*">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template match="support_level">
    <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="deprecated_in">
    <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="removed_in">
    <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="description">
    <xsl:param name="bulletlevel">0</xsl:param>

    <!--
    Note: we do a for-each to preserve the order of the nodes.
    If we simply did an apply-template, paragraphs would get mixed up with
    variable lists, etc.
     -->
    <for-each select="./*">
        <xsl:apply-templates select="./*">
            <xsl:with-param name="bulletlevel" select="$bulletlevel"/>
            <xsl:with-param name="returntype" select="single"/>
        </xsl:apply-templates>
        <!--
        Insert an extra carriage return here to provide some nicer reading
        for walls of text
        -->
        <xsl:text>&#10;</xsl:text>
    </for-each>
</xsl:template>

<!-- 
Syntax is a bit odd.  Each application type has its own formatting
for how something should be called, which is determined based on the passed
in parameter type.  Once the syntax is formatted, a description of each
parameter/option is displayed under the Arguments heading.  This reparses
the XML again with the full descriptions, and forms bulleted lists.
-->
<xsl:template match="syntax">
    <xsl:param name="type"/>
    <xsl:param name="name"/>
    <xsl:text>&#10;```&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="$type='application'">
        <!-- 
        This big long nasty block constructs the syntax to call an
        application.  This parses through each parameter, and - if
        a parameter has arguments - defers the syntax to the arguments.
        If a parameter does not have arguments, it uses the syntax from
        the parameter node.  For optional parameters, a two-pass approach
        is used for the nodes to properly bracket the parameters.
        i-->
        <xsl:value-of select="$name"/><xsl:text>(</xsl:text>
        <xsl:for-each select="parameter">
            <xsl:choose>
                <!-- Ignore dialplan contexts and extensions as priority will encompass it -->
                <xsl:when test="(@documentationtype='dialplan_context' or @documentationtype='dialplan_extension')">
                </xsl:when>
                <!-- Handle parameters with arguments -->
                <xsl:when test="argument">
                    <!-- Close off optional parameters if we're required and last -->
                    <xsl:choose>
                        <xsl:when test="(@documentationtype='dialplan_context' or @documentationtype='dialplan_extension' or @documentationtype='dialplan_priority')">
                        </xsl:when>
                        <xsl:when test="position() = last() and (@required='yes' or @required='true')">
                            <xsl:for-each select="current()/../parameter">
                                <xsl:choose>
                                    <xsl:when test="@required='true' or @required='yes' or position() = last()"/>
                                    <xsl:otherwise>
                                        <xsl:text>]</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>

                    <!-- Only display the parameter name if the parameter
                         itself has argument parameters; otherwise, the
                         arguments themselves form the parameter -->
                    <xsl:if test="@hasparams">
                        <!-- Dialplan priority has special handling for conversion, as it encompasses the entire CEP -->
                        <xsl:choose>
                            <xsl:when test="(@documentationtype='dialplan_priority')">
                                <xsl:text>[[context,]extension,]priority</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@name"/>
                            </xsl:otherwise>
                        </xsl:choose>

                        <xsl:if test="@hasparams='optional'">
                            <xsl:text>[</xsl:text>
                        </xsl:if>
                        <xsl:text>(</xsl:text>
                    </xsl:if>

                    <xsl:for-each select="argument">
                        <!-- By default, arguments are optional -->
                        <xsl:choose>
                            <xsl:when test="@required='yes' or @required='true'"/>
                            <xsl:otherwise>
                                <xsl:text>[</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>

                        <xsl:choose>
                            <xsl:when test="(@documentationtype='dialplan_priority')">
                                <xsl:text>[[context,]extension,]priority</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@name"/>
                            </xsl:otherwise>
                        </xsl:choose>

                        <!-- Separators are either the parent's or ',' -->
                        <xsl:if test="position() != last()">
                            <xsl:choose>
                                <xsl:when test="../@argsep">
                                    <xsl:value-of select="../@argsep"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>,</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="@multiple='true' or @multiple='yes'">
                            <xsl:text>[</xsl:text>
                            <!-- Only display separator in multi if we have something before us -->
                            <xsl:if test="position() = last()">
                                <xsl:choose>
                                    <xsl:when test="../@argsep">
                                        <xsl:value-of select="../@argsep"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>,</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:text>...</xsl:text>
                            <xsl:text>]</xsl:text>
                        </xsl:if>

                    </xsl:for-each>

                    <!-- Close off optional arguments -->
                    <xsl:for-each select="argument">
                        <xsl:choose>
                            <xsl:when test="@required='yes' or @required='true'"/>
                            <xsl:otherwise>
                                <xsl:text>]</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>

                    <!-- Close off the parameter arguments -->
                    <xsl:if test="@hasparams">
                        <xsl:if test="@hasparams='optional'">
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:text>)</xsl:text>
                    </xsl:if>

                    <!-- Use the local separator, or the parent, or ',' -->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="../@argsep">
                                <xsl:value-of select="../@argsep"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>,</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Handle regular parameters -->
                    <xsl:choose>
                        <xsl:when test="@required='true' or @required='yes'" />
                        <xsl:otherwise>
                            <xsl:text>[</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Close off optional parameters -->
                    <xsl:choose>
                        <xsl:when test="position() = last() and (@required='true' or @required='yes')">
                            <xsl:for-each select="current()/../parameter">
                                <xsl:choose>
                                    <!-- 'dialplan_priority' should handle closing brackets for us, so ignore context and extension -->
                                    <xsl:when test="(@required='true' or @required='yes' or position() = last()) or (@documentationtype='dialplan_context' or @documentationtype='dialplan_extension')"/>
                                    <xsl:otherwise>
                                        <xsl:text>]</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="(@documentationtype='dialplan_priority')">
                            <xsl:text>[[context,]extension,]priority</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="../@argsep">
                                <xsl:value-of select="../@argsep"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>,</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="@multiple='true' or @multiple='yes'">
                        <xsl:text>[</xsl:text>
                        <xsl:choose>
                            <xsl:when test="../@argsep">
                                <xsl:value-of select="../@argsep"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>,</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>...</xsl:text>
                        <xsl:text>]</xsl:text>
                    </xsl:if>

                    <!-- Close off optional parameters -->
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <!-- Only close off parameters if the last parameter is not required -->
                            <xsl:choose>
                                <xsl:when test="@required='true' or @required='yes'"/>
                                <xsl:otherwise>
                                    <xsl:for-each select="current()/../parameter">
                                        <xsl:choose>
                                            <xsl:when test="@required='true' or @required='yes'"/>
                                            <xsl:otherwise>
                                                <xsl:text>]</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose> <!-- optional args -->
                </xsl:otherwise>  <!-- parameters w/o arguments -->
            </xsl:choose>
        </xsl:for-each>           <!-- for-each parameter -->
        <xsl:for-each select="parameter">
            <xsl:choose>
                <xsl:when test="argument"/>
                <xsl:choose>
                    <xsl:when test="@required='true' or @required='yes'"/>
                    <xsl:otherwise>
                        <xsl:text>[</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:choose>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="$type='function'">
        <xsl:value-of select="translate($name, $smallcase, $uppercase)"/>
        <xsl:text>(</xsl:text>
            <xsl:for-each select="parameter">
                <xsl:if test="@required='false' or @required='no'">
                    <xsl:text>[</xsl:text>
                </xsl:if>
                <xsl:if test="position() &gt; 1">
                    <xsl:choose>
                        <xsl:when test="../@argsep">
                            <xsl:value-of select="../@argsep"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>,</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:value-of select="@name"/>
                <xsl:if test="@multiple='true' or @multiple='yes'">
                    <xsl:text>[</xsl:text>
                    <xsl:choose>
                        <xsl:when test="../@argsep">
                            <xsl:value-of select="../@argsep"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>,</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>...</xsl:text>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="parameter">
                <xsl:if test="@required='false' or @required='no'">
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="$type='agi'">
        <xsl:value-of select="translate($name, $smallcase, $uppercase)"/>
        <xsl:text> </xsl:text>
        <xsl:for-each select="parameter">
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:value-of select="translate(@name, $smallcase, $uppercase)"/>
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:if>
    <xsl:if test="$type='manager'">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>Action: </xsl:text><xsl:value-of select="$name"/><xsl:text>&#10;</xsl:text>
        <xsl:for-each select="parameter">
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:value-of select="@name"/>
            <xsl:text>: &lt;value&gt;</xsl:text>
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:if>
    <xsl:if test="$type='managerEvent'">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>Event: </xsl:text><xsl:value-of select="$name"/><xsl:text>&#10;</xsl:text>
        <xsl:for-each select="parameter">
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:value-of select="@name"/>
            <xsl:text>: &lt;value&gt;</xsl:text>
            <xsl:if test="@required='false' or @required='no'">
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>```</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>##### Arguments</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
        <xsl:when test="parameter">
            <xsl:apply-templates select="parameter">
                <xsl:with-param name="bulletlevel" select="0"/>
            </xsl:apply-templates>
            <xsl:text>&#10;</xsl:text>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template match="see-also">
    <xsl:if test="ref">
    <xsl:text>### See Also&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="ref"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="ref">
    <!--
    Note that the links should have already been formed properly by the
    python script
    -->
    <xsl:text>* </xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="info">
    <xsl:param name="bulletlevel"/>
    <xsl:param name="returntype"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:value-of select="concat('* __Technology: ', @tech, '__')"/>
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text>&lt;br&gt;&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
           <xsl:text>&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    
    <xsl:apply-templates>
        <xsl:with-param name="returntype">single</xsl:with-param>
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
    </xsl:apply-templates>
    
    
    <!-- xsl:if test="para">
        <xsl:apply-templates select="para">
            <xsl:with-param name="returntype">single</xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:apply-templates select="example"/>
    <xsl:apply-templates select="note">
        <xsl:with-param name="returntype">single</xsl:with-param>
    </xsl:apply-templates>
    <xsl:apply-templates select="warning">
        <xsl:with-param name="returntype">single</xsl:with-param>
    </xsl:apply-templates>
    <xsl:apply-templates select="variablelist">
        <xsl:with-param name="bullet" select="$bullet"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="enumlist">
        <xsl:with-param name="bullet" select="$bullet"/>
    </xsl:apply-templates>
    -->
</xsl:template>

<xsl:template match="parameter">
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>* `</xsl:text><xsl:value-of select="@name"/><xsl:text>`</xsl:text>
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text> - </xsl:text>
        </xsl:when>
        <xsl:otherwise>
           <xsl:text>&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- Note: we do a for-each to preserve the order of the nodes -->
    <for-each select="./*">
        <xsl:apply-templates select="./*">
            <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
            <xsl:with-param name="returntype">single</xsl:with-param>
        </xsl:apply-templates>
    </for-each>
</xsl:template>

<xsl:template match="argument">
    <xsl:param name="bulletlevel"/>
    <xsl:param name="separator">,</xsl:param>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>* `</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:if test="@multiple='true' or @multiple='yes'">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$separator"/>
        <xsl:value-of select="@name"/>
        <xsl:text>...]</xsl:text>
    </xsl:if>
    <xsl:if test="@hasparams='yes' or @hasparams='true' or @hasparams='optional'">
        <xsl:text> (</xsl:text>
        <xsl:if test="@hasparams='yes' or @hasparams='true'">
            <xsl:text>*</xsl:text>
        </xsl:if>
        <xsl:text>params</xsl:text>
        <xsl:if test="@hasparams='yes' or @hasparams='true'">
            <xsl:text>*</xsl:text>
        </xsl:if>
        <xsl:text> )</xsl:text>
    </xsl:if>
    <xsl:text>`</xsl:text>
    <xsl:if test="@required='true' or @required='yes'">
        <xsl:text> **required**</xsl:text>
    </xsl:if>
    
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text> - </xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <for-each select="./*">
        <xsl:apply-templates select="./*">
            <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
            <xsl:with-param name="separator" select="@argsep"/>
            <xsl:with-param name="returntype">single</xsl:with-param>
        </xsl:apply-templates>
    </for-each>
</xsl:template>

<!--
Paragraphs can be outputted either with carriage returns between paragraphs,
or with no extra spacing.  The returntype parameter determines how they should
be displayed.
-->
<xsl:template match="para">
    <xsl:param name="returntype"/>
<!-- 
    <xsl:for-each select="*">
    <xsl:choose>
        <xsl:when test="literal">
            <xsl:apply-templates select="literal"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:for-each>
 -->    
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:choose>
        <xsl:when test="$returntype='none'">
            <xsl:text>&#10;</xsl:text>
        </xsl:when>
        <xsl:when test="$returntype='single'">
            <xsl:text>&lt;br&gt;&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&lt;br&gt;&#10;&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="example">
    <xsl:text>``` title="Example: </xsl:text>
    <xsl:value-of select="@title"/>
    <xsl:text>"&#10;</xsl:text>
    <ast:strip>
        <xsl:value-of select="."/>
    </ast:strip>
    <xsl:text>&#10;```&#10;</xsl:text>
</xsl:template>

<xsl:template match="note">
    <xsl:param name="returntype"/>
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>/// note
</xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>
///

</xsl:text>
</xsl:template>

<xsl:template match="warning">
    <xsl:param name="returntype"/>
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>/// warning
</xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>
///

</xsl:text>
</xsl:template>

<xsl:template match="variablelist">
    <xsl:param name="bulletlevel"/>
    <xsl:apply-templates select="variable">
        <xsl:with-param name="bulletlevel" select="$bulletlevel"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="variable">
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>* `</xsl:text>
    <xsl:value-of select="translate(@name, $smallcase, $uppercase)"/>
    <xsl:text>`</xsl:text>
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="para">
                <xsl:with-param name="returntype">single</xsl:with-param>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
        <xsl:when test="value">
            <xsl:for-each select="value">
    <xsl:text>
</xsl:text>
                <xsl:value-of select="str:padding(($bulletlevel + 1) * $tabsize, ' ')"/>
                <xsl:text>* `</xsl:text>
                <xsl:value-of select="translate(@name, $smallcase, $uppercase)"/>
                <xsl:text>`</xsl:text>
                <xsl:choose>
                    <xsl:when test="string-length(@default) &gt; 0">
                        <xsl:text> default: (</xsl:text><xsl:value-of select="@default"/><xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="string-length(.) &gt; 0">
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:if>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template match="enumlist">
    <xsl:param name="bulletlevel"/>
    <xsl:apply-templates select="enum">
        <xsl:with-param name="bulletlevel" select="$bulletlevel"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="enum">
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>* `</xsl:text><xsl:value-of select="@name"/><xsl:text>`</xsl:text>
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="para">
                <xsl:with-param name="returntype">single</xsl:with-param>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>
</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
<!-- 
    <xsl:apply-templates select="./*">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
        <xsl:with-param name="returntype">single</xsl:with-param>
    </xsl:apply-templates>
 -->    
    <xsl:apply-templates select="enumlist">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="parameter">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="note">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
        <xsl:with-param name="returntype">single</xsl:with-param>
    </xsl:apply-templates>
    <xsl:apply-templates select="warning">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
        <xsl:with-param name="returntype">single</xsl:with-param>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="optionlist">
    <xsl:param name="bulletlevel"/>
    <xsl:apply-templates select="option">
        <xsl:with-param name="bulletlevel" select="$bulletlevel"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="option">
    <xsl:param name="bulletlevel"/>
    <xsl:text>
</xsl:text>
    <xsl:value-of select="str:padding($bulletlevel * $tabsize, ' ')"/>
    <xsl:text>* `</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:if test="argument">
        <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:for-each select="argument">
        <!-- xsl:if test="@required='true' or @required='yes'">
            <xsl:text>*</xsl:text>
        </xsl:if-->
        <xsl:value-of select="@name"/>
        <!-- xsl:if test="@required='true' or @required='yes'">
            <xsl:text>*</xsl:text>
        </xsl:if-->
        <xsl:if test="position() != last()">
            <xsl:choose>
                <xsl:when test="../@argsep">
                    <xsl:value-of select="../@argsep"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>,</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
    </xsl:for-each>
    <xsl:if test="argument">
        <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>`</xsl:text>
    <xsl:choose>
        <xsl:when test="para">
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="para">
                <xsl:with-param name="returntype">single</xsl:with-param>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&#10;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="variablelist">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="argument">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
        <xsl:with-param name="separator" select="@argsep"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="enumlist">
        <xsl:with-param name="bulletlevel" select="$bulletlevel + 1"/>
    </xsl:apply-templates>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet> 
