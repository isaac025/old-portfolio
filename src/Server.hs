module Server where

import Data.Text (Text)
import Lucid (Html)
import Network.Wai.Handler.Warp (run)
import Pages
import PortMonad
import Servant
import Servant.HTML.Lucid (HTML)

type ListingAPI name =
    Get '[HTML] (Html ())
        :<|> Capture name Text :> Get '[HTML] (Html ())

type ProjectsAPI = "projects" :> ListingAPI "projectname"
type ResearchAPI = "research" :> ListingAPI "projectname"
type BlogAPI = "blogs" :> ListingAPI "blogname"

type API =
    "home" :> Get '[HTML] (Html ())
        :<|> "images" :> Raw

{-        :<|> ProjectsAPI
        :<|> ResearchAPI
        :<|> BlogAPI
        :<|> "contact" :> Get '[HTML] (Html ())
-}
server :: ServerT API Port
server = homeHandler :<|> imageHandler -- :<|> projectsHandler :<|> researchHandler :<|> blogsHandler :<|> contactHandler
  where
    homeHandler :: Port (Html ())
    homeHandler = pure homePage

    imageHandler :: ServerT Raw Port
    imageHandler = serveDirectoryFileServer "./images"

    projectsHandler :: Server ProjectsAPI
    projectsHandler = projectsListingHandler :<|> projectNameHandler
      where
        projectsListingHandler :: Handler (Html ())
        projectsListingHandler = undefined

        projectNameHandler :: Text -> Handler (Html ())
        projectNameHandler = undefined

    researchHandler :: Server ProjectsAPI
    researchHandler = researchListingHandler :<|> researchNameHandler
      where
        researchListingHandler :: Handler (Html ())
        researchListingHandler = undefined

        researchNameHandler :: Text -> Handler (Html ())
        researchNameHandler = undefined

    blogsHandler :: Server ProjectsAPI
    blogsHandler = blogListingHandler :<|> blogNameHandler
      where
        blogListingHandler :: Handler (Html ())
        blogListingHandler = undefined

        blogNameHandler :: Text -> Handler (Html ())
        blogNameHandler = undefined

    contactHandler :: Handler (Html ())
    contactHandler = undefined

api :: Proxy API
api = Proxy

app :: Config -> Application
app config = serve api (hoistServer (Proxy @API) (runPort config) server)

runApp :: IO ()
runApp = run 8080 (app (Config "" Nothing Nothing))
