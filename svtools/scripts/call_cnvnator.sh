#
# single sample CNVnator calling
# Pawel Sztromwasser, 03/2018
#

bam=$1

# get reference and results_dir locations
source common_env

chromosomes=/gen/reference/b37/chromosomes
cnvnator=cnvnator

timestamp=`get_timestamp`
workdir=${results_dir}/cnvnator_$timestamp
if [ ! -d "$workdir" ]; then
	mkdir $workdir
fi

rootf=${workdir}/`basename $bam`.cnvnator.root
err_file=${workdir}/`basename $bam`.cnvnator.root.err
calls_file=${workdir}/`basename $bam`.sv_cnvnator.calls
bed_file=${workdir}/`basename $bam`.sv_cnvnator.bed

BIN_SIZE=100


#export ROOTSYS=/usr

echo 'Step1:' > ${err_file}
$cnvnator -root $rootf \
	-genome $reference \
	-tree $bam >> ${err_file} 2>&1

echo 'Step2:' >> ${err_file}
$cnvnator -root $rootf \
	-his $BIN_SIZE -d $chromosomes >> ${err_file} 2>&1

echo 'Step3:' >> ${err_file}
$cnvnator -root $rootf \
	-stat $BIN_SIZE >> ${err_file} 2>&1

echo 'Step4:' >> ${err_file}
$cnvnator -root $rootf \
	-partition $BIN_SIZE >> ${err_file} 2>&1

echo 'Step5:' >> ${err_file}
$cnvnator -root $rootf \
	-call $BIN_SIZE > ${calls_file} 2>>${err_file}

echo 'Step6:' >> ${err_file}

for reg in `cut -f2 ${calls_file}`; do 
	samtools view $bam $reg | awk '{sum+=$5}END{if (NR==0) {print "NA"} else {print sum/NR}}'
done > ${calls_file}.mqs

sed 's/:/\t/g' ${calls_file} \
	| sed -E 's/([0-9])-([1-9])/\1\t\2/g' \
	| sed 's/deletion/DEL/g' | sed 's/duplication/DUP/g' \
	| awk '{OFS="\t"; print $2,$3,$4,$1,$5,$6,$7,$8,$9,$10,$11}' \
	| paste - ${calls_file}.mqs > ${bed_file}

echo 'Cleaning up...' >> ${err_file}
if [ -s "${calls_file}" ]; then
	rm $rootf
fi



