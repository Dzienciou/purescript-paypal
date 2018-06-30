module Paypal where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (kind Effect)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Promise 

foreign import data PAYPAL :: Effect

foreign import run :: forall e. Unit -> Promise String


