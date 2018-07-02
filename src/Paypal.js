'use strict';
const paypal = require('paypal-rest-sdk');
const payments = paypal.v1.payments;
const webhooks = paypal.v1.webhooks;

exports.executeImpl = function(client) {
  return function(paymentId){
    return function(payerId){

      var body = {"payer_id" : payerId}
      var request = new payments.PaymentExecuteRequest(paymentId);
      request.requestBody(body);
      return client.execute(request).then(function (response) {
        console.log(response.statusCode);
        return response;
      }).catch(function(error) {
        console.error(error.statusCode);
        console.error(error.message);
      });
    
    };
  };
}

exports.paymentImpl = function(client) {
  return function(payment) {
    var paymentJson = JSON.parse(payment)
    var request = new payments.PaymentCreateRequest();
    request.requestBody(paymentJson);
    
    return client.execute(request).then(function (response) {
      console.log(response.statusCode);
      return response;
    }).catch(function(error) {
      console.error(error.statusCode);
      console.error(error.message);
    });
  }
}

exports.webhook = function(client){
  return function(webhook) {
    var webhookJson = JSON.parse(webhook)
    var request = new webhooks.WebhookCreateRequest();
    request.requestBody(webhookJson);
    
    return client.execute(request).then(function (response) {
      console.log(response.statusCode);
      return (response.result);
    }).catch(function(error) {
      console.error(error.statusCode);
      console.error(error.message);
    });
};
}

exports.clientImpl = 
 function(mode){
   return function(id){
     return function(secret){
       var env;
        if (mode === 'production') {
          // Live Account details
          env = new paypal.core.LiveEnvironment('Your Live Client ID', 'Your Live Client Secret');
        } else {
          env = new paypal.core.SandboxEnvironment(id, secret);
        }
        return new paypal.core.PayPalHttpClient(env);
      };
    };
   };
