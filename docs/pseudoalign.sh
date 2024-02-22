# navigate to the folder with .fastq
cd ~/synDNA/results/processed_fastq

# loop through each pair of .fastq files in the directory
for file1 in *_1_trimmed.fastq; do
    # check whether the file has already been aligned
    srr="${file1%_1_trimmed.fastq}"
    out="../abunds/${srr}"

    if [ -e "$out/abundance.tsv" ]; then
        echo "Abundance file for $srr already exists. Skipping."
    else
        file2="${srr}_2_trimmed.fastq"

        # create the output directory if it doesn't exist
        mkdir -p "$out"

        # perform pseudoalignment
        kallisto quant -i ../../docs/synDNA.idx -o "$out" "$file1" "$file2"
    fi
done
