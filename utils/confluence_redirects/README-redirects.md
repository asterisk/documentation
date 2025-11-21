# Confluence URL Redirects

## Confluence URLs

The Confluence Wiki instance previously used to host Asterisk documentation used a URL scheme that did not reflect the tree structure of the site.

All pages started with the `/wiki/display/AST/` prefix and if a page title was unique across the site, only the page title was added to the prefix.  For instance, the URL for the "License Information" page in the "About the Project" section would simply be...

```
/wiki/display/AST/License+Information
```

The API documentation has duplicate pages by design.  For instance, there's a "Hangup" page in AGI Commands, AMI Actions, AMI events and Dialplan Applications AND there's a set of them for each Asterisk version we generate documentation for.  The old documentation generation process took care of this by prefixing the page titles with the Asterisk version and API type...

```
/wiki/display/AST/Asterisk+20+AGICommand_hangup
/wiki/display/AST/Asterisk+20+ManagerAction_Hangup
/wiki/display/AST/Asterisk+20+ManagerEvent_Hangup
/wiki/display/AST/Asterisk+21+AGICommand_hangup
/wiki/display/AST/Asterisk+21+ManagerAction_Hangup
/wiki/display/AST/Asterisk+21+ManagerEvent_Hangup
...
```

Finally, if the page title contained other than non-alphanumeric characters or spaces, the URL would be the page ID:

```
/wiki/pages/viewpage.action?pageId=5243109
```

## Attempts to redirect them to the new docs site

### Attempt 1

The first attempt to redirect involved using some basic Nginx redirect rules on the oss-downloads server which handles the wiki.asterisk.org domain which used to house Confluence.  Basically, it stripped off the `/wiki/display/AST/` prefix and sent back a 301 redirect to the new site docs.asterisk.org.  This almost always resulted in a 404 Not Found however.  To get around this, we added redirect capability to the mkdocs.yml file but the entries had to be maintained manually.

### Attempt 2

The next attempt involved using the sitemap.xml file and a custom 404 page handler.  When a page wasn't found and the gh-pages server would return the custom 404 page which contained Javascript that would pull down the sitemap.xml file, search it to find a page somewhere in the heirarchy that matched the basename of the page requested, then tell the browser to navigate to that page.  This worked "OK" for pages that had exactly the same name as the old page but not very well for the API documentation.  It also required the client to grab the 1.2MB sitemap.xml file for every 404 and because all the work was done on the client, it resulted in delays and page flashes.  It would also mess up crawlers because instead of getting a 301 which they could follow, they got a 404.

### Attempt 3

Since we have the sitemap.xml file at build time, the next attempt took the file and for each entry tried to guess what the Confluence URL would have looked like.  From that a Nginx redirect map was created redirecting the Confluence URL to the new Docs URL and stored in the root of the docs website.  A nightly timer job on oss-downloads retrieved the file and reloaded Nginx.  Now anyone attempting to visit https://wiki.asterisk.org would have the page looked up in the map and, if it was found, would be redirected to the exact page on the new docs site.  If not found, they'd be redirected to the Not Found page on the new website.  From a performance perspective, this worked great but the "tried to guess" bit didn't really work for pages that were on the old site but not on the new site, like EOL Asterisk release doeumentation.  The `create_redirect_map.py` script that was used to generate the redirect_map.conf file is still in this repo but kept for reference only.

### Attempt 4

As luck and my mental-illness would have it, I still have the Confluence extract we used to create the new site in June 2023.  The extract contains a JSON document for every page containing its page title and URL.  I extracted those to the `confluence-urls.txt` file in this directory.  There's also a `create_redirect_map.sh` bash script that uses a bunch of rules to find the equivalent page in the new site and if found, create a redirect rule for it.  There were 9600 entries in the `confluence-urls.txt`, 9432 of which were found and written to `redirect_map_static.conf`.  The rest were things that just don't exist anymore or other things that didn't warrant spending time to deal with.  Now here's the good part... the `create_redirect_map.sh` script never has to be run again because Confluence is GONE and the `confluence-urls.txt` file can never change.  There's also a separate `redirect_map_extra.conf` file in this directory into which additional redirect entries can be placed as needed.  There are a few in there already that the script didn't catch but were easy to find manually.

## Operation

So now we have 2 redirect files in `utils/confluence_redirects`.  The top-level Makefile has a rule for `docs/redirect_map.conf` that concatenates the two files into the one and checks them for formatting and duplicate entries (which will cause Nginx to barf).  After that's run, the result must be committed and pushed to make the file available at `https://docs.asterisk.org/redirect_map.conf` the next time a site publish is performed.

The `nginx-redirect-map-fetch.service` and `nginx-redirect-map-fetch.timer` files reside on oss-downloads in `/etc/systemd/system` and cause the server to download the file to `/etc/nginx/redirect_map.conf` and reload nginx.  `/etc/nginx/nginx.conf` loads the map and `/etc/nginx/conf.d/redirects.conf` has the lookup block.

## Maintenance

If you discover bad entries in the original `redirect_map_static.conf` file, you can correct or comment them out but you shouldn't remove any entries and any new entries should go in the `redirect_map_extra.conf` file.  You also should run `./check_map.sh redirect_map_static.conf redirect_map_extra.conf` to check the formatting and make sure there are no dups in the file.  `make docs/redirect_map.conf` does this as well.
