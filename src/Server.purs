module Server where

import Prelude

import Control.IxMonad ((:*>), (:>>=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.AVar (AVAR)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Argonaut (Json, jsonParser)
import Data.Either (Either)
import Data.Foreign (ForeignError(..))
import Data.List.Types (NonEmptyList(..))
import Data.Maybe (Maybe(..))
import Data.Record.Fold (collect)
import Data.StrMap (StrMap)
import Data.Variant (Variant)
import Debug.Trace (traceAny, traceAnyM)
import Hyper.Node.Server (defaultOptionsWithLogging, runServer)
import Hyper.Request (readBody)
import Hyper.Response (closeHeaders, respond, writeStatus)
import Hyper.Status (statusBadRequest, statusOK)
import Node.Buffer (BUFFER)
import Node.HTTP (HTTP)
import Polyform.Validation (V(..), Validation(..), hoistFnMV, hoistFnV, runValidation)
import Simple.JSON (readJSON)
import Types (Notification, Resource, Amount)
import Validators.Affjax (valJson)
import Validators.Json (JsError, arrayOf, field, int, number, string)

main :: forall e. Eff (console :: CONSOLE, avar :: AVAR, buffer :: BUFFER, http :: HTTP | e) Unit
main =
  runServer defaultOptionsWithLogging {} onNotif
  where 
    onNotif =
        readBody :>>=
        case _ of
          "" ->
            writeStatus statusBadRequest
            :*> closeHeaders
            :*> respond "... anyone there?"
          msg ->
            writeStatus statusOK
            :*> closeHeaders
            :*> runValidation notificationJson msg
            :*> (traceAny ((runValidation notificationJson msg):: Maybe _) (\_ -> respond ("You said: " <> msg)))


readMsg :: String -> Either String Json
readMsg msg = jsonParser msg



notificationJson = notification <<< valJson

notification
  :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (Notification)
notification = collect
  { id: field "id" string
  , event_type: field "event_type" string
  , resource: field "resource" resource
  }

resource
  :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (Resource)
resource = collect
  { id: field "id" string
  , amount: field "amount" amount
  }

amount
  :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (Amount)
amount = collect
  { currency: field "currency" string
  , total: field "total" string
  }
  

readBodyValidation = 
        hoistFnV $ case _ of
          "" ->
            Invalid []
          msg ->
            Valid [] msg


