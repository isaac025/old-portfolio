module Server where

import App
import Servant
import Server.Contact
import Server.Home

type API = HomeAPI :<|> ContactAPI :<|> "static" :> Raw

appToHomeServer :: Config -> Server HomeAPI
appToHomeServer cfg = hoistServer homeApi (runAppT cfg) homeServer

appToContactServer :: Config -> Server ContactAPI
appToContactServer cfg = hoistServer contactApi (runAppT cfg) contactServer

api :: Proxy API
api = Proxy

files :: Server Raw
files = serveDirectoryFileServer "static"

app :: Config -> Application
app cfg =
    let hServer = appToHomeServer cfg
        cServer = appToContactServer cfg
     in serve api (hServer :<|> cServer :<|> files) -- :<|> fileServer)
