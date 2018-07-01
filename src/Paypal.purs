module Paypal where

import Control.Monad.Eff (kind Effect)
import Control.Promise (Promise)
import Data.Argonaut (Json)

foreign import data PAYPAL :: Effect

foreign import payment :: forall e. Client Mode -> String -> Promise String
foreign import webhook :: forall e. Client Mode -> String -> Promise String

data Mode = Sandbox | Production
type ClientId = String --TODO sholud be newtype
type ClientSecret = String


foreign import data Client :: Type -> Type

--TODO: now client impl in js ignores Mode

client :: forall ext. Mode -> ClientId -> ClientSecret -> Client Mode-- Aff (paypal :: PAYPAL | ext) (Client Mode)
client m cId cSecret =
    clientImpl (serMode m) cId cSecret
    where
      serMode Sandbox = "sandbox"
      serMode Production = "production"

foreign import clientImpl :: forall ext. String -> String -> String -> Client Mode -- Aff ( paypal :: PAYPAL | ext) (Client Mode)
