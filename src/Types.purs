module Types where

import Prelude

type PaymentRow ext = (
    intent :: String, --TODO make in "enum"
    payer :: {
        payment_method :: String
    },
    redirect_urls :: {
        cancel_url :: String,
        return_url :: String
      }
    | ext
)

type Payment = Record (PaymentRow ())

-- type PaymentExtras = (transactions :: Array Transaction)
-- type Transaction = (item_list :: )

-- var payment = {
--       "intent": "sale",
--       "transactions": [{
--         "item_list": {
--             "items": [{
--                 "name": "item",
--                 "sku": "item",
--                 "price": "1.00",
--                 "currency": "USD",
--                 "quantity": 1
--             }]
--         },
--         "amount": {
--             "currency": "USD",
--             "total": "1.00"
--         },
--         "description": "This is the payment description."
--         }],
--       "redirect_urls": {
--         "cancel_url": "http://example.com/cancel",
--         "return_url": "http://example.com/return"
--       },
--       "payer": {
--         "payment_method": "paypal"
--       }
--     };