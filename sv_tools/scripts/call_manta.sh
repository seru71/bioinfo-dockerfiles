bams="$*"

# get reference and results_dir locations
source common_env

manta=/tools/manta-1.3.2/bin/configManta.py 
n_jobs=10
mem_limit=128

timestamp=`get_timestamp`
cmd="$manta --runDir=${results_dir}/manta_${timestamp} --referenceFasta=${reference}"
for bam in $bams; do
  cmd="$cmd --bam $bam"
done

# generate workflow script
workflow_cmd=`$cmd | tail -n1`

# run the workflow
$workflow_cmd -m local -j $n_jobs -g $mem_limit 

