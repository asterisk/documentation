# Description

This repository contains the Asterisk Documentation project. Documentation is written in markdown and generated
using the mkdocs utility. You can find the documentation in the "docs" directory.

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

This will generate the documentation and serve it using a webserver on localhost for viewing.
