# UMedia

> UMedia provides access to digitized collections from across the University of Minnesota. These materials include photographs, archives, audio, video, maps, and more, with new items added on a regular basis. These open and freely available resources support the teaching and research needs of scholars, educators, students, and the public.

Site: [https://umedia.lib.umn.edu](https://umedia.lib.umn.edu)

Data is ingested from CONTENTdm into a Solr index and served by this Ruby on Rails application.

# Developer Quickstart

## Build, populate with data, and start the app

- [Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Install Docker Compose](https://docs.docker.com/compose/)

Initialize and start the local dev environment:

`./local_dev_init.sh.sh`

**Note**: you will be prompted for a password. Use your `sudo` / machine admin password here.

You'll see something like the following eventually appear in your terminal:

```bash
...
app_1          | [6] Puma starting in cluster mode...
app_1          | [6] * Version 3.12.1 (ruby 2.6.1-p33), codename: Llamas in Pajamas
app_1          | [6] * Min threads: 5, max threads: 5
app_1          | [6] * Environment: test
app_1          | [6] * Process workers: 3
app_1          | [6] * Preloading application
app_1          | [6] * Listening on tcp://0.0.0.0:3001
app_1          | [6] * Daemonizing...
app_1          | [1] Puma starting in cluster mode...
app_1          | [1] * Version 3.12.1 (ruby 2.6.1-p33), codename: Llamas in Pajamas
app_1          | [1] * Min threads: 5, max threads: 5
app_1          | [1] * Environment: development
app_1          | [1] * Process workers: 3
...
```

Once the rails server has booted, open [http://localhost:3000/](http://localhost:3000/) in your browser.

### Optional: Configure credentials in the `.env` file:

```bash
SECRET_KEY_BASE=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_API_URI=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_API_KEY=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_CDN_URI=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_THUMB_FALLBACK_URL=<<YOUR CONFIG HERE>>
AWS_ACCESS_KEY_ID=<<YOUR CONFIG HERE>>
AWS_SECRET_ACCESS_KEY=<<YOUR CONFIG HERE>>
AWS_REGION=<<YOUR CONFIG HERE>>
```

Then, reboot the app: `docker-compose stop; docker-compose up`

## Ingest CONTENTdm Content Into Solr

A few sample records are provided by a sample solr snapshot, but you may ingest more:

```bash
# Ingest everything (ingest content from all collections)
rake ingest:collections

# Ingest content for a single collection
rake ingest:collection[set_spec_here]

# Ingest a single record
rake ingest:record[record_id_here]

# Ingest collection metadata (used to populate the collection search on the home page)
rake ingest:collection_metadata

# Ingest a fixed set of sample records (this is the "official" list of records used in our solr test index - see "Working With the Solr Test Index")
rake ingest:sample_records

# Enrich parent items with the transcripts of their children (makes search by transcripts possible)
rake ingest:all_collection_transcripts
```

Once the ingest sidekiq jobs (background worker processes) have completed:

`docker-compose exec app rake solr:commit`

## Interacting with the App on the Command Line

Enter an interactive session with the application (must be running in another tab):

`docker-compose exec app /bin/bash`

Replace `/bin/bash` with `rails console` to skip right to a Rails console session.

Execute a task in the Rails Test Environment (e.g. shell into the test version of the app service):

`./docker-compose-test-exec app /bin/bash`

# Testing

To run the test suite: `./docker-compose-test-run app bundle exec rake test`

### Watching Your Functional Tests (Helpful for Debugging)

The Reflections `docker-compose.yml` comes equipped with a selenium server running VNC. To watch Selenium as it drives the test browser, install a [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) and connect it to `localhost:5900` (note: **no** `http://`) with the password "`secret`".

### Working With the Solr Test Index

Let's say you found a bug that depends on a certain record being in the index and want to write a test for this error.

1. Write your (failing test).
2. Add the record to the `sample-records.json` file in the root directory of this repository.

    This allows others to deterministically recreate the sample index.
    **Note**: be sure to `git pull origin master` before modifying this file so that you have the most recent list of example records.

   ```json
    [
      "p16022coll262:137",
      "p16022coll171:1706",
      "p16022coll416:904",
      "p16022coll358:6032",
      "p16022coll402:1349",
      "p16022coll406:104",
      "p16022coll251:3420",
      "p16022coll135:0",
      "p16022coll272:6",
      "p16022coll95:33",
      "p16022coll289:3",
      "p16022coll345:69542",
      "p16022coll287:464",
      "p16022coll287:649",
      "p16022coll287:561"
    ]
   ```
3. Ingest the new record(s)

    (Assumes your app is up and running via `docker-compose up` in another terminal tab)

    ```bash
    docker-compose exec app rake ingest:sample_records
    ```

    This...will take a while. Go get a snack.

4. Commit the record after sidekiq has finished processing (watch sidekiq here: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq))

   ```bash
   docker-compose exec app rake solr:commit
   ```

5. Index transcript metadata

   Compound records may have children with transcripts. In order to make these child transcripts searchable, we have to run a post-indexing process that enriches the parent record with child record transcripts as child records are not searched in the primary index search UI.

   ```bash
   docker-compose exec app rake ingest:all_collection_transcripts;
   docker-compose exec app rake solr:commit
   ```

6. Synchronize the Solr dev index to the test index

   After verifying that your new record appears in the dev instance of your site, you may then sync it to the test instance.

   ```bash
   ./sync_dev_index_to_test_index.sh
   ```
7. Get your tests to pass.
8. Create a PR with your working code, test, and new `sample-records.json`.
9. Push the new test instance to DockerHub once your changes have been merged.

    Share your new test index so that your new tests pass for others.

    ```bash
    ./push_test_index_to_dockerhub.sh
    ```

# Docker Help

## Some aliases for your shell

```bash
# Note: you might consider adding aliases (shortcuts) in your shell
# env to make it easier to run these commands. e.g.:
# alias dps='docker ps -a'

# Show all docker images
docker ps -a

# Force Remove all umedia images
docker-compose stop; docker rmi -f $(docker images -q --filter="reference=umedia*")

# Remove all inactive Docker images (ones that have "Exited")
docker rm $(docker ps -a | grep Exited | awk '\''BEGIN { FS=" " } ; {print $1;}'\'')

# CAREFUL! Scorched earth! remove all Docker images and volumes
docker system prune -a --volumes
```

## Usefull Tools

- [Docker Dive](https://github.com/wagoodman/dive)

This is especially useful for analyzing containers to see why they are the size that they are and finding ways to slim them down.
