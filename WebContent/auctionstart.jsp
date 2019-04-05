<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>New Auction</title>
</head>
<body>
<div>
	To begin adding an auction, look up the book you want to sell by its ISBN-10:
	<br>
	<form  method="post" action="addauction.jsp">
	<br>
	ISBN: <input name="isbn" type="text"/>
	<br>
	<input type="submit" value="submit"/>
	</form>
	<br>
</div>

</body>
</html>