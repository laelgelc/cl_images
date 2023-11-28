#!/bin/bash
clear
mkdir -p images/temp

rm -f images/temp/*

cut -d' ' -f1 images/columns | uniq | sort > files

while read n word 
do
  echo "--- $n ---"
  rg -w $n images/columns | sort -t' ' -k1,1 > a
  echo "$n" > images/temp/$n
  join -a 1 -1 1 -2 1 -e 0 files a | sed "s/$/ $n 0/" | cut -d' ' -f3 >> images/temp/$n
done < images/selectedwords
