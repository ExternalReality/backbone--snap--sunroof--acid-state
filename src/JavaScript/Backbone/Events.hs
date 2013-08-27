module JavaScript.Backbone.Events where

import Language.Sunroof

-----------------------------------------------------------------------------------------
trigger :: SunroofArgument a => JSObject -> a -> JS t ()
trigger obj a = invoke "trigger" a obj 
