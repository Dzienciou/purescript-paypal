module Main where

import Keys
import Prelude

import Control.Monad.Aff (attempt, launchAff, launchAff_, runAff, runAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Promise (toAff)
import Global.Unsafe (unsafeStringify)
import Paypal (ClientId(..), Mode(..), PAYPAL, ClientSecret(..), client, payment, webhook)
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
  aff <- toAff $ payment clien pay
  log $ unsafeStringify aff
  -- aff <- toAff $ webhook clien (writeJSON webh)
  -- log $ unsafeStringify aff