module Server where

import Lucid (Html)
import Servant
import Servant.HTML.Lucid (HTML)

type API =
    "home" :> Get '[HTML] (Html ())
        :<|> "projects" :> Get '[HTML] (Html ())
        :<|> "research" :> Get '[HTML] (Html ())
        :<|> "blog" :> Get '[HTML] (Html ())
        :<|> "contact" :> Get '[HTML] (Html ())
