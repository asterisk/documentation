---
title: Trade Study: Github vs. Gitlab
pageid: 50463027
---




!!! note 
    The Asterisk project moved to GitHub on April 29th 2023.

    https://github.com/asterisk

      
[//]: # (end-note)





The current Asterisk code base, and community services have been mostly self hosted and managed using various tool sets (Gerrit, Jenkins, Atlassian, etc...). While this has been fine we're always looking for ways to improve the project, and its workflows. As such the Asterisk project, and a number of its services will be moving to an internet hosted software development platform (e.g. [Github](https://github.com/) or [Gitlab](https://gitlab.com/)). Doing so offers several advantages:

* Consolidates the code base and most services beneath one management application, which will make automation of processes between services much easier.
* Cloud hosts version control and other services removing the huge burden of having to self manage such things.
* Utilize an interface that is broadly used and hopefully more familiar to developers and other members of the community.

Moving will not be without effort though, and it's import to assess eligible products to ensure they can support the Asterisk project now, and in the future. Both [Github](https://github.com/) and [Gitlab](https://gitlab.com/) offer similar services, and functionality[1](https://github.com/features) ,[2](https://about.gitlab.com/features/) (by tier[1](https://docs.github.com/en/get-started/learning-about-github/githubs-products),[2](https://about.gitlab.com/features/by-paid-tier/)) that should suffice for what's needed. The following is a list of items that may be relevant to the hosting of the Asterisk project at one of the sites:



|  | [Github](https://github.com/) | [Gitlab](https://gitlab.com/) |
| --- | --- | --- |
| Deployment options | Cloud | Cloud and locally hosted |
| Open source | No | [Yes](https://gitlab.com/gitlab-org/gitlab) |
| API | [Yes](https://docs.github.com/en/rest) | [Yes](https://docs.gitlab.com/ee/api/) |
| Easy to understand documentation | [Yes](https://docs.github.com/en) | [Yes](https://docs.gitlab.com/) |
| Public project benefits | Yes, public projects gain some extra benefits that are usually associated with [paid tiers](https://github.com/pricing) for private repos | Yes, being an [open source project](https://about.gitlab.com/solutions/open-source/) Asterisk should get full benefits of their [ultimate tier](https://about.gitlab.com/pricing/), but need to [qualify annually](https://about.gitlab.com/solutions/open-source/join/) |
| General limits | [Actions](https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration), [LFS](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github) | [Various](https://docs.gitlab.com/ee/user/gitlab_com/index.html) |
| Repositories |  |  |
| Public/Private | [Unlimited](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories) (limited feature set for private) | Unlimited |
| Collaborators | Unlimited | Unlimited |
| Max size | < 5GB is [recommended](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github) | [10GB](https://docs.gitlab.com/ee/user/gitlab_com/index.html#repository-size-limit) |
| Max file size | [100MB](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), however larger files can be tracked via their [Large File Storage](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage) facility. | [5GB](https://docs.gitlab.com/ee/user/gitlab_com/index.html#repository-size-limit) per push |
| Permissions | [Read, write, other roles](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-roles-for-an-organization) (see also [organizational roles](https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/roles-in-an-organization)) | [Role based](https://docs.gitlab.com/ee/user/permissions.html) |
| Statistics | [Yes](https://docs.github.com/en/repositories/viewing-activity-and-data-for-your-repository/viewing-a-summary-of-repository-activity) | [Yes](https://docs.gitlab.com/ee/user/analytics/repository_analytics.html) |
| Collaborators/Users |  |  |
| Max allowed | Unlimited | Unlimited |
| Auth | SSH, 2FA, OAuth, SSO, and [other integrations](https://docs.github.com/en/authentication) | SSH, 2FA, OAuth, SSO, and [other integrations](https://docs.gitlab.com/ee/topics/authentication/) |
| Crowd account preservation | No, a Github account will need to be created | No, a Gitlab account will need to be created |
| CLA | [Possibly](https://github.com/cla-assistant/cla-assistant), but will probably have to set something up using a Github workflow | No, will have to set something up with their automation tools ([interesting post](https://stackoverflow.com/questions/54132483/how-to-ask-for-cla-signature-in-merge-requests-on-gitlab) about why Gitlab moved away from CLAs) |
| Issues |  |  |
| Description templates | [Yes](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository) | [Yes](https://docs.gitlab.com/ee/user/project/issues/index.html) |
| Custom forms | [Yes](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository#creating-issue-forms), in beta but available to public projects | No |
| Confidential/Private | No, all issues are public | [Yes](https://docs.gitlab.com/ee/user/project/issues/confidential_issues.html) |
| Close via commit | [Yes](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword) | [Yes](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically) |
| Canned responses | [Yes](https://docs.github.com/en/get-started/writing-on-github/working-with-saved-replies) | No |
| Fixed version | Use [milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones) | Use [milestones](https://docs.gitlab.com/ee/user/project/milestones/) |
| Other tags/labels | [Yes](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels) | [Yes](https://docs.gitlab.com/ee/user/project/labels.html), and also has [scoped labels](https://docs.gitlab.com/ee/user/project/labels.html#scoped-labels) |
| Code |  |  |
| Review | [Pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) | [Merge requests](https://docs.gitlab.com/ee/user/project/merge_requests/) |
| Require approval | [Yes](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches) | [Yes](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/) |
| Require checks | [Yes](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/troubleshooting-required-status-checks) | [Yes](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html) |
| Cherry-pick via UI | No | [Yes](https://docs.gitlab.com/ee/user/project/merge_requests/cherry_pick_changes.html) |
| Private Repos/Forks | [Yes](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility), and [forks](https://docs.github.com/en/code-security/repository-security-advisories/collaborating-in-a-temporary-private-fork-to-resolve-a-repository-security-vulnerability) for resolving security issues. | [Yes](https://docs.gitlab.com/ee/user/project/repository/forking_workflow.html), and should be used for [confidential issues](https://docs.gitlab.com/ee/user/project/merge_requests/confidential.html) |
| Security |  |  |
| Issue | No private issues | [Confidential issues](https://docs.gitlab.com/ee/user/project/issues/confidential_issues.html) |
| Advisory | [Yes](https://docs.github.com/en/code-security/repository-security-advisories/about-github-security-advisories-for-repositories) | [Reports](https://docs.gitlab.com/ee/user/application_security/vulnerability_report/#manually-add-a-vulnerability-finding), but there doesn't seem to be a way to edit it |
| CVE integration | [Yes](https://docs.github.com/en/code-security/repository-security-advisories/publishing-a-repository-security-advisory#requesting-a-cve-identification-number-optional) | [Yes](https://docs.gitlab.com/ee/user/application_security/cve_id_request.html) |
| Patch | [Temporary private fork](https://docs.github.com/en/code-security/repository-security-advisories/collaborating-in-a-temporary-private-fork-to-resolve-a-repository-security-vulnerability), or can use a private repo | Use private repo |
| Continuous Integration |  |  |
| Minutes | [Seemingly unlimited](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions) for public repos, 2000 per month for private | [50,000](https://about.gitlab.com/pricing/) per month |
| Storage | [Seemingly unlimited](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions) for public repos (might be limited by max repo file storage), 500MB per month for private | [10GB](https://docs.gitlab.com/ee/user/usage_quotas.html) |
| Self hosting | [Yes](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) | [Yes](https://docs.gitlab.com/runner/) |
| Triggers | [Various builtin](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows) | [API or webhook](https://docs.gitlab.com/ee/ci/triggers/) |
| Parallel | [Yes](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions) | [Yes](https://docs.gitlab.com/ee/ci/pipelines/) |
| Workflow limits | 6 hours job execution time, 35 day workflow run, 1000 API requests an hour, 20 concurrent jobs, 500 runs queued a second, [etc...](https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration) | 1GB artifact size, 1000 per group/1000 per project runners, unlimited concurrent jobs, 25000 pipeline triggers, [etc...](https://docs.gitlab.com/ee/user/gitlab_com/index.html#gitlab-cicd) |
| Release Management |  |  |
| Create | [Yes](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases) | [Yes](https://docs.gitlab.com/ee/user/project/releases/) |
| Link to issues | [Yes](https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases) | [Not yet](https://gitlab.com/gitlab-org/gitlab/-/issues/199087) |
| Release notes | [Automatic](https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes) | [Nothing automatic yet](https://gitlab.com/gitlab-org/gitlab/-/issues/15563). Use the [issue API](https://docs.gitlab.com/ee/api/milestones.html#get-all-issues-assigned-to-a-single-milestone) and get issues assigned to a milestone |
| Additional files | Yes can attach | Links available through UI, and [API](https://docs.gitlab.com/ee/api/releases/links.html). |
| Pre-release option | [Yes](tps://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) | Naming only |
| Forms | [Yes](https://docs.github.com/en/repositories/releasing-projects-on-github/automation-for-release-forms-with-query-parameters) | [Yes](https://about.gitlab.com/blog/2020/05/07/how-gitlab-automates-releases/) |
| Automation | Yes through [actions](https://github.com/features/actions), custom scripts or [3rd party tools](https://github.com/release-it/release-it) | Yes through [dev ops](https://docs.gitlab.com/ee/ci/introduction/#continuous-deployment), custom scripts or [3rd party tools](https://github.com/release-it/release-it) |
| Documentation |  |  |
| Wiki | [Yes](https://docs.github.com/en/communities/documenting-your-project-with-wikis/about-wikis) | [Yes](https://docs.gitlab.com/ee/user/project/wiki/) |
| Pages | [Yes](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) | [Yes](https://docs.gitlab.com/ee/user/project/pages/) |

One can see from the above that both platforms have the basic services and tools Asterisk needs to function as a successful open source project. They really only differ in a few minor areas. However, a decision has to be made and the Asterisk project has decided on:

Winner: Github
--------------

There are a few reasons why [Github](https://github.com/) was chosen over [Gitlab](https://gitlab.com/). One minor difference is that currently [Github](https://github.com/) actions and workflows appear to be able to trigger off a greater number of built-in events vs. [Gitlab](https://gitlab.com/) automations. The latter seeming to require more custom tooling, and writing and maintaining our own scripts in order to achieve similar functionality.

There are probably a few other minor distinctions that swayed the decision, but there is at least one notable complication with [Gitlab](https://gitlab.com/) that made the choice easier. In order to use [Gitlab's](https://gitlab.com/) Ultimate tier the Asterisk project would need to [qualify annually](https://about.gitlab.com/solutions/open-source/join/) as an open source project. Note, the values listed in the table above assume such qualification. Otherwise we'd fall under their [free tier](https://about.gitlab.com/pricing/), which only allows 5 users per namespace. In [Gitlab](https://gitlab.com/) a "User means each individual end-user (person or machine) of Customer and/or its Affiliates (including, without limitation, employees, agents, and consultants thereof) with access to the Licensed Materials hereunder" (see [FAQ](https://about.gitlab.com/pricing/)).  Based on the current requirements it's "iffy" if Asterisk would qualify. Even if it did it's very possible Asterisk may not next time. The project just can't take the risk.

  


