# GitHub

## Preparing Pull Requests

We provide a pull request template which aims to help in preparing a _good_ PR description–the one that helps reviewers to understand **what** and **why** have been implemented and what are the next steps.

### Labels

Most PRs should have at least **one** label: type of the change (feature, bug, documentation, etc.)

_Global_ changes (such as CI configuration, security upgrades) might not have a component label.

### WIP features

We encourage to propose a PR and ask for review even if the feature is not complete (for medium/big features).

In that case, consider the following:
- Create a **draft** pull request (see [GitHub Docs](https://help.github.com/articles/about-pull-requests/#draft-pull-requests))
- Add the "wip" label (it's helpful to distinguish form other PRs in the list)
- Do not add `[WIP]` or similar to the title.

When requesting a review of "wip" feature, an author **must** provide a comment on what has been implemented (or use a checklist in the PR description).

## Code Reviews

☝ **Every PR must have at least one reviewer**

Exclusions:
- Hotfixes for critical production bugs when no reviewers are available
- Small development changes that do not affect production
- Minor documentation fixes

### Reviewer Guidelines

Be kind. Be concise.

Discussion – ✅
Philosophy – ⛔️

Read also:
- [https://medium.freecodecamp.org/unlearning-toxic-behaviors-in-a-code-review-culture-b7c295452a3c](https://medium.freecodecamp.org/unlearning-toxic-behaviors-in-a-code-review-culture-b7c295452a3c)
- [https://blog.plaid.com/building-an-inclusive-code-review-culture/](https://blog.plaid.com/building-an-inclusive-code-review-culture/)
- [https://blog.github.com/2015-01-21-how-to-write-the-perfect-pull-request/](https://blog.github.com/2015-01-21-how-to-write-the-perfect-pull-request/)
- [https://github.com/thoughtbot/guides/tree/master/code-review](https://github.com/thoughtbot/guides/tree/master/code-review)

## Working with Branches

Always use _merge_ strategy (`"Merge Pull Request"`) when merging features to the `master` branch (that would allow us to easily revert changes in case of fire 🔥).

Prefer _rebase_ strategy when merging sub-features to feature branches (to avoid useless merge commits\* in the feature itself).

**Squash responsibly 🎃** (and learn how to use [fixups](https://thoughtbot.com/blog/autosquashing-git-commits)).

**Never merge master to the branch**\* to resolve conflicts (and never use GitHub's "Resolve Conflicts" for the same reason). Rebase the branch instead.

**Delete the branch** after it has been merged. Let's keep the repo clean!

TIP: Use the following commands to clean your local repo:
- `git pull -p` – automatically remove refs to deleted remote branches
- `git remote prune origin` – the same as above without pulling
- `git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D` – delete local branches which remotes has been deleted.
