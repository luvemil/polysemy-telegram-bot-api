{-# LANGUAGE TemplateHaskell #-}

module Telegram.Effects.Bot where

import Data.Generics.Labels ()
import Data.Generics.Product ()
import Data.Generics.Sum ()
import qualified Data.Text as T
import Polysemy
import Telegram.Bot as TG

type Result a = Either String a

type TargetId = T.Text

data Bot m a where
    SendMessage :: TargetId -> T.Text -> Bot m (Result T.Text)
    GetUpdates :: Bot m (Result T.Text)
    GetMe :: Bot m (Result T.Text)

makeSem ''Bot

runBotToIO :: (Member (Embed IO) r) => String -> Sem (Bot : r) a -> Sem r a
runBotToIO telegramBotToken = interpret $ \m -> do
    let tgEnv =
            TGEnv
                { tgToken = T.pack telegramBotToken
                , tgBaseUrl = tgDefaultBaseUrl
                }
    case m of
        SendMessage target msg -> do
            res <- embed $ T.pack <$> TG.sendMessage tgEnv target msg
            pure $ Right res
        GetUpdates -> do
            res <- embed $ T.pack <$> TG.getUpdates tgEnv
            pure $ Right res
        GetMe -> do
            res <- embed $ T.pack <$> TG.getMe tgEnv
            pure $ Right res