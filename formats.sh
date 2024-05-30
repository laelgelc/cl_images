#!/bin/bash
clear
nlines=$( cat tweets/emoji.txt | wc -l | tr -dc '[0-9]' )

tail +2 images/correlation | tr -s ' ' | sed 's/^/CORR /' > bottom
head -1 images/correlation | tr -s ' ' | sed 's/^[ ]*//' | sed "s/\(v......\)/$nlines/g" | sed 's/^/N . /' > n

sed 's;data.csv;images/data.csv;' std.py > p
python3 p > s 
tr -s ' ' < s | cut -d' ' -f2 | grep -v 'float' | tr '\n' ' ' | sed 's/^/STD	 . /' > std 
echo >> std

sed 's;data.csv;images/data.csv;' mean.py > p
python3 p > m 
tr -s ' ' < m | cut -d' ' -f2 | grep -v 'float' | tr '\n' ' ' | sed 's/^/MEAN . /' > mean
echo >> mean

cat mean std n bottom > images/sas/corr.txt

echo "PROC FORMAT library=work ;
  VALUE  \$lexlabels" > images/sas/word_labels_format.sas
tr '\t' ' ' < images/selectedwords | sed 's/\(.*\) \(.*\)/"\1" = "\2"/' | sed -e 's/&/and/g' -e 's/%/pc/g' | tr -d '()' >> images/sas/word_labels_format.sas
echo ";
run;
quit;" >> images/sas/word_labels_format.sas
