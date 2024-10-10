module Server where

import Configuration (Config (paths, url), loadConfig)
import Data.Text (Text)
import Control.Monad.IO.Class
import Db.Blog (getBlogs)
import Lucid (Html)
import Network.Wai.Handler.Warp (run)
import Pages
import PortMonad
import Servant
import Servant.HTML.Lucid (HTML)

type ListingAPI name =
    Get '[HTML] (Html ())
        :<|> Capture name Text :> Get '[HTML] (Html ())

type BlogAPI = "blogs" :> Get '[HTML] (Html ())

type API =
    "home" :> Get '[HTML] (Html ())
        :<|> "contact" :> Get '[HTML] (Html ())
        :<|> "static" :> Raw
        :<|> BlogAPI

server :: ServerT API Port
server = homeHandler :<|> contactHandler :<|> imageHandler :<|> blogsHandler -- :<|> projectsHandler :<|> researchHandler  :<|> contactHandler
  where
    homeHandler :: Port (Html ())
    homeHandler = do
        c <- grab @Config
        pure (homePage (url c) (paths c))

    imageHandler :: ServerT Raw Port
    imageHandler = serveDirectoryFileServer "./static"

    contactHandler :: Port (Html ())
    contactHandler = do
        c <- grab @Config
        pure (contactPage (url c) (paths c))

    blogsHandler :: ServerT BlogAPI Port
    blogsHandler = blogListingHandler -- :<|> blogNameHandler
      where
        blogListingHandler :: Port (Html ())
        blogListingHandler = do
            c <- grab @Config
            l <- getBlogs
            liftIO $ print l
            pure (blogPage l (url c) (paths c))

api :: Proxy API
api = Proxy

app :: Env -> Application
app e = serve api (hoistServer (Proxy @API) (runPort e) server)

runApp :: IO ()
runApp = do
    l <- loadConfig
    case l of
        Left m -> print m
        Right c -> makeEnv c >>= run 8080 . app
