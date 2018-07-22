#! /bin/bash
# cut adepter all fa file

OutputFilesArray=`find . -name "*-trimmed.fastq.gz"`

for name in $OutputFilesArray
do
	rm $name
	echo delete $name
done

OutputFilesArray=`find . -name "*.cut.log"`

for name in $OutputFilesArray
do
	rm $name
	echo delete $name
done


InputFilesArray_1=`find . -name "*R1_001_fastq.gz"`
i=$((1))
for name in $InputFilesArray
do
	nameSec=${$name/R1_001/R2_001}
	cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT -o $name-trimmed.fastq.gz -p $nameSec-trimmed.fastq.gz $name $nameSec > $name.cut.log &
done 
wait
echo Done