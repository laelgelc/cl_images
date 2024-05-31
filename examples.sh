#!/bin/bash
clear

project=cl_st1_yara

mkdir -p images/examples
rm -f images/examples/*

html2text -nobs images/sas/output_"$project"/loadtable.html > a

# The following block results in errors when run on a Linux Ubuntu system. It has been refactored as follows
#rm -f x??
#split -p'=====' a
#ls x?? > files

rm -f xx??
csplit a '/=====/+1' '{*}'
ls xx?? > files

while read file
do
      pole=$( grep '^Factor ' $file | cut -d' ' -f2,3 | sed -e 's/^/f/' -e 's/ //g' )
      sed 's/^[ ]*//' $file | grep '^[0-9]' | tr -dc '[:alpha:][:punct:][0-9]\n ' | sed 's/^/~/' | tr  '[:space:]()' ' ' | tr -s ' ' |  tr '~' '\n' | cut -d' ' -f2 | grep -v '^$' | sed "s/^/$pole /" 
done < files > images/examples/factors


#rm -f x??
rm -f xx??

head -1 images/sas/output_"$project"/"$project"_scores.tsv | tr -d '\r' | tr '\t' '\n' > vars
    
last=$( cut -d' ' -f1 images/examples/factors | tr -dc '[0-9\n]' | sort -nr | head -1 )
    
for i in $(eval echo {1..$last});
do
      column=$( echo " $i + 1 " | bc ) 
      cut -f1,"$column" images/sas/output_"$project"/"$project"_scores_only.tsv  | tail +2 > a

      for pole in pos neg
      do
        echo "--- "f"$i""$pole"" ---" 

        if [ "$pole" == pos ] ; then
           sort -nr -k2,2 a | grep -v '\-' | tr '\t' ' ' | grep -v ' 0' | head -20 | nl -nrz > files
        else
           sort -n -k2,2 a | grep '\-' | tr '\t' ' ' | grep -v ' 0' | grep -v '	0' | head -20 | nl -nrz > files
        fi

        grep f"$i""$pole" images/examples/factors | sort -t' ' -k2,2 | cut -d' ' -f2 | sort > factor_words
        
        while read n file score
        do

          grep -m1 $file images/sas/output_"$project"/"$project"_scores.tsv | tr -d '\r' | tr '\t' '\n' > scores
          paste vars scores | tr '\t' ' ' | grep '^v' | grep -v ' 0$' | cut -d' ' -f1 | sort > vars_text
          join vars_text images/selectedwords | cut -d' ' -f2 | sort > vars_text_codes
          username=$( grep -w $file user_index.txt | cut -d' ' -f2 )
          picture=$( grep -w $file images/images_index.txt | cut -d'|' -f2,7 | tr ':|' ' ' | cut -d' ' -f2,4 | sed 's;\(.*\) \(.*\);\1.\2;' )
          folder=$( grep -w $file images/images_index.txt | cut -d'|' -f1 | tr ':|' ' ' | cut -d' ' -f2  )
          url=$( grep -m1 -B5 $file tweets/jq.txt | grep '"url"'  | cut -d':' -f2- | tr -d '",' | sed 's/^[ ]*//' )
          extension=$( echo $picture | cut -d'.' -f2 )
          cp images/images/$folder/$picture images/examples/image_f"$i""$pole"_x`"$n"."$extension"

          echo "---------------" 

          echo "# $n" 
          echo "score = $score"  
          echo "url: $url"
          echo

          grep -w $file images/labels.txt | tr '|' '\n' | sed 's/l:/~/' | tr '~' '\n'    

          echo
          echo "Lemmas in this picture that loaded on the factor:"
          echo

          join vars_text_codes factor_words > ll
          tr '\n' ',' < ll | sed 's/,/, /g' | sed 's/, $//' > images/examples/lemmas_f"$i"_"$pole"_"$n".txt
          cat ll

          echo 

        done < files > images/examples/examples_f"$i"_"$pole".txt

      done

done

    #rm -f vars factor_words scores vars_text vars_text_codes
