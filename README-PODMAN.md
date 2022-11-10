## Podman Quickstart

This repo was original designed to run using Docker but it works with Podman with only minimal modification.

This README concerns only the steps for getting UMedia running under podman, for a more detailed explaination of how it fits together, please see the regular README.md file.

## FIXES BEFORE MERGING

- [ ] need to cleanup `.env`

- [ ] `libpangocairo-1.0` in DOCKERFILE

- [ ] double check solr_conf startup, check flags used in commands (`-F` is ignored)

- [ ] test on MacOS x86 bare metal

- [ ] test on Linux x86 (Ubuntu) VM


### Requirements

#### MacOS

If you're using an Apple Silicon (ARM) Machine, **you will need to use either a linux x86 VM through [UTM](https://mac.getutm.app) or an x86 Mac**. It is possible to run it on an Apple Silicon machine using some QEMU trickery but much more complicated. Save youself the hassle.

Install Podman with MacPorts: `sudo port install podman podman-compose`

You can also use a python venv to install `podman-compose`: `pip3 install podman-compose`

1. make sure the `podman-macos-helper` tool is installed: `sudo podman-macos-helper install`
2. Intialize a podman virtual machine: `podman machine init umedia`
3. If your machine has a lot of resources, give the VM a little bit more power: `podman machine set --cpus 2 --memory 4096 umedia`
4. start the VM: `podman machine start umedia`

#### Linux

<!--I’d just like to interject for a moment. What you’re refering to as Linux, is in fact, GNU/Linux, or as I’ve recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX.-->

1. Install Podman and podman-compose via your system's package manager. There are also third party repositories available, see the [podman install documentation](https://podman.io/getting-started/installation#installing-on-linux) for details.
2. **Optional**: you can setup a podman machine as in the instructions above, but it's not necessary when running on linux hosts

### Build and Start

> *tip!*: You may wish to do this in `tmux` or `byobu` to manage the terminal windows you'll have open 

1. Intialize the environment: `./podman_dev_init.sh`
2. build the app (this will take a bit): `podman-compose up`
3. populate the solr indicies: `./podman_dev_index_init.sh`
4. once the solr index has been setup, you can open `localhost:3000` in a browser and it should be working
5. ingest the sample records (this will take a bit): `podman-compose exec app bundle exec rake ingest:sample_records`
6. you can check the status of the record ingest by opening `localhost:3000/sidekiq`
7. when sidekiq has gotten through its queue, commit the items to solr: `podman-compose exec app bundle exec rake solr:commit`
8. and then ingest the metadata: `podman-compose exec app bundle exec rake ingest:collection_metadata`
9. **once everything above has completed**, run `podman-compose stop && podman-compose up`

### Further Development

For much more, see the regular README, repacing `docker` or `docker-compose` with `podman` or `podman-compose` as appropriate. Any scripts that are strings of `docker` commands will need to be modified as has been done here.
