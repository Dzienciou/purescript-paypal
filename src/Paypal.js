'use strict';
const paypal = require('paypal-rest-sdk');
const payments = paypal.v1.payments;



exports.payment = function(client) {
  return function(payment) {

    var paymentJson = JSON.parse(payment)
    var request = new payments.PaymentCreateRequest();
    request.requestBody(paymentJson);
    
    return client.execute(request).then(function (response) {
      console.log(response.statusCode);
      return (response.result);
    }).catch(function(error) {
      console.error(error.statusCode);
      console.error(error.message);
    });
  }
}

exports.clientImpl = 
 function(mode){
   return function(id){
     return function(secret){
        var env = new paypal.core.SandboxEnvironment(id,secret);
        return new paypal.core.PayPalHttpClient(env);
    };
   };
 };
