# Description

This repository contains the Asterisk Documentation project. Documentation is written in markdown and generated
using the [mkdocs](https://www.mkdocs.org) utility and the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme. You can find the documentation source in the "docs" directory.

Contributions are welcomed via the usual fork and pull request process.  All contributions are subject to the
[Creative Commons Attribution-ShareAlike 3.0 United States](LICENSE.md) license.

Prior to submitting a pull request, you should run `mkdocs build` and address any issues reported.

# Dependencies

Dependencies for documentation can be installed using the included requirements.txt in the repository.

If pip3 is available on the system then the dependencies can be installed using:

```
$ pip3 install -r requirements.txt
```

# Serving Documentation Locally

When writing documentation or making changes it can be useful to serve the content locally to see your changes.
This can be done using mkdocs:

```
$ mkdocs serve
```

To bind to any address/interface (0.0.0.0) or an IP address use:

```
$ mkdocs serve --dev-addr <IP Address>:8000
```

This will generate the documentation and serve it using a webserver on localhost for viewing.
