{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module App where

import Control.Monad.Except (ExceptT)
import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Aeson (FromJSON)
import Data.Text (Text)
import Data.Yaml (decodeFileEither)
import GHC.Generics (Generic)
import Servant.Server (Handler (..), ServerError)

newtype AppT m a = AppT {unAppT :: ReaderT Config (ExceptT ServerError m) a}
    deriving (Functor, Applicative, Monad, MonadReader Config, MonadIO)

runAppT :: Config -> AppT IO a -> Handler a
runAppT c app = Handler $ runReaderT (unAppT app) c

data Environment = Dev | Test | Prod
    deriving (Generic)

instance FromJSON Environment

data Config = Config
    { url :: Text
    , paths :: [Text]
    , env :: Environment
    }
    deriving (Generic)

instance FromJSON Config
loadConfig :: (MonadIO m) => m (Either Text Config)
loadConfig = do
    conf <- liftIO $ decodeFileEither "./.env.yaml"
    pure $ either (\_ -> Left "Error parsing file") Right conf
