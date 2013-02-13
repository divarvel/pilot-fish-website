--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Applicative ((<$>))
import           Control.Monad       (forM_)
import           Data.Monoid         (mappend)
import           Hakyll


--------------------------------------------------------------------------------
langs = ["fr", "en"]
defaultLang = "fr"

main :: IO ()
main = hakyll $ do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler
    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    forM_ ["fr","en"] $ \lang -> match (fromGlob $ lang ++ "/*.markdown") $ do
        route   $ langRoute `composeRoutes` (setExtension "html")
        compile $ pandocCompiler
            >>= loadAndApplyTemplate (fromFilePath $ "templates/menu-"++ lang ++".html") defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
langRoute :: Routes
langRoute = gsubRoute (defaultLang ++ "/") (const "")
