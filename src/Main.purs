module Main where

import Prelude

import Control.Monad.Aff (attempt, launchAff, launchAff_, runAff, runAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Promise (toAff)
import Global.Unsafe (unsafeStringify)
import Paypal (Mode(..), PAYPAL, client, run)
import Keys

main :: forall e. Eff (console :: CONSOLE, paypal :: PAYPAL | e) Unit
main = launchAff_ $ do
  let clien = client Sandbox clientId secret
  aff <- toAff $ run clien
  log $ unsafeStringify aff