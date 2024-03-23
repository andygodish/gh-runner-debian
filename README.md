# GH Runners

Debian based self-hosted GitHub runners.

The original self hosted runners are based on a Fedora base image. The use of the entire Fedora image does not align with what we are trying to accomplish with this repository --- slim and secure images pre-built with tools that our development teams perfer to use. 

## Updating Runner Release

By using the `get-runner-release.bash` file in the docker build, we can ensure that we are using the most up-to-date version of the runner software everytime we trigger a container build using our CI solution. 

## Runner Registration

This iteration of the image contains a stripped down version of the `runner.sh` script that does not take into consideration App Tokens that would otherwise be generated as part of the formal creation of a GH App. This allowed the stripping of an additional shell script that can be found in the [old repo](https://github.com/vr-infrastructure/openshift-gh-runners/blob/main/base/get_github_app_token.sh). We are only concerned with `Enterprise Runners`.

## Local Docker Container Build and Registration

The following assumes the execution of the docker command at the root of this repository. This simulates the execution process in the GH Workflows.

```
docker build -f debian/ghrunners/dockerfile -t runner:local . 
```

To create an enterprise runner, you only need to provide a `GITHUB_OWNER` and `GITHUB_PAT` as environment variables `-e`. 

Supplying the `/bin/bash` entrypoint will allow you to view output logs.

```
docker run -e GITHUB_PAT=${GITHUB_PAT} -e GITHUB_OWNER=${GITHUB_OWNER}  -it runner:test /bin/bash
```
