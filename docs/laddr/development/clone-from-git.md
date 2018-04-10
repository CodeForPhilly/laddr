# Clone Laddr from git

This guide is for developers who want to work on Laddr's core code. It will walk you through
setting up a fresh site instance and cloning a version of Laddr into it from a remote git
repository.

## Step 1: Obtain an emergence host

You will need a host server dedicated to running emergence. If you don't have access to one already,
the easiest way to get started is to spin up a small **Ubuntu 16.04 LTS** virtual machine with a cloud
provider like Digital Ocean, Google Cloud Compute, AWS, or countless others. Once you are logged in
to your fresh Ubuntu 16.04 machine, follow [emergence's installation guide][emergence-install]
to prepare it for hosting emergence-powered sites like Laddr.

Alternatively, if you're familiar with Docker, you can spin up an emergence container:

```bash
docker run -d \
    -it \
    --name emergence \
    -v /emergence:/emergence \
    -p 127.0.0.10:80:80 \
    -p 127.0.0.10:3306:3306 \
    -p 127.0.0.10:9083:9083 \
    jarvus/emergence \
    tmux new -s emergence emergence-kernel
```

## Step 2: Create a site for your laddr development instance

Laddr is based on emergence's `skeleton-v2` site template. Unlike when provising a *deployment*
instance of Laddr, for development you want to create a site extending Laddr's parent
site like Laddr does rather than Laddr itself. Laddr's code will be cloned from git and applied
on top of the parent site.

Use emergence's host control panel to create a new site with your desired hostname and initial user, just
be sure to select `skeleton-v2.emr.ge` as the parent hostname. After the site is created login to <kbd>/develop</kbd>
with your initial user developer account.

## Step 3: Configure mapping to the laddr git repository

To configure a link between your emergence instance and a git repository, create a new file at `php-config/Git.config.d/laddr.php` and copy its initial contents
from the [the file at the same path in Laddr's develop branch][git-config]
on Github.

Optionally, edit the `remote` option to point at your own fork, and switch it to the SSH protocol if you'd like to be able to push changes from the web UI.

## Step 4: Initialize git repository

Visit <kbd>/site-admin/sources</kbd> to view initialize the configured git repository. If you are
cloning via HTTPS you will need to SSH into the server and use the git CLI to push changes. If you switch the remote to an SSH git URL before initializing, a deploy key will be generated for you that you can install on GitHub before continueing to enable web-based read/write access.

## Step 5: Pull code from git

Visit <kbd>/site-admin/sources/laddr</kbd> and click **Pull** if needed to pull the latest commits from github into your
git working copy. Then click the **Sync** -> **Update emergence VFS** button to import the git working tree copy into your
emergence instance.

[emergence-install]: https://emergenceplatform.gitbook.io/emergence-book/server-setup/installation/ubuntu-16.04
[git-config]: https://github.com/CodeForPhilly/laddr/blob/develop/php-config/Git.config.d/laddr.php
