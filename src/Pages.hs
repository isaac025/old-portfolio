module Pages where

import Clay (Css)
import Data.Text (Text)
import Lucid
import PagesCss (cssList, renderCss)

cssToHtml :: [Css] -> Html ()
cssToHtml css = style_ [type_ "text/css"] (foldMap renderCss css)

base :: Html () -> Text -> [Text] -> Html ()
base h u xs = do
    doctypehtml_ $ do
        html_ $ do
            head_ $ do
                title_ "ih1d"
                cssToHtml cssList
                script_ [src_ "/static/htmx/htmx.min.js"] ("" :: Text)
            body_ $ do
                do
                    nav_ [] $ do
                        foldMap navItem xs
                    h
  where
    navItem :: Text -> Html ()
    navItem x = a_ [href_ $ u <> "/" <> x, class_ "nav-item"] (toHtml $ "[ " <> x <> " ]")

homePage :: Text -> [Text] -> Html ()
homePage =
    base $ do
        h2_ [] "Wake up..."
        h3_ [] "The Matrix has you"
        h4_ [] "Follow the white rabbit."
        br_ []
        h5_ "Knock, knock..."

contactPage :: Text -> [Text] -> Html ()
contactPage = base $ do
    div_ [class_ "box"] $ do
        div_ [class_ "box-header"] $ do
            div_ [class_ "box-link"] $ do
                h2_ [] "ih1d"
            div_ [class_ "box-link"] $ do
                navLinks
  where
    navLinks :: Html ()
    navLinks = nav_ [] $ do
        a_ [href_ "https://github.com/isaac025"] $ do
            img_ [class_ "icon-link", src_ "/static/images/github.png"]
        a_ [href_ "https://youtube.com/@ih1d"] $ do
            img_ [class_ "icon-link", src_ "/static/images/youtube.png"]
        a_ [href_ "https://twitch.com/ih1d"] $ do
            img_ [class_ "icon-link", src_ "/static/images/twitch.svg"]
        a_ [href_ "mailto:isaac.lopez@upr.edu"] $ do
            img_ [class_ "icon-link", src_ "/static/images/mail.svg"]
