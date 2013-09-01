{-# LANGUAGE DataKinds #-}
module JavaScript.Require (defineModule, define) where

import Data.Default
import Language.Sunroof

define :: (SunroofArgument a, Sunroof b) 
       => JSFunction (JSArray JSString, JSFunction a b) JSObject
define = fun "define"

defineModule :: (SunroofArgument a, Sunroof b) 
             => String 
             -> [String] 
             -> (a -> JS A b)
             -> IO String
defineModule moduleName moduleDependencies moduleFunction = 
  sunroofCompileJSA def moduleName $ do
    jsModuleDependencies <- array moduleDependencies
    jsModuleFunction     <- function moduleFunction
    define `apply` (jsModuleDependencies, jsModuleFunction)

