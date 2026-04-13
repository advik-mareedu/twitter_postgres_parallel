#!/bin/bash

files=$(find data/*)

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for file in $files; do
    echo
    unzip -p "$file" | \
    jq -c 'walk(
      if type=="string" then
        gsub("\\\\"; "\\\\\\\\") |  # escape backslashes
        gsub("\r"; "")      |        # remove carriage returns
        gsub("\n"; "\\n")  |        # escape newlines
        gsub("\""; "\\\"")           # escape quotes
      else
        .
      end
    )' | \
    psql postgresql://postgres:pass@localhost:1100 \
      -c "\COPY tweets_jsonb (data) FROM STDIN"
    # copy your solution to the twitter_postgres assignment here
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do
    echo
    # copy your solution to the twitter_postgres assignment here
    python3 load_tweets.py --inputs="$file" --db postgresql://postgres:pass@localhost:1200

done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:3/ --inputs $file
done
