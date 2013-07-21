{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Reagent where

------------------------------------------------------------------------------
import Control.Applicative
import Control.Lens (makeLenses)
import Control.Monad (mzero)
import Data.Aeson
import Data.Data
import Data.IxSet
import Data.Maybe
import Data.SafeCopy
import Data.Text hiding (drop)


------------------------------------------------------------------------------
newtype ReagentId = ReagentId { _unReagentId :: Integer }
   deriving (Eq, Ord, Data, Enum, Typeable, SafeCopy, Show)

makeLenses ''ReagentId


------------------------------------------------------------------------------
newtype ReagentName = ReagentName { _unReagentName :: Text }
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ReagentName


------------------------------------------------------------------------------
newtype ImageUrl = ImageUrl { _unImageUrl :: Text }
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ImageUrl


------------------------------------------------------------------------------
newtype ShortDescription = ShortDescription { _unShortDescription :: Text }
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ShortDescription


------------------------------------------------------------------------------
newtype LongDescription = LongDescription { _unLongDescription :: Text }
  deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''LongDescription


------------------------------------------------------------------------------
data Reagent = Reagent { _reagentId        :: Maybe ReagentId
                       , _name             :: ReagentName
                       , _imageUrl         :: ImageUrl
                       , _shortDescription :: ShortDescription
                       , _longDescription  :: LongDescription
                       }
               deriving (Eq, Ord, Data, Typeable, Show)

makeLenses ''Reagent
deriveSafeCopy 0 'base ''Reagent


------------------------------------------------------------------------------
instance ToJSON Reagent where
  toJSON Reagent{..} =  
    object [ "id"               .= _unReagentId idOrUnSavedId
           , "name"             .= _unReagentName _name
           , "imageUrl"         .= _unImageUrl _imageUrl
           , "shortDescription" .= _unShortDescription _shortDescription
           , "longDescription"  .= _unLongDescription _longDescription
           ] 
    where
      idOrUnSavedId = fromMaybe (ReagentId (-1)) _reagentId
 
                                
------------------------------------------------------------------------------
instance FromJSON Reagent where
  parseJSON (Object v) =
    Reagent <$> (fmap ReagentId   <$> v .:? "id")
            <*> (ReagentName      <$> v .:  "name")
            <*> (ImageUrl         <$> v .:  "imageUrl")
            <*> (ShortDescription <$> v .:  "shortDescription")
            <*> (LongDescription  <$> v .:  "longDescription")
    
  parseJSON _ = mzero


------------------------------------------------------------------------------
instance Indexable Reagent where
  empty = ixSet [ ixFun $ \reagent -> [ _reagentId reagent ]
                , ixFun $ \reagent -> [ _name reagent ]
                ]
