{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}

module JavaScript.ReagentIconView (reagentIconViewModule) where

import Data.Default
import Language.Sunroof.JS.Map
import Language.Sunroof
------------------------------------------------------------------------------
import JavaScript.Backbone.Events
import JavaScript.Backbone.View
import JavaScript.Mustache        hiding (render)
import JavaScript.Require

------------------------------------------------------------------------------
reagentIconViewModule :: IO String
reagentIconViewModule =
  sunroofCompileJSA def "ReagentIconViewModule" $ do
       requireArray <- array [ "backbone"
                             , "mustache"
                             , "models/reagent-model"
                             , "text!/../templates/reagent_icon_template.html"
                             , "backbone-extentions/view-utilities" :: String                             
                             ]
       moduleFunction <- function reagentIconView
       define `apply` (requireArray, moduleFunction)

------------------------------------------------------------------------------
reagentIconView :: (JSObject, JSObject, JSObject, JSString, JSObject, JSObject) -> JS t (JSBackboneView NotRendered)
reagentIconView (backbone, templateRenderer, _model, template, _, _) = do
  reagentView     <- viewObject
  eventsMap       <- newMap
  onClickCallback <- iconClicked reagentView
  bindings        <- templateBindings _model
  renderFunction  <- render' templateRenderer template bindings

  insert ("click" :: JSString) onClickCallback eventsMap

  reagentView # model  := _model
  reagentView # render := renderFunction
  reagentView # events := eventsMap
  (`extend` (backbone ! view)) (obj reagentView)

------------------------------------------------------------------------------
iconClicked :: JSBackboneView a -> JS t (JSFunction () ())
iconClicked _view =
  function $ \ _ -> do
    let _model = _view ! model
    _view `trigger` ("icon-clicked" :: JSString, _model)

------------------------------------------------------------------------------
templateBindings :: JSObject -> JS t JSTemplateBindings
templateBindings _ = newMap

------------------------------------------------------------------------------
render' :: JSObject
        -> JSString
        -> JSMap JSString JSObject
        -> JS t (JSFunction () (JSBackboneView Rendered))
render' templateRenderer template bindings =  
  function $ \_ -> do
    renderTemplate (JSBackboneView this) templateRenderer template bindings
    return $ JSBackboneView this
           
