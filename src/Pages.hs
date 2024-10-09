module Pages where

import Clay (Css)
import Data.Text (Text)
import Lucid
import PagesCss (cssList, renderCss)

-- | Content type
newtype Title = Title Text

instance ToHtml Title where
    toHtml = undefined
    toHtmlRaw = toHtml

data Content = Content
    { title :: Title
    , path :: Text
    , content :: [Text]
    }

cssToHtml :: [Css] -> Html ()
cssToHtml css = style_ [type_ "text/css"] (foldMap renderCss css)

base :: Html () -> Html ()
base h = do
    doctypehtml_ $ do
        html_ $ do
            head_ $ do
                title_ "Isaac Lopez's website"
                cssToHtml cssList
            body_ $ do
                h

homePage :: Html ()
homePage =
    base $ do
        h2_ [] "Isaac Hiram Lopez Diaz"
        h3_ [] "Computer Scientist"
        img_ [class_ "crime", src_ "/images/crime.png", alt_ "crime and punishment"]
