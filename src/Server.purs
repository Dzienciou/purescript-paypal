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
import Data.StrMap (StrMap)
import Debug.Trace (traceAny, traceAnyM)
import Hyper.Node.Server (defaultOptionsWithLogging, runServer)
import Hyper.Request (readBody)
import Hyper.Response (closeHeaders, respond, writeStatus)
import Hyper.Status (statusBadRequest, statusOK)
import Node.Buffer (BUFFER)
import Node.HTTP (HTTP)
import Simple.JSON (readJSON)

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
            :*> (traceAny (readMsg msg) (\_ -> respond ("You said: " <> msg)))


readMsg :: String -> Either String Json
readMsg msg = jsonParser msg

-- searchResult
--   :: forall err m
--    . Monad m
--   => Validation m
--       (Array (Variant (JsError err)))
--       Json
--       (Notification)
-- searchResult = collect
--   { page: field "page" int
--   , perPage: field "per_page" int
--   , totalCount: field "total_count" int
--   , searchId: field "search_id" string
--   , photos: field "data" $ arrayOf image
--   }