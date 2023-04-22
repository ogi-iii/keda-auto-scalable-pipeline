#!/bin/bash

if [ ! -d kafka-streams-pipeline/ ]; then
    git clone https://github.com/ogi-iii/kafka-streams-pipeline.git
fi
./kafka-streams-pipeline/demo/scripts/delete-datagen.sh

echo "Generating source data was stopped."
