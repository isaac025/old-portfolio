module PortMonad where

import Configuration
import Control.Monad.Reader
import Data.Pool (Pool, defaultPoolConfig, newPool)
import Data.Text.Encoding (encodeUtf8)
import Database.PostgreSQL.Simple (Connection, close, connectPostgreSQL)
import Servant.Server (Handler)

type DbPool = Pool Connection

data Env = Env
    { config :: Config
    , pool :: DbPool
    }

newtype Port a = Port (ReaderT Env Handler a)
    deriving (Functor, Applicative, Monad, MonadReader Env, MonadIO)

runPort :: Env -> Port a -> Handler a
runPort c (Port a) = runReaderT a c

makeEnv :: Config -> IO Env
makeEnv c@Config{..} = do
    p <- newPool $ defaultPoolConfig (connectPostgreSQL $ encodeUtf8 postgres) close 10 5
    pure (Env c p)

class Has field env where obtain :: env -> field
instance Has DbPool Env where obtain = pool
instance Has Config Env where obtain = config

grab :: forall field env m. (MonadReader env m, Has field env) => m field
grab = asks $ obtain @field
{-# INLINE grab #-}
