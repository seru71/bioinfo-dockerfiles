#
# Run SV2 on a fixed set of SV variant files for the sample. 
# Input is a set of BAM files, named following pattern: <PATH>/<SAMPLE>.bam
# Single-sample SV call files produced by CNVnator and ERDS are created from fixed paths and <SAMPLE> identifiers.
#
# by Pawel Sztromwasser, 4/2018
#


source ./common_env

bams=("$@")

sv2=sv2
ped=/gen/projects/RCAD_WGS/RCAD.ped
snv=/gen/projects/RCAD_WGS/results/all_samples.fb1.1p.vcf.gz


for i in ${!bams[@]}; do
#  samples[$i]=`basename ${bams[$i]} | sed 's/.bam//'`
  sample=`basename ${bams[$i]} | sed 's/.bam//'`
  erds_vcfs=/gen/projects/RCAD_WGS/results/${sample}/${sample}.sv_erds.vcf
  cnvnator_bed=${results_dir}/cnvnator_2018-03-23T000000/${sample}.bam.sv_cnvnator.bed
done

lumpy_vcf=${results_dir}/lumpy_2018-04-17T100600/all_samples.sv.vcf.gz
manta_vcf=${results_dir}/manta_2018-03-21T083000/results/variants/diploidSV.vcf.gz


timestamp=`get_timestamp`
out_prefix=${results_dir}/sv2_${timestamp}
if [ ! -d ${out_prefix} ]; then
	mkdir  ${out_prefix}
fi

cd ${out_prefix}
${sv2} -i ${bams[@]} -v ${manta_vcf} -v ${lumpy_vcf} -v ${erds_vcfs[@]} -b ${cnvnator_beds[@]} -snv ${snv} -p ${ped} -o all_samples
