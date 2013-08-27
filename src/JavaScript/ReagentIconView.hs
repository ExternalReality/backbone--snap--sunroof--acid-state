{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}

module JavaScript.ReagentIconView (reagentIconViewJS) where

import           Data.Default
import           JavaScript.Backbone.Events
import           JavaScript.Backbone.View
import           Language.Sunroof.JS.Map
------------------------------------------------------------------------------
import           JavaScript.Mustache        hiding (render)
import           Language.Sunroof


------------------------------------------------------------------------------
reagentIconViewJS :: IO String
reagentIconViewJS = sunroofCompileJSA def 
                                      "ReagentIconView" 
                                      (function $ uncurry newReagentIconView)

------------------------------------------------------------------------------
newReagentIconView :: JSObject -> JSString -> JS t (JSBackboneView NotRendered)
newReagentIconView _model template = do
  reagentView     <- new "Object" () >>= apply JavaScript.Backbone.View.extend
  eventsMap       <- newMap
  onClickCallback <- iconClicked reagentView
  bindings        <- templateBindings _model
  renderFunction  <- render' reagentView template bindings

  insert ("click" :: JSString) onClickCallback eventsMap

  reagentView # model  := _model
  reagentView # render := renderFunction
  reagentView # events := eventsMap
  return reagentView

------------------------------------------------------------------------------
iconClicked :: JSBackboneView a -> JS t (JSFunction () ())
iconClicked view =
  function $ \ _ -> do
    let ob = obj view
    let _model = ob ! model
    ob `trigger` ("icon-clicked" :: JSString, _model)

------------------------------------------------------------------------------
templateBindings :: JSObject -> JS t JSTemplateBindings
templateBindings _ = newMap

------------------------------------------------------------------------------
render' :: JSBackboneView a
        -> JSString
        -> JSMap JSString JSObject
        -> JS t (JSFunction () (JSBackboneView Rendered))
render' view template bindings =
  function $ \_ -> do
    renderTemplate view template bindings
    return $ JSBackboneView (obj view)
