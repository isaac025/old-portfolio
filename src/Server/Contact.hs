module Server.Contact where

import App
import Base
import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Text (Text)
import Lucid
import Servant
import Servant.HTML.Lucid (HTML)

type ContactAPI = "contact" :> Get '[HTML] (Html ())

contactServer :: (MonadIO m) => ServerT ContactAPI (AppT m)
contactServer = do
    ae <- asks configApp
    pure $ contactPage (url ae) (paths ae)

contactApi :: Proxy ContactAPI
contactApi = Proxy

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
