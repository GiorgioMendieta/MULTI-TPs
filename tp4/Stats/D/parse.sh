#!/bin/bash

# Set the input directory
input_dir="./D"

# Loop through each file in the directory
for input_file in ./*.txt; do

    # Set the output CSV file name based on the input file name
    csv_file="${input_file%.txt}.csv"

    # Remove output file if it exists
    [ -e "$csv_file" ] && rm "$csv_file"

    # Print the CSV header
    echo "CYCLE,IMISS RATE,DMISS RATE,CPI" > $csv_file

    # Use awk to extract the values and append them to the CSV file
    awk '/^[-*]/ {if (/cycle/) cycle=$NF; if (/IMISS RATE/) imr=$NF; if (/DMISS RATE/) dmr=$NF; if (/CPI/) cpi=$NF; if (/^\*\*\* proc/) print cycle "," imr "," dmr "," cpi}' "$input_file" >> "$csv_file"

done

echo "Values extracted and stored in $csv_file"
