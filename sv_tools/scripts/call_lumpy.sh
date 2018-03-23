#!/bin/bash
#
# Runs multisample speedseq sv. Assumes mapping has been done with followin speedseq's pipeline
# and split- and discordant reads are in $SAMPLE.[splitter|discordants].bam
#

bams="$*"

# get reference and results_dir locations
source common_env

speedseq=speedseq
exclude_bed=/tools/speedseq/annotations/ceph18.b37.lumpy.exclude.2014-01-15.bed

timestamp=`date --iso-8601=minutes`
if [ ! -d ${results_dir}/speedseq_${timestamp} ]; then
         mkdir ${results_dir}/speedseq_${timestamp}
fi

# parse args and prepare input to speedseq
BAMS_ARG=`echo $bams | sed 's//,/'`
SPLITTERS_ARG=`echo $BAMS_ARG | sed 's/.bam/.splitters.bam/g'`
DISCORDANTS_ARG=`echo $BAMS_ARG | sed 's/.bam/.discordants.bam/g'`


output_prefix=${out_dir}/speedseq_${timestamp}/all_samples.sv.vcf.gz
${speedseq} sv -o ${output_prefix}/all_samples -R ${reference} -x ${exclude_bed} -g -t 30 \
	-B ${BAMS_ARG} -S ${SPLITTERS_ARG} -D ${DISCORDANTS_ARG}  &> ${output_prefix}/all_samples.sv.err


