<?php 
require_once '../includes/DbOperation.php';
 
$response = array();
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
 
    if (isset($_POST['email']) && isset($_POST['password'])) {
 
        $db = new DbOperation();
 
        if ($db->userLogin($_POST['email'], $_POST['password'])) {
            $response['error'] = false;
            $response['user'] = $db->getUserByEmail($_POST['email']);
        } else {
            $response['error'] = true;
            $response['message'] = 'Invalid username or password';
        }
 
    } else {
        $response['error'] = true;
        $response['message'] = 'Parameters are missing';
    }
 
} else {
    $response['error'] = true;
    $response['message'] = "Request not allowed";
}
 
echo json_encode($response);

?>