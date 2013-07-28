<?php 
// This php is to be put on your server, and change the URLs in WalkitTalkie.m
// to point to this file's public location. 
require "Services/Twilio/Capability.php";

$accountSid = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; 
$authToken = "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY";

// The app outgoing connections will use: 
$appSid = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

// The client name for incoming connections: 
$clientName = $_REQUEST["ClientName"];

$capability = new Services_Twilio_Capability($accountSid, $authToken);

// This would allow incoming connections as $clientName:
$capability->allowClientIncoming($clientName);

// This allows outgoing connections to $appSid with the "From" parameter being $clientName 
$capability->allowClientOutgoing($appSid, array(), $clientName);

// This would return a token to use with Twilio based on 
// the account and capabilities defined above 
$token = $capability->generateToken();

echo $token; 
?>