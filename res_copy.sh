#!/usr/bin/env bash

for sample in $(ls above20/*json | cut -f2 -d"/" | cut -f2 -d"_")
do
	echo "=====================creating json for $sample=========================================="
        original=$(ls above20/*json | cut -f2 -d"/" | grep $sample)
	echo $original
	genes=$(grep -A1 gene above20/$original  | grep name | cut -f2 -d":" | sort -u | sed -z 's/[ ,",\,]//g; s/\n/,/g; s/,$/\n/; s/,//g')
	echo $genes
	if [ $genes == "INPRRT" ]
	then
	        echo -e "{" > results3/${sample}_lab_dr_report.json
        	# Get the mutations
        	## Add header having the subtype and genes analysed
        	subtype=$( grep -A1 "\"bestMatchingSubtype\"" above20/$original | tail -1 | cut -f2 -d":" | sed 's/,//; s/ //' | cut -f1 -d"(" | sed 's/"//; s/^ [ \t]*//; s/[ \t]*$//')
		echo $subtype
		genesanalysed="IN,PR,RT"
        	#genesanalysed=$(grep -A1 gene $original  | grep name | cut -f2 -d":" | sort -u | sed -z 's/[ ,",\,]//g; s/\n/,/g; s/,$/\n/')
        	echo -e "\"Subtype\":\"$subtype\",\n\"Genes.Analysed\":\"$genesanalysed\"," >> results3/${sample}_lab_dr_report.json # add subtype and genes analysed
        	echo -e "\"data\":[" >> results3/${sample}_lab_dr_report.json
        	echo -e "type\tname\tcode\tdcode\tlevel\tscore" > ${sample}_levels.txt
        	for code in `cat drug_names.csv | grep -v Type | grep PI | cut -f2 -d","`
        	do
                	drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
                	resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
                	drugnamecode=$(echo "$drugname ($code)") # create drug name code
                	score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
                	echo -e "PI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done


        	for code in `cat drug_names.csv | grep -v Type | grep -w NRTI | cut -f2 -d","`
        	do
                	drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
                	resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
                	drugnamecode=$(echo "$drugname ($code)") # create drug name code
                	score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
                	echo -e "NRTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done

        	for code in `cat drug_names.csv | grep -v Type | grep -w NNRTI | cut -f2 -d","`
        	do
               		drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
                	resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
                	drugnamecode=$(echo "$drugname ($code)") # create drug name code
                	score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
                	echo -e "NNRTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done

        	for code in `cat drug_names.csv | grep -v Type |grep INSTI | cut -f2 -d","`
        	do
                	drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
                	resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
                	drugnamecode=$(echo "$drugname ($code)") # create drug name code
                	score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
                	echo -e "INSTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done

        	for i in $(cat ${sample}_levels.txt | grep -v type | cut -f3) # access the drug names
        	do
                	dclass=$(cat ${sample}_levels.txt | grep $i | cut -f1) # create drug class
                	dname=$(cat ${sample}_levels.txt | grep $i | cut -f2) # create drug name
                	dcode=$i
                	dresistancelevel=$(cat ${sample}_levels.txt | grep $i | cut -f5) # create resistance level
                	dscore=$(cat ${sample}_levels.txt | grep $i | cut -f6) # create the score
                	echo -e "   {" >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Drug.Class\":\"$dclass\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Drug.Name\":\"$dname\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Code\":\"$dcode\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Resistance.level\":$dresistancelevel," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"score\":$dscore" >> results3/${sample}_lab_dr_report.json
                	echo -e "   }," >> results3/${sample}_lab_dr_report.json
        	done
        	echo -e " ]," >> results3/${sample}_lab_dr_report.json
        	## create above mutations
        	touch ${sample}_PI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' > ${sample}_PI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_above.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "pimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "piaccmut.csv"} {print > fout}'
        	for i in $(ls *pimajmut.csv *piaccmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ]
                	then
                        	cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_above.csv
                	elif [ $nlines -eq 3 ]
                	then
                        	cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_above.csv
                	fi
        	done
        	piabove=$(cat ${sample}_PI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_PI_above.csv *pimajmut.csv *piaccmut.csv

        	touch ${sample}_NRTI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"NRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' > ${sample}_NRTI_above.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"NRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "cnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *cnrtimajmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ]
                	then
                        	cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_above.csv
                	elif [ $nlines -eq 3 ]
                	then
                        	cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_above.csv
                	fi
        	done
        	nrtiabove=$(cat ${sample}_NRTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NRTI_above.csv *cnrtimajmut.csv

        	touch ${sample}_NNRTI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"NNRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' > ${sample}_NNRTI_above.csv      
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"NNRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "cnnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *cnnrtimajmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                        	cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_above.csv
                	elif [ $nlines -eq 3 ] 
                	then
                        	cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_above.csv
                	fi
        	done
        	nnrtiabove=$(cat ${sample}_NNRTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NNRTI_above.csv *cnnrtimajmut.csv

        	touch ${sample}_INSTI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' > ${sample}_INSTI_above.csv
        	#sed -z 's/\n/#/g' $original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_above.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "instimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "instiaccmut.csv"} {print > fout}'
        	for i in $(ls *instimajmut.csv *instiaccmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                        	cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_above.csv
                	elif [ $nlines -eq 3 ] 
                	then
                        	cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_above.csv
                	fi
        	done
        	instiabove=$(cat ${sample}_INSTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_INSTI_above.csv *instimajmut.csv *instiaccmut.csv

        	## add the above mutations to the json
        	echo -e " \"HIVDR.Mutations.above.20\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"pi.above.20\":\"$piabove\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti.above.20\":\"$nrtiabove\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nnrti.above.20\":\"$nnrtiabove\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"insti.above.20\":\"$instiabove\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json

        	## create below mutations
        	touch ${sample}_PI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20pimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20piaccmut.csv"} {print > fout}'
        	for i in $(ls *b20pimajmut.csv *b20piaccmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                        	percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                        	if [ $percent -eq 2 ] 
                        	then
                                	cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_below.csv
                        	fi
                	elif [ $nlines -eq 3 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_below.csv
                	        fi
                	fi
        	done
        	pibelow=$(cat ${sample}_PI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_PI_below.csv *b20pimajmut.csv *b20piaccmut.csv

        	touch ${sample}_NRTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"NRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20cnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *b20cnrtimajmut.csv)
        	do
                	nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                        	if [ $percent -eq 2 ] 
                        	then
                        	        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_below.csv
                        	fi
                	elif [ $nlines -eq 3 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_below.csv
                	        fi
                	fi
        	done

        	nrtibelow=$(cat ${sample}_NRTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NRTI_below.csv *b20cnrtimajmut.csv
        	touch ${sample}_NNRTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"NNRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20cnnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *b20cnnrtimajmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_below.csv
                	        fi
                	elif [ $nlines -eq 3 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_below.csv
                	        fi
                	fi
        	done
        	nnrtibelow=$(cat ${sample}_NNRTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NNRTI_below.csv *b20cnnrtimajmut.csv

        	touch ${sample}_INSTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instiaccmut.csv"} {print > fout}'
        	for i in $(ls *b20instimajmut.csv *b20instiaccmut.csv)
        	do
               		nlines=$(cat $i | wc -l)
                	if [ $nlines -eq 2 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
                	        fi
                	elif [ $nlines -eq 3 ] 
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ] 
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
                	        fi
                	fi
        	done
        	instibelow=$(cat ${sample}_INSTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_INSTI_below.csv *b20instimajmut.csv *b20instiaccmut.csv

        	## add the below mutations to the json
        	echo -e " \"HIVDR.Mutations.below.20\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"pi.below.20\":\"$pibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti.below.20\":\"$nrtibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nnrti.below.20\":\"$nnrtibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"insti.below.20\":\"$instibelow\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ## Create comments
        	touch ${sample}_comments_nnrti.csv ${sample}_comments_nrti.csv ${sample}_comments_pimajor.csv ${sample}_comments_piaccessory.csv ${sample}_comments_instimajor.csv ${sample}_comments_instiaccessory.csv
    
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"NNRTI\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_nnrti.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"NRTI\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_nrti.csv
#        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_pimajor.csv
#        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_piaccessory.csv
#        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | awk 'BEGIN {FS="\"commentType\": \"Major\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instimajor.csv 
#        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | awk 'BEGIN {FS="\"commentType\": \"Accessory\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instiaccessory.csv

#		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"IN"
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | awk 'BEGIN {FS="\"commentType\": \"Accessory\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"IN"
		in=$(echo $?)
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"PR"
		pr=$(echo $?)
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"IN"
		prin=$(echo $?)

		echo "$original,$pr,$in,$prin" >> aexitstatus.test

		if [[ "$pr" -eq 0 && "$in" -eq 0 ]]
		then
			sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_piaccessory.csv
	        	sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | awk 'BEGIN {FS="\"commentType\": \"Accessory\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instiaccessory.csv
		elif [[ "$pr" -eq 0 && "$prin" -eq 1 ]]
		then
			sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_piaccessory.csv
		elif [[ "$pr" -eq 1 && "$prin" -eq 0 ]]
		then
			sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instiaccessory.csv
		fi
		
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | awk 'BEGIN {FS="\"commentType\": \"Major\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"IN"	
		inm=$(echo $?)
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"PR"
		prm=$(echo $?)
		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | grep "\"name\": \"IN"
		prinm=$(echo $?)

		echo "$original,$prm,$inm,$prinm" >> mexitstatus.test
		
		if [[ "$prm" -eq 0 && "$inm" -eq 0 ]]
		then
        		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_pimajor.csv
        		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | awk 'BEGIN {FS="\"commentType\": \"Major\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instimajor.csv 
		elif [[ "$prm" -eq 1 && "$prinm" -eq 0 ]]
		then
        		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instimajor.csv
		elif [[ "$prm" -eq 0 && "$prinm" -eq 1 ]]
		then	
        		sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_pimajor.csv
		fi

        	### Add the comments to the json
        	echo -e " \"comments\":{" >> results3/${sample}_lab_dr_report.json
        	##### Add RT comments
        	echo "==============add rt comments================="
        	echo -e " \"rt\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nnrti\":\"$(cat ${sample}_comments_nnrti.csv)\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti\":\"$(cat ${sample}_comments_nrti.csv)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json

        	###### Add PI comments
        	echo "===========add pi comments==============="
        	echo -e " \"pi\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"major\":\"$(cat ${sample}_comments_pimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"accessory\":\"$(cat ${sample}_comments_piaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ##### Add INSTI comments
	        echo "====================add insti comments============"
	        echo -e " \"insti\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"major\":\"$(cat ${sample}_comments_instimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"accessory\":\"$(cat ${sample}_comments_instiaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }" >> results3/${sample}_lab_dr_report.json
	        echo -e "}," >> results3/${sample}_lab_dr_report.json
	        echo -e " \"runDetails\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"amplified\": "true"," >> results3/${sample}_lab_dr_report.json # add amplification
	        echo -e "   \"testDate\":\"$(date +%F" "%T)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e "  }\n}" >> results3/${sample}_lab_dr_report.json
#		bash all.sh
	elif [ $genes == "INRT" -o $genes == "IN" ]
	then
        	echo -e "{" > results3/${sample}_lab_dr_report.json
        	# Get the mutations
        	## Add header having the subtype and genes analysed
        	subtype=$( grep -A1 "\"bestMatchingSubtype\"" above20/$original | tail -1 | cut -f2 -d":" | sed 's/,//; s/ //' | cut -f1 -d"(" | sed 's/"//; s/^ [ \t]*//; s/[ \t]*$//')
		genesanalysed="IN"
        	#genesanalysed=$(grep -A1 gene $original  | grep name | cut -f2 -d":" | sort -u | sed -z 's/[ ,",\,]//g; s/\n/,/g; s/,$/\n/')
        	echo -e "\"Subtype\":\"$subtype\",\n\"Genes.Analysed\":\"$genesanalysed\"," >> results3/${sample}_lab_dr_report.json # add subtype and genes analysed
        	echo -e "\"data\":[" >> results3/${sample}_lab_dr_report.json
        	echo -e "type\tname\tcode\tdcode\tlevel\tscore" > ${sample}_levels.txt
	
	        for code in `cat drug_names.csv | grep -v Type |grep INSTI | cut -f2 -d","`
        	do
        	        drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
        	        resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
        	        drugnamecode=$(echo "$drugname ($code)") # create drug name code
        	        score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
        	        echo -e "INSTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done

        	for i in $(cat ${sample}_levels.txt | grep -v type | cut -f3) # access the drug names
        	do
        	        dclass=$(cat ${sample}_levels.txt | grep $i | cut -f1) # create drug class
        	        dname=$(cat ${sample}_levels.txt | grep $i | cut -f2) # create drug name
        	        dcode=$i
        	        dresistancelevel=$(cat ${sample}_levels.txt | grep $i | cut -f5) # create resistance level
        	        dscore=$(cat ${sample}_levels.txt | grep $i | cut -f6) # create the score
        	        echo -e "   {" >> results3/${sample}_lab_dr_report.json
        	        echo -e "     \"Drug.Class\":\"$dclass\"," >> results3/${sample}_lab_dr_report.json
        	        echo -e "     \"Drug.Name\":\"$dname\"," >> results3/${sample}_lab_dr_report.json
        	        echo -e "     \"Code\":\"$dcode\"," >> results3/${sample}_lab_dr_report.json
        	        echo -e "     \"Resistance.level\":$dresistancelevel," >> results3/${sample}_lab_dr_report.json
        	        echo -e "     \"score\":$dscore" >> results3/${sample}_lab_dr_report.json
        	        echo -e "   }," >> results3/${sample}_lab_dr_report.json
        	done
        	echo -e " ]," >> results3/${sample}_lab_dr_report.json
        	## create above mutations
	
        	touch ${sample}_INSTI_above.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $2}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "instimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $2}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "instiaccmut.csv"} {print > fout}'
        	for i in $(ls *instimajmut.csv *instiaccmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_above.csv
        	        elif [ $nlines -eq 3 ]
        	        then
        	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_above.csv
        	        fi
        	done
        	instiabove=$(cat ${sample}_INSTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_INSTI_above.csv *instimajmut.csv *instiaccmut.csv
	
	        ## add the above mutations to the json
	        echo -e " \"HIVDR.Mutations.above.20\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"pi.above.20\":\"\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nrti.above.20\":\"\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nnrti.above.20\":\"\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"insti.above.20\":\"$instiabove\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json
        	touch ${sample}_INSTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $3}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instiaccmut.csv"} {print > fout}'
        	for i in $(ls *b20instimajmut.csv *b20instiaccmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
        	                fi
        	        elif [ $nlines -eq 3 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
        	                fi
        	        fi
        	done
        	touch ${sample}_INSTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"mutationType\": \"Major\""} {print $1}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"mutationType\": \"Accessory\""} {print $1}' | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20instiaccmut.csv"} {print > fout}'
        	for i in $(ls *b20instimajmut.csv *b20instiaccmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
                	        fi
                	elif [ $nlines -eq 3 ]
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ]
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_INSTI_below.csv
                	        fi
                	fi
        	done

        	instibelow=$(cat ${sample}_INSTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_INSTI_below.csv *b20instimajmut.csv *b20instiaccmut.csv
        	## add the below mutations to the json
        	echo -e " \"HIVDR.Mutations.below.20\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"pi.below.20\":\"$pibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti.below.20\":\"$nrtibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nnrti.below.20\":\"$nnrtibelow\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"insti.below.20\":\"$instibelow\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ## Create comments
	        touch ${sample}_comments_nnrti.csv ${sample}_comments_nrti.csv ${sample}_comments_pimajor.csv ${sample}_comments_piaccessory.csv ${sample}_comments_instimajor.csv ${sample}_comments_instiaccessory.csv
	
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | awk 'BEGIN {FS="\"commentType\": \"Major\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instimajor.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | awk 'BEGIN {FS="\"commentType\": \"Accessory\""} {print $3}' | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_instiaccessory.csv
	
	        ### Add the comments to the json
	        echo -e " \"comments\":{" >> results3/${sample}_lab_dr_report.json
        	##### Add RT comments
        	echo "==============add rt comments================="
        	echo -e " \"rt\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nnrti\":\"$(cat ${sample}_comments_nnrti.csv)\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti\":\"$(cat ${sample}_comments_nrti.csv)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ###### Add PI comments
	        echo "===========add pi comments==============="
	        echo -e " \"pi\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"major\":\"$(cat ${sample}_comments_pimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"accessory\":\"$(cat ${sample}_comments_piaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ##### Add INSTI comments
	        echo "====================add insti comments============"
	        echo -e " \"insti\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"major\":\"$(cat ${sample}_comments_instimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"accessory\":\"$(cat ${sample}_comments_instiaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }" >> results3/${sample}_lab_dr_report.json
	        echo -e "}," >> results3/${sample}_lab_dr_report.json
        	echo -e " \"runDetails\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"amplified\": "true"," >> results3/${sample}_lab_dr_report.json # add amplification
        	echo -e "   \"testDate\":\"$(date +%F" "%T)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e "  }\n}" >> results3/${sample}_lab_dr_report.json

	#	bash int.sh
	elif [ $genes == "PRRT" ]
	then
        	echo -e "{" > results3/${sample}_lab_dr_report.json
        	# Get the mutations
        	## Add header having the subtype and genes analysed
        	subtype=$( grep -A1 "\"bestMatchingSubtype\"" above20/$original | tail -1 | cut -f2 -d":" | sed 's/,//; s/ //' | cut -f1 -d"(" | sed 's/"//; s/^ [ \t]*//; s/[ \t]*$//')
		genesanalysed="PR,RT"
        	genesanalysed=$(grep -A1 gene above20/$original  | grep name | cut -f2 -d":" | sort -u | sed -z 's/[ ,",\,]//g; s/\n/,/g; s/,$/\n/')
        	echo -e "\"Subtype\":\"$subtype\",\n\"Genes.Analysed\":\"$genesanalysed\"," >> results3/${sample}_lab_dr_report.json # add subtype and genes analysed
        	echo -e "\"data\":[" >> results3/${sample}_lab_dr_report.json
        	echo -e "type\tname\tcode\tdcode\tlevel\tscore" > ${sample}_levels.txt
        	for code in `cat drug_names.csv | grep -v Type | grep PI | cut -f2 -d","`
        	do
        	        drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
        	        resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
        	        drugnamecode=$(echo "$drugname ($code)") # create drug name code
        	        score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
        	        echo -e "PI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
        	done
	
	
	        for code in `cat drug_names.csv | grep -v Type | grep -w NRTI | cut -f2 -d","`
	        do
	                drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
	                resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
	                drugnamecode=$(echo "$drugname ($code)") # create drug name code
	                score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
	                echo -e "NRTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
	        done
	
	        for code in `cat drug_names.csv | grep -v Type | grep -w NNRTI | cut -f2 -d","`
	        do
	                drugname=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -A2 $code | grep "fullName" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//') # create drugname
	                resistancelevel=$(grep -E -B4 " Resistance\"|Susceptible" above20/$original  | grep -Ev "Drug|}" | grep -A2 $code | grep "text" | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' |  sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/.*/"&"/') # create resistance level
	                drugnamecode=$(echo "$drugname ($code)") # create drug name code
	                score=$(grep -E -B5 " Resistance\"|Susceptible" above20/$original | grep -Ev "Drug|}" | grep -B2 level | grep -A2 $code | grep score | cut -f2 -d: | sed 's/"//g' | sed 's/,$//' | sed 's/^ [ \t]*//; s/[ \t]*$//') # create score
	                echo -e "NNRTI\t$drugname\t$code\t$drugnamecode\t$resistancelevel\t$score" >> ${sample}_levels.txt
	        done
	
	        for i in $(cat ${sample}_levels.txt | grep -v type | cut -f3) # access the drug names
	        do
                	dclass=$(cat ${sample}_levels.txt | grep $i | cut -f1) # create drug class
                	dname=$(cat ${sample}_levels.txt | grep $i | cut -f2) # create drug name
                	dcode=$i
                	dresistancelevel=$(cat ${sample}_levels.txt | grep $i | cut -f5) # create resistance level
                	dscore=$(cat ${sample}_levels.txt | grep $i | cut -f6) # create the score
                	echo -e "   {" >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Drug.Class\":\"$dclass\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Drug.Name\":\"$dname\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Code\":\"$dcode\"," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"Resistance.level\":$dresistancelevel," >> results3/${sample}_lab_dr_report.json
                	echo -e "     \"score\":$dscore" >> results3/${sample}_lab_dr_report.json
                	echo -e "   }," >> results3/${sample}_lab_dr_report.json
        	done
        	echo -e " ]," >> results3/${sample}_lab_dr_report.json
		
       		## create above mutations
        	touch ${sample}_PI_above.csv
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "pimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "piaccmut.csv"} {print > fout}'
        	for i in $(ls *pimajmut.csv *piaccmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_above.csv
        	        elif [ $nlines -eq 3 ]
        	        then
        	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_above.csv
        	        fi
        	done
        	piabove=$(cat ${sample}_PI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_PI_above.csv *pimajmut.csv *piaccmut.csv
	
	        touch ${sample}_NRTI_above.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"NRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "cnrtimajmut.csv"} {print > fout}'
	        for i in $(ls *cnrtimajmut.csv)
	        do
	                nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
                	        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_above.csv
                	elif [ $nlines -eq 3 ]
                	then
                	        cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_above.csv
                	fi
        	done
	
	        nrtiabove=$(cat ${sample}_NRTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
	        rm ${sample}_NRTI_above.csv *cnrtimajmut.csv
	
	        touch ${sample}_NNRTI_above.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"mutationType\": \"NNRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "cnnrtimajmut.csv"} {print > fout}'
	        for i in $(ls *cnnrtimajmut.csv)
	        do
	                nlines=$(cat $i | wc -l)
	                if [ $nlines -eq 2 ]
	                then
	                        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_above.csv
	                elif [ $nlines -eq 3 ]
	                then
	                        cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_above.csv
	                fi
	        done
	        nnrtiabove=$(cat ${sample}_NNRTI_above.csv | sed -z 's/\n/,/g; s/,$/\n/')
	        rm ${sample}_NNRTI_above.csv *cnnrtimajmut.csv
	
	        ## add the above mutations to the json
	        echo -e " \"HIVDR.Mutations.above.20\":{" >> results3/${sample}_lab_dr_report.json
		echo -e "   \"pi.above.20\":\"$piabove\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"nrti.above.20\":\"$nrtiabove\"," >> results3/${sample}_lab_dr_report.json
       		echo -e "   \"nnrti.above.20\":\"$nnrtiabove\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"insti.above.20\":\"$instiabove\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }," >> results3/${sample}_lab_dr_report.json

        	## create below mutations
        	touch ${sample}_PI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Major\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20pimajmut.csv"} {print > fout}'
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"Accessory\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20piaccmut.csv"} {print > fout}'
        	for i in $(ls *b20pimajmut.csv *b20piaccmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_below.csv
        	                fi
        	        elif [ $nlines -eq 3 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_PI_below.csv
        	                fi
        	        fi
        	done
        	pibelow=$(cat ${sample}_PI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_PI_below.csv *b20pimajmut.csv *b20piaccmut.csv

        	touch ${sample}_NRTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"NRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20cnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *b20cnrtimajmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
        	                        cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_below.csv
        	                fi
        	        elif [ $nlines -eq 3 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NRTI_below.csv
                	        fi
                	fi
        	done	
	
        	nrtibelow=$(cat ${sample}_NRTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NRTI_below.csv *b20cnrtimajmut.csv

        	touch ${sample}_NNRTI_below.csv
        	sed -z 's/\n/#/g' below20/$original | grep -o "\"mutationType\": \"NNRTI\".*" | awk 'BEGIN {FS="\"__typename\": \"MutationsByType\""} {print $1}' | sed -z 's/#/\n/g' | grep -E "text|percent" | cut -f2 -d":" | sed 's/[", ,\,]//g' | awk '/^[[:alpha:]]/{if (fout) close(fout); fout = $1 "b20cnnrtimajmut.csv"} {print > fout}'
        	for i in $(ls *b20cnnrtimajmut.csv)
        	do
        	        nlines=$(cat $i | wc -l)
        	        if [ $nlines -eq 2 ]
        	        then
        	                percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
        	                if [ $percent -eq 2 ]
        	                then
                	                cat $i | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_below.csv
                	        fi
                	elif [ $nlines -eq 3 ]
                	then
                	        percent=$(cat $i | tail -1 | awk '{if ($1 < 20) print 2}')
                	        if [ $percent -eq 2 ]
                	        then
                	                cat $i | sed -n '1p;3p' | awk 'ORS=NR%2?"\t":"\n"' | awk '{printf "%s %.1f\n", $1,$2}' | awk '{print $1"("$2"%)"}' | sed -z 's/\n/,/g; s/,$/\n/' >> ${sample}_NNRTI_below.csv
                	        fi
                	fi
        	done
        	nnrtibelow=$(cat ${sample}_NNRTI_below.csv | sed -z 's/\n/,/g; s/,$/\n/')
        	rm ${sample}_NNRTI_below.csv *b20cnnrtimajmut.csv
	
	        ## add the below mutations to the json
	        echo -e " \"HIVDR.Mutations.below.20\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"pi.below.20\":\"$pibelow\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nrti.below.20\":\"$nrtibelow\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nnrti.below.20\":\"$nnrtibelow\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"insti.below.20\":\"$instibelow\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ## Create comments
	        touch ${sample}_comments_nnrti.csv ${sample}_comments_nrti.csv ${sample}_comments_pimajor.csv ${sample}_comments_piaccessory.csv ${sample}_comments_instimajor.csv ${sample}_comments_instiaccessory.csv
	
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"NNRTI\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_nnrti.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"NRTI\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_nrti.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Major\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_pimajor.csv
	        sed -z 's/\n/#/g' above20/$original | grep -o "\"commentType\": \"Accessory\".*" | perl -pe 's/"highlightText": \[#.*?#.*?\]//g' | cut -f1 -d"]" | sed -z 's/#/\n/g' | grep "\"text\":" | grep  -v "\"text\": \"[A-Z]\{1,2\}[0-9]\{1,3\}[A-Z]\{1,2\}\"," | cut -f2 -d":" | sort -u | sed 's/^ [ \t]*//; s/[ \t]*$//' | sed 's/,$//' | sed -z 's/\n/|/g; s/|$/|/; s/|$/\n/' | sed 's/"//g' > ${sample}_comments_piaccessory.csv
	
	        ### Add the comments to the json
	        echo -e " \"comments\":{" >> results3/${sample}_lab_dr_report.json
	        ##### Add RT comments
	        echo "==============add rt comments================="
	        echo -e " \"rt\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nnrti\":\"$(cat ${sample}_comments_nnrti.csv)\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"nrti\":\"$(cat ${sample}_comments_nrti.csv)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ###### Add PI comments
	        echo "===========add pi comments==============="
	        echo -e " \"pi\":{" >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"major\":\"$(cat ${sample}_comments_pimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
	        echo -e "   \"accessory\":\"$(cat ${sample}_comments_piaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
	        echo -e " }," >> results3/${sample}_lab_dr_report.json
	
	        ##### Add INSTI comments
	        echo "====================add insti comments============"
	        echo -e " \"insti\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"major\":\"$(cat ${sample}_comments_instimajor.csv)\"," >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"accessory\":\"$(cat ${sample}_comments_instiaccessory.csv)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e " }" >> results3/${sample}_lab_dr_report.json
       		echo -e "}," >> results3/${sample}_lab_dr_report.json
        	echo -e " \"runDetails\":{" >> results3/${sample}_lab_dr_report.json
        	echo -e "   \"amplified\": "true"," >> results3/${sample}_lab_dr_report.json # add amplification
        	echo -e "   \"testDate\":\"$(date +%F" "%T)\"" >> results3/${sample}_lab_dr_report.json
        	echo -e "  }\n}" >> results3/${sample}_lab_dr_report.json
	
	
#		bash prrt.sh
	fi
done
