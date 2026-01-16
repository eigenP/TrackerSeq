# Note that bartender does not run on all systems -- particularly redhat linux

reformat_csv=$1
output=$2

### 1. clustering lineage barcodes based on umi and NT position information, using Bartender v1.1

# Detect bartender executable
if command -v bartender_single_com &> /dev/null; then
    BARTENDER_CMD=bartender_single_com
elif command -v bartender &> /dev/null; then
    BARTENDER_CMD=bartender
else
    echo "Error: Bartender executable (bartender_single_com or bartender) not found."
    exit 1
fi

$BARTENDER_CMD -f $reformat_csv -o $output -d 5 -z 5
