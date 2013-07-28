{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.AcidState
import Snap.Snaplet.Heist
import Snap.Snaplet.Auth
import Snap.Snaplet.Session
------------------------------------------------------------------------------
import Mixture.MixtureQueries
import PotionMaker.PotionMakerQueries
import PotionSoap
import Reagent.ReagentQueries

------------------------------------------------------------------------------
data App = App
    { _heist :: Snaplet (Heist App)
    , _sess  :: Snaplet SessionManager
    , _auth  :: Snaplet (AuthManager App)
    , _acid  :: Snaplet (Acid PotionSoapState)
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
                             ,'createPotionMaker
                             ,'saveMixture
                             ,'potionMakersMixtures
                             ,'validateMixture
                             ]
