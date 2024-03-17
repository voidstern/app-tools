#! /bin/bash

# Download CSV Files
babelish csv_download --gd-filename="AppTools Strings"
mv ./translations_Strings.csv ./Localizable.csv

# Generate Strings
babelish csv2strings --filename="./Localizable.csv" --langs=English:en German:de French:fr Spanish:es Chinese:zh-Hans Finnish:fi Japanese:ja Korean:ko Italian:it Polish:pl Russian:ru Portugese:pt-BR Arabic:ar --output-dir="./Sources/AppTools/Resources/" --default-lang=en

# Update Swift Files
swiftgen