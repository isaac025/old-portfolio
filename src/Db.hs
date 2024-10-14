{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Db where

import App (Config (..))
import Control.Monad.Reader (MonadIO, MonadReader, asks, liftIO)
import Data.Text (Text)
import Database.Persist.Sql (SqlPersistT, runMigration, runSqlPool)
import Database.Persist.TH (mkMigrate, mkPersist, persistLowerCase, share, sqlSettings)

share
    [ mkPersist sqlSettings
    , mkMigrate "migrateAll"
    ]
    [persistLowerCase|
    Blog json
        title Text
        content Text
        deriving Show Eq
|]

doMigrations :: SqlPersistT IO ()
doMigrations = runMigration migrateAll

runDb :: (MonadReader Config m, MonadIO m) => SqlPersistT IO b -> m b
runDb query = do
    pool <- asks configPool
    liftIO $ runSqlPool query pool
