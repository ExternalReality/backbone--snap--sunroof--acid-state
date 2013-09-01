{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}

module JavaScript.RouterUtilities (replaceContentWith) where

-----------------------------------------------------------------------------------------
import Control.Monad
import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.JQuery
------------------------------------------------------------------------------
import JavaScript.Backbone.View

------------------------------------------------------------------------------
replaceOrAppend :: JSObject -> JSObject -> JSA ()
replaceOrAppend content replacement = do
  innerContent  <- content # children
  let isContentEmpty = (innerContent ! jsLength)  ==* (0 :: JSNumber)
  ifB isContentEmpty
     (append content replacement)
     (void $ replaceWith innerContent replacement)

------------------------------------------------------------------------------
replaceContentWith :: JSBackboneView NotRendered -> JSA ()
replaceContentWith view = do
  content <- jQuery "#content"
  renderedView <- (view ! render) `apply` ()  
  replaceOrAppend content $ el renderedView

------------------------------------------------------------------------------
children :: JSObject -> JS t JSObject
children = invoke "children" ()

------------------------------------------------------------------------------
replaceWith :: JSObject -> JSObject -> JS t JSObject
replaceWith = invoke "replaceWith"

------------------------------------------------------------------------------
jsLength :: JSSelector JSNumber
jsLength = attr "length"
