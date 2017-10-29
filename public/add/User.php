<?php


$email = htmlspecialchars($_GET["email"]);
$password = htmlspecialchars($_GET["password"]);
$name = htmlspecialchars($_GET["name"]);

// Create connection
$con=mysqli_connect("localhost","root","root","AddEmAll");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 
$sql = "INSERT INTO Users (Email, Name,Password) VALUES ( '$email' , '$name', '$password')";


if ($con->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}
 
// Close connections
mysqli_close($con);
?>