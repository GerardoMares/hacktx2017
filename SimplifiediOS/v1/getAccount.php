<?php

require_once '../includes/DbOperation.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
    if (!verifyRequiredParams(array('email', 'account'))) {
    	$email = $_POST['email'];
        $account = $_POST['account'];

        $db = new DbOperation();

        $result = $db->getAccount($email, $account);
        
        if ($result != NOTOK) {
        	$response['error'] = false;
            $response['account'] = $result;
        }
    }
}



function verifyRequiredParams($required_fields) {
 
    //Getting the request parameters
    $request_params = $_REQUEST;
 
    //Looping through all the parameters
    foreach ($required_fields as $field) {
        //if any requred parameter is missing
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
 
            //returning true;
            return true;
        }
    }
    return false;
}

echo json_encode($response);

?>
