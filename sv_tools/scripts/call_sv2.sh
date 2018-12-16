#
# Run SV2 on a fixed set of SV variant files for the sample. Input is a BAM file
#
# by Pawel Sztromwasser, 3/2018
#


source ./common_env

bam=$1

sv2=sv2
ped=/gen/projects/RCAD_WGS/RCAD.ped
snv=/gen/projects/RCAD_WGS/results/all_samples.fb1.1p.vcf.gz

sample=`basename $bam | sed 's/.bam//'`
lumpy_vcf=/gen/projects/RCAD_WGS/results/${sample}/${sample}.sv_lumpy.vcf.gz
erds_vcf=/gen/projects/RCAD_WGS/results/${sample}/${sample}.sv_erds.vcf
cnvnator_bed=/gen/projects/RCAD_WGS/SV_docker/results/cnvnator_2018-03-23T000000/${sample}.bam.sv_cnvnator.bed

timestamp=`get_timestamp`
out_prefix=${results_dir}/sv2
if [ ! -d ${out_prefix} ]; then
	mkdir  ${out_prefix}
fi

cd ${out_prefix}
${sv2} -i ${bam} -v ${lumpy_vcf} -v ${erds_vcf} -b ${cnvnator_bed} -snv ${snv} -p ${ped} -o ${sample}
