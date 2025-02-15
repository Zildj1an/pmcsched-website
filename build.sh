#!/bin/bash
documents=(
    './index.md index'
)

ndocs=${#documents[@]}

selected_document=$1
selected_document_base=$(basename "$selected_document" .md)

if [ "${selected_document}" != "" ]; then
    filter_on=1
else
    filter_on=0
fi

echo "Selected document: ${selected_document}"
echo "Selected document base: ${selected_document_base}"
echo "Filter on: ${filter_on}"
echo "Number of documents: ${ndocs}"

for (( i=0 ; $i<$ndocs ; i++ ))
do
    items=(${documents[$i]})
    source_file=${items[0]}
    target_file1=${items[1]}.html
    target_file2=${items[1]}.pdf

    echo "Processing document ${i}: ${source_file}"
    echo "Target HTML: ${target_file1}"
    echo "Target PDF: ${target_file2}"

    if [ ${filter_on} -eq 1 ] && [ "${selected_document_base}" != "${items[1]}" ]; then
        echo "Skipping ${source_file} because it does not match the selected document."
        continue
    fi

    echo "Converting ${source_file} to ${target_file1}"
    pandoc ${source_file} -N --self-contained --template pandoc-templates/idocs3.html-template.html --toc --highlight-style tango -o ${target_file1}
    if [ $? -ne 0 ]; then
        echo "Error converting ${source_file} to HTML"
    fi

    if [ ${source_file} != '../index.md' ]; then
        echo "Converting ${source_file} to ${target_file2}"
        pandoc ${source_file} -N --toc --highlight-style tango -o ${target_file2}
        if [ $? -ne 0 ]; then
            echo "Error converting ${source_file} to PDF"
        fi
    fi
done

