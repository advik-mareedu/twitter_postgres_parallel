#!/bin/sh

files=$(find data/*)

echo '================================================================================'
echo 'load pg_denormalized'
echo '================================================================================'
# FIXME: implement this with GNU parallel
time echo "$files" | parallel ./load_denormalized.sh

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
# FIXME: implement this with GNU parallel
time echo "$files" | parallel python3 load_tweets.py --inputs={} --db postgresql://postgres:pass@localhost:1200

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
# FIXME: implement this with GNU parallel
#time echo "$files" | parallel python3 load_tweets_batch.py --inputs={} --db postgresql://postgres:pass@localhost:1300
