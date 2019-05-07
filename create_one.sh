#!/bin/bash

collection=${1}
shards=${2:-0}

if [ $shards -gt 0 ]
then
    echo "create ${collection} with ${shards} shards"

    # register configset
    (cd $collection && zip -r - *) | \
    curl -X POST --header 'Content-Type:application/octet-stream' --data-binary @- \
    "http://localhost:8983/solr/admin/configs?action=UPLOAD&name=${collection}_set"

    # create a collection
    curl "http://localhost:8983/solr/admin/collections?action=CREATE&name=${collection}&numShards=${shards}&collection.configName=${collection}_set"
else
    echo "need number of shards"
fi