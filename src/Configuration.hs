{-# LANGUAGE DeriveGeneric #-}

module Configuration where

import Control.Monad.IO.Class
import Data.Aeson (FromJSON)
import Data.Text (Text)
import Data.Yaml (decodeFileEither)
import GHC.Generics (Generic)

data Environment = Dev | Test | Prod
    deriving (Generic)

instance FromJSON Environment

data Config = Config
    { url :: Text
    , paths :: [Text]
    , env :: Environment
    , postgres :: Text
    }
    deriving (Generic)

instance FromJSON Config
loadConfig :: (MonadIO m) => m (Either Text Config)
loadConfig = do
    conf <- liftIO $ decodeFileEither ".env.yaml"
    pure $ either (\_ -> Left "Error parsing file") Right conf
