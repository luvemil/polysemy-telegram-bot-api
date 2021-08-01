module Telegram.Bot.Calls where

import Control.Lens.Operators
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.Text as T
import Network.Wreq (FormParam ((:=)))
import qualified Network.Wreq as Wreq
import Network.Wreq.Lens
import Telegram.Bot.Endpoints

getUpdates :: TGEnv -> IO String
getUpdates env = do
    let endpoint = buildEndpoint env "getUpdates"
    res <- Wreq.get endpoint
    let body :: String = BS.unpack $ res ^. responseBody
    pure body

getMe :: TGEnv -> IO String
getMe env = do
    let endpoint = buildEndpoint env "getMe"
    res <- Wreq.get endpoint
    let body :: String = BS.unpack $ res ^. responseBody
    pure body

sendMessage :: TGEnv -> T.Text -> T.Text -> IO String
sendMessage env target msg = do
    let endpoint = buildEndpoint env "sendMessage"
    res <- Wreq.post endpoint ["chat_id" := target, "text" := msg]
    let body :: String = BS.unpack $ res ^. responseBody
    pure body