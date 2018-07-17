<?php
	$ch = curl_init("http://127.0.0.1:30001/user/1024/name");
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	// stepWindow equals 30
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
		'Token: ' . hash('sha256', "5f8d6d88-6c6e-46a4-af5d-a2834d3c1022" . (int)(time() / 30)),
	));
	var_dump(json_decode(curl_exec($ch), true));
?>