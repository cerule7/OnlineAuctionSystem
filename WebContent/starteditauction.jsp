<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Auction</title>
</head>
<body>

<h1> Edit Auction </h1>

Leave blank the fields you don't want to change, and fill in the fields that you do want to edit. 

<form  method="post" action="editauction.jsp">
	<br>
	Starting price: <input name="startprice" pattern="^\d*(\.\d{0,2})?$" />
	<br>
	Minimum price: <input name="minprice" pattern="^\d*(\.\d{0,2})?$" />
	<br>
	Minimum increment: <input name="minincrement" pattern="^\d*(\.\d{0,2})?$" />
	<br>
	Start date (YYYY-MM-DD): <input name="start_date" pattern="[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" type="text"/>
	<br>
	Start time (HH:MM:SS): <input name="start_time" pattern="[0-9][0-9]:[0-9][0-9]:[0-9][0-9]" type="text"/>
	<br>
	End date (YYYY-MM-DD): <input name="end_date" pattern="[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" type="text"/>
	<br>
	End time (HH:MM:SS): <input name="end_time" pattern="[0-9][0-9]:[0-9][0-9]:[0-9][0-9]" type="text"/>
	<br>
	<% out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + request.getParameter("auctionID") + "\">"); %>
	<input type="submit" value="submit"/>	
</form>

</body>
</html>