#!/usr/bin/env python3
"""Convert sitemap to redirect map for old Confluence URLs

Copyright (C) 2025, Sangoma Technologies, Inc.
George T Joseph <gjoseph@sangoma.com>

This program is free software, distributed under the terms of
the GNU General Public License Version 2.
"""

import sys, os, re
import xml.etree.ElementTree as ET
from urllib.parse import urlparse
from datetime import datetime as dt
import datetime

sectionmap = {
    "WhatsNew/" : "New+in+{version}",
    "Upgrading/" : "Upgrading+to+Asterisk+{version}",
    "API_Documentation/" : "Asterisk+{version}+Command+Reference",
    }

subsectionmap = {
    "AGI_Commands/": ("AGI+Commands", "AGICommand"),
    "AMI_Actions/": ("AMI+Actions", "ManagerAction"),
    "AMI_Events/": ("AMI+Events", "ManagerEvent"),
    "Dialplan_Applications/": ("Dialplan+Applications", "Application"),
    "Dialplan_Functions/": ("Dialplan+Functions", "Function"),
    "ARI/": ("ARI", None),
    "Asterisk_REST_Interface/": ("ARI", None),
    "Module_Configuration/": ("Module+Configuration", "Configuration"),
    "Modules/": (None, None),
    }

def main(argv):
    infile = argv[1] if len(argv) > 1 else None
    outfile = argv[2] if len(argv) > 2 else None
    tree = ET.parse(infile)
    redirects = {}
    for loc in tree.findall(".//{*}url/{*}loc"):
        url = urlparse(loc.text)
        path = url.path
        if path.endswith('/'):
            path = path[:-1]
        m = re.match(r'/Asterisk_([0-9]+)_Documentation/([^/]+/)?([^/]+/)?([^/]+/)?$', url.path)
        api_section = ""
        section = ""
        pagename = ""
        if m is not None:
            version = m.groups()[0]
            if m.groups()[1]:
                section = sectionmap[m.groups()[1]]
            if m.groups()[2]: 
                subsection = subsectionmap[m.groups()[2]]
            pagename = m.groups()[3]
            if m.lastindex == 1:
                key = f"/wiki/display/AST/Asterisk+{version}+Documentation".lower()
            elif m.lastindex == 2:
                key = f"/wiki/display/AST/{section.format(version=version)}".lower()
            elif m.lastindex == 3:
                if subsection[0] is None:
                    continue
                key = f"/wiki/display/AST/Asterisk+{version}+{subsection[0]}".lower()
            elif  m.lastindex == 4:
                if pagename.endswith('/'):
                    pagename = pagename[:-1]
                if subsection[1] is None:
                    sn = ""
                    pagename = pagename.replace('_','+')
                else:
                    sn = subsection[1]+"_"
                if subsection[1] == "AGICommand":
                    pagename = pagename.replace('_','+')
                key = f"/wiki/display/AST/Asterisk+{version}+{sn}{pagename}".lower()
        else:
            if re.match(r'/(?:Certified-Asterisk|Latest_API)', url.path):
                continue
            if url.path == '/':
                key = "/wiki/display/AST/Home".lower()
            else:
                key = f"/wiki/display/AST/{os.path.basename(path).replace('-','+')}".lower()
        if key not in redirects:
            redirects[key] = url.path
    with open(outfile, 'w') if outfile else sys.stdout as f:
        f.write("# Auto-generated file. Do not edit!\n")
        d = dt.now().strftime("%Y-%m-%d %T %z")
        f.write(f"# Generated {d}\n")
        f.write("# Maps old URLs to new URLs\n")
        f.write("# Format: /old/url/ /new/url/;\n")
        f.write("#\n")
        for k in redirects.keys():
            f.write(f"{k} {redirects[k]};\n")
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv) or 0)
