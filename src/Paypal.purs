module Paypal where

import Control.Monad.Eff (kind Effect)
import Control.Promise (Promise)
import Data.Argonaut (Json)
import Data.Newtype (class Newtype, unwrap)
import Simple.JSON (writeJSON)
import Types (Payment, Intent(..), PaymentMethod(..), Webhook, Execute)

foreign import data PAYPAL :: Effect

foreign import ffipayment :: Client Mode -> String -> Promise String
foreign import webhook :: Client Mode -> String -> Promise String
foreign import ffiexecute :: Client Mode -> String -> String -> Promise String

execute :: Client Mode -> Execute -> Promise String
execute cl executeRecord = ffiexecute cl (executeRecord.paymentId) (executeRecord.payerId)

payment :: Client Mode -> Payment -> Promise String
payment client pay = ffipayment client (writeJSON pay)


data Mode = Sandbox | Production
newtype ClientId = ClientId String --TODO sholud be newtype
derive instance newtypeClientId :: Newtype ClientId _

newtype ClientSecret = ClientSecret String
derive instance newtypeClientSecret :: Newtype ClientSecret _

foreign import data Client :: Type -> Type

--TODO: now client impl in js ignores Mode

client :: forall ext. Mode -> ClientId -> ClientSecret -> Client Mode-- Aff (paypal :: PAYPAL | ext) (Client Mode)
client m cId cSecret =
    clientImpl (serMode m) (unwrap cId) (unwrap cSecret)
    where
      serMode Sandbox = "sandbox"
      serMode Production = "production"

foreign import clientImpl :: forall ext. String -> String -> String -> Client Mode -- Aff ( paypal :: PAYPAL | ext) (Client Mode)

