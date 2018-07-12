#!/bin/bash

NTArray_1=`find . -name "GSM*_C1_R*_1.fq.gz"`
NTArray_2=`find . -name "GSM*_C1_R*_2.fq.gz"`
TRArray_1=`find . -name "GSM*_C2_R*_1.fq.gz"`
TRArray_2=`find . -name "GSM*_C2_R*_1.fq.gz"`

ntsorted1=$(sort <<<"${NTArray_1[*]}")
ntsorted2=$(sort <<<"${NTArray_2[*]}")
trsorted1=$(sort <<<"${TRArray_1[*]}")
trsorted2=$(sort <<<"${TRArray_2[*]}")


i=$((1))
for name in $ntsorted1 
do 
	echo "NT-R_"$i": " $name
	i=$((i+1))
done


i=$((1))
for name in $ntsorted2
do 
	echo "NT-R_"$i": " $name
	i=$((i+1))
done

i=$((1))
for name in $trsorted1
do 
	echo "TR-R_"$i": " $name
	i=$((i+1))
done

i=$((1))
for name in $trsorted2
do 
	echo "TR-R_"$i": " $name
	i=$((i+1))
done


repCount=$((i))


echo "Step 1: Tophat"
phaseStart=$(date +%s)

i=$((1))
for ((i=1;i<=$repCount;i++)) 
do
	sfileStart=$(date +%s)
	tophat -p 8 -G genes.gtf -o C1_R$i\_thout genome ${ntsorted1[i]} ${ntsorted2[i]}
	sfileEnd=$(date +%s)
	secs=$(($sfileEnd - $sfileStart))
	echo $NTArray_1[i] " and 2 has been processed"
	echo "Time Consume for this file: " 
	printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
done

i=$((1))
for ((i=1;i<=$repCount;i++)) 
do
	sfileStart=$(date +%s)
	tophat -p 8 -G genes.gtf -o C2_R$i\_thout genome ${trsorted1[i]} ${trsorted2[i]}
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








