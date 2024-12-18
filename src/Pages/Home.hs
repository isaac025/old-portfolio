module Pages.Home where

import Lucid
import Pages.Base

homePage :: Html ()
homePage =
    base $ do
        h2_ [] "Isaac H. Lopez Diaz"
        h3_ [] "Software engineer from PR"
        br_ []
        h4_ [] "Interest: Programming Languages, Functional Programming"
        h4_ [] "Computer Architecture, Homotopy Type Theory, etc."
        br_ []
        h4_ [] "I enjoy making music :)"
