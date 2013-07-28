{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}

module Mixture (Mixture (..), NotValidated, Validated) where

------------------------------------------------------------------------------
import Data.Aeson
import Data.Aeson.TH
import Control.Applicative
import Data.Data
import Data.SafeCopy
import Data.Set
import Control.Monad (mzero)
------------------------------------------------------------------------------
import Reagent

data NotValidated = NotValidated
data Validated = Validated

deriving instance Data Validated
deriving instance Typeable Validated

deriveSafeCopy 0 'base ''NotValidated
deriveJSON id ''NotValidated

deriveSafeCopy 0 'base ''Validated
deriveJSON id ''Validated

------------------------------------------------------------------------------
data Mixture a = Mixture { _reagents :: Set Reagent }
      deriving (Eq, Ord, Data, Typeable, Show)
      
deriveSafeCopy 0 'base ''Mixture
deriveToJSON (drop 1) ''Mixture

------------------------------------------------------------------------------
instance FromJSON (Mixture NotValidated) where
  parseJSON (Object v) =
    Mixture <$> (fromList <$> v .: "reagents")
  
  parseJSON _ = mzero
