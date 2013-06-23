{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Reagent.Reagent where

------------------------------------------------------------------------------
import Control.Applicative
import Control.Lens (makeLenses)
import Control.Monad (mzero)
import Control.Monad.Reader.Class
import Data.Acid
import Data.Aeson
import Data.Aeson.TH
import Data.Data
import Data.IxSet
import Data.Maybe
import Data.SafeCopy
import Data.Text hiding (drop)
import Data.Typeable

------------------------------------------------------------------------------
newtype ReagentId = ReagentId { _unReagentId :: Integer }
  deriving (Eq, Ord, Data, Enum, Typeable, SafeCopy, Show)

makeLenses ''ReagentId
deriveFromJSON (const "id") ''ReagentId
  

------------------------------------------------------------------------------
newtype ReagentName = ReagentName { _unReagentName :: Text}
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ReagentName
deriveFromJSON (const "name") ''ReagentName


------------------------------------------------------------------------------
newtype ImageUrl = ImageUrl { _unImageUrl :: Text }
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ImageUrl
deriveFromJSON (const "imageUrl") ''ImageUrl


------------------------------------------------------------------------------
data Reagent = Reagent { _reagentId :: Maybe ReagentId
                       , _name      :: ReagentName
                       , _imageUrl  :: ImageUrl
                       }
               deriving (Eq, Ord, Data, Typeable, Show)

makeLenses ''Reagent
deriveSafeCopy 0 'base ''Reagent


------------------------------------------------------------------------------
instance ToJSON Reagent where
  toJSON Reagent{..} =  object [ "id"       .=  _unReagentId idOrUnSavedId
                               , "name"     .=  _unReagentName _name
                               , "imageUrl" .=  _unImageUrl _imageUrl
                               ] 
    where
      idOrUnSavedId = fromMaybe (ReagentId (-1)) _reagentId
                                 
------------------------------------------------------------------------------
-- TODO : Clean this fucking code up Eric.
instance FromJSON Reagent where
  parseJSON (Object v) = do 
    id <- v .:? "id"
    name <- ReagentName <$> v .: "name"
    url  <- ImageUrl <$> v .:  "imageUrl"
    return $ Reagent (ReagentId <$> id) name url
    
  parseJSON _          = mzero

------------------------------------------------------------------------------

instance Indexable Reagent where
  empty = ixSet [ ixFun $ \reagent -> [ _reagentId reagent ]
                , ixFun $ \reagent -> [ _name reagent ]
                ]
