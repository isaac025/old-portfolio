module PagesCss (
    cssList,
    renderCss,
) where

import Clay
import Data.Text (Text)
import Data.Text.Lazy (toStrict)

cssList :: [Css]
cssList = [styleH2, styleH3, imgClass]

renderCss :: Css -> Text
renderCss = toStrict . render

styleH2 :: Css
styleH2 =
    h2 ? do
        display block
        textAlign center

styleH3 :: Css
styleH3 =
    h3 ? do
        display block
        textAlign center

imgClass :: Css
imgClass =
    ".crime" ? do
        display block
        textAlign center
        borderTopWidth (px 0)
        borderRightWidth (px 0)
        borderBottomWidth (px 0)
        borderLeftWidth (px 0)
        borderTopStyle solid
        borderRightStyle solid
        borderBottomStyle solid
        borderLeftStyle solid
