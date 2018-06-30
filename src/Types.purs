module Types where

type Payment ext = (
    intent :: String, --TODO make in "enum"
    payer :: {
        payment_method:: String
    }
    | ext
)

-- type PaymentExtras = ()