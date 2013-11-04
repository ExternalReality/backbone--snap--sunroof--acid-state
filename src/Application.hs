{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Control.Monad.State
import Data.Data
import Data.Text (Text)
import Snap.Snaplet
import Snap.Snaplet.AcidState
import Snap.Snaplet.Auth
import Snap.Snaplet.Heist
import Snap.Snaplet.Session
import Web.Routes
import Web.Routes.TH
------------------------------------------------------------------------------
import Mixture.MixtureQueries
import PotionMaker.PotionMakerQueries
import PotionSoap
import Reagent.ReagentQueries

------------------------------------------------------------------------------
data Route = Count Int 
           | Msg String Int
      deriving (Eq, Ord, Read, Show, Data, Typeable)

$(derivePathInfo ''Route)

------------------------------------------------------------------------------
instance MonadRoute (Handler App App) where
    type URL (Handler App App) = Route
    askRouteFn = gets _routeFn

------------------------------------------------------------------------------
data App = App
    { _heist   :: Snaplet (Heist App)
    , _sess    :: Snaplet SessionManager
    , _auth    :: Snaplet (AuthManager App)
    , _acid    :: Snaplet (Acid PotionSoapState)
    , _routeFn :: Route -> [(Text, Maybe Text)] -> Text
    }

makeLenses ''App

------------------------------------------------------------------------------
instance HasHeist App where
    heistLens = subSnaplet heist

------------------------------------------------------------------------------
instance HasAcid App PotionSoapState where
     getAcidStore = view $ acid . snapletValue

------------------------------------------------------------------------------
type AppHandler = Handler App App

------------------------------------------------------------------------------
makeAcidic ''PotionSoapState ['allReagents
                             ,'newReagent
                             ,'reagentById
                             ,'reagentByName
                             ,'updateReagent
                             ,'deleteReagent
                             ,'createPotionMaker
                             ,'saveMixture
                             ,'potionMakersMixtures
                             ,'findReagents
                             ]









