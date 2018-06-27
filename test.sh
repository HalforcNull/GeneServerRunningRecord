#!/bin/bash


# array=`find . -name "*.test"`
# i=1

# for name in $array 
# do 
# 	echo $name
# 	echo $i
# 	i=$i+1
# done

repCount=5


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

