# Docker - cidsDistribution tools

## What is it ?
This image contains tools for **preparing** and **building** [cids-distribution docker images](https://github.com/cismet/docker_cids-distribution) und **updating** the distributions to a given release.

## How to build it ?
Simply use `buildImage.sh` to build the docker image. Don't forget to modify `IMAGE_NAME` and `IMAGE_VERSION` if you whant to give your image an own name and/or version-tag.

## How to use it ?
This image uses [docker in docker](https://hub.docker.com/_/docker/). That's why it's mandatory to add the `/var/run/docker.sock` volume.
You also have to add your `$HOME` directory as a volume to `/root` if you need access to your docker config file (f.e. login credentials for your own repository).
The path of the directory of your distribution have to be added as a volume (same path inside the container than the hosts path). Additionaly this path has to be set as the environment variable `CIDS_DISTRIBUTION_DIR`.

### example
An example if using it from inside the cids-distribution directory (`pwd` equals the directory of the distribution):
```sh
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME:/root:ro \
  -v ${pwd}:${pwd}:ro \
  -e CIDS_DISTRIBUTION_DIR=${pwd} \
  reg.cismet.de/abstract/cids-distribution-tools:18.04.1 \
  <command> <params>
```
If no command and params are given, you get the usage instructions (available commands / parameters).

### `.env` file
The cidsDistribution tools need an `.env` that defines some variables telling the tools which name and tag the image should get, and also which distribution it should build with which extension and which codebase. An exemple:
```
IMAGE_NAME=reg.cismet.de/wupp/cids-distribution
IMAGE_VERSION=6.2.1
IMAGE_TAG_PREFIX=live

CIDS_DISTRIBUTION=cids-distribution-wuppertal
CIDS_EXTENSION=WuNDa
CIDS_CODEBASE=http://s10221.wuppertal-intra.de/cismet/cidsDistribution
```

### `volume/local` and `volume/private` directories

WARNING: ***Don't forget to add `volume/private/*` to the `.gitignore` file of your cidsDistribution if you don't wan't to share your private secrets whit the whole world !!!***

To build/update the cidsDistribution the tools need to add 2 volumes to the temporary container:
* `volume/local` containing the local Jars of the cidsDistribution you are building/updating
* `volume/private` containing the secrets needed to build/update the image like the `keystore` and `keystore.pwd` (only contains the keystore password) for signing the jars and `server.pwd` (contains to lines: `SERVER_USERNAME=<username>` and `SERVER_PASSWORD=<password>`) for the login credentials of the repository.

### available commands / parameters
* **`prepareExt <tag>`**: runs a temporary container of an existing docker cidsDistribution image with the given `<tag>` and copies all the `/cidsDistribution/lib/ext`-Jars of the container to the `volume/ext` directory of the host. These jars are copied into the `/cidsDistribution/lib/ext` directory while building the image.
* **`buildImage`**: builds the docker cidsDistribution image.
* **`updateDistribution <release>`**: runs a temporary container that builds/updates the distribution in the given `<release>` version, and commits the changes to the image.

## Who uses it ?
Examples of distributions using these tools: 
* https://github.com/cismet/cids-distribution-wuppertal
* https://github.com/cismet/cids-distribution-wrrl-db-mv
* https://github.com/cismet/cids-distribution-watergis
