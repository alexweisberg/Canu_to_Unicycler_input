#!/bin/bash
#inputgraph="DNGQU0102_10.contigs.gfa"
#inputfasta="DNGQU0102_10.contigs.fasta"
inputgraph=$1
inputfasta=$2
declare -A seqs
IFS=$'\n'
singlelinefasta=`awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $inputfasta`
for line in `echo -e "$singlelinefasta"`; do
	if [ "${line:0:1}" == ">" ]; then
		header=`echo -e "$line" | sed 's/>//g;s/ .*//g'`
	else
		seqs[$header]=$line
	fi
done

while read line; do
	linetype=`echo -e "$line" | cut -f 1`
	if [[ $linetype == "S" ]]; then
		seqid=`echo -e "$line" | cut -f 2`
		curseq=${seqs[$seqid]}
		linepostfix==`echo -e "$line" | cut -f 4- | sed 's/=//g;s/=//g'`
		echo -e "S	$seqid	$curseq	$linepostfix"
	elif [[ $linetype == "L" ]]; then
		oldcigar=`echo -e "$line" | cut -f 6`
		separatedcigar=`echo -e "$oldcigar" | grep -Eo '[0-9]+[[:alpha:]]' | sed 's/\([0-9]\+\)/\1\t/g'`
		overlap=0
		for cigar in `echo -e "$separatedcigar"`; do
			cigardigit=`echo -e "$cigar" | cut -f 1`
			cigarcode=`echo -e "$cigar" | cut -f 2`
			if [[ $cigarcode == "M" ]]; then
				overlap=$((overlap + cigardigit))
			elif [[ $cigarcode == "I" ]]; then
				overlap=$((overlap + cigardigit))
			elif [[ $cigarcode == "D" ]]; then
				overlap=$((overlap - cigardigit))
			else
				echo "other cigar type shouldn't get here"
			fi
		done
		overlap+="M"
		lineprefix=`echo -e "$line" | cut -f 1-5`
		#linepostfix=`echo -e "$line" | cut -f 7-`
		echo -e "$lineprefix	$overlap"
	else
		echo -e "$line"
	fi
done < $inputgraph
