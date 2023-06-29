# Description

This repository contains the Asterisk Documentation project.

# Static Documentation

The static documentation contained in the ./docs/ directory is written directly in markdown.  The publish process uses [mkdocs](https://www.mkdocs.org), [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/), and [mike](https://github.com/jimporter/mike) to generate the HTML web site.  The directory structure is fairly straightforward so if you wish to contribute, you should fork this repository and submit pull requests against files in that directory.

All contributions are subject to the 
[Creative Commons Attribution-ShareAlike 3.0 United States](LICENSE.md) license.

# Markdown Flavor
The docs are written in standard markdown, not GitHub Flavored markdown.  There are lots of extensions available though.  Most of the extensions provided by [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/reference/) are enabled except those only available to paying sponsors and a few that don't make sense in this environment. 

# Dynamic Documentation

The dynamic documentation includes the pages generated from Asterisk itself and includes:
* AGI_Commands
* AMI_Actions
* AMI_Events
* Asterisk_REST_Interface
* Dialplan_Applications
* Dialplan_Functions
* Module_Configuration

The publish process gets this information directly from the Asterisk CreateDocs job (which runs nightly) and generates markdown.  For this reason, all changes to the dynamic documentation need to be made in the Asterisk source code itself.  With the exception of the Asterisk_REST_Interface, the documentation comes from the XML that's embedded in Asterisk modules.  The ARI documentation comes from the JSON files in rest-api/api-docs.

# Build/Test Dependencies

Dependencies for documentation can be installed using the included requirements.txt file.

```
$ pip3 install -r requirements.txt
```

If you don't want to install the requirements for the current user or globally, you can create a virtual environment specific to this directory first...

```
$ python -m venv ./.venv
$ source .venv/bin/activate
(.venv)$ pip3 install -r requirements.txt
# run `deactivate` when done
(.venv)$ deactivate
$ 
```

The next time you want to test, you can just activate the virtual environment without needing to install the dependencies again.  The `.venv` directory is already in the `.gitignore` file.

# Testing Static Documentation

The static documentation is easy to test (and you should).

To generate the static site html...

```
# Enter the virtual environment first if you need to
$ source .venv/bin/activate
# Then run...
(.venv) $ mkdocs build
INFO     -  Cleaning site directory
INFO     -  Building documentation to directory: .../documentation/site
INFO     -  Documentation built in 18.91 seconds
```

The fully generated site should now be in the `site` directory which is also in the `.gitignore` file.

If you wish to browse the documentation, you have 2 options:
* Run `mkdocs serve` from the `documentation` directory.    
  This will allow you to open a browser to http://127.0.0.1:8000/ to view the documentation.  You can use the `-a | --dev-addr <IP:PORT>` option to cause the server to bind to any address/port combination you want.  For example: `-a [::]:8000` will bind port 8000 to all IPv4 and IPv6 addresses.
* Set up an apache or nginx virtual server that points to the `site` directory.    
  Configuration is up to you.

**WARNING:** Never run the `Makefile` included in the repo unless you absolutely need to build the dynamic documentation as well as the static.

# Testing Dynamic Documentation

**WARNING:** This is an **advanced** procedure and requires 2 new local git repositories to be created and the use of a regular web server to view!

## Background

The Asterisk Documentation is published via GitHub Pages and the tools used are geared for that environment.  This imposes some strange requirements on th epoublish process.  The tool we use to manage the dynamic documentation on a per Asterisk branch basis and the integration of the static documentation ([mike](https://github.com/jimporter/mike)) also presents some unusual requirements.  Here's a list of things you need to know.

* The tooling requires that you publish your site to a `gh-pages` branch  _in the same repo as your documentation source._  On top of that, it has a completely different directory structure than the documentation `main` branch.

* `mike` can't build the final site with all static and versions of dynamic documentation at one time.  You have to run it once for each branch and it accumulates the output in the `gh-pages` branch.

* `mike` is great at building versioned documentation but not so great at mixing both unversioned and versioned documentation in the same site.

* Switching between the `main` and `gh-pages` is problematic if you have uncommitted changes in your `main` branch.  This makes it hard to point a web server to the final result.

* Switching between the `main` and `gh-pages` is also problematic since building the documentation creates temporary directories which might not be .gitignored in the `gh-pages` branch.

## Prerequisites

Here's what you need to do.  Tread carefully!

* Create a new **bare** local repository somewhere outside the documentation directory.  We'll call it `local-docs-bare`.  `cd <somepath> ; git init --bare --initial-branch=gh-pages local-docs-bare`
* Clone that repo right next to it. We'll call it `local-docs`. `cd <somepath> ; git clone file:///<somepath>/local-docs-bare local-docs`.
* Copy the .gitignore file from the documentation directory and push it to the bare repo:    

```
$ cd local-docs
$ cp <path>/documentation/.gitignore ./
$ git add .gitignore
$ git commit -a -m "Initial Commit"
$ git push
```
* In the documentation directory, add a remote named `local` pointing to the local-docs-bare repo (it **must** be named `local`).  Then pull the `gh-pages` branch.  

```
$ cd <path>/documentation
$ git remote add local file:///<somepath>/local-docs-bare
$ git fetch local
$ git checkout -b gh-pages local/gh-pages
git checkout main
```

* Create a `Makefile.inc` file with some configuration variables.  This file must NOT be checked in.  Here are the contents to use:

```
LATEST := 20
EVERYTHING := 16 18 19 20
```

As new mainline branches are created you'll need to update the `LATEST` and `EVERYTHING` variables and as branches go EOL, they'll need to be removed from `EVERYTHING`.

* Set up a local web server that points to the `local-docs` directory.  NOTE: You can't browse to the docs with a file:// URL because there are redirects and file:/// URLs don't automatically render index.html files.  If you're using nginx, here's a simple config that sets up port 7445.  Just replace `<somepath>` with the path to the `local-docs` directory. Don't forget to restart nginx after you add the config file.

```
server {
    listen 7445;
    server_name  _;
    root         <somepath>/local-docs;

location / {
    try_files $uri $uri/ index.html;
  }
}

```

## Build and Push

Now comes the easy part.  To build the entire site and push it to your `local-docs-bare` repo, just run `make PUSH=yes`.  When that's done, you can go to your `local-docs` repo, do a `git pull` and the documentation will magically appear. Just point your browser to whatever URL you set up your web serve with and you should be good to go.

## The Build Process

Before we can build anything here, we need to get the source for the dynamic docs from Asterisk.  Every night at 0400 UTC, the Asterisk CreateDocs job runs and produces the needed XML and markdown files.  Assuming it runs on time, here's the process that happens when you run `make`.

First, `make` queries the Asterisk source repository on GitHub to find the [CreateDocs](https://github.com/asterisk/asterisk/actions/workflows/CreateDocs.yml) workflow run that ran "today".  If for some reason no job is found, the process stops.  Once it has that, it runs the following steps for each branch in the `EVERYTHING` variable.

1.  Download the dynamic XML and markdown for the branch into `./temp/build-<branch>/source` directory.

2.  Since the ARI documentation is already in markdown format, those files are copied into the `./temp/build-<branch>/docs/_Asterisk_REST_Interface` directory.  The leading `_` just helps sort the dynamic documentation to the bottom of the left sidebar.

3. The mkdocs-template.yml file is copied to the `./temp/build-<branch>/mkdocs.yml` file.  This contains all the instructions on how to actually build the site.

4.  The `./temp/build-<branch>/docs/index.md` file is created with just a banner.

5.  Here's the tricky part...  I mentioned above that `mike` isn't great at building sites with both versioned and unversioned content.  Here's how we get around that.  If the branch we're creating is the "latest" branch, we copy all the static documentation from the top-level `docs` directory into `./temp/build-<branch>/docs`.  This means that the static documentation will only appear if you;re viewing the "latest" branch, which is the default.

6.  The `utils/astxml2markdown.py` script is run to transform the XML file from Asterisk into markdown files which are output to the `./temp/build-<branch>/docs` directory.  At this point, the "latest" branch has both the static content plus its own dynamic content and the "non-latest" branches have only their dynamic content.

7.  `mike deploy` is run for the branch which causes that branch's HTML content to be created in `./temp/build-<branch>/site`.  That directory is then copied to the local `gh-pages` branch under a directory named for the Asterisk branch.  If `PUSH=yes` was set, the `gh-pages` branch is pushed to the remote (which happens to also be called "local" to differentiate it from the "upstream" GitHub remote.  Sorry about that.).

8.  If this branch is the "latest", `mike set-default` is run so that if you browse to the web site root, you get redirected to the "latest" branch which has both the static content and the branch's dynamic content.

### Build a Single Branch

You can build and optionally push a single branch by running `make BRANCH=<branch> PUSH=yes`.  This will build only the specified branch (and the static content if the branch is the "latest") and push it without disturbing the other branches.
