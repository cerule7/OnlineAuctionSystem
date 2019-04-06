<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction</title>
</head>
<body>

<h2>Auction</h2>
<p>

<% 

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");

ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

int auctionID = Integer.parseInt(request.getParameter("auctionID"));

PreparedStatement q = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
q.setInt(1, auctionID);
ResultSet result = q.executeQuery();

if(result.next() == false){
	out.print("Auction does not exist!");
	return;
} 

String itemID = result.getString("itemID");
double start_price = result.getDouble("start_price");
String item_name = result.getString("item_name");
String sellerID = result.getString("sellerID");
double min_increment = result.getDouble("min_increment");
LocalDateTime end = LocalDateTime.parse(result.getString("end_date_time").substring(0, 10) + "T" + result.getString("end_date_time").substring(11));

PreparedStatement q2 = con.prepareStatement("SELECT * FROM Item WHERE itemID=?");
q2.setString(1, itemID);
ResultSet result2 = q2.executeQuery();

if(result2.first() == false){
	out.print("Item does not exist!");
	return;
} 

String author = result2.getString("author");
String genre = result2.getString("genre");
int numpages = result2.getInt("num_pages");

out.print("<b>" + item_name + "</b> <br>");
out.print("Author: " + author + "<br>");
out.print("Genre: " + genre + " <br>");
out.print("Number of pages: " + String.valueOf(numpages)+ " <br>");
out.print("Sold by: " + sellerID + "<br>"); //this will be updated to link to the seller's profile
out.print("Auction ends at: " + result.getString("end_date_time").substring(0, 10) + " " + result.getString("end_date_time").substring(11));

%>

</body>
</html>