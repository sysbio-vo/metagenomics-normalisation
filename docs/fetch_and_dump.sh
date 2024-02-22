# Specify the path to the file containing SRA IDs
sraIDs_file="$HOME/synDNA/docs/sraIDs.txt"

# Change to the data folder
cd ~/synDNA/data

# Loop through each SRA ID in the file
while IFS= read -r sraID; do
    # Check if FASTQ files already exist for the current SRA ID
    if [[ -e "${sraID}_1.fastq" && -e "${sraID}_2.fastq" ]]; then
        echo "FASTQ files for $sraID already exist. Skipping."
    else
        # Download the SRA data
        echo "Fetching $sraID"
        prefetch $sraID

        # Convert the SRA data to FASTQ format
        echo "Dumping $sraID"
        fastq-dump --split-files $sraID

        # Remove the downloaded SRA data
        echo "Removing $sraID"
        rm -r $sraID
    fi
done < "$sraIDs_file"
