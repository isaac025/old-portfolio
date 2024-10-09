module PortMonad where

import Control.Monad.State
import Data.Text (Text)
import Servant.Server (Handler)

data Config = Config
    { url :: Text
    , path :: Maybe Text
    , token :: Maybe Text
    }

newtype Port a = Port (StateT Config Handler a)
    deriving (Functor, Applicative, Monad, MonadState Config, MonadIO)

runPort :: Config -> Port a -> Handler a
runPort c (Port a) = do
    (s, _) <- runStateT a c
    pure s
