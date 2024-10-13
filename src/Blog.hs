{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}

module Blog where

import Data.Text (Text)
import GHC.Generics (Generic)
import Lucid

newtype Title = Title {unTitle :: Text}
    deriving (Generic, Show, Eq)

data Blog = Blog
    { bid :: Int
    , title :: Title
    , content :: Text
    }
    deriving (Generic, Show, Eq)

instance ToHtml Blog where
    toHtml (Blog _ (Title t) _) =
        li_ [] $ do
            toHtml t
    toHtmlRaw = toHtml

instance ToHtml [Blog] where
    toHtml blogs = ul_ [] $ do
        foldMap toHtml blogs
    toHtmlRaw = toHtml
