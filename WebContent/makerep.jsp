<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Customer Representative</title>
</head>
<body>
<div>
	<form  method="post" action="registerquery.jsp">
	Enter a username:<input name="username" type="text"/> 
	<br>
	Enter a password:<input name="password" type="text"/> 
	<br>
	Enter an email address:<input name="email" type="text"/> 
	<br>
<!-- 	this is a hidden attribute that sends the user type to registerquery -->
	<input type="hidden" id="usertype" name="usertype" value="cust_rep">
	<input type="submit" value="submit"/>
	</form>
	<br>
</div>

</body>
</html>