#!/bin/bash
source .hsenv/bin/activate
cabal install -fdevelopment
.hsenv/cabal/bin/potion-soap 
