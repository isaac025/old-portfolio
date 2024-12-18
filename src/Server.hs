module Server where

import Lucid (Html)
import Network.Wai.Handler.Warp (run)
import Pages (contactPage, homePage)
import Servant
import Servant.HTML.Lucid (HTML)

type HomeAPI = Get '[HTML] (Html ())

type ContactAPI = "contact" :> Get '[HTML] (Html ())

type MusicAPI = "music" :> Get '[HTML] (Html ())

type API = HomeAPI :<|> ContactAPI :<|> "static" :> Raw

server :: Server API
server = homeHandler :<|> contactHandler :<|> serveDirectoryFileServer "static"
  where
    homeHandler :: Handler (Html ())
    homeHandler = pure homePage

    contactHandler :: Handler (Html ())
    contactHandler = pure contactPage

api :: Proxy API
api = Proxy

app :: Application
app = serve api server

runApp :: IO ()
runApp = run 8080 app
