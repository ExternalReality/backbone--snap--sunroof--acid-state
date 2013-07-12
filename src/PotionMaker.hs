{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}

module PotionMaker where

------------------------------------------------------------------------------
import Authentication.AcidStateBackend
import Control.Lens hiding (Indexable)
import Control.Monad
import Data.Data
import Data.IxSet
import Data.Set
import Data.SafeCopy
import Reagent
import Snap.Snaplet.Auth
------------------------------------------------------------------------------
import Mixture

------------------------------------------------------------------------------
type PotionMakerId = UserId 

deriving instance Typeable PotionMakerId
deriving instance Data PotionMakerId


------------------------------------------------------------------------------
data PotionMaker = PotionMaker { _potionMakerId :: PotionMakerId               
                               , _mixtures      :: Set (Mixture Validated)
                               }
      deriving (Eq, Ord, Typeable, Data, Show)
     
makeLenses ''PotionMaker
deriveSafeCopy 0 'base ''PotionMaker

     
------------------------------------------------------------------------------
instance Indexable PotionMaker where
  empty = ixSet [ ixFun $ \potionMaker -> [_potionMakerId potionMaker] ]
  

------------------------------------------------------------------------------                   
