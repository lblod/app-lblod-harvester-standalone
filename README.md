# app-lblod-harvester-standalone
A version of the app-lblod-harvester with batteries included.

The application provides the following features:
- A jobs-dashboard to schedule lblod harvesting jobs
- A sparql endpoint to query the harvested information.

## pre-requisites
- [Docker Compose (at least v3.7)](https://docs.docker.com/compose/)
- 16 gb of RAM recommended
- The host can access the internet

The application hasn't been tested on any windows operating system.

## What's included?
This repository has two setups. The base of these setups resides in the standard docker-compose.yml.

* *docker-compose.yml* This provides you with the backend components.
* *docker-compose.dev.yml* Provides changes for a good local development setup.
  - publishes the backend services on port 80 directly, so you can navigate to the application easily.
  - publishes the database instance on port 8890 so you can easily see the content in the base triplestore
  - Note: make sure there are not already services running on these port
## Running
This section contains general information on running and maintaining an installation.

### Running the dev setup

  Execute the following:

      # Clone this repository
      git clone https://github.com/lblod/app-lblod-harvester-standalone

      # Move into the directory
      cd app-lblod-harvester-standalone

      # Start the system
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

  Wait for everything to boot to ensure clean caches.  You may choose to monitor the migrations service in a separate terminal and wait for the overview of all migrations to appear: `docker-compose logs -f --tail=100 migrations`.

We don't recommend this setup for production.

### Running the regular setup

  ```
  docker-compose up
  ```
  This is likely the way to go for production.
  The application starts without publishing any ports. As a best practice, Docker Compose recommends tailoring your deployment configuration in a [docker-compose.override.yml file](https://docs.docker.com/compose/extends/).

To monitor the logs, `docker-compose logs -ft` is your friend,

## Exploring the application
### Running your first harvesting job
We assume the application is running in dev setup. Go to `http://localhost`. The jobs dashboard should appear.
To schedule your first job, click 'Create new job'.
Choose 'Harvest & Publish' and fill in a URL that contains data to harvest. (E.g `https://publicatie.gelinkt-notuleren.vlaanderen.be/Vlaams-Brabant/Provincie/77b41550-25e2-11ec-8016-4117a34b12d5/notulen`, & mind trailing spaces)
Click 'Schedule' and go back to the overview page.
If everything goes well after a while the job should have the status 'success'.
A job contains multiple tasks, which you may want to explore in detail later.

To verify whether data was collected, you can go to 'Sparql' and start querying the data.

If you run the following query:

```
PREFIX besluit: <http://data.vlaanderen.be/ns/besluit#>
PREFIX mandaat: <http://data.vlaanderen.be/ns/mandaat#>
PREFIX lblodlg: <http://data.lblod.info/vocabularies/leidinggevenden/>

SELECT (COUNT(*) as ?total) WHERE {
  ?s a besluit:Zitting .
}

```
it should return a total greater than 0 if any data was found. Harvesting the same URL twice, will not increase this count. All URI's are unique.
Let's go a little bit deeper and see whether any information may be found about 'Agendapunten' tied to a 'Zitting'.

```
PREFIX http: <http://www.w3.org/2011/http#>
PREFIX besluit: <http://data.vlaanderen.be/ns/besluit#>
PREFIX mandaat: <http://data.vlaanderen.be/ns/mandaat#>
PREFIX lblodlg: <http://data.lblod.info/vocabularies/leidinggevenden/>
PREFIX dct: <http://purl.org/dc/terms/>

SELECT DISTINCT ?zitting ?dateZitting ?title WHERE {
  ?zitting a besluit:Zitting.
  ?zitting besluit:geplandeStart ?dateZitting.
  ?zitting besluit:behandelt ?agendapunt.
  ?agendapunt a besluit:Agendapunt.
  ?agendapunt dct:title ?title.
}
```
### Features
#### Harvesting jobs
Run a one time harvesting job.

#### Scheduled jobs
A periodic harvesting job is triggered to run a specific target URL.
This is useful for automatically gathering newly published information.

#### Sparql
A sparql interface to query (a filtered) view on the database.
Some extra notes:
  - direct connection to the database is possible too. See 'Advanced' section.
  - Queries are performed over HTTP, and can be queried through many HTTP clients.

## Advanced
### Anatomy of a harvesting job
The harvesting job consists of multiple tasks.

#### Collecting
The crawler downloads pages and makes sure if linked pages are downloaded too. (E.g from an overview page of all 'zittingen' to  detail page of 'notulen')
It stops once all linked pages are downloaded.

The harvester doesn't make any difference between bulk harvest operations and single pages. As long as all required annotations are there, the harvester will follow the relevant links.

See [lblod/harvest-collector-service](https://github.com/lblod/harvest-collector-service) for more info.

#### Importing
The RDFa from all downloaded pages is extracted. It performs basic validation too.
See (lblod/harvesting-import-service)[https://github.com/lblod/harvesting-import-service]

#### Validating
A more extended validation is performed against the [applicatieprofiel/besluit-publicatie](https://data.vlaanderen.be/doc/applicatieprofiel/besluit-publicatie/).
In this case, it is purely informative, and non-valid information will not block the process.

#### PublishHarvestedTriples
This step is to publish the gathered information. Here it means this will be available through the web interface in the harvesting frontend.
More information may be found here [lblod/import-with-sameas-service](https://github.com/lblod/import-with-sameas-service). (Note: another service in the future will probably perform this step.)

#### Checking-urls
It might be, mostly in bulk harvests, that downloads fail. The harvesting process is not halted, and the failed ones are reported here.
See [lblod/harvest-check-url-collection-service](https://github.com/lblod/harvest-check-url-collection-service)

## Accessing the database directly.
The database can be published and queried directly. See running 'Running dev setup'.
Going to `http://localhost:8890/sparql` as basic SPARQL interface is provided to query this.
Also, all queries are HTTP-request and could be performed by many HTTP clients.

## Performance database
Harvesting can be an expensive operation for bigger municipalities, e.g. Ghent, Antwerp.
A more beefy configuration has been included for the database and will need a more powerful machine too.
To run with this configuration, include the following settings in your `docker-compose.override.yml` file.
```
# other override settings
  virtuoso:
    volumes:
      - ./data/db:/data
      - ./config/virtuoso/virtuoso-beefy.ini:/data/virtuoso.ini
      - ./config/virtuoso/:/opt/virtuoso-scripts
```
## Overview of the Services

The `docker-compose.yml` file represents all used services in the application. They use images (currently) published on [Docker hub](https://hub.docker.com/). From there, good pointers towards documentation should be available.

For your comfort, we provide an overview of the core services here.

### Core services
The core services are listed here.


| Service  | Repository  |
|---|---|
| identifier  | https://github.com/mu-semtech/mu-identifier  |
| dispatcher  | https://github.com/mu-semtech/mu-dispatcher  |
| database  | https://github.com/mu-semtech/mu-authorization  |
| virtuoso  | https://github.com/tenforce/docker-virtuoso  |
| migrations | https://github.com/mu-semtech/mu-migrations-service |
| cache | https://github.com/mu-semtech/mu-cache |
| delta-notifier | https://github.com/mu-semtech/delta-notifier |
| file | https://github.com/mu-semtech/file-service |
| harvesting-download-url | https://hub.docker.com/r/lblod/download-url-service  |
| resource | https://github.com/mu-semtech/mu-cl-resources |
