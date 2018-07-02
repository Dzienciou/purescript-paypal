module Paypal where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (kind Effect)
import Control.Promise (Promise, toAff)
import Data.Argonaut (Json)
import Data.List (List)
import Data.Newtype (class Newtype, unwrap)
import Data.Traversable (sequence)
import Data.Variant (Variant)
import Debug.Trace (traceAny)
import Json (executeResponse, paymentResponse)
import Polyform.Validation (V(..), Validation(..), hoistFn, hoistFnMV, hoistFnV)
import Simple.JSON (class WriteForeign, writeJSON)
import Types (Execute, ExecuteResponse, Intent(..), Payment, PaymentMethod(..), Webhook, PaymentResponse)
import Validators.Affjax (valJson)
import Validators.Json (JsError)

foreign import data PAYPAL :: Effect

foreign import paymentImpl :: Client Mode -> String -> Promise Json
foreign import webhook :: Client Mode -> String -> Promise String
foreign import executeImpl :: Client Mode -> String -> String -> Promise Json

execute cl executeRecord = Valid [] <$> (toAff $ executeImpl cl (executeRecord.paymentId) (executeRecord.payerId))

executeValidation :: forall err t.
  Client Mode
  -> Validation (Aff t)
       (Array (Variant (JsError err)))
       Execute
       ExecuteResponse
executeValidation mode = hoistFnV(status 200) <<< executeResponse <<<  hoistFnMV(execute mode)

payment :: forall t12 t8. Client Mode -> Payment -> Aff t12 (V (Array t8) Json)
payment client pay = Valid [] <$> (toAff $ paymentImpl client (writeJSON pay))

paymentValidation :: forall err t.
  Client Mode
  -> Validation (Aff t)
       (Array (Variant (JsError err)))
       Payment
       PaymentResponse
paymentValidation mode = hoistFnV(status 201) <<< paymentResponse <<<  hoistFnMV(payment mode)
  
status 
  :: forall t3 t7
   . Int 
  -> { statusCode :: Int | t3 }
  -> V (Array t7) { statusCode :: Int | t3}
status code response = 
    if response.statusCode == code then
      Valid [] response
    else 
      Invalid []

data Mode = Sandbox | Production
newtype ClientId = ClientId String
derive instance newtypeClientId :: Newtype ClientId _

newtype ClientSecret = ClientSecret String
derive instance newtypeClientSecret :: Newtype ClientSecret _

foreign import data Client :: Type -> Type

--TODO: now client impl in js ignores Mode

client :: forall ext. Mode -> ClientId -> ClientSecret -> Client Mode
client m cId cSecret =
    clientImpl (serMode m) (unwrap cId) (unwrap cSecret)
    where
      serMode Sandbox = "sandbox"
      serMode Production = "production"

foreign import clientImpl :: forall ext. String -> String -> String -> Client Mode
