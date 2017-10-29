<?php
// $request = $this->getRequest();


$email = htmlspecialchars($_GET["email"]);
// Create connection
$conn = mysqli_connect("localhost","root","root","AddEmAll");
 
$sql = "SELECT * FROM Users WHERE Email = '$email'";

$result = $conn->query($sql);

$bool = $result->num_rows > 0;

 $response = array(
        'status' => $bool
    );

 echo json_encode($response);

$conn->close();
?>