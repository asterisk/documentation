# PR Checklist as of November 7, 2025

**Attention!** This pull request may contain issues that could prevent it from being accepted.  Please review the checklist below and take the recommended action.  If you believe any of these are not applicable, just add a comment and let us know.

- [ ] Contributor License Agreement is not signed yet.

- [ ] There is a Merge commit in this PR.  The Asterisk project doesn't use Merge commits so this commit must be removed.

- [ ] There is more than 1 commit in this PR and no PR comment with a `multiple-commits:` special header. Please squash the commits down into 1 or see the [Code Contribution](https://docs.asterisk.org/Development/Policies-and-Procedures/Code-Contribution/) documentation for how to add the `multiple-commits:` header.

- [ ] The PR title does not match the commit title. This can cause confusion for reviewers and future maintainers. GitHub doesn't automatically update the PR title when you update the commit message so if you've updated the commit with a force-push, please update the PR title to match the new commit message body.

- [ ] The PR description does not match the commit message body. This can cause confusion for reviewers and future maintainers. GitHub doesn't automatically update the PR description when you update the commit messageso if you've updated the commit with a force-push, please update the PR description to match the new commit message body.

- [ ] A commit message doesn't contain a blank line after the title.

- [ ] The PR description and/or commit message has unsupported trailers after the `Resolves`, `Fixes`, `UserNote`, `UpgradeNote` and/or `DeveloperNote` trailers. Please refrain from adding unsupported trailers as theywill confuse the release change log generation.  If you really need them, please move them before any of thesupportred trailers and ensure there's a blank line after them.

- [ ] The PR description and/or commit message has a malformed `Fixes` or `Resolves` trailer. The `Fixes` and `Resolves` keywords MUST be preceeded by a blank line and followed immediately by a colon, a space, a hash sign(`#`), and the issue number. If you have multiple issues to reference, you can add additional `Fixes` and`Resolves` trailers on consecutive lines as long as the first one has the preceeding blank line. A malformedtrailer will prevent the issue from being automatically closed when the PR merges and from being listed in the release change logs.<br> Regular expression: `^(Fixes|Resolves): #[0-9]+$`.<br> Example: `Fixes: #9999`.

- [ ] The PR is cross-referenced by one or more issues () but doesn't contain any `Fixes` or `Resolves` trailers. A missing trailer will prevent the issue from being automatically closed when the PR merges and from being listed in the release change logs.<br> Regular expression: `^(Fixes|Resolves): #[0-9]+$`.<br> Example: `Fixes: #9999`.

- [ ] The PR description and/or commit message references one or more issues (  ) without a `Fixes:` or `Resolves:` keyword. Without those keywords, the issues won't be automatically closed when the PR merges and won't be listed in the release change logs.<br>Regular expression: `^(Fixes|Resolves): #[0-9]+$`.<br> Example: `Fixes: #9999`.

- [ ] The PR description and/or commit message has malformed `UserNote`, `UpgradeNote` and/or `DeveloperNote` trailers. The `UserNote`, `UpgradeNote` and `DeveloperNote` keywords MUST be predeeded by a blank line and followed immediately by a colon and a space before the actual note text.  This is to ensure that the note is properly formatted and displayed in the release change logs.

- [ ] Either the PR description has a `Fixes` or `Resolves` special trailer but the commit mesage doesn't orthe other way around. A properly formatted `Fixes` or `Resolves` trailer is required in the PR description to allow the issue and the PR to be cross-linked and for the issue to be automatically closed when the PR merges. It's also required in the commit message to allow the issue to be listed in the release change logs.

- [ ] The are no `cherry-pick-to` headers in any comment in this PR. If the PR applies to more than just thebranch it was submitted against, please add a comment with one or more `cherry-pick-to: <branch>` headers ora comment with `cherry-pick-to: none` to indicate that this PR shouldn't be cherry-picked to any other branch. See the [Code Contribution](https://docs.asterisk.org/Development/Policies-and-Procedures/Code-Contribution/) documentation for more information.

- [ ] The following `cherry-pick-to` values are invalid: . Valid values are .

- [ ] An Alembic change was detected but a commit message UpgradeNote with at least one of the 'alembic', 'database' or 'schema' keywords wasn't found. Please add an UpgradeNote to the commit message that mentions oneof those keywords notifying users that there's a database schema change.

- [ ] An Alembic change was detected but no changes were detected to any sample config file. If this PR changes the database schema, it probably should also include changes to the matching sample config files in configs/samples.

- [ ] There appear to be changes to Autoconf source files (configure.ac, bootstrap.sh, *.m4) but the ./configure file itself hasn't changed. If you change any Autoconf source file, you must run `./bootstrap.sh` to regenerate the configure file.

- [ ] The ./configure file appears to have been changed manually. This file is auto-generated by running `./bootstrap.sh` and must not be modified directly. Please revert the changes to the ./configure file and run `./bootstrap.sh` to regenerate it.

- [ ] There appear to be changes to res/res_ari_*.c and/or res/ari/*.h files but no corresponding changes tothe the json files in rest-api/api-docs. The *.c and *.h files are auto-generated from the json files by `make ari-stubs` and must not be modified directly.

- [ ] There appear to be changes to the json files in rest-api/api-docs but no corresponding changes to the res/res_ari_*.c and/or res/ari/*.h files that are generated from them. You must run `make ari-stubs` after modifying any file in rest-api/api-docs and include the changes in your commit.

- [ ] An ARI change was detected but a commit message UpgradeNote or DeveloperNote mentioning ARI wasn't found. Please add a DeveloperNote for new capabilities or an UpgradeNote for non-backwards compatible changes tothe commit message that mentions ARI notifying users that there's been a change to the REST resources.

- [ ] A change was detected to the sample configuration files in ./config/samples but no UserNote or UpgradeNote was found in the commit message. If this PR includes changes that contain new configuration parameters or a change to existing parameters, please include a UserNote in the commit message.  If the changes require some action from the user to preserve existing behavior, please include an UpgradeNote.

- [ ] A change was detected to the pjsip sample configuration files in ./config/samples but no Alembic change was detected. If this PR includes changes that contain new configuration parameters or a change to existingconfiguration parameters for pjsip, chances are that a change to the realtime database schema is also required.

Documentation:<br>
* [Asterisk Developer Documentation](https://docs.asterisk.org/Development/)<br>
* [Code Contribution](https://docs.asterisk.org/Development/Policies-and-Procedures/Code-Contribution/)<br>
* [Commit Messages](https://docs.asterisk.org/Development/Policies-and-Procedures/Commit-Messages)<br>
* [Alembic Scripts](https://docs.asterisk.org/Development/Reference-Information/Other-Reference-Information/Alembic-Scripts/)<br>
