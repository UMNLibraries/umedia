# UMedia

> UMedia provides access to digitized collections from across the University of Minnesota. These materials include photographs, archives, audio, video, maps, and more, with new items added on a regular basis. These open and freely available resources support the teaching and research needs of scholars, educators, students, and the public.

Site: [https://umedia.lib.umn.edu](https://umedia.lib.umn.edu)

Data is ingested from CONTENTdm into a Solr index and served by this Ruby on Rails application.

# Developer Quickstart

## Build, populate with data, and start the app

- [Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Install Docker Compose](https://docs.docker.com/compose/)

Initialize and start the local dev environment:

`./local_dev_init.sh`

**Note**: you will be prompted for a password. Use your `sudo` / machine admin password here.

`docker-compose up`

**Note** If you see somthing like `ERROR: The image for the service you're trying to recreate has been removed.`, respond with `y` to continue with the new image.

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

Wait for the app to fully boot, then open a new terminal tab and populate the local test and development solr core instances:

`./local_dev_index_init.sh`

Open [http://localhost:3000/](http://localhost:3000/) in your browser to see your dev instance.


### Ingest Sample Records Into Dev

A set of sample records has been selected for local development and testing. To ingest these records, open a new tab in your terminal / console application and issue the following command:

`docker-compose exec app bundle exec rake ingest:sample_records`

**Note:** this is pretty slow in develpment instances and will take a while.

Once these records have been indexed (monitor sidekiq indexing workers here:
[http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)), commit them to
solr and ingest the homepage collection overview info:


Commit items to solr:

`docker-compose exec app bundle exec rake solr:commit`

Ingest Collection Metadata:

`docker-compose exec app bundle exec rake ingest:collection_metadata`

After populating the development index, syncronize the development solr index to the test solr index `./sync_dev_index_to_test_index.sh` so that integration tests may pass.


### Optional: Configure credentials in the `.env` file:

```bash
SECRET_KEY_BASE=<<YOUR CONFIG HERE>>
# Nailer is a lambda app that handles thumbnail processing and storage:
UMEDIA_NAILER_API_URI=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_API_KEY=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_CDN_URI=<<YOUR CONFIG HERE>>
UMEDIA_NAILER_THUMB_FALLBACK_URL=<<YOUR CONFIG HERE>>
# This key is used to give the app permission to delete thumbnail
# from a given S3 bucket:
AWS_ACCESS_KEY_ID=<<YOUR CONFIG HERE>>
AWS_SECRET_ACCESS_KEY=<<YOUR CONFIG HERE>>
AWS_REGION=<<YOUR CONFIG HERE>>

# number of search results per page from Solr
UMEDIA_SEARCH_ROWS=20
# number of collections per page on homepage
# Always set to 1 by the test suite to enforce reliable paging on /home
UMEDIA_COLLECTION_PAGE_LIMIT=20
```

Then, reboot the app: `docker-compose stop; docker-compose up`. You should now be ready to develop via http://localhost:3000.

# Ingest CONTENTdm Content Into Solr
Interact with the Solr index and Sidekiq processor with the following methods:

```bash

# Ingest a fixed set of sample records (this is the "official" list of records used in our
# solr test index - see "Working With the Solr Test Index")
# NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:sample_records

# Ingest everything (ingest content from all collections)
# Might take up to 36 hours
# NOT ALWAYS NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:collections

# Ingest content for a single collection
# NOT ALWAYS NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:collection[set_spec_here]

# Ingest a single record
# NOT ALWAYS NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:record[record_id_here]

# Ingest collection metadata (used to populate the collection search on the home page)
# NOT ALWAYS NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:collection_metadata



# Enrich parent items with the transcripts of their children (makes search by
# MAYBE NEEDED FOR BASIC DEVELOPMENT
docker-compose exec app bundle exec rake ingest:collection_transcripts
```

Once the ingest sidekiq jobs (background worker processes) have completed:

`docker-compose exec app bundle exec rake solr:commit`

## Interacting with the App on the Command Line

Enter an interactive session with the application (must be running in another tab):

`docker-compose exec bundle exec app /bin/bash`

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
    docker-compose exec app bundle exec rake ingest:sample_records
    ```

    This...will take a while. Go get a snack.

4. Commit the record after sidekiq has finished processing (watch sidekiq here: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq))

   ```bash
   docker-compose exec app bundle exec rake solr:commit
   ```

5. Index transcript metadata

   Compound records may have children with transcripts. In order to make these child transcripts searchable, we have to run a post-indexing process that enriches the parent record with child record transcripts as child records are not searched in the primary index search UI.

   ```bash
   docker-compose exec app bundle exec rake ingest:collection_transcripts;
   docker-compose exec app bundle exec rake solr:commit
   ```

6. Synchronize the Solr dev index to the test index

   After verifying that your new record appears in the dev instance of your site, you may then sync it to the test instance.

   ```bash
   ./sync_dev_index_to_test_index.sh
   ```
7. Get your tests to pass.
8. Take a snapshot of the test instance and commit it as the new test instance:

```bash
./docker-compose-test-exec app bundle exec rake solr:backup
git add snapshots_test; git commit -m "update solr test instance with latest records"`
```
9.  Create a PR with your working code, test, and new `sample-records.json` and `snapshots_test` instance.

# Docker Help

## Troubleshooting docker-compose
Any updates to the `Gemfile/Gemfile.lock` require rebuilding the app's Docker
image. Local gem installs via `bundle install|update` will not affect the
existing images and may result in confusing errors from docker-compose when you
believe gems should be present.

```
app_1          | Could not find rake-13.0.2 in any of the sources
app_1          | Run `bundle install` to install missing gems.
```

Running `bundle install` as suggested by the error means doing so with
`docker-compose exec`. As a temporary fix you can:

```
$ docker-compose exec bundle install
```

To permanently resolve it, rebuild the image and restart the containers

```
$ docker-compose build
$ docker-compose up
```

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

## Useful Tools

- [Docker Dive](https://github.com/wagoodman/dive)

This is especially useful for analyzing containers to see why they are the size
that they are and finding ways to slim them down.

## Maintenance Tasks
### Refreshing thumbnails
Thumbnails are stored in S3 (by way of [AWS Lambda and Nailer](https://github.umn.edu/Libraries/nailer)) and served out of CloudFront. The S3 object name is a SHA1 hash of the provider's thumbnail URL as harvested by [ETLHub](https://github.umn.edu/Libraries/etlhub). For example:

- **Document**: https://umedia.lib.umn.edu/item/p16022coll175:2532
- **Has CONTENTdm source thumbnail**: https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll175/id/2532
- **Stored in S3/CloudFront as**: https://dkp5i0hinw9br.cloudfront.net/**6c738be3eac3276240b4776d2d175975d594e652**.png
- **Source thumbnail image sha1**:
```shell
$ echo -n https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll175/id/2532 | sha1sum
6c738be3eac3276240b4776d2d175975d594e652  -
```

To force a thumbnail
to be refreshed, delete it from the S3 bucket CloudFront is pointing to, then
invalidate the item in CloudFront.

- Examine the image in the browser to find its URL (e.g.
  `https://dkp5i0hinw9br.cloudfront.net/a457332b5a24d00b615d26308639ebf499c3c053.png`)
- Log into AWS console
- Navigate to CloudFront
- Locate the CDN distribution identified by the domain name you found with the
  image (e.g. `dkp5i0hinw9br.cloudfront.net`) and note which bucket is its
  `Origin`
- Navigate in the AWS console to S3
- Open the bucket associated with the CloudFront domain and search for the
  thumb's hash (e.g. `a457332b5a24d00b615d26308639ebf499c3c053`)
- Delete the item from S3
- Navigate in the AWS console to CloudFront
- To force a cache invalidation, open the Distribution, click the
  `Invalidations` tab
- Create a new Invalidation using the thumb's hash as an object path to
  invalidate (`a457332b5a24d00b615d26308639ebf499c3c053.png`)

### Clearing Rails Cache (if expected display changes do not appear)
The application cache (in Redis) may need to be cleared if collection metadata
changes do not show up after the nightly `rake ingest:collection_metadata` job.

```
$ RAILS_ENV=production bundle exec rake umedia_cache:clear
```

### Full reindexing (wipe & reindex)
Perform full reindexing **on the staging server**, backup the new index then
restore it to production via shared NFS.

Note: Make sure sidekiq is running on the staging server with `sudo systemctl
status sidekiq-*`

```shell
# On STAGING SERVER!!
# -----------------------------------------------------------------
# Wipe the index - takes a few seconds
$ RAILS_ENV=production bundle exec rake solr:delete_index

# Ingest collection metadata - takes a minute or so
$ RAILS_ENV=production bundle exec rake ingest:collection_metadata

# Ingest all collection data - takes 30+ hours
$ RAILS_ENV=production bundle exec rake ingest:collections

# Load transcript data
$ RAILS_ENV=production bundle exec rake ingest:collection_transcripts

# Run the daily changes job if the staging server does not keep crons
# up to date and the restore target gets a day ahead of this index
$ RAILS_ENV=production bundle exec rake ingest:collections_daily

# Once Sidekiq has finished everything, backup the new index to NFS
# Commit Solr for good measure (probably not necessary but only takes a moment)
$ RAILS_ENV=production bundle exec rake solr:commit
$ RAILS_ENV=production bundle exec rake solr:backup

# On PRODUCTION SERVER
# -----------------------------------------------------------------
# Restore the index from the shared NFS space (automatically uses the most recent)
$ RAILS_ENV=production bundle exec rake solr:restore

# Clear cache
$ RAILS_ENV=production bundle exec rails runner 'Rails.cache.clear'
$ RAILS_ENV=production bundle exec rake umedia_cache:clear_counts
```

## OAI-PMH Troubleshooting Examples
- List all collection metadata (`ListSets`): `https://cdm16022.contentdm.oclc.org/oai/oai.php?verb=ListSets`
- List all items in a collection (`ListIdentifiers` for set `p16022coll345`): `https://cdm16022.contentdm.oclc.org/oai/oai.php?verb=ListRecords&metadataPrefix=oai_dc&set=p16022coll345`
- Resume listing (next page) of that same set with its `resumptionToken` found at the end of the XML (note some params replaced by `resumptionToken`) `https://cdm16022.contentdm.oclc.org/oai/oai.php?verb=ListRecords&resumptionToken=p16022coll345:25539:p16022coll345:0000-00-00:9999-99-99:oai_dc`
- Get a single full record (`GetRecord`, identifier `oai:cdm16022.contentdm.oclc.org:p16022coll264/133`) `https://cdm16022.contentdm.oclc.org/oai/oai.php?verb=GetRecord&metadataPrefix=oai_dc&identifier=oai:cdm16022.contentdm.oclc.org:p16022coll264/133`
