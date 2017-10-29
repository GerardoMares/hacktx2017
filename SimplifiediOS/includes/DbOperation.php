<?php

class DbOperation
{
    private $conn;
 
    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Constants.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

       /*
     * This method is added
     * We are taking username and password
     * and then verifying it from the database
     * */
 
    public function userLogin($email, $pass)
    {
        $password = md5($pass);
        $stmt = $this->conn->prepare("SELECT Email FROM Users WHERE Email = ? AND Password = ?");
        $stmt->bind_param("ss", $email, $password);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
 
    /*
     * After the successful login we will call this method
     * this method will return the user data in an array
     * */
 
    public function getUserByEmail($email)
    {
        $stmt = $this->conn->prepare("SELECT Email, Name, Facebook, Twitter, Instagram, Snapchat FROM Users WHERE Email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($email, $name, $fb, $tw, $ig, $sc);
        $stmt->fetch();
        $user = array();
        $user['name'] = $name;
        $user['email'] = $email;
        $user['fb'] = $fb;
        $user['tw'] = $fb;
        $user['ig'] = $fb;
        $user['sc'] = $fb;

        return $user;
    }
 
    //Function to create a new user
    public function createUser($email, $pass, $name)
    {
        if (!$this->isUserExist($email)) {
            $password = md5($pass);
            $stmt = $this->conn->prepare("INSERT INTO Users (Email, Name, Password) VALUES (?, ?, ?)");
            $stmt->bind_param("sss", $email, $name, $password);
            if ($stmt->execute()) {
                return USER_CREATED;
            } else {
                return USER_NOT_CREATED;
            }
        } else {
            return USER_ALREADY_EXIST;
        }
    }
 
 
    private function isUserExist($email)
    {
        $stmt = $this->conn->prepare("SELECT Email FROM Users WHERE Email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    public function updateAccount($email, $account, $value) {
        if (!$this->isUserExist($email)) {
            $stmt = $this->conn->prepare("UPDATE Users SET $account = '$value' WHERE Email = '$email'");
            if ($stmt->execute()) {
                return OK;
            } else {
                return NOTOK;
            }
        } else {
            return USER_ALREADY_EXIST;
        }

    }
}
?>