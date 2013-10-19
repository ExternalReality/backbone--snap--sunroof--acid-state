{-# LANGUAGE OverloadedStrings #-}
module Authentication.JanrainEngage (getAuthUserFromSocialNetwork) where

import Control.Monad (liftM, liftM3, ap)
import Data.Aeson
import Data.ByteString.Char8
import Data.Maybe
import Data.Text hiding (unpack)
import Network
import Network.HTTP.Conduit
import Snap.Snaplet.Auth
import System.Posix.Env.ByteString (getEnvironment)
import qualified Data.HashMap.Strict as H
import           Data.Aeson (Value(String))
------------------------------------------------------------------------------
type ShellEnvironment = [(ByteString, ByteString)]
type AuthInfoToken    = ByteString

------------------------------------------------------------------------------
data JanrainAPIConfig = JanrainAPIConfig { _apiURLRoot     :: ByteString
                                         , _apiKey         :: ByteString
                                         , _responseFormat :: ByteString
                                         }

------------------------------------------------------------------------------
data AuthInfoResponse = AuthInfoResponse { _status  :: String
                                         , _profile :: AuthInfoProfile
                                         } deriving (Show)

instance FromJSON AuthInfoResponse where
  parseJSON (Object v) = AuthInfoResponse `liftM` (v .: "stat")
                                          `ap`    (v .: "profile") 


------------------------------------------------------------------------------
data AuthInfoProfile = AuthInfoProfile { _identifier        :: Text 
                                       , _email             :: Text
                                       , _preferredUsername :: Text
                                       } deriving (Show)

instance FromJSON AuthInfoProfile where
  parseJSON (Object v) = AuthInfoProfile `liftM` (v .: "identifier")
                                         `ap`    (v .: "email")
                                         `ap`    (v .: "preferredUsername") 

------------------------------------------------------------------------------
readJanrainApiConfig :: ShellEnvironment -> JanrainAPIConfig
readJanrainApiConfig environment = do
  let config = liftM3 JanrainAPIConfig url key contentType
  fromMaybe (error "Could Not Read Api Configuration") config
    where
      url            = envLookup "ENGAGE_API_URL"
      key            = envLookup "ENGAGE_API_KEY"
      contentType    = envLookup "ENGAGE_API_RESPONSE_FORMAT"
      envLookup evar = lookup evar environment

------------------------------------------------------------------------------
getAuthUserFromSocialNetwork :: AuthInfoToken -> IO (Maybe AuthUser)
getAuthUserFromSocialNetwork token = do
  (JanrainAPIConfig url key format) <- readJanrainApiConfig `liftM` getEnvironment
  withSocketsDo $ do
    request' <- parseUrl $ unpack url
    let body' = body key format request'
    let request = request' { method = "POST"
                           , requestBody = requestBody body'
                           }
    response <- withManager $ httpLbs request
    let maybeAuthInfoResponse = decode $ responseBody response
    return $ authInfoResponseToAuthUser `fmap` maybeAuthInfoResponse
    
    where
      body key format = urlEncodedBody [ ("apiKey",  key)
                                       , ("token",  token)
                                       , ("format", format)
                                       ]

------------------------------------------------------------------------------
authInfoResponseToAuthUser :: AuthInfoResponse -> AuthUser
authInfoResponseToAuthUser (AuthInfoResponse _ profile) = 
  defAuthUser { userEmail = Just $ _email profile
              , userRoles = [Role "customer"]
              , userLogin = _preferredUsername profile
              , userMeta  = H.fromList [("social token", String $ _identifier profile)]  
              }
