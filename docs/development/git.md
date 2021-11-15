# Git Guide

## Naming Conventions

We use naming conventions for branches and commits to automatically connect them to JIRA tickets
(see [GitHub for Jira](https://www.atlassian.com/blog/jira-software/github-for-jira)).

### Branch naming

We name branches according to the following scheme: `<type>/<short-description>`.

Where _type_ can be one of "fix", "feat" (_feature_), "docs" or "chore" (for everything else).

### Commits naming

We use [conventional commits specification](https://www.conventionalcommits.org/en/v1.0.0-beta.4/).

Commit message should be of the form:

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

Where _type_ can be one of "fix", "feat", "docs", or "chore" (for everything else).

Please, use short and descriptive messages. Here is a good [tutorial](http://chris.beams.io/posts/git-commit/).

Add the link to the corresponding issue in the commit body, e.g.:

```sh
# The second -m will add the text to the commit description
$ git commit -m "chore: add docker-compose.yml" -m "https://evilmartians.atlassian.net/browse/VIC-17"
```

That would make links to the issues clickable on GitHub (just click on `...` near the commit name)
and even locally, if you're using a _link-aware_ terminal (e.g. VS Code):

```sh
$ git show -s --format=%B 6994e09
chore: add docker-compose.yml

https://company-name.atlassian.net/browse/TASK-00
```

**TIP**: add Git alias for showing commit descriptions:

```sh
$ git config --global alias.msg "show -s --format=%B"
$ git msg 6994e09
```

Use "[ci skip]" to prevent CI builds if commit doesn't contain anything _testable_: `"[ci skip] docs: update readme"`.

Use commit message _body_ to provide more context to the change. That would help others in the future when they'll try to _blame_ you)

## Hooks & LeftHook

To automate local development we use Git hooks managed by [LeftHook](https://github.com/evilmartians/lefthook).

### Installation

- Install lefthook (see [Readme](https://github.com/evilmartians/lefthook) for instructions).

- Run the following commands to install hooks:

```sh
# install all custom scripts from `.lefthook` folder
$ lefthook install
```

### Usage

The existing hooks assumes that you have Ruby installed.

You can modify the hooks behavior and skip some hooks locally or change the command
using `lefthook-local.yml`.

If you are using DIP for the development, run this command:

```sh
cp -f lefthook-local.dip_example.yml lefthook-local.yml
```

### Skipping hooks

Use the standard Git option `--no-verify` to skip `pre-commit` and `commit-msg` hooks:

```sh
$ git commit -m "..." --no-verify
```

Use `LEFTHOOK_EXCLUDE=<tag>` to exclude only the specific tags or use `LEFTHOOK=0` to disable all LeftHook hooks.
