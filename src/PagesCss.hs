module PagesCss (
    cssList,
    renderCss,
) where

import Clay
import Clay.Selector (selectorFromText)
import Data.Text (Text)
import Data.Text.Lazy (toStrict)

cssList :: [Css]
cssList =
    [ styleBody
    , styleNav
    , navItemClass
    , h2Style
    , h2Class
    , h3Style
    , h4Style
    , h5Style
    , navItemHover
    , boxClass
    , boxHeaderClass
    , boxLinkClass
    , iconLinkClass
    , textLinkClass
    ]

renderCss :: Css -> Text
renderCss = toStrict . render

styleBody :: Css
styleBody =
    body ? do
        display block
        textAlign center
        background black
        fontFamily ["Courier"] [sansSerif]

styleNav :: Css
styleNav =
    nav ? do
        display flex
        justifyContent center
        padding (px 10) (px 10) (px 10) 0

h2Style :: Css
h2Style =
    h2 ? do
        color "#00cc00"

h3Style :: Css
h3Style =
    h3 ? do
        color "#00cc00"

h4Style :: Css
h4Style =
    h4 ? do
        color "#00cc00"

h5Style :: Css
h5Style =
    h5 ? do
        color "#00cc00"

navItemClass :: Css
navItemClass =
    ".nav-item" ? do
        margin 0 0 0 (px 15)
        padding (px 5) (px 5) (px 15) (px 15)
        textDecoration none
        color darkgreen
        border (px 2) solid transparent
        transition "all" (sec 0.3) ease 0

navItemHover :: Css
navItemHover =
    selectorFromText ".nav-item" # hover ? do
        color "#00cc00"
        transform $ scale 1.1 1.1

boxClass :: Css
boxClass =
    ".box" ? do
        display displayTable
        height (pct 100)
        width (pct 100)
        textAlign center

h2Class :: Css
h2Class = do
    ".box" ? do
        h2 ? do
            fontSize (px 80)
            marginBottom (px 5)

boxHeaderClass :: Css
boxHeaderClass =
    ".box-header" ? do
        display tableCell
        verticalAlign middle

boxLinkClass :: Css
boxLinkClass =
    ".box-link" ? do
        marginRight (px 25)
        marginBottom (px 30)

iconLinkClass :: Css
iconLinkClass =
    ".icon-link" ? do
        width (px 32)
        marginRight (px 10)

textLinkClass :: Css
textLinkClass =
    ".icon-link" ? do
        marginRight (px 20)
        fontSize (px 10)
