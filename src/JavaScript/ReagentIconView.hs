{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}

module JavaScript.ReagentIconView (reagentIconViewModule) where

import Control.Monad
import Data.Boolean
import Data.Default
import Language.Sunroof
import Language.Sunroof.JS.Map
import Prelude hiding (log)
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
                          , "handlebars"
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
  reagentView        <- new "Object" () 
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
  extendView backbone reagentView

------------------------------------------------------------------------------
initialize' :: JS t (JSFunction ReagentModel ())
initialize' = function $ \reagentModel -> this # model := reagentModel;

------------------------------------------------------------------------------
templateBindings :: JS t (JSFunction () TemplateBindings)
templateBindings = function $ \_ -> do
  let model' = this ! model
  bindings'   <- new "Object" ()
  name'       <- name model'
  imageUrl'   <- imageUrl model'

  bindings' # "reagentName"      := name'
  bindings' # "imageUrl"         := imageUrl'
  bindings' # "imageNotFoundUrl" := ("images/reagent-icons/unavailable/imageNotFoundUrl" :: JSString)
  bindings' # "isImageUndefined" := (true :: JSBool)
  return bindings'

------------------------------------------------------------------------------
render' :: JSObject
        -> JSString
        -> JS t (JSFunction () (JSBackboneView Rendered))
render' mustache template =
  function $ \_ -> do    
    bindings' <- (this ! bindings) $$ ()
    let notRenderedView = createJSBackboneView this
    renderedView <- renderTemplate (template, bindings') notRenderedView
    disableImageDragEffect renderedView
    return renderedView

------------------------------------------------------------------------------
renderTemplate = invoke "renderTemplate"

------------------------------------------------------------------------------
iconClicked :: JS t (JSFunction () ())
iconClicked =
  function $ \ _ ->
    this # trigger ("icon-clicked" :: JSString, this ! model :: ReagentModel)

------------------------------------------------------------------------------
disableImageDragEffect :: JSBackboneView Rendered -> JS t ()
disableImageDragEffect ob = do 
  disableFunction <- function $ \ _ -> return false
  em  <- ob # select "img"
  let em' = (em ! index 0) :: JSObject 
  em' # onDragStart := disableFunction

------------------------------------------------------------------------------
select :: JSString -> JSBackboneView Rendered ->  JS t JSObject
select = invoke "$"

------------------------------------------------------------------------------
onDragStart :: JSSelector (JSFunction () JSBool)
onDragStart = attr "ondragstart"
