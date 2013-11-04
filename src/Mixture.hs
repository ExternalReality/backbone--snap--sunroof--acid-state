{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE TemplateHaskell            #-}

module Mixture ( Mixture (..)
               , MixtureId (..)
               , reagents
               , mixtureId
               ) where

------------------------------------------------------------------------------
import           Control.Lens        hiding (Indexable, (.=))
import           Data.Aeson
import           Data.Aeson.TH
import           Data.Data
import           Data.IxSet          hiding (fromList)
import           Data.Maybe
import           Data.SafeCopy
import           Data.Set
------------------------------------------------------------------------------
import           Reagent

------------------------------------------------------------------------------
newtype MixtureId = MixtureId { _unMixtureId :: Integer }
      deriving (Eq, Ord, Data, Typeable, Show, Num)

deriveSafeCopy 0 'base ''MixtureId
deriveJSON defaultOptions ''MixtureId

------------------------------------------------------------------------------
data Mixture = Mixture { _mixtureId :: Maybe MixtureId
                       , _reagents  :: Set Reagent
                       }
      deriving (Eq, Ord, Data, Typeable, Show)

deriveSafeCopy 0 'base ''Mixture
makeLenses ''Mixture

------------------------------------------------------------------------------
instance ToJSON Mixture where
  toJSON Mixture{..} =
    object [ "id"        .= _unMixtureId idOrUnSavedId
           , "reagents"  .= _reagents
           ]
    where
      idOrUnSavedId = fromMaybe (MixtureId (-1)) _mixtureId

------------------------------------------------------------------------------
instance Indexable Mixture where
  empty = ixSet [ ixFun $ \mixture -> [ _mixtureId mixture ]
                , ixFun $ \mixture -> [ _reagents mixture ]
                ]
