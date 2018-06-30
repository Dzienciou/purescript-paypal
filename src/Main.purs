module Main where

import Prelude

import Control.Monad.Aff (attempt, launchAff, launchAff_, runAff, runAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Control.Promise
import Control.Monad.Eff.Console (CONSOLE)
import Global.Unsafe (unsafeStringify)
import Paypal (run, PAYPAL)

main :: forall e. Eff (console :: CONSOLE, paypal :: PAYPAL | e) Unit
main = launchAff_ $ do
  a <- attempt $ toAff $ run unit
  log $ unsafeStringify a

-- data Mode = Sandbox | Production

-- foreign import data Client :: Type -> Type

-- client :: Mode -> ClientId -> ClientSecret -> Eff (Client Mode)
-- client m cId cSecret =
--    clientImpl (serMode m) cId cSecret
--    where
--    serMode Sandbox = "sandbox"
--    serMode Production = "production"
-- foreign import clientImpl :: String -> String -> String
-- tam jeszcez w tym client powinno być (unwrap cId) (unwrap cSecret)
-- bo to pewnie jakieś newtype będą type (newtype ClientSecret = ClientSecret String)
-- zły typ podałem dla clientImpl - powinien miec String -> String -> String -> Eff ? (Client Mode)
-- lub po prostu ClientMode bez Eff
-- Bo to będzie "raczej" czysty konstrutkor