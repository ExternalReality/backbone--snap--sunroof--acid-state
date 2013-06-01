{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Reagent where

------------------------------------------------------------------------------
import Control.Lens (makeLenses)
import Control.Monad.Reader.Class
import Data.Acid
import Data.Aeson
import Data.Aeson.TH
import Data.Data
import Data.IxSet
import Data.SafeCopy
import Data.Text hiding (drop)
import Data.Typeable

------------------------------------------------------------------------------
newtype ReagentId = ReagentId { _unReagentId :: Integer }
               deriving (Eq, Ord, Data, Enum, Typeable, SafeCopy, Show)

makeLenses ''ReagentId


------------------------------------------------------------------------------
newtype ReagentName = ReagentName { _unReagentName :: Text }
    deriving (Eq, Ord, Data, Typeable, SafeCopy, Show)

makeLenses ''ReagentName


------------------------------------------------------------------------------
data Reagent = Reagent { _reagentId :: ReagentId
                       , _name      :: ReagentName
                       }
               deriving (Eq, Ord, Data, Typeable, Show)

deriveSafeCopy 0 'base ''Reagent
makeLenses ''Reagent


------------------------------------------------------------------------------
instance ToJSON Reagent where
    toJSON Reagent{..} =  object [ "id"   .= _unReagentId   _reagentId
                                 , "name" .= _unReagentName _name
                                 ]


------------------------------------------------------------------------------
instance Indexable Reagent where
     empty = ixSet [ ixFun $ \reagent -> [ _reagentId reagent ]
                   , ixFun $ \reagent -> [ _name reagent ]
                   ]


------------------------------------------------------------------------------
succReagentId :: ReagentId -> ReagentId
succReagentId (ReagentId n) = ReagentId $ n + 1
