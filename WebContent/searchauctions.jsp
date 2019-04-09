<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!-- Lets the user specify an auction query with -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Auctions</title>
</head>
<body>
<!-- Search by form -->
<form action="">
	<fieldset>
		<legend>Search the list of auctions</legend>
		<input type="text" name="query">
		<input type="submit" value="Search">
		<br>
		I am searching for a...
		<select name="criteria" size=1>
			<option value="sellerID">Seller</option>
			<option value="min_increment">Minimum Price Increment</option>
			<option value="start_date_time">Auction Start Date</option>
			<option value="auctionID">Auction ID</option>
			<option value="item_name">Book Name</option>
			<option value="genre">Genre</option>
		</select>
		<br>
		I want the list displayed in...
		<select name="order">
			<option value="ASC">Ascending</option>
			<option value="DESC">Descending</option>
		</select>
		 order.
	</fieldset>
</form>

	<%
		
	%>
</body>
</html>