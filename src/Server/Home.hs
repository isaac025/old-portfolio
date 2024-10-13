module Server.Home where

import App
import Base
import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Text (Text)
import Lucid
import Servant
import Servant.HTML.Lucid (HTML)

type HomeAPI = "home" :> Get '[HTML] (Html ())

homeServer :: (MonadIO m) => ServerT HomeAPI (AppT m)
homeServer = do
    cfg <- ask
    pure $ homePage (url cfg) (paths cfg)

homePage :: Text -> [Text] -> Html ()
homePage =
    base $ do
        h2_ [] "Wake up..."
        h3_ [] "The Matrix has you"
        h4_ [] "Follow the white rabbit."
        br_ []
        h5_ "Knock, knock..."

homeApi :: Proxy HomeAPI
homeApi = Proxy
