<?php
// $request = $this->getRequest();


$account = htmlspecialchars($_GET["account"]);
$value = htmlspecialchars($_GET["value"]);
$email = htmlspecialchars($_GET["email"]);
$id = htmlspecialchars($_GET["id"]);

// Create connection
$con=mysqli_connect("localhost","root","root","AddEmAll");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 
// This SQL statement selects ALL from the table 'Locations'
$sql = "UPDATE Users SET $account = '$value' WHERE Email = '$email'";

 
if ($con->query($sql) === TRUE) {
    echo "Account updated successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}


 
// Close connections
mysqli_close($con);
?>