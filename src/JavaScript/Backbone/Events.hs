module JavaScript.Backbone.Events where

import Language.Sunroof

-----------------------------------------------------------------------------------------
trigger :: (Sunroof a, SunroofArgument b) => a -> b -> JS t ()
trigger a b = invoke "trigger" b a 
