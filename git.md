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