<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>Auction's Bid History</title>
	<%
	String auctionID = request.getParameter("auctionID");
	out.println("<h2 style=\"text-align: center\">Bid History for Auction " + auctionID + "</h2>");
	%>
	<hr>
	</head>
	
	<body>
	<%
	// Open the connection to the database
	try{
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		Class.forName("com.mysql.jdbc.Driver");		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");

		// Construct the SQL query to get the bid history tuples.
		String sqlQuery = "SELECT * FROM Bids_on WHERE auctionID = '" + auctionID + "'" +
						  "ORDER BY datetime ASC";
		ResultSet result = con.prepareStatement(sqlQuery).executeQuery();
		ResultSet auction = con.prepareStatement("SELECT * FROM Auction WHERE AuctionID = " + 
			auctionID).executeQuery();
		
		// Print the results out for the user to see.
		auction.next();
		double price = auction.getDouble(1);
		out.print("Starting Price: $" + String.format("%.2f", price) + "<p>");
		while(result.next()){
			price += result.getDouble(3);
			out.print("Bid on " + result.getString(5) +
					  ", Bid Amount: $" + String.format("%.2f", result.getDouble(3))+
					  " by " + result.getString(1) +
					  ", New Price: $" + String.format("%.2f", price) +
					  "<p>");
		}
	} catch(Exception e) {
		e.printStackTrace();
	}
	%>
	</body>
</html>