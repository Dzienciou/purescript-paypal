module Server where

import Prelude

import Control.IxMonad ((:*>), (:>>=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.AVar (AVAR)
import Control.Monad.Eff.Console (CONSOLE)
import Debug.Trace (traceAny, traceAnyM)
import Hyper.Node.Server (defaultOptionsWithLogging, runServer)
import Hyper.Request (readBody)
import Hyper.Response (closeHeaders, respond, writeStatus)
import Hyper.Status (statusBadRequest, statusOK)
import Node.Buffer (BUFFER)
import Node.HTTP (HTTP)

main :: forall e. Eff (console :: CONSOLE, avar :: AVAR, buffer :: BUFFER, http :: HTTP | e) Unit
main =
  runServer defaultOptionsWithLogging {} onPost
  where 
    onPost =
        readBody :>>=
        case _ of
          "" ->
            writeStatus statusOK
            :*> closeHeaders
            :*> respond "... anyone there?"
          msg ->
            writeStatus statusBadRequest
            :*> closeHeaders
            :*> (traceAny msg (\_ -> respond ("You said: " <> msg)))