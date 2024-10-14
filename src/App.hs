{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module App where

import Control.Monad.Except (ExceptT)
import Control.Monad.IO.Class
import Control.Monad.Logger (runNoLoggingT)
import Control.Monad.Reader
import Data.Aeson (FromJSON)
import Data.Text (Text)
import Data.Yaml (ParseException, decodeFileEither)
import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool)
import GHC.Generics (Generic)
import Servant.Server (Handler (..), ServerError)

newtype AppT m a = AppT {unAppT :: ReaderT Config (ExceptT ServerError m) a}
    deriving (Functor, Applicative, Monad, MonadReader Config, MonadIO)

runAppT :: Config -> AppT IO a -> Handler a
runAppT c app = Handler $ runReaderT (unAppT app) c

data Config = Config
    { configApp :: AppEnv
    , configPool :: ConnectionPool
    }

data Environment = Dev | Test | Prod
    deriving (Generic)

instance FromJSON Environment

data AppEnv = AppEnv
    { url :: Text
    , paths :: [Text]
    , env :: Environment
    }
    deriving (Generic)

instance FromJSON AppEnv

loadAppEnv :: (MonadIO m) => m (Either ParseException AppEnv)
loadAppEnv = liftIO $ decodeFileEither "./.env.yaml"

mkPool :: Environment -> IO ConnectionPool
mkPool Dev = runNoLoggingT $ createPostgresqlPool connStr (envPool Dev)
mkPool Test = undefined
mkPool Prod = undefined

envPool :: Environment -> Int
envPool Dev = 1
envPool Test = 1
envPool Prod = 8

connStr :: ConnectionString
connStr = "host=localhost dbname=postgres user=postgres password=postgres port=5432"
