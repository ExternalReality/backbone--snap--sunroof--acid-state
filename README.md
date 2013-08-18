B1;2802;0cB1;2802;0c# Developer Setup Instructions

On Debian and Ubuntu systems, repository packages 

    :::bash
      apt-get install haskell-platform cabal-install 

should do the trick.

Cabal manages haskell packages, kind of like pip for python I guess.

    :::bash
      # update the haskell repository cache
      cabal update
      # install cabal-dev, for managing haskell projects
      # I think this is no longer necessary
      cabal install cabal-dev
      cabal install hsenv
      # run hsenv, which creates a .hsenv folder where the haskell
      # virtual environment is stored for this application
      hsenv

This installs some stuff locally (i.e. no root privileges needed) to
$(HOME)/.cabal/

    :::bash
       add $(HOME)/.cabal/bin to the path and run
       #pulls in haskell dependencies
       cabal-dev install --only-dependencies
       #compiles haskell code and starts development web server @ localhost:8000 (well actually 0.0.0.0:8000)
       ./reload.sh

Then the script ./reload.sh will recompile the haskell code and start
the development webserver on localhost:8000

The haskell source code lives in

    :::bash
	src/

and the client-side code (javascript) lives in:

    :::bash
	public/js/


