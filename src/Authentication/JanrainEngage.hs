module Authentication.JanrainEngage (getAuthUser) where

import Control.Monad (ap, liftM2, liftM, join)
import Data.ByteString.Char8
import Data.Text hiding (pack)
import Network.Http.Client 
import Snap.Snaplet.Auth
import System.Environment (getEnvironment)
import System.IO.Streams
import System.IO.Streams.Attoparsec
import System.IO.Streams.Network

------------------------------------------------------------------------------  
type AuthInfoToken = Text
data JanrainAPIConfig = JanrainAPIConfig { _apiURLRoot          :: ByteString
                                         , _responseContentType :: ByteString
                                         }

------------------------------------------------------------------------------
readJanrainApiConfig :: [([Char], String)] -> JanrainAPIConfig
readJanrainApiConfig environment = do
  let config = liftM2 JanrainAPIConfig url contentType                                
  case config of
    Nothing   -> error "Could Not Read Api Configuration"
    Just conf -> conf 
  
    where
      url = envLookup ""
      contentType = envLookup  ""
      envLookup evar = fmap pack (lookup evar environment)

------------------------------------------------------------------------------
getAuthUser :: IO AuthUser
getAuthUser = do
  (JanrainAPIConfig url contentType) <- readJanrainApiConfig `liftM` getEnvironment
  post url contentType emptyBody responseHandler
  

------------------------------------------------------------------------------
responseHandler :: Response -> InputStream ByteString -> IO AuthUser
responseHandler = undefined
