module Pages.Contact where

import Lucid
import Pages.Base

contactPage :: Html ()
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
