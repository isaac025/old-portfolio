{-# LANGUAGE RecordWildCards #-}

module Init where

import App (AppEnv (..), Config (..), loadAppEnv, mkPool)
import Control.Exception.Safe (SomeException (..), bracket, catch, finally, onException, throwIO)
import Control.Monad (void)
import Data.Pool (destroyAllResources)
import Data.Text (Text, pack)
import Data.Typeable (typeOf)
import Database.Persist.Postgresql (runSqlPool)
import Db (doMigrations)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Say (say)
import Server (app)

tshow :: (Show a) => a -> Text
tshow = pack . show

runApp :: IO ()
runApp =
    withConfig $ \config -> do
        say "aquiring config"
        cfg <- initialize config `finally` say "exited: initialized config"
        run 8080 cfg `finally` say "server is closed"

shutdown :: Config -> IO ()
shutdown cfg = void $ destroyAllResources (configPool cfg)

withConfig :: (Config -> IO a) -> IO a
withConfig action = do
    a@AppEnv{..} <- loadAppEnv >>= either throwIO pure
    pool <- mkPool env `onException` say "exception in makePool"
    say "got pool "
    action
        Config{configApp = a, configPool = pool}

initialize :: Config -> IO Application
initialize cfg = do
    say "initialize"
    say "running migrations"
    bracket
        (say "starting to run migrations")
        (\_ -> say "migrations complete!")
        $ \_ ->
            do
                say "running migrations"
                runSqlPool doMigrations (configPool cfg) `catch` \(SomeException e) -> do
                    say $
                        mconcat
                            [ "exception on migrations, type: "
                            , tshow (typeOf e)
                            , ", shown: "
                            , tshow e
                            ]
                    throwIO e
                say "all done!"
    say "making app"
    pure . app $ cfg
