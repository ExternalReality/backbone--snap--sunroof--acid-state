{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}

module JavaScript.ReagentIconView (reagentIconViewModule) where

import Data.Boolean
import Data.Default
import Language.Sunroof
import Language.Sunroof.JS.Map
------------------------------------------------------------------------------
import JavaScript.Backbone
import JavaScript.Backbone.Events
import JavaScript.Backbone.View
import JavaScript.Mustache        hiding (render)
import JavaScript.ReagentModel
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
reagentIconView :: (Backbone, JSObject, ReagentModel, JSString, JSObject, JSObject)
                -> JS t (JSBackboneView NotRendered)
reagentIconView (backbone, mustache, _model, template, _, _) = do
  reagentView        <- viewObject
  eventsMap          <- newMap
  onClickCallback    <- iconClicked
  bindingsFunction   <- templateBindings
  renderFunction     <- render' mustache template
  initializeFunction <- initialize'

  insert ("click" :: JSString) onClickCallback eventsMap

  reagentView # events     := eventsMap
  reagentView # initialize := initializeFunction
  reagentView # bindings   := bindingsFunction
  reagentView # render     := renderFunction
  extendView backbone (obj reagentView)

------------------------------------------------------------------------------
initialize' :: JS t (JSFunction ReagentModel ())
initialize' = function $ \reagentModel -> this # model := reagentModel;

------------------------------------------------------------------------------
templateBindings :: JS t (JSFunction () TemplateBindings)
templateBindings = function $ \_ -> do
  let model' = this ! model
  bindings  <- new "Object" ()
  name'     <- name model'
  imageUrl' <- imageUrl model'

  bindings # "reagentName"      := name'
  bindings # "imageUrl"         := imageUrl'
  bindings # "imageNotFoundUrl" := ("images/reagent-icons/unavailable/imageNotFoundUrl" :: JSString)
  bindings # "isImageUndefined" := (true :: JSBool);
  return bindings

------------------------------------------------------------------------------
render' :: JSObject
        -> JSString
        -> JS t (JSFunction () (JSBackboneView Rendered))
render' mustache template =
  function $ \_ -> do
    bindings' <- (this ! bindings) $$ ()
    renderTemplate (JSBackboneView this) mustache template bindings'
    return $ JSBackboneView this

------------------------------------------------------------------------------
iconClicked :: JS t (JSFunction () ())
iconClicked =
  function $ \ _ ->
    this `trigger` ("icon-clicked" :: JSString, this ! model :: ReagentModel)


-- implement these
    -- isImageUndefined: function(){
    --     return typeof(this.model.get("imageUrl")) != "undefined";
    -- },

    -- disableImageDragEffect : function(){
    --    this.$('img').ondragstart = function() { return false; };
    -- },
