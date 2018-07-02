module Types where


import Simple.JSON (class WriteForeign, write)

data Intent = Sale | Authorize | Order

instance intentWriter :: WriteForeign Intent  where
  writeImpl = case _ of 
    Sale -> write "sale"
    Authorize -> write "authorize"
    Order -> write "order"

data PaymentMethod = Paypal | CreditCard
-- From API Docs: "The use of the PayPal REST /payments APIs to accept credit card payments is restricted"
instance paymentMethodWriter :: WriteForeign PaymentMethod  where
  writeImpl = case _ of 
    Paypal -> write "paypal"
    CreditCard -> write "credit_card"

type Payment = {
    intent :: Intent,
    payer :: {
        payment_method :: PaymentMethod
    },
    redirect_urls :: {
        cancel_url :: String,
        return_url :: String
      },
    transactions :: Array Transaction
}

type Transaction = {item_list :: {items :: Array Item}, amount :: Amount, description :: String}
type Item = {name :: String, sku :: String, price :: Number, currency :: String, quantity:: Int}
type Amount = {currency :: String, total :: String}

type Webhook = {
    url :: String,
    event_types :: Array EventType 
}
type EventType = {
    name :: String
--  ,  status :: String
}

type Notification = 
  {  id :: String
  ,  event_type :: String 
  ,  resource :: Resource
  }

type Resource = 
    { id :: String
    , amount :: Amount
    }

type Execute = 
  {  paymentId :: String
  ,  payerId :: String
  }