<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!-- Lets the user specify an auction query with a String and ordering preferences-->
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
		try{
			// Open the connection to the database
			String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
			Class.forName("com.mysql.jdbc.Driver");		
			ApplicationDB db = new ApplicationDB();	
			Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
			
			// Prep the query for an SQL search.
			String[] query = request.getParameter("query").toLowerCase().split(" ");
			
			// Seperate the search algorithm based on criteria for proper querying.
			String criteria = request.getParameter("criteria");
			if(criteria.equals("sellerID") || criteria.equals("item_name") ||
			   criteria.equals("genre")) {
				String sqlQuery = "SELECT DISTINCT * FROM Auction WHERE " + criteria + "LIKE ";
				/* Make algo to search for all possible permutations of query array.
				   EX. "tall green lamp" would search for "tall green lamp", 
				   "tall green", "green lamp","tall lamp", "green tall", "green",
				   etc. until all possible permutations have been exhuasted in a SQL
				   query where the attribute's value is LIKE %perumatation%.
				   
				*/
				for(int i=0; i<query.length; i++){
					sqlQuery+= "'%?%', ";
				}
				
			} else if(criteria.equals("min_increment")) {
				
			} else if(criteria.equals("start_date_time")) {
				
			} else if(criteria.equals("auctionID")) {
				
			} 
			
			con.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>