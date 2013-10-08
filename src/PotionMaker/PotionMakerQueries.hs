module PotionMaker.PotionMakerQueries where

import Control.Lens

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
take' :: Int -> [a] -> [a]
take' _ []                 = []
take' n (x:xs) | (n <= 0)  = []
               | otherwise = x : take' (n-1) (xs)
