<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit User</title>
</head>
<body>

<h1> Edit User </h1>

Leave blank the fields you don't want to change, and fill in the fields that you do want to edit. 

<form  method="post" action="edituser.jsp">
	Password:<input name="password" type="text"/> 
	<br>
	Email address:<input name="email" type="text"/> 
	<br>
	<% out.print("<input type=\"hidden\" name=\"userID\" value=\"" + request.getParameter("userID") + "\">"); %>
	<input type="submit" value="submit"/>	
</form>

</body>
</html>