#
# Run MetaSV on a fixed set of SV variant files for the sample. Input is a BAM file
#
# by Pawel Sztromwasser, 4/2018
#


source ./common_env

bam=$1

#tool paths
metasv=run_metasv.py
spades=spades
age_align=age_align


#ped=/gen/projects/RCAD_WGS/RCAD.ped
#snv=/gen/projects/RCAD_WGS/results/all_samples.fb1.1p.vcf.gz

sample=`basename $bam | sed 's/.bam//'`
lumpy_vcf=${results_dir}/lumpy_2018-04-17T100600/all_samples.sv.vcf.gz
manta_vcf=${results_dir}/manta_2018-03-21T083000/results/variants/diploidSV.vcf.gz
#cnvnator_native=${results_dir}/cnvnator_2018-03-23T000000/${sample}.bam.sv_cnvnator.calls

timestamp=`get_timestamp`
out_prefix=${results_dir}/metasv_${timestamp}
if [ ! -d ${out_prefix} ]; then
	mkdir  ${out_prefix}
fi

${metasv} --reference ${reference} \
	--manta_vcf ${manta_vcf} \
	--lumpy_vcf ${lumpy_vcf} \
	--sample ${sample} --bam ${bam} \
	--spades ${spades} --age ${age_align} \
	--num_threads 15 --workdir ${out_prefix}/work --outdir ${out_prefix} \
	--min_support_ins 2 --max_ins_intervals 500000 --isize_mean 500 --isize_sd 150 --boost_sc
#       --breakdancer_native breakdancer.out \
#       --breakseq_native breakseq.gff \
#       --cnvnator_native cnvnator.call \
#       --pindel_native pindel_D pindel_LI pindel_SI pindel_TD pindel_INV \

