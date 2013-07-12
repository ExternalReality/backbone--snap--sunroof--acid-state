{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}
module Mixture (Mixture (..), NotValidated, Validated) where

------------------------------------------------------------------------------
import Data.Aeson.TH
import Data.Data
import Data.SafeCopy
import Data.Set
------------------------------------------------------------------------------
import Reagent

data NotValidated = NotValidate
data Validated = Validated

deriving instance Data Validated
deriving instance Typeable Validated

deriveSafeCopy 0 'base ''NotValidated
deriveJSON id ''NotValidated

deriveSafeCopy 0 'base ''Validated
------------------------------------------------------------------------------
data Mixture a = Mixture { _reagents :: Set Reagent }
      deriving (Eq, Ord, Data, Typeable, Show)
      

deriveSafeCopy 0 'base ''Mixture
deriveJSON (drop 1) ''Mixture

------------------------------------------------------------------------------


