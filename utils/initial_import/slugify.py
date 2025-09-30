#!/usr/bin/env python3

import os
import sys
import unicodedata
import re

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

    value = re.sub(r'\+', '-', value)
    value = re.sub(r'[^.\w\s-]', '', value)
    return re.sub(r'[-\s]+', '-', value).strip('-_')

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("You must supply 1 argument")
        sys.exit(1)
    pathcomp = sys.argv[1].split('/')
    newpath = []
    for p in pathcomp:
        newpath.append(slugify(p))

    print("/".join(newpath))
