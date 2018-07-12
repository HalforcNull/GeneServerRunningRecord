#! /bin/bash
# cut adepter all fa file
InputFilesArray=`find . -name "*.fastq.gz"`
OutputFilesArray=`find . -name "*-trimmed.fastq.gz"`

for name in $OutputFilesArray
do
	rm $name
	echo delete $name
done



i=$((1))
for name in $InputFilesArray
do
	cutadapt -a CCCCCCCCCCTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -a GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTTCAGAGCCGTGTAGATCT -e 0.1 -O 5 -m 15 --quality-base=64 -q 15 -o $name-trimmed.fastq.gz $name > $name.cut.log &
done 
wait
echo Done