#!/bin/bash

for file in *.json; do
    mv -- "$file" "${file%.json}.tf"
done