#!/bin/bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TRACKERSEQ_DIR="$SCRIPT_DIR/../TrackerSeq"
BIN_DIR="$SCRIPT_DIR/../bin"

# Change to the script directory so that artifacts (like plots) are generated in demo/
cd "$SCRIPT_DIR"

# Setup environment
# Only add local bin to PATH if bbduk.sh is not in system PATH
if ! command -v bbduk.sh &> /dev/null; then
    echo "External tools not found in PATH. Using mocks in $BIN_DIR"
    export PATH=$BIN_DIR:$PATH
else
    echo "Using external tools found in PATH"
fi

# Define variables
DATADIR=$SCRIPT_DIR/data
OUTPUT=$SCRIPT_DIR/output
SAMPLE="test_sample"
R1="dummy_R1.fastq"
R2="dummy_R2.fastq"
EXPECT=5

mkdir -p $OUTPUT

echo "Starting pipeline..."

echo "--- Step 1: Preprocessing ---"
# 1_preprocessing.sh datadir output R1 R2 sample expect
bash $TRACKERSEQ_DIR/1_preprocessing.sh $DATADIR $OUTPUT $R1 $R2 $SAMPLE $EXPECT

echo "--- Step 2: Reformat ---"
# 2.1_reformat_caller.sh output fastq sample
# Needs to run from TrackerSeq dir to find python script
pushd $TRACKERSEQ_DIR > /dev/null
bash 2.1_reformat_caller.sh $OUTPUT barcode_extracted.fastq $SAMPLE
popd > /dev/null

echo "--- Step 3: Clustering ---"
# 3_bartender_clustering.sh input_csv output_prefix
# 2_reformat.py produces output/barcode_reformat_for_bartender.csv
bash $TRACKERSEQ_DIR/3_bartender_clustering.sh $OUTPUT/barcode_reformat_for_bartender.csv $OUTPUT/${SAMPLE}_h5_bartender_pcr

echo "--- Step 4: Lineage Analysis ---"
# 4.1_lineage_analysis.sh dir sample n_reads n_umi
# Needs to run from TrackerSeq dir to find python scripts
pushd $TRACKERSEQ_DIR > /dev/null
bash 4.1_lineage_analysis.sh $OUTPUT $SAMPLE 1 1
popd > /dev/null

echo "Pipeline finished successfully."

# Note: Step 6 (R script) is skipped as per instructions.
# Note: bbduk, repair, and bartender_single_com are MOCKED in ./bin/
# Please ensure real tools are installed and tested in a production environment.
# Note: Add the python notebook for Step 6 later.
