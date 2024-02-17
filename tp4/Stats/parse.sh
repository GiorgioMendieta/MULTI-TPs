#!/bin/bash

headers="CYCLE,IMISS RATE,DMISS RATE,CPI"

for dir in */; do
    # Set the output CSV file name for each directory
    results="${dir%/}_results.csv"
    
    # Remove output file if it exists
    [ -e "$results" ] && rm "$results"

    # Print the CSV header
    echo $headers > $results

    # Loop through each file in the directory
    for input_file in $dir/*.txt; do

        # Set the output CSV file name based on the input file name
        # %.txt removes the extension
        csv_file="${input_file%.txt}.csv"

        # Remove output file if it exists
        [ -e "$csv_file" ] && rm "$csv_file"

        # Print the CSV header
        echo $headers > $csv_file

        # Use awk to extract the values and append them to the CSV file
        awk '/^[-*]/ {if (/cycle/) cycle=$NF; if (/IMISS RATE/) imr=$NF; if (/DMISS RATE/) dmr=$NF; if (/CPI/) cpi=$NF; if (/^\*\*\* proc/) print cycle "," imr "," dmr "," cpi}' "$input_file" >> "$csv_file"
    
        # Get the last line of the CSV file and append it to the results CSV
        tail -1 "$csv_file" >> "$results"
    done
    echo "CSV files extracted and stored in $dir"
    echo "Results stored in $results"
done