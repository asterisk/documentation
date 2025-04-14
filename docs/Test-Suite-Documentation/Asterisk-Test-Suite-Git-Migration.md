---
title: Asterisk Test Suite Git Migration
pageid: 28315154
---

This page contains (and will contain) information pertaining to the migration of the Asterisk test suite from subversion to git.

#### Moving the test suite to git:

There are several things that need to be considered before making the move. First, how should the project be structured? A few possible options:

1. *Keep the current* – Use the structure that is already in place with everything under one repository. Everyone is use to it (there is something to be said for that) and knows how it works.
2. *Framework + tests* - One repository for the Framework and “n” repositories for the tests. This separates the shared/generic code from the more specific individual tests. Also, tests could be grouped by repository. A minor benefit to doing it this way is it would be possible to only checkout a desired set of tests without having to download the entire test suite.
3. *Branch all the things*   **–**  One repository with a master branch that contains just the framework code and then 'n' branches for various tests. One drawback here is running the test suite against multiple tests could be problematic or overly complicated.

As mentioned, having one repository with the tests residing in various branches would make it a bit more difficult when wanting to run multiple tests. For instance, when a test is run the branch that the test resides in would need to be checked out. This would have to occur for each test.

Having the tests reside in separate repositories is also not without complications. For instance, how would the repositories interact with each other (histories, logs, other dependencies)? Git has some mechanisms that attempt to alleviate the issue such as submodule and subtree(s), but each of those add another layer of complexity and their own problems.

Maintaining the current structure certainly keeps things simple. Nothing would really have to change as far developer work flow and how tests are run. It would also ensure that histories/logs would be maintained with the move (not even sure if it would be possible under the other options). Also, if for some reason a subversion mirror needed to be maintained keeping the current structure might be the only option.

#### A path forward:

Moving to git and learning a new source control system is a task in and of itself for new git users. With this, and the aforementioned things, in mind for now the migration of the test suite from subversion to git will consist of *keeping the current structure in place*. The test suite structure will stay the same and the framework and tests will be maintained in one repository to be hosted on git.asterisk.org.
