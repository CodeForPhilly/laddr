# Clone Laddr from git
This guide is for developers who want to work on Laddr's core code. It will walk you through
setting up a fresh site instance and cloning a version of Laddr into it from a remote git
repository.

## Step 1: Obtain an emergence host
You will need a host server dedicated to running emergence. If you don't have access to one already,
the easiest way to get started is to spin up a small **Ubuntu 14.04 LTS** virtual machine with a cloud
provider like Digital Ocean, Google Cloud Compute, AWS, or countless others. Once you are logged in
to your fresh Ubuntu 14.04 machine, follow [emergence's installation guide][emergence-install]
to prepare it for hosting emergence-powered sites like Laddr.

## Step 2: Create a site
Laddr is based on emergence's `skeleton-v2` site template. Unlike when provising a *deployment*
instance of Laddr, for development you want to create a site extending Laddr's parent
site like Laddr does rather than Laddr itself. Laddr's code will be cloned from git and applied
on top of the parent site.

Use emergence's host control panel to create a new site with your desired hostname and initial user, just
be sure to select `skeleton-v2.emr.ge` as the parent hostname. After the site is created login to <kbd>/develop</kbd>
with your initial user developer account.

## Step 3: Configure git link
To configure a link between your emergence instance and a git repository, create a file called
<kbd>Git.config.php</kbd> in the top level of the `php-config` directory and copy its initial contents
from the [latest version of Laddr's development Git.config.php][Git.config.php]
on Github.

You may change `originBranch` to select a different source and change `workingBranch` to change which branch you'll
be initially setup to commit to (both can be set to the same thing.)

See the [emergence manual page on git integration][emergence-git] for full details on all the configuration
options.

## Step 4: Initialize git links
Visit <kbd>/git/status</kbd> to view initialize the link with the configured git repository. If you are
cloning via HTTPS or don't need to push changes back to origin from the web interfaces, you can leave the deploy key field
empty and skip setting one up. Without a deploy key you will need to SSH into the server and use the git CLI to push changes.
[Setting up a deploy key][emergence-git] will enable you to use emergence's (currently minimal) web interface
for commiting/pushing changes.

## Step 5: Pull code from git
Visit <kbd>/git/status</kbd> and click **Pull** if needed to pull the latest commits from github into your
git working copy. Then click the **Disk -> VFS** button to import the git working tree copy into your
emergence instance.

[emergence-install]: http://emr.ge/docs/setup/ubuntu/14.04
[emergence-git]: http://emr.ge/docs/git/init
[Git.config.php]: https://github.com/CfABrigadePhiladelphia/laddr/blob/development/php-config/Git.config.php