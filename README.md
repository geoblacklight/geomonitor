# GeoMonitor

GeoMonitor is a application that monitors the health and availability of GeoServer hosts and layers. Built at Stanford University out of the desire to build a better discovery application for geospatial data, GeoBlacklight.

## Features

- RESTful API
- Host status pings
- Individual layer status using WMS requests
- Host and layer availability history

## Installation

**Requires PostgreSQL 9.*

### Create file `data/transformed.json`

This should be an array of [geoblacklight-schema](https://github.com/geoblacklight/geoblacklight-schema) documents.

#### Quick way (sample of documents)

```
$ curl -L https://raw.githubusercontent.com/geoblacklight/geoblacklight-schema/master/examples/selected.json -o data/transformed.json
```

#### Complete way (full documents)

Use [GeoHydra](https://github.com/sul-dlss/geohydra) to download, validate, and transform all OpenGeoportal documents to geoblacklight-schema format.

```
# Clone geohydra repository (to your location of choice)
$ git clone https://github.com/sul-dlss/geohydra.git

# Download OGP Solr Documents
$ ruby ogp/download.rb

# Validate documents
$ ruby ogp/validate.rb

# Transform documents
$ ruby ogp/tranform.rb

# Copy transformed.json to GeoMonitor
$ cp [path of transformed.json]/transformed.json [geomonitor path]/data/transformed.json
```


### Setup database

```
$ rake db:create
$ rake db:seed
```

### Ping hosts
```
$ rake ping:hosts
```

### Run tests

```
$ rspec
```

### Run checks on layers
```
# All layers
$ rake layers:check_all

# Check empties (layers that have not been checked yet)
$ rake layers:check_empties

# Check Stanford layers (private layers restricted to Stanford network)
$ rake layers:check_stanford

```

These rake tasks can be setup on cron jobs using the whenever gem. See `/config/schedule.rb`

```
every '15 * * * *' do
  rake 'layers:check_stanford'
end
```



## Contributing

1. Fork it ( http://github.com/<my-github-username>/geomonitor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
