dir=$1
sample=$2
n_reads=$3
n_umi=$4

outdir=${dir}/TS_lineage_analysis_reads${n_reads}_umi${n_umi}
mkdir -p ${outdir}

python 4_LARRY_Klein.py $dir/${sample}_whitelist.txt $dir/barcode_reformat.fa $dir/${sample}_h5_bartender_pcr_barcode.csv $dir/${sample}_h5_bartender_pcr_cluster.csv $outdir/${sample}_matrix $dir/${sample} $n_reads $n_umi $outdir/${sample}

python 5_cellbc_assign.py $outdir/${sample}_matrix $dir/${sample}_whitelist.txt $outdir/${sample}_sparse_matrix
