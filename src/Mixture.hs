{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE TemplateHaskell            #-}

module Mixture ( Mixture (..)
               , MixtureId (..)
               , NotValidated
               , Validated
               , reagents
               , mixtureId
               ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Lens        hiding (Indexable, (.=))
import           Control.Monad       (mzero)
import           Data.Aeson
import           Data.Aeson.TH
import           Data.Data
import           Data.IxSet          hiding (fromList)
import           Data.Maybe
import           Data.SafeCopy
import           Data.Set
------------------------------------------------------------------------------
import           Reagent

data NotValidated = NotValidated
data Validated = Validated

deriving instance Data Validated
deriving instance Typeable Validated


deriveSafeCopy 0 'base ''NotValidated
deriveJSON defaultOptions ''NotValidated


deriveSafeCopy 0 'base ''Validated
deriveJSON defaultOptions ''Validated

------------------------------------------------------------------------------
newtype MixtureId = MixtureId { _unMixtureId :: Integer }
      deriving (Eq, Ord, Data, Typeable, Show, Num)

deriveSafeCopy 0 'base ''MixtureId
deriveJSON defaultOptions ''MixtureId

------------------------------------------------------------------------------
data Mixture a = Mixture { _mixtureId :: Maybe MixtureId
                         , _reagents  :: Set Reagent
                         }
      deriving (Eq, Ord, Data, Typeable, Show)

deriveSafeCopy 0 'base ''Mixture
makeLenses ''Mixture

------------------------------------------------------------------------------
instance ToJSON (Mixture a) where
  toJSON Mixture{..} =
    object [ "id"        .= _unMixtureId idOrUnSavedId
           , "reagents"  .= _reagents
           ]
    where
      idOrUnSavedId = fromMaybe (MixtureId (-1)) _mixtureId

------------------------------------------------------------------------------
instance FromJSON (Mixture NotValidated) where
  parseJSON (Object v) =
    Mixture <$> (fmap MixtureId  <$> v .:? "id")
            <*> (fromList        <$> v .:  "reagents")

  parseJSON _ = mzero

------------------------------------------------------------------------------
instance Indexable (Mixture a) where
  empty = ixSet [ ixFun $ \mixture -> [ _mixtureId mixture ]
                , ixFun $ \mixture -> [ _reagents mixture ]
                ]
