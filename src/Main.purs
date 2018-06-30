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
import Paypal (Mode(..), PAYPAL, client, payment)
import Types (Payment)
import Simple.JSON (writeJSON)

pay :: Payment
pay = {
    intent: "sale", --TODO make in "enum"
    payer : {
        payment_method: "paypal"
    },
    redirect_urls: {
        cancel_url : "http://example.com/cancel",
        return_url : "http://example.com/return"
      }
  }

main :: forall e. Eff (console :: CONSOLE, paypal :: PAYPAL | e) Unit
main = launchAff_ $ do
  let clien = client Sandbox clientId secret
  aff <- toAff $ payment clien (writeJSON pay)
  log $ unsafeStringify aff