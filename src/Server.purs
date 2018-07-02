module Server where

import Prelude

import Control.IxMonad ((:*>), (:>>=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.AVar (AVAR)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Argonaut (Json, jsonParser)
import Data.Either (Either)
import Data.Maybe (Maybe)
import Debug.Trace (traceAny)
import Hyper.Node.Server (defaultOptionsWithLogging, runServer)
import Hyper.Request (readBody)
import Hyper.Response (closeHeaders, respond, writeStatus)
import Hyper.Status (statusBadRequest, statusOK)
import Node.Buffer (BUFFER)
import Node.HTTP (HTTP)
import Polyform.Validation (runValidation)
import Json (notification)
import Validators.Affjax (valJson)

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
