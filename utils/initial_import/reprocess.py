#!/usr/bin/env python3
"""Confluence content dumper

Copyright (C) 2023, Sangoma Technologies Inc.
Joshua C. Colp <jcolp@sangoma.com>
George Joseph <gjoseph@sangoma.com>
"""

from argparse import ArgumentParser as ArgParser
import os
import sys
import pprint
import unicodedata
import re as regex
import json
import yaml
import time
import math

md_fixes = {}

def slugify(value, allow_unicode=False):
    """
    Taken from https://github.com/django/django/blob/master/django/utils/text.py
    Convert to ASCII if 'allow_unicode' is False. Convert spaces or repeated
    dashes to single dashes. Remove characters that aren't alphanumerics,
    underscores, or hyphens. Convert to lowercase. Also strip leading and
    trailing whitespace, dashes, and underscores.
    """
    value = str(value)
    if allow_unicode:
        value = unicodedata.normalize('NFKC', value)
    else:
        value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore').decode('ascii')
    value = regex.sub(r'[^.\w\s-]', '', value)
    return regex.sub(r'[-\s]+', '-', value).strip('-_')

def parse_args():
    """Function to handle building and parsing of command line arguments"""
    description = (
        'Command line utility to export pages in a Confluence space to markdown, html and/or json'
    )

    parser = ArgParser(description=description)
    parser.add_argument('--docs', type=str, default="docs", help="Document directory to process", required=False)
    parser.add_argument('--single-page', type=str, help="Single markdown page to process", required=False)
    parser.add_argument('--md-fixes', type=str, help="YAML file with markdown regex fixes", required=True)
    parser.add_argument('--quiet', dest="quiet", default=False,
                        action='store_const', const=True)
    parser.add_argument('--dry-run', dest="dry_run", default=False,
                        action='store_const', const=True)
    parser.add_argument('--no-recurse', dest="no_recurse", default=False,
                        action='store_const', const=True)

    args = parser.parse_args()
    if not args:
        return

    return args

def fix_document(page_num, path, md_fixes, args):

    with open(path, "r") as f:
        md_body = f.read()

    fixes = 0
    for fix in md_fixes:
        if fix.get("repeat", False):
            count = 1
            print("repeat")
            while count > 0:
                (md_body, count) = fix['re'].subn(fix['repl'], md_body)
                fixes += count
        else:
            (md_body, count) = fix['re'].subn(fix['repl'], md_body)
            fixes += count

    if not args.dry_run:
        with open(path, "w") as f:
            f.write(md_body)
        
    if not args.quiet and fixes > 0:
        print("%5d - %s  fixes: %d" % (page_num, path, fixes))

def reprocess():
    """Export all pages from a given Confluence space to markdown in local files"""

    # Arguments are required to exist
    args = parse_args()
    if not args:
        return

    md_fixes = None
    if args.md_fixes is not None:
        with open(args.md_fixes, "r") as f:
            md_fixes = yaml.load(f, Loader=yaml.Loader)
        for fix in md_fixes:
            fix['re'] = regex.compile(fix['pattern'], regex.M)

    page_num = 1

    if args.single_page is not None:
        fix_document(page_num, args.single_page, md_fixes, args)
        return

    if args.no_recurse:
        for f in os.scandir(args.docs):
            if f.is_file() and f.path.endswith(".md"):
                fix_document(page_num, f.path, md_fixes, args)
    else:
        for root, dirs, files in os.walk(args.docs, topdown=True):
            for name in files:
                if name.endswith(".md"):
                    fn=os.path.join(root, name)
                    fix_document(page_num, fn, md_fixes, args)
                    page_num += 1

if __name__ == '__main__':
    start_time = time.time()
    reprocess()
    end_time = time.time()
    et = end_time - start_time

