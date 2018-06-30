'use strict';
const paypal = require('paypal-rest-sdk');
const payments = paypal.v1.payments;



exports.run = function(x) {
    var env;
    if (process.env.NODE_ENV === 'production') {
      // Live Account details
      env = new paypal.core.LiveEnvironment('Your Live Client ID', 'Your Live Client Secret');
    } else {
      env = new paypal.core.SandboxEnvironment('ASr4YVgmQkWBm_K6jaleMivNcEek-kTwS1YPjbiuWQUtWMyLsDs0k0m6DYsJjRu0FCS76r9DF91HYZPn','EMaAOBvwKAnJLr8q-BQnf1zAtECgVwbgTGiGbHEJCX0t4i4E64g1cIdzsB-5py4LjM1YHpZp4zGL9pNy')
        //'AdV4d6nLHabWLyemrw4BKdO9LjcnioNIOgoz7vD611ObbDUL0kJQfzrdhXEBwnH8QmV-7XZjvjRWn0kg', 'EPKoPC_haZMTq5uM9WXuzoxUVdgzVqHyD5avCyVC1NCIUJeVaNNUZMnzduYIqrdw-carG9LBAizFGMyK');
    }
    
    var client = new paypal.core.PayPalHttpClient(env);
    
    var payment = {
      "intent": "sale",
      "transactions": [{
        "item_list": {
            "items": [{
                "name": "item",
                "sku": "item",
                "price": "1.00",
                "currency": "USD",
                "quantity": 1
            }]
        },
        "amount": {
            "currency": "USD",
            "total": "1.00"
        },
        "description": "This is the payment description."
        }],
      "redirect_urls": {
        "cancel_url": "http://example.com/cancel",
        "return_url": "http://example.com/return"
      },
      "payer": {
        "payment_method": "paypal"
      }
    };
    
    
    
    
    var request = new payments.PaymentCreateRequest();
    request.requestBody(payment);
    
    var result = client.execute(request).then(function (response) {
      console.log(response.statusCode);
      return (response.result);
    }).catch(function(error) {
      console.error(error.statusCode);
      console.error(error.message);
    });
    return result;
}

