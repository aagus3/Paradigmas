# Keep in sync with fork

To keep your repository in sync with `https://bitbucket.org/paradigmas-programacion-famaf/grupo00` these are the steps to follow:

## Add upstream channel (for the first time only)

    $ git remote add upstream https://<bitbucketuser>@bitbucket.org/paradigmas-programacion-famaf/grupo00.git

### Fetch and merge upstream

    $ git fetch upstream
    $ git checkout master  # this will sync into the master branch
    $ git merge upstream/master