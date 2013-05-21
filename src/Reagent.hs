{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Reagent where

import Data.Aeson.TH
import Data.Text

type ReagentName = Text

data Reagent = Reagent { _name :: ReagentName }
     deriving (Show)

$(deriveJSON id ''Reagent)
