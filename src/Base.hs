module Base where

import BaseCss (cssList, renderCss)
import Clay (Css)
import Data.Text (Text)
import Lucid

cssToHtml :: [Css] -> Html ()
cssToHtml css = style_ [type_ "text/css"] (foldMap renderCss css)

base :: Html () -> Text -> [Text] -> Html ()
base h u xs = do
    doctypehtml_ $ do
        html_ $ do
            head_ $ do
                title_ "ih1d"
                cssToHtml cssList
            body_ $ do
                do
                    nav_ [] $ do
                        foldMap navItem xs
                    h
  where
    navItem :: Text -> Html ()
    navItem x = a_ [href_ $ u <> "/" <> x, class_ "nav-item"] (toHtml $ "[ " <> x <> " ]")
