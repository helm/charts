#!/bin/bash

while read line
do
    echo "$line" >> /tmp/test.txt
done

/tools/bats/bats -t /tmp/test.txt

