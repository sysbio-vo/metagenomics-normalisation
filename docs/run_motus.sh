#!/bin/bash

fastq_dir="/home/lbombini/synDNA/results/processed_fastq"
abunds_dir="/home/lbombini/synDNA/results/motus_abunds"
run2SampleName="/home/lbombini/synDNA/docs/run2SampleName.csv"

# Check if the file exists
if [ -f "$run2SampleName" ]; then
    echo "run2SampleName exists: $run2SampleName"
else
    echo "run2SampleName does not exist: $run2SampleName"
fi

# Check if directories exist
if [ -d "$fastq_dir" ]; then
    echo "Fastq directory exists: $fastq_dir"
else
    echo "Fastq directory does not exist: $fastq_dir"
fi

if [ -d "$abunds_dir" ]; then
    echo "Abunds directory exists: $abunds_dir"
else
    echo "Abunds directory does not exist: $abunds_dir"
fi

# loop through each pair of .fastq files in the directory
for run1 in "$fastq_dir"/*_1_trimmed.fastq; do
	srr=$(basename "$run1" | cut -d'_' -f1)
    run2="${run1/_1_/_2_}"
    sample_name=$(awk -F ',' -v srr="$srr" '$1 == srr {print $3}' "$run2SampleName")
    
    # check whether run2 exists
    if [[ ! -e $run2 ]]; then
        echo "$run2 is missing. Skipping."
        continue
    fi
    
    # check whether the files have been already profiled
    out="${abunds_dir}/${srr}.motus"
    if [[ -e $out ]]; then
    	echo "$srr has already been processed. Skipping."
    else
    	# perform motus profile
        echo "Running motus profiler on $srr (sample name: $sample_name)"
        motus profile -f $run1 -r $run2 -o $out -n $sample_name
    fi
    echo " * * * "
    echo ""
done

echo "Successfully sone executing run_motus.sh"
