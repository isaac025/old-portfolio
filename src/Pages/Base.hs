module Pages.Base where

import Clay (Css)
import Data.Text (Text)
import Lucid
import Pages.CSS (cssList, renderCss)

cssToHtml :: [Css] -> Html ()
cssToHtml css = style_ [type_ "text/css"] (foldMap renderCss css)

base :: Html () -> Html ()
base h = do
    doctypehtml_ $ do
        html_ $ do
            head_ $ do
                title_ "ih1d"
                cssToHtml cssList
            body_ $ do
                do
                    nav_ [] $ do
                        foldMap navItem links
                    h
  where
    navItem :: Text -> Html ()
    navItem x = a_ [href_ $ "http://ihld.xyz" <> "/" <> x, class_ "nav-item"] (toHtml $ "[ " <> x <> " ]")

    links = ["", "contact"]
