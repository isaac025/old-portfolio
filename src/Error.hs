{-# LANGUAGE DeriveAnyClass #-}

module Error where

import Control.Exception
import Control.Monad.Except (MonadError)
import Control.Monad.Except qualified as E
import Data.Text (Text, pack)
import GHC.Stack
import PgNamed qualified as Pg

type WithError m = (MonadError AppError m)

throwError :: (WithError m) => ErrorType -> m a
throwError = E.throwError . AppError (toSource callStack)

toSource :: CallStack -> Text
toSource cs = showCallStack
  where
    showCallStack :: Text
    showCallStack =
        case getCallStack cs of
            [] -> "<unkown loc>"
            [(name, loc)] -> showLoc name loc
            (_, loc) : (callerName, _) : _ -> showLoc callerName loc
    showLoc :: String -> SrcLoc -> Text
    showLoc name SrcLoc{..} = pack (srcLocModule <> ".") <> pack name <> "#" <> pack (show srcLocStartLine)

newtype AppException = AppException AppError
    deriving (Show)
    deriving anyclass (Exception)

data AppError = AppError
    { call :: Text
    , errorType :: ErrorType
    }
    deriving (Show, Eq)

newtype ErrorType = InternalError IError
    deriving (Eq, Show)

data IError
    = DbNamedError Pg.PgNamedError
    | ServerError String
    deriving (Eq, Show)

dbNamedError :: Pg.PgNamedError -> ErrorType
dbNamedError = InternalError . DbNamedError
