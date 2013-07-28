var Twilio = require('twilio');
Twilio.initialize('AC282d3459f9f433ad7578a0621b3e6669', '7321a55ba898fb87224757cf1a1d71c4');

Parse.Cloud.define("textMentor", function(request, response) {
    Twilio.sendSMS({
      From: "+14088494309",
      To: "+19542604240",
      Body: "Request for help: javascript. Reach me at 4086918871"
    }, {
      success: function(httpResponse) {
        console.log(httpResponse);
        response.success("SMS sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
});
Parse.Cloud.define("textTech", function(request, response) {
    Twilio.sendSMS({
      From: "+14088494309",
      To: "+19542604240",
      Body: "Request for gadgets: ipad. Reach me at 4086918871"
    }, {
      success: function(httpResponse) {
        console.log(httpResponse);
        response.success("SMS sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
});
Parse.Cloud.define("textFood", function(request, response) {
    Twilio.sendSMS({
      From: "+14088494309",
      To: "+19542604240",
      Body: "Request for food: I scream for Ice Cream. Reach me at 4086918871"
    }, {
      success: function(httpResponse) {
        console.log(httpResponse);
        response.success("SMS sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
});



// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
