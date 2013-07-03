# This is my README



Setup
=====

On Debian and Ubuntu systems, repository packages haskell-platform and
cabal-install should do the trick.

Cabal manages haskell packages.

cabal install cabal-dev

This installs some stuff locally (i.e. no root privileges needed) to
$(HOME)/.cabal/

add $(HOME)/.cabal/bin to the path and run

# pulls in haskell dependencies
cabal-dev install --only-dependencies
# compiles haskell code and starts development web server @ localhost:8000
# (well actually 0.0.0.0:8000)
./reload.sh

Then the script ./refresh.sh will recompile the haskell code and start
the development webserver on localhost:8000
