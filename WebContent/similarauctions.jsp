<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Similar Auctions</title>
</head>
<body>
<%
try{
	// Open the connection to the database
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	Class.forName("com.mysql.jdbc.Driver");		
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
	
	String auctionID = request.getParameter("auctionID");
	
	// Prepare SQL statement.
	String sqlQuery = "SELECT * FROM Auction LEFT JOIN Item ON Auction.ItemID = Item.ItemID " +
					  "WHERE Auction.auctionID = " + auctionID;
	
	ResultSet result = con.prepareStatement(sqlQuery).executeQuery();
	
	
	
} catch(Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>