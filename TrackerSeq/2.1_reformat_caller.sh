
output=$1
fastq=$2
sample=$3

python 2_reformat.py $output/$fastq $output/barcode_reformat $sample
