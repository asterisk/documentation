---
title: Git Migration
pageid: 29396435
---

Overview
========

For a long time now, there's been a desire to move to Git. A few highlights why:

* It's a very nice distributed version control system. As source control management goes, it's one of the best, if not the best.
* From a "developing daily in Asterisk" perspective, merges in Asterisk are a pain. It is not uncommon to have merge conflicts as things are merged to various branches, and Subversion is notorious for making this process cumbersome. While merges still occur in git - as do conflicts - the process is much more streamlined.
	+ As an aside, we calculated that the team at Digium lost about a total of six weeks due to merge conflicts during the development of Asterisk 12. That's a lot of time that could have been spent writing features, fixing bugs, and generally doing something else other than staring at diff conflicts.
* The Asterisk project has developed a *lot* of tools to work around Subversion - both to do merges, as well as to manage branches, deal with private/public repos, etc. Some of these tools work well; some require constant tweaking. Git obsoletes the need for a fair number of these tools, which is nice. For others, this presents an opportunity to make some much needed changes on the infrastructure that makes releases.

This page serves as a place to put thoughts and findings on moving to Git, document draft processes, and generally get this project moving. As things progress and policies become more well-defined, they will be spun off into their own pages.

!!! note This Page Is Historical
    Two things to keep in mind when reading this page:

    1. This page's purpose was always meant to record things for historical purposes. Don't take what is on here as gospel.
    2. Per the discussion on the [asterisk-dev](http://lists.digium.com/pipermail/asterisk-dev/2014-September/070303.html) mailing list, the tools chosen for managing review/CI around git are Gerrit and Jenkins.

[//]: # (end-note)

[Underpants Gnomes](http://en.wikipedia.org/wiki/Gnomes_%28South_Park%29) Project Plan for Moving to Git
========================================================================================================

1. Migrate the Asterisk Test Suite
2. Migrate Asterisk
3. ???
4. Profit.

Git Hosting Comparison
======================

One of the nice things about moving to Git is that there are a ton of great platforms that make using Git easier/better/prettier. One of the terrible things about moving to Git is that there are a ton of great platforms that make using Git easier/better/prettier, and everyone has an opinion about it 

Below is a comparison of four platforms, subjected to a variety of criteria:

* Web View - can we use the interwebs to view things
* Project Management - how much does the platform provide outside of source control. To some extent, this is not terribly important for the Asterisk project; issues are going to remain in JIRA at the very least.
* Protected Branches - many developers use private branches in Subversion today. Having the ability to prevent pushes is handy.
* Rewriting History - sometimes it's good to forget; sometimes it's not.
* Arbitrary Repository Creation - users may want more than just a branch.
* Git Hooks/Web Hooks - given the amount of infrastructure the project already has, it is certain we'll need to integrate Git with existing tools.
* Performance - this is a big one, given the amount of history the Asterisk project has. A good management tool will need to be able to handle the nearly half a million commits the Asterisk project currently has.

|  | Github | Atlassian Stash | Gitlab | Gitolite | Gerrit OpenStack Workflow |
| --- | --- | --- | --- | --- | --- |
| **Web View** | Yes | Yes | Yes | Provided by gitweb or CGit (CGit looks like a more attractive solution) | Provided by CGit |
| **Project Management** | Issues, Wiki, Pull Requests, Code Review are all built in. | Issues, Wiki, Pull Requests, Code Review are all built in. | Issues, Wiki, Pull Requests, Code Review are all built in. | None. Although we have alternate solutions for Issues, Wikis, and Code Review, a solution for Pull Requests would be nice. Contributors could work on pull requests using their own Github account and submit their work via patches to Review Board. | Does not encompass Issues. The overall workflow includes code review/project managements through Gerrit and CI through Jenkins/Zuul. This would replace Review Board and Bamboo. |
| **Protected Branches** | Permissions are only supported at the repository level. A client hook could be installed to prevent pushing certain branches but this could not be enforced on the server. | Protected branches are supported, whether or not they have been created yet, but are not enforced when forking or creating a repository that acts as another remote. Custom Stash hooks could be implementing to stop certain branches from been pushed but must be installed manually per repository. | Protected branches are supported but must first be created with at least one file in the given branch. Forking or creating a repository that acts as another remote removes all permissions related to protected branches. The enterprise edition supports git hooks but they appear to be limited at this time although their project page mentions that they are prepared to implement new hooks as requested. These hooks would have to be enabled on a per repository basis. | Protected branches are supported, whether or not they have been created yet. Since permissions are defined using regular expressions, repositories do not have to exist before permissions can be applied. | Gerrit supports permissions on a per branch basis. |
| **Rewriting History** | No protection against rewriting history. A client side hook could be installed to prevent this but could not be enforced on the server. | Permissions allow protecting against rewriting history. | Permissions allow protecting against rewriting history. | Permissions allow protecting against rewriting history. | Permissions allow protecting against rewriting history, but can be overridden. |
| **Arbitrary Repository Creation (Team Repositories)** | Users can create arbitrary repositories under their own Github account for the purposes of creating pull requests. | A team repository project can be created to allow users to create arbitrary repositories. | Users can create arbitrary repositories under their name, in a similar fashion to Github. | A regular expression permission can be set up to create wildcard repositories to support team repositories. | User would need ability to create projects in Gerrit. |
| **Git Hooks** | Installing git hooks is not supported at this time. | Custom Stash hooks can be installed as plugins on a per repository basis. These hooks differ from git hooks in that they must be written using Atlassian's API for hooks using Java. | Only the enterprise edition supports this. | Git hooks are supported plus additional hooks provided by Gitolite to support calling hooks before git is invoked or after a repository is created. | Yes |
| **Web Hooks** | Web hooks are supported and could be used to sync commits with other products/platforms. | Web hooks are not supported but custom Stash hooks could be written to implement syncing with other products/platforms. | Web hooks are supported and could be used to sync commits with other products/platforms. | Web hooks are not supported. Git hooks would have to be created to support syncing with other products/platforms. | Gerrit has an event stream. |
| **Performance** | Github's performance has been showed to be more than adequate. Minimal downtime has occurred in the past. | Year old issue mentions timeouts when cloning large repositories which appears to have been fixed. No other information on performance issues could be found. | Recent issues mention timeouts when cloning large repositories. Another issue mentions problems when rendering graphs for repositories with large number of commits. Issues appear not to have been fixed yet. | Since Gitolite is thin wrapper around git, performance is very close to that of git. I could not find any information on performance issues. | Yes  |
| **Process Recommendation** | A public repository for contributors to post pull requests and clone/pull from along with a private repository for pushing commits to. The public repository would in effect be a mirror of selected branches from the private one. This mirror may or may not be done automatically. A limited number of commiters to control what commits/branches are pushed to the public/private repository. | A public and a private instance with custom Stash hooks to prevent certain branches from been pushed, which would have to be enabled on a per repository basis. The public repository would in effect be a mirror of the private repository where pull requests can be created and contributors can clone/pull from. As with Github, a limited number of commiters to control what commits/branches are pushed to the public/private repositories. Rewriting history should only be allowed for team repositories and for admins. | A public and a private instance with custom enterprise edition hooks to prevent certain branches from been pushed, which would have to be enabled on a per repository basis. The public repository would in effect be a mirror of the private repository where pull requests can be created and contributors can clone/pull from. As with Github and Stash, a limited number of commiters to control what commits/branches are pushed to the public/private repositories. Rewriting history should only be allowed for team repositories and for admins. | A public and a private instance using permissions to protect certain branches and to allow team repositories. Rewriting history should only be allowed for team repositories and for admins. As with Github, Stash, and Gitlab, a limited number of commiters to control what commits/branches are pushed to the public/private repositories. | Use a model similar to open stack model. Anyone can contribute. Once approved, developers with higher permissions can push to a branch. |

Notes
-----

* Given our large number of commits, performance should be one of our most important criteria. Security can be somewhat controlled by limiting the number of commiters to selected branches.
* There's a lot of benefit in not tying our issue tracker, test tools, review tools, and everything to a single management platform. Many of the platforms tie you into a full solution, which may be detrimental in the long run.

Initial Recommendations
-----------------------

| Platform | Recommendations |
| --- | --- |
| Github | While it is by far the most popular platform, it does have some drawbacks.1. It owns your process: issues, reviews, everything ends up getting sublimated under Github.
2. No ability to enforce commit message format, or review it.
3. No ability to enforce protection of branches.
 |
| Stash | While it would plug into our existing Atlassian tools, it also has some drawbacks. ~~The largest is that each finding on a review sends out a separate e-mail. Since all findings are sent to the asterisk-dev list (and that should not change), any review with even a few findings will turn into spam.~~ **In Stash 3.4, with batching of email notifications, we've made it easier for you to manage your pull request load and reduce the noise.** |
| Gitlab | Potential performance issues are a big knock against this. |
| Gitolite | This is the most minimal of the management platforms, and has the fewest end-user features. At the same time, it also gets in the way the least. (We also already have it set up at [git.asterisk.org](https://git.asterisk.org)) |
| Gerrit | This would require the most tooling changes. At the same time, it also has some obvious benefits (tight integration between source control, code review, and CI), and has worked well for the OpenStack project. |

One of the nice things about git is that it is very easy to set up a mirror on Github for those who want it, but use something else for the "daily" development activities. ~~For now, the initial recommendation is to go with Gitolite, as it has a lot of the backend features that we'd like, is very performant, and doesn't require a re-evaluation of every tool the Asterisk project uses.~~

For now, we are leaning towards:

1. Gitolite
2. Gerrit

Mirrors can be set up on Github if desired (similar to the DAHDI project currently).

Moving the Asterisk Test Suite to Git
=====================================

This is a nice place to start, as it lets us flesh out a lot of the tooling without worrying as much about branches and tags. It's also much smaller.

1. Upgrade the existing instance of gitolite (which probably means "purge")
2. Determine how we want to manage contributors/authors. Currently, we use a commit message template to note that someone other than the committer wrote the patch; if at all possible, we'd like to incorporate that into the process.
	1. This means a much larger authors file (if possible)
	2. It also means no anonymous authors, as we need the e-mail address. That's probably a good thing in the long run.
3. Figure out how we want to manage commit access
	1. SSL certificates
	2. SSH keys
4. Create the repo from SVN. Turn off SVN commit access.
5. Migrate ReviewBoard to hit the new Git repo.
6. Update the Bamboo scripts/agents to hit the new repo.
7. Have cake.
