#!/bin/bash
#
# Runs multisample speedseq sv. Assumes that:
# 1. mapping has been done following speedseq's pipeline
# 2. split- and discordant read bams are in the same location as tha main bam file 
# 3. names of the above bams are $SAMPLE.[splitters|discordants].bam
#

bams="$*"

# get reference and results_dir locations
source common_env

speedseq=speedseq
exclude_bed=/tools/speedseq/annotations/ceph18.b37.lumpy.exclude.2014-01-15.bed
n_threads=20

timestamp=`get_timestamp`
if [ ! -d ${results_dir}/lumpy_${timestamp} ]; then
         mkdir ${results_dir}/lumpy_${timestamp}
fi

# parse args and prepare input to speedseq
BAMS_ARG=`echo $bams | sed 's/ /,/g'`
SPLITTERS_ARG=`echo $BAMS_ARG | sed 's/.bam/.splitters.bam/g'`
DISCORDANTS_ARG=`echo $BAMS_ARG | sed 's/.bam/.discordants.bam/g'`


output_prefix=${results_dir}/lumpy_${timestamp}/all_samples
${speedseq} sv -o ${output_prefix} -R ${reference} -x ${exclude_bed} -g -t $n_threads \
	-B ${BAMS_ARG} -S ${SPLITTERS_ARG} -D ${DISCORDANTS_ARG} &> ${output_prefix}.sv.err


