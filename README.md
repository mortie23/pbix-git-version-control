# How to commit a PowerBI PBIX to Git

## What is the problem

A PBIX file, under the hood, it just a series of text files archived into a single file.
For PowerBI to read the file and display the dashboard in PowerBI desktop or web it needs to uncompress the archive and read the files first.

Version control systems like Git are terrific at tracking text files and not designed to track files that are not text. If the file is text, then incremental changes are efficiently tracked and stored. Otherwise Git will just track versions by keeping a full history of the file.

Git will see a commit of a PBIX file and say "I can't track the changes, so I will just keep another version of the file". This results in:

1. You cannot use it to see what the changes were between versions
2. The size of the repo starts to blow out the more you commit

We want Git to track the underlying files in the archive. But we want the users to not have to worry about this.

## Git Hooks

Git hooks are scripts that Git can run before or after most Git actions (like commit, receive, checkout etc). They are kept in the hidden `.git` directory and are local client files. This means they are not tracked by Git and are not synced between remotes when pushed or pulled. There are ways to get around this.

## Sharing Git Hooks

One way to do this is to create a `hooks` director in the root of your repo and then run this configuration.

```sh
git config core.hooksPath './hooks
```

It tells Git to look for the hooks scripts in this directory instead of the default in the `.git` directory.

## How we solve the PBIX problem

We want Git to do the following whenever a PBIX is committed:

1. Extract the PBIX into its underlying files
2. Commit these files instead
3. Do not commit the PBIX file

We want get to do the following whenever a PBIX is pulled/merged/checked out

1. Compress the PBIX

## Pre-requisite

> This will only work for PBIX that source the data from a remote source. If the DataModel is contained within the PBIX it will not work

Running on client machine with:

- Windows 10
- Git 2.27.0.windows.1
- GNU bash, version 4.4.23(1)-release (x86_64-pc-msys)
- Powershell Core 7.2.4

## Example

First let's create the PBIX.

### Dataset

I have a cloud hosted PostGres database and have loaded some sample NFL data to it subsequently loaded this to PowerBI as a XMLA dataset.

![](./images/pbi-git-datasource.png)

Lets open up PowerBI desktop and connect to this dataset.

![](./images/pbi-git-datasource-connect.png)

### Dashboard

We will create somthing very simple

1. Text box
2. Map viz

![](./images/pbi-git-dashboard.png)

### Use PBIT file type

We need to save this as a PBIT to ensure that one of the underlying files is created (`DataMashup`).

![](./images/pbi-git-dashboard-pbit.png)

But then we will rename the extension back to PBIX to make things easier (i.e. double clicking the file will open it in PowerBI desktop and make it easier to edit).

![](./images/pbi-git-dashboard-pbix.png)
