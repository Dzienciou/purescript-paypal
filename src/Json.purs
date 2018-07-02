module Json where


import Prelude

import Data.Argonaut (Json)
import Data.Record.Fold (collect)
import Data.Variant (Variant)
import Polyform.Validation (Validation(..))
import Types (Amount, ExecuteResponse, ExecuteResult, Link, Notification, PaymentResult, Resource, PaymentResponse)
import Validators.Json (JsError, arrayOf, field, int, string)


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

paymentResponse :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (PaymentResponse)
paymentResponse = collect
  { statusCode: field "statusCode" int
  , result: field "result" paymentResult
  }


paymentResult :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (PaymentResult)
paymentResult = collect
  { id: field "id" string
  , intent: field "intent" string
  , state: field "state" string
  , links: field "links" $ arrayOf link
  }

link :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (Link)
link = collect
  { href: field "href" string
  , rel: field "rel" string
  , method: field "method" string
  }

executeResponse :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (ExecuteResponse)
executeResponse = collect
  { statusCode: field "statusCode" int
  , result: field "result" executeResult
  }

executeResult :: forall err m
   . Monad m
  => Validation m
      (Array (Variant (JsError err)))
      Json
      (ExecuteResult)
executeResult = collect
  { id: field "id" string
  }