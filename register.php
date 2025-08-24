<?php
$servername = "localhost";
$username = "rohit";   // your MySQL username
$password = "password"; // your MySQL password
$dbname = "userDB";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// Get form data
$user = $_POST['username'];
$pass = $_POST['password'];

// ⚠️ Storing as plain text (NOT recommended in real projects)
$sql = "INSERT INTO users (username, password) VALUES ('$user', '$pass')";

if ($conn->query($sql) === TRUE) {
  // Redirect to welcome.html after successful login/registration
  header("Location: welcome.html");
  exit();
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>



