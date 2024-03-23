# GH Runners

Debian based self-hosted GitHub runners.

## Updating Runner Release

By using the `get-runner-release.bash` file in the docker build, the most up-to-date version of the runner software is downloaded everytime this runner is used in a GitHub actions workflow.

## Runner Registration

The `runner.sh` script does not take into consideration App Tokens that would otherwise be used for a GitHub App. This image is only meant for `Repository` & `Enterprise` runners, it will not work with organization runners. See the GH documentation for more details.

## Local Docker Container Build and Registration

```
docker build -f debian/ghrunners/dockerfile -t runner:local . 
```

To create an enterprise runner, you only need to provide a `GITHUB_OWNER` and `GITHUB_PAT` as environment variables `-e`. 

Supplying the `/bin/bash` entrypoint will allow you to view output logs.

```
docker run -e GITHUB_PAT=${GITHUB_PAT} -e GITHUB_OWNER=${GITHUB_OWNER}  -it runner:test /bin/bash
```
