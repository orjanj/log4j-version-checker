#!/bin/bash
tmp_dir=/tmp/log4j

# inspect manifest version of log4j files
if [ -z $1 ]; then
    echo "Usage: ./${0} <directory to search for files in>"
    exit 1
else
    search_dir=$1
fi


# check if tmp dir exits - if not, create it
if [ ! -d "${tmp_dir}" ]; then
    if mkdir -p /tmp/log4j; then
        echo "Successfully created tmp dir for log4j version checker."
    else
        echo "Error: Unable to create directory ${tmp_dir}."
        exit 1
    fi
else
    echo "Temporary directory ${tmp_dir} exists."
fi

# crawl through each matching jar file and check version
for file in $(find $search_dir -name "*log4j*.jar" -type f)
do
    if unzip -q -d $tmp_dir $file; then
        echo "---------- VERSION INFORMATION ----------"
        manifest_file="${tmp_dir}/META-INF/MANIFEST.MF"
        if [ -f $manifest_file ]; then
            echo "Filename: ${file}"
            egrep -i 'Specification-(Title|Vendor|Version)' $manifest_file
            rm -r $tmp_dir/* # remove contents from tmp dir
        else
            echo "Error: Manifest file not found: ${manifest_file}"
        fi
    else
        echo "Error: Unable to extract ${file} to ${tmp_dir}."
    fi
done
