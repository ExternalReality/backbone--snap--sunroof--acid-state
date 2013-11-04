{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module PotionMaker where

------------------------------------------------------------------------------
import Authentication.AcidStateBackend()
import Control.Lens hiding (Indexable)
import Data.Data
import Data.IxSet
import Data.Set
import Data.SafeCopy
import Snap.Snaplet.Auth
------------------------------------------------------------------------------
import Mixture

------------------------------------------------------------------------------
type PotionMakerId = UserId

deriving instance Typeable PotionMakerId
deriving instance Data PotionMakerId

------------------------------------------------------------------------------
data PotionMaker = PotionMaker { _potionMakerId :: PotionMakerId               
                               , _mixtures      :: Set Mixture
                               }
      deriving (Eq, Ord, Typeable, Data, Show)
     
makeLenses ''PotionMaker
deriveSafeCopy 0 'base ''PotionMaker
     
------------------------------------------------------------------------------
instance Indexable PotionMaker where
  empty = ixSet [ ixFun $ \potionMaker -> [_potionMakerId potionMaker] ]
  
------------------------------------------------------------------------------                   
