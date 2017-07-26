#!/bin/bash
docker build -t paper/builder .
mkdir -p out
docker run --rm -t -i -e DISPLAY -v $PWD:/out:rw paper/builder
