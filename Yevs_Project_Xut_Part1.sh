#!/bin/bash
# MCF7 (NT) vs MCF7 (TR)

echo "Start running script : Yevs_Project_Xut_Part1.sh"
echo "This script generate diff_out data to compare MCF7(NT) vs MCF7(TR)"

NTArray=`find . -name "*MCF7-NT*.fastq"`
TRArray=`find . -name "*MCF7-TR*.fastq"`

ntsorted=$(sort <<<"${NTArray[*]}")
trsorted=$(sort <<<"${TRArray[*]}")

i=$((1))
for name in $ntsorted 
do 
	echo "NT-R_"$i": " $name
	i=$((i+1))
done

i=$((1))
for name in $trsorted 
do 
	echo "TR-R_"$i": " $name
	i=$((i+1))
done

repCount=$((i))
# nohup tophat -p 8 -G genes.gtf -o Sample_4_thout genome Sample_4_184A1-TR1/4_184A1-TR1_S4_L001_R1_001.fastq.gz Sample_4_184A1-TR1/4_184A1-TR1_S4_L001_R2_001.fastq.gz > 4.nohup &

echo "Step 1: Tophat"
phaseStart=$(date +%s)

i=$((1))
for name in $ntsorted 
do
	sfileStart=$(date +%s)
	tophat -p 8 -G genes.gtf -o C1_R$i\_thout genome name
	i=$((i+1))
	sfileEnd=$(date +%s)
	secs=$(($sfileEnd - $sfileStart))
	echo name "has been processed"
	echo "Time Consume for this file: " 
	printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
done

i=$((1))
for name in $trsorted 
do
	sfileStart=$(date +%s)
	tophat -p 8 -G genes.gtf -o C2_R$i\_thout genome name
	i=$((i+1))
	sfileEnd=$(date +%s)
	secs=$(($sfileEnd - $sfileStart))
	echo name "has been processed"
	echo "Time Consume for this file: " 
	printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
done

phaseEnd=$(date +%s)
secs=$(($phaseStart - $phaseEnd))
echo "Step 1: Tophat. Done."
echo "Total time consume of tophat: "
printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))


echo "Step 2: Cufflinks"
phaseStart=$(date +%s)

for ((i=1;i<=$repCount;i++)) 
do
	sfileStart=$(date +%s)
	cufflinks -p 8 -o C1_R$i\_clout C1_R$i\_thout/accepted_hits.bam
	sfileEnd=$(date +%s)
	secs=$(($sfileEnd - $sfileStart))echo C1_R$i\_clout "has been processed"
	echo "Time Consume for this file: " 
	printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
done

for ((i=1;i<=$repCount;i++)) 
do
	sfileStart=$(date +%s)
	cufflinks -p 8 -o C2_R$i\_clout C2_R$i\_thout/accepted_hits.bam
	sfileEnd=$(date +%s)
	secs=$(($sfileEnd - $sfileStart))
	echo C2_R$i\_clout "has been processed"
	echo "Time Consume for this file: " 
	printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
done

phaseEnd=$(date +%s)
secs=$(($phaseStart - $phaseEnd))
echo "Step 2: cufflinks. Done."
echo "Total time consume of tophat: "
printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

echo "Step 3: Create assembly file"

if [ -f "assemblies.txt" ]
then
	rm assemblies.txt
fi
touch assemblies.txt
for ((i=1;i<=$repCount;i++)) 
do
	echo "./C1_R"$i"_clout/transcripts.gtf" >> assemblies.txt
	echo "./C2_R"$i"_clout/transcripts.gtf" >> assemblies.txt
done

echo "Step 3: Create assembly file. Done."


echo "Step 4: Cuffmerge"
phaseStart=$(date +%s)

cuffmerge -g genes.gtf -s genome.fa -p 8 assemblies.txt

phaseEnd=$(date +%s)
secs=$(($phaseStart - $phaseEnd))
echo "Step 4: Cuffmerge. Done."
echo "Total time consume of tophat: "
printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))


echo "Step 5: Cuffdiff"
phaseStart=$(date +%s)

c1flist=""
c2flist=""
for ((i=1;i<=$repCount;i++)) 
do
	if [ ! $i == 1 ]
	then
		c1flist=$c1flist","
		c2flist=$c2flist","
	fi
	c1flist=$c1flist"./C1_R"$i"_thout/accepted_hits.bam"
	c2flist=$c2flist"./C2_R"$i"_thout/accepted_hits.bam"
done

cuffdiff -o diff_out -b genome.fa -p 8 -L C1,C2 -u merged_asm/merged.gtf $c1flist $c2flist

phaseEnd=$(date +%s)
secs=$(($phaseStart - $phaseEnd))
echo "Step 4: Cuffmerge. Done."
echo "Total time consume of tophat: "
printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
