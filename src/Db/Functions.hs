module Db.Functions where

import Control.Monad.Except (runExceptT)
import Control.Monad.Reader
import Data.Pool qualified as P
import Database.PostgreSQL.Simple qualified as Sql
import Error
import PgNamed qualified as Pg
import PortMonad

type WithDb env m = (MonadReader env m, Has DbPool env, MonadIO m)

queryRaw :: forall res env m. (WithDb env m, Sql.FromRow res) => Sql.Query -> m [res]
queryRaw q = withPool $ \conn -> Sql.query_ conn q

query ::
    forall res args env m.
    (WithDb env m, Sql.ToRow args, Sql.FromRow res) =>
    Sql.Query ->
    args ->
    m [res]
query q args = withPool $ \conn -> Sql.query conn q args

queryNamed :: (WithDb env m, WithError m, Sql.FromRow res) => Sql.Query -> [Pg.NamedParam] -> m [res]
queryNamed q params =
    withPool (\conn -> runExceptT $ Pg.queryNamed conn q params) >>= liftDbError

withPool :: (WithDb env m) => (Sql.Connection -> IO b) -> m b
withPool f = do
    pool <- grab @DbPool
    liftIO $ P.withResource pool f

liftDbError :: (WithError m) => Either Pg.PgNamedError a -> m a
liftDbError = either (throwError . dbNamedError) pure
