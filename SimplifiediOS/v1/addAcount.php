<?php

require_once '../includes/DbOperation.php';
 
$response = array();
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
    if (!verifyRequiredParams(array('email', 'account', 'value'))) {
        //getting values

        
        $email = $_POST['email'];
        $account = $_POST['account'];
        $value = $_POST['value'];

 
        //creating db operation object
        $db = new DbOperation();
 
        //adding user to database
        $result = $db->updateAccount($email, $account, $value);
 
        //making the response accordingly
        if ($result == OK) {
            $response['error'] = false;
            $response['message'] = 'User updated successfully';
        } else {
            $response['error'] = true;
            $response['message'] = 'Some error occurred';
        }

    } else {
        $response['error'] = true;
        $response['message'] = 'Required parameters are missing';
    }

} else {
    $response['error'] = true;
    $response['message'] = 'Invalid request';
}
 
//function to validate the required parameter in request
function verifyRequiredParams($required_fields)
{
 
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