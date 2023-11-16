# Git

## Executable bit discrepancies

When sharing files between Windows and Linux, changes on Windows may result in
unwanted change detection of the Linux executable bit, for example:

```
diff --git a/splunk-queries.md b/splunk-queries.md
old mode 100755
new mode 100644
```

To fix, set `core.fileMode=false`, like so:
`git config core.fileMode false`

This is usually set when cloning a repo in Windows, but can be set manually
if it got missed, i.e. if cloning on Windows but using WSL.

(see https://stackoverflow.com/questions/26884337/how-do-i-get-windows-to-leave-the-executable-bit-alone)

## Email patches

In some circumstances, you may lack network access to an upstream remote
(just as a hypothetical scenario, this could happen when you're trying to update
your personal code snippets repository over a corporate network).
In that case, you may still be able to "push" commits by emailing a patch.
Use `git format-patch` to create the patch, and `git am` to apply it.

Reading:
- Git SCM [`format-patch` documentation](https://git-scm.com/docs/git-format-patch)
- Git SCM [`am` documentation](https://git-scm.com/docs/git-am)
- Git-Tower [tutorial](https://www.git-tower.com/learn/git/faq/create-and-apply-patch/)

```
# Switch to the base branch that is missing the new changes
git checkout main

# Create patch files for all new commits in a branch
git format-patch my-branch

# Combine into a single patch file (or print to stdout)
git format-patch my-branch --stdout > /path/to/patch/file
git format-patch my-branch --stdout

# Instead of switching to a base branch, you can specify the commits to include
# using a revision range
git format-patch from..to --stdout
git format-patch from..HEAD --stdout

```