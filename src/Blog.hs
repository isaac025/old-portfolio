{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Blog where

import Data.Text (Text)
import Database.PostgreSQL.Simple (FromRow, ToRow)
import Database.PostgreSQL.Simple.FromField (FromField)
import GHC.Generics (Generic)
import Lucid

newtype Title = Title {unTitle :: Text}
    deriving (Generic, Show, Eq)
    deriving newtype (FromField)

deriving instance ToRow Title

data Blog = Blog
    { bid :: Int
    , title :: Title
    , content :: Text
    }
    deriving (Generic, Show, Eq)
    deriving anyclass (FromRow)

instance ToHtml Blog where
    toHtml (Blog _ (Title t) _) =
        li_ [] $ do
            toHtml t
    toHtmlRaw = toHtml

instance ToHtml [Blog] where
    toHtml blogs = ul_ [] $ do
        foldMap toHtml blogs
    toHtmlRaw = toHtml
