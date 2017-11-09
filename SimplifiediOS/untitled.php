<?php 
include_once "includes/Constants.php"; ?>
<html>
<body>
<h1>Sample page</h1>
<?php

  // /* Connect to MySQL and select the database. */
  $connection = mysqli_connect(DB_HOST, DB_USERNAME, DB_PASSWORD);

  if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

  $database = mysqli_select_db($connection, DB_DATABASE);

  // /* Ensure that the Employees table exists. */
  VerifyUsersTable($connection, DB_DATABASE); 

  // /* If input fields are populated, add a row to the Employees table. */
 
  $employee_email = htmlentities($_POST['Email']);
  $employee_name = htmlentities($_POST['Name']);
  $employee_password = htmlentities($_POST['Password']);
  $employee_facebook = htmlentities($_POST['Facebook']);
  $employee_twitter = htmlentities($_POST['Twitter']);
  $employee_instagram = htmlentities($_POST['Instagram']);
  $employee_snapchat = htmlentities($_POST['Snapchat']);

  if (strlen($employee_password) || strlen($employee_email) || strlen($employee_name)) {
    AddUser($connection, $employee_email, $employee_name, $employee_password);
  }
?>

<!-- Input form -->
<form action="<?PHP echo $_SERVER['SCRIPT_NAME'] ?>" method="POST">
  <table border="0">
    <tr>
      <td>Name</td>
      <td>Address</td>
    </tr>
    <tr>
      <td>
        <input type="text" name="Email" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="Name" maxlength="90" size="60" />
      </td>
      <td>
        <input type="text" name="Password" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="Facebook" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="Twitter" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="Instagram" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="Snapchat" maxlength="45" size="30" />
      </td>
      <td>
        <input type="submit" value="Add Data" />
      </td>
    </tr>
  </table>
</form>

<!-- Display table data. -->
<table border="1" cellpadding="2" cellspacing="2">
  <tr>
    <td>Email</td>
    <td>Name</td>
    <td>Password</td>
    <td>Facebook</td>
    <td>Twitter</td>
    <td>Instagram</td>
    <td>Snapchat</td>
  </tr>

<?php

$result = mysqli_query($connection, "SELECT * FROM Users"); 

while($query_data = mysqli_fetch_row($result)) {
  echo "<tr>";
  echo "<td>",$query_data[0], "</td>",
    "<td>",$query_data[1], "</td>",
    "<td>",$query_data[2], "</td>",
"<td>",$query_data[3], "</td>",
 "<td>",$query_data[4], "</td>",
 "<td>",$query_data[5], "</td>",
 "<td>",$query_data[6], "</td>";
  echo "</tr>";
}
?>

</table>

<!-- Clean up. -->
<?php

  mysqli_free_result($result);
  mysqli_close($connection);

?>

</body>
</html>


<?php

// /* Add an employee to the table. */
function AddUser($connection, $email, $name, $password) {

   $n = mysqli_real_escape_string($connection, $name);
   $e = mysqli_real_escape_string($connection, $email);
   $p = mysqli_real_escape_string($connection, md5($password));

   $query = "INSERT INTO Users (Email, Name, Password) VALUES ('$e', '$n' , '$p');";

   if(!mysqli_query($connection, $query)) echo("<p>Error adding user data.</p>");
}

// /* Check whether the table exists and, if not, create it. */
function VerifyUsersTable($connection, $dbName) {
  if(!TableExists("Users", $connection, $dbName)) 
  { 
     $query = "CREATE TABLE Users (
                Email varchar(45) NOT NULL PRIMARY KEY,
                Name varchar(45) DEFAULT NULL,
                Password varchar(45) DEFAULT NULL,
                Facebook varchar(45) DEFAULT NULL,
                Twitter varchar(45) DEFAULT NULL,
                Instagram varchar(45) DEFAULT NULL,
                Snapchat varchar(45) DEFAULT NULL
                
              )";

     if(!mysqli_query($connection, $query)) echo("<p>Error creating table.</p>");
  }
}

// /* Check for the existence of a table. */
function TableExists($tableName, $connection, $dbName) {
  $t = mysqli_real_escape_string($connection, $tableName);
  $d = mysqli_real_escape_string($connection, $dbName);

  $checktable = mysqli_query($connection, 
      "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$t' AND TABLE_SCHEMA = '$d'");

  if(mysqli_num_rows($checktable) > 0) return true;

  return false;
}
?>
   