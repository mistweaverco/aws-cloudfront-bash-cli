#!/bin/bash

# Simple bash script to invalidate AWS CloudFront files.
# Usage:
# export AWS_DISTRIBUTION_ID=<YOUR_AWS_DISTRIBUTION_ID>
# export AWS_ACCESS_KEY=<YOUR_AWS_ACCESS_KEY>
# export AWS_SECRET_KEY=<YOUR_AWS_SECRET_KEY>
# bash ./aws-cloudfront-cli.bash /nav/logo.png /nav/logo2.png /nav/logo3.png
main() {
  local api_endpoint
  local unixtime
  local xml
  local gmt_datestr
  local hash_value
  local sig

  api_endpoint="https://cloudfront.amazonaws.com/2010-11-01/distribution/$AWS_DISTRIBUTION_ID/invalidation"
  unixtime=$(date +%s)
  xml="<InvalidationBatch>"

  for path in "$@"; do
    xml="$xml<Path>$path</Path>"
  done

  xml="$xml<CallerReference>${AWS_DISTRIBUTION_ID}__$unixtime</CallerReference></InvalidationBatch>"
  gmt_datestr=$(LC_ALL=en_US.utf8 date -u +"%a, %d %b %Y %k:%M:%S GMT")
  hash_value=$(echo -n "$gmt_datestr" | openssl dgst -sha1 -binary -hmac "$AWS_SECRET_KEY")
  sig=$(echo -n "$hash_value" | openssl base64)

  curl \
    -X POST\
    -H "Authorization: AWS $AWS_ACCESS_KEY:$sig"\
    -H "Date: $gmt_datestr"\
    -H "Content-Type: text/xml; charset=UTF-8"\
    -d "$xml" "$api_endpoint"
}
main "$@"
