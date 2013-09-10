module JavaScript.Backbone.Events where

import Language.Sunroof

-----------------------------------------------------------------------------------------
trigger :: (Sunroof a, SunroofArgument b) => b -> a -> JS t ()
trigger = invoke "trigger"
