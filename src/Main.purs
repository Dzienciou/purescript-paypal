module Main where

import Keys (clientId, secret)
import Prelude (Unit, bind, discard, ($))

import Control.Monad.Aff (launchAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Global.Unsafe (unsafeStringify)
import Paypal (ClientId(ClientId), ClientSecret(ClientSecret), Mode(Sandbox), PAYPAL, client, executeValidation, paymentValidation)
import Polyform.Validation (runValidation)
import Types (Payment, Intent(..), PaymentMethod(..), Webhook)

pay :: Payment
pay = {
    intent: Sale, --TODO make in "enum"
    payer : {
        payment_method: Paypal
    },
    redirect_urls: {
        cancel_url : "http://example.com/cancel",
        return_url : "http://example.com/return"
      },
    transactions : [{
      item_list : {
          items : [{
              name : "item",
              sku : "item",
              price : 1.00,
              currency : "USD",
              quantity : 1
          }]
      },
      amount : {
          currency : "USD",
          total : "1.00"
      },
      description : "This is the payment description."
      }]
}
webh::Webhook
webh = {
  url : "https://saltem.serveo.net",
  event_types: [
    {
      name: "PAYMENT.AUTHORIZATION.CREATED"
    },
    {
      name: "PAYMENT.AUTHORIZATION.VOIDED"
    }
  ]
}

main :: forall e. Eff (console :: CONSOLE, paypal :: PAYPAL | e) Unit
main = launchAff_ $ do
  let clien = client Sandbox (ClientId clientId) (ClientSecret secret)
  aff <- runValidation (paymentValidation clien) pay
  log $ unsafeStringify aff
  aff1 <- runValidation (executeValidation clien) {paymentId: "PAY-3KM72955519730726LM5CQNA" , payerId: "62RKLLSMXRL5S"}
  log $ unsafeStringify aff1

  -- aff <- toAff $ webhook clien (writeJSON webh)
  -- log $ unsafeStringify aff