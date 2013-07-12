module PotionMaker.PotionMakerQueries where

import Control.Lens
import Control.Monad
import Data.Acid
import Data.IxSet as IxSet
import qualified Data.Set as S
import Snap.Snaplet.Auth

------------------------------------------------------------------------------
import PotionMaker
import PotionSoap

------------------------------------------------------------------------------
createPotionMaker :: UserId ->  Update PotionSoapState ()
createPotionMaker userId = do
  let potionMaker = PotionMaker userId S.empty
  potionMakers %= updateIx userId potionMaker
                  

------------------------------------------------------------------------------
