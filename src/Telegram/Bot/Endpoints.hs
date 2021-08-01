module Telegram.Bot.Endpoints where

import qualified Data.Text as T

data TGEnv = TGEnv
    { tgToken :: T.Text
    , tgBaseUrl :: T.Text
    }

type TGMethod = String

tgDefaultBaseUrl :: T.Text
tgDefaultBaseUrl = "https://api.telegram.org/"

buildEndpoint :: TGEnv -> TGMethod -> String
buildEndpoint TGEnv{..} method =
    T.unpack tgBaseUrl -- TODO: Ensure ends in /
        ++ "bot"
        ++ T.unpack tgToken
        ++ "/"
        ++ method