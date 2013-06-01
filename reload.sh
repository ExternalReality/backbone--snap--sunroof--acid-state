#!/bin/bash

rm -rf ./snaplets
cabal-dev install -fdevelopment
cabal-dev/bin/potion-soap 
