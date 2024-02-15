# navigating to the folder with raw files
cd ~/synDNA/data
# loop through each pair of .fastq files in the directory
for file1 in *_1.fastq; do
	srr="${file1%_1.fastq}"
    file2="${srr}_2.fastq"
    # check whether the files have been already trimmed
    out1="../results/processed_fastq/${srr}_1_trimmed.fastq"
    out2="../results/processed_fastq/${srr}_2_trimmed.fastq"
    html_out="../results/fastp_reports/${srr}.html"
    json_out="../results/fastp_reports/${srr}.json"
    if [[ -e $out1 && -e $out2 ]]; then
    	echo "$srr has already been processed. Skipping."
    else
    	# perform QC
    	fastp -i "$file1" -I "$file2" -o "$out1" -O "$out2" -h "$html_out" -j "$json_out"
    fi
done
