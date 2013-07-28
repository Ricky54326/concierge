<?php
	$clientName = $_REQUEST["ClientName"];
	header('Content-type: text/xml');
?>

<Response>
	<Dial callerId="##########"><!-- replace this number with a validated 
									 Twilio number in your account -->
		<Client><?php echo $clientName; ?></Client>
	</Dial>
</Response>


 

 