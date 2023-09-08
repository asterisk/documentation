#!/usr/bin/env python3
"""Asterisk XML to Markdown Generator

This module implements functionality to take the Asterisk XML documentation
and produce resulting Markdown files.

Based on the original astxml2wiki implementation for publishing to
Confluence.

Copyright (C) 2023, Sangoma Technologies, Inc.
Joshua C. Colp <jcolp@sangoma.com>

This program is free software, distributed under the terms of
the GNU General Public License Version 2.
"""

import sys, os, re
import lxml.etree as etree
import string
import copy
from optparse import OptionParser
import re
import pprint
from copy import deepcopy

pp = pprint.PrettyPrinter(indent=2)

usage = "Usage: ./astxml2markdown.py " \
    "--branch=\"master\" " \
    "--file=/path/to/core-en_US.xml " \
    "--directory=docs " \
    "--version=master " \
    "--revision=551bb8a8cf807fbdb3d2c3c017ee362bdb9934a9 "


class FormatExample(etree.XSLTExtension):
    def __init__(self):
        self.replre = re.compile(r'^\s+')

    def execute(self, context, self_node, input_node, output_parent):
        newtext = re.sub(self.replre, '', input_node.text)
        newnode = deepcopy(input_node)
        newnode.text = newtext
        output_parent.append( newnode )

def escape(string):
    return re.sub(r'([\{\}\[\]^_])', r'\\\1', string)

class AstXML2Markdown:
    def __init__(self, argv):
        self._markup_tags = {
            'filename': ('*','*'),
            'directory': ('*','*'),
            'emphasis': ('*','*'),
            'variable': ('**','**'),
            'literal': ('\'','\''),
            'replaceable': ('_','_'),
            'astcli': ('`','`')}

        self.s = ''
        self.elements = []
        self.args = {
            'branch': '',
            'file': '',
            'directory': '',
            'revision': '',
            'version': '',
        }

        argv.pop(0)
        for a in argv:
            pieces = a.split("=", 1)
            try:
                self.args[pieces[0].strip('-')] = pieces[1]
            except:
                self.args[pieces[0].strip('-')] = True

        self.parent = {
            'manager': 'AMI Actions',
            'function': 'Dialplan Functions',
            'application': 'Dialplan Applications',
            'agi': 'AGI Commands',
            'managerEvent': 'AMI Events',
            'configInfo': 'Module Configuration',
            'module': 'Modules'
        }

        if self.args['xslt'] == '':
            self.args['xslt'] = 'astxml2markdown.xslt'

        if self.args['file'] == '':
            sys.stderr.write("Please specify a path to core-en_US.xml.\n")
            sys.stderr.write(usage)
            sys.stderr.write("\n")
            sys.exit(2)
        elif self.args['directory'] == '':
            sys.stderr.write("Please specify a directory to store markdown files in.\n")
            sys.stderr.write(usage)
            sys.stderr.write("\n")
            sys.exit(2)
        elif self.args['branch'] == '':
            sys.stderr.write("Please specify a branch for this documentation.\n")
            sys.stderr.write(usage)
            sys.stderr.write("\n")
            sys.exit(2)
        elif self.args['version'] == '' and self.args['revision'] == '':
            sys.stderr.write("Please specify a version or revision for this documentation.\n")
            sys.stderr.write(usage)
            sys.stderr.write("\n")
            sys.exit(2)

    def build_paragraph_contents(self, node):
        ''' First pass on the XML node.  For each para node, we need to replace
        out the formatting markup - using an XSLT to do this job is tricky, as
        it won't necessarily preserve the order of text/markup '''
        for paragraph in node.getiterator('para'):
            current_text = ''
            if paragraph.text:
                children = paragraph.getchildren()
		# Emulate the itertext function
                paragraph_text = []
                for p in paragraph.getiterator():
                    if p.text:
                        paragraph_text.append(p.text)
                    if p.tail:
                        paragraph_text.append(p.tail)

                for t in paragraph_text:
                    match = [markup for markup in children if markup.text == t]
                    if len(match):
                        # Just use the first.
                        markup = match[0]
                        if markup.tag in self._markup_tags.keys():
                            current_text += '%s%s%s' % (self._markup_tags[markup.tag][0], \
                            escape(t), self._markup_tags[markup.tag][1])
                    else:
                        current_text += escape(t)
                for c in children:
                    paragraph.remove(c)
                paragraph.text = current_text.replace('\n', ' ').replace('\t','')

        # values may also need to be escaped
        for value in node.getiterator('value'):
            if value.text:
                value.text = escape(value.text)
            # escape [] in names
            if 'name' in value.attrib:
                value.set('name', escape(value.get('name')))

        return node

    def build_seealso_references(self, node):
        # refnodes may be shared between nodes so we make a copy of everything
        # so we don't modify things multiple times
        node = copy.deepcopy(node)
        refnodes = node.getiterator('ref')
        for refnode in refnodes:
            type = refnode.attrib.get('type')
            module = refnode.attrib.get('module')
            if not module:
                module = ''
            else:
                module = '_%s' % module
            link = refnode.text.replace(" ", "_")

            if self.parent.get(type) is not None:
                link = '[%s %s%s](/Asterisk_%s_Documentation/API_Documentation/%s/%s%s)' % (
                    self.parent[type], link, module,
                    self.args['branch'],
                    self.parent[type].replace(' ', '_'), link, module)
            else:
                link = '{{%s}}\n' % link

            refnode.text = link

        return node

    def parse(self):
        ''' Collect and do the first pass of formatting on the XML nodes for each
        major type '''

        self.xmltree = etree.parse(self.args['file'])
        self.xmltree.xinclude()
        for child in self.xmltree.getiterator():
            if child.tag == 'application' or \
                child.tag == 'manager' or \
                child.tag == 'agi' or \
                child.tag == 'function' or \
                child.tag == 'configInfo' or \
                child.tag == 'managerEvent' or \
                child.tag == 'module':

                # Two things have to be constructed here.  The paragraph contents,
                # as we have XML embedded with text - and that's just not easy to
                # do in XSLT (without doing multiple XSLT passes).  The ref links
                # have to be built here, as we have the information to build the
                # page links based on what was passed in to this script.
                child = self.build_paragraph_contents(child)
                child = self.build_seealso_references(child)
                self.elements.append(child)


    def generate(self):
        ''' generate the markdown files according to formatting '''

        format_ext = FormatExample()
        extensions = { ('ast', 'strip') : format_ext }
        xslt = etree.XSLT(etree.parse(self.args['xslt']), extensions = extensions)

        markdown_path = self.args['directory']
        os.makedirs(markdown_path, exist_ok=True)
        with open(markdown_path + "/index.md", "w") as ix:
            ix.write("# API Documentation\n")

        # The over all layout of this is main documentation -> prefix/version documentation -> parents -> reference documentation

    	# Create the main directory to contain the markdown
        os.makedirs(markdown_path, exist_ok=True)

        # Go through the parents creating their directories and pages
        for parent in self.parent:
            os.makedirs(markdown_path + "/" + self.parent[parent].replace(' ', '_'), exist_ok=True)
            with open(markdown_path + "/" + self.parent[parent].replace(' ', '_') + "/index.md", "w") as ix:
                ix.write("# %s\n" % self.parent[parent])

        for node in self.elements:
            name = node.attrib.get('name')
            module = node.attrib.get('module')
            if not name:
                raise ValueError('name undefined for node')

            markdown = str(xslt(node))

            # Include the branch and version (or revision this was generated from)
            markdown += "\n### Generated Version\n\n"
            markdown += ("This documentation was generated from Asterisk branch %s" %
                self.args['branch'])
            if self.args['version']:
                markdown += (" using version %s " % self.args['version'])
            elif self.args['revision']:
                markdown += (" using revision %s " % self.args['revision'])

            filename = name.replace(" ", "_") + ".md"

            f = open(markdown_path + "/" + self.parent[node.tag].replace(' ', '_') + "/" + filename, "w")
            f.write(markdown)
            f.close()

def main(argv):
    a = AstXML2Markdown(argv)

    a.parse()

    a.generate()

    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv) or 0)
