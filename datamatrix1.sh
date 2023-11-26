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

echo "--- images/data.csv ...---"

files=(images/temp/*)
batch_size=50
num_files=${#files[@]}
num_batches=$((num_files / batch_size))

for ((i = 0; i < num_batches; i++)); do
  start=$((i * batch_size))
  end=$((start + batch_size - 1))
  awk '
    FNR==1 { col++ }
    FNR>max { max=FNR }
    { l[FNR,col]=$0 }
    END {
      for (i=1;i<=max;i++) {
        for (j=1;j<=col;j++) {
          printf "%-50s",l[i,j]
        }
        print ""
      }
    }
  ' "${files[@]:$start:$batch_size}" >> u
done

awk '
  FNR==1 { col++ }
  FNR>max { max=FNR }
  { l[FNR,col]=$0 }
  END {
    for (i=1;i<=max;i++) {
      for (j=1;j<=col;j++) {
        printf "%-50s",l[i,j]
      }
      print ""
    }
  }
' "${files[@]:$((num_batches * batch_size))}" >> u

tr -s ' ' < u | tr ' ' ',' | sed 's/,$//' > images/data.csv
