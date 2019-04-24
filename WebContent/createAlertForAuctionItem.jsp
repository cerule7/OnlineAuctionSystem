<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title>Auction Alert</title>
</head>
<body>

<h2>Auction Alert for Item </h2>
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

if(result2.first() == false){ //this shouldn't happen
	out.print("Item does not exist!");
	return;
} 

String userID = request.getQueryString().substring(request.getQueryString().indexOf('=') + 1);
String author = result2.getString("author");
String genre = result2.getString("genre");
int numpages = result2.getInt("num_pages");

out.print("<b>" + item_name + "</b> <br>");
out.print("Author: " + author + "<br>");
out.print("Genre: " + genre + " <br>");
out.print("Number of pages: " + String.valueOf(numpages)+ " <br>");
out.print("Sold by: " + sellerID + "<br>"); //this will be updated to link to the seller's profile
int is_over = -1;
if(LocalDateTime.now().isAfter(end)){
	is_over = result.getInt("is_over");

	PreparedStatement q33 = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=? ORDER BY bid DESC LIMIT 1");
	q33.setInt(1, auctionID);
	ResultSet result33 = q33.executeQuery();
	if(result33.first() == false || result33.getDouble("bid") < result.getDouble("min_price")){
	  out.print("<p> Nobody won this item. <p>");
	  out.print("NO Alert Set");
		out.print("<br>");

		out.print("<br>");
		
	  out.print("<a href=\"index.jsp\"> Return to index </a>");


	} else {
		double current_bid2 = result33.getDouble("bid");
		String winner = result33.getString("username");
		out.print("<p> The winner was " + winner + " with a bid of $" + String.format("%.2f", current_bid2));
		out.print("NO Alert Set");
		out.print("<br>");

		out.print("<br>");
		
		out.print("<a href=\"index.jsp\"> Return to index </a>");

	} 
	return;
}

out.print("Auction ends at: " + result.getString("end_date_time").substring(0, 10) + " " + result.getString("end_date_time").substring(11, result.getString("end_date_time").length() - 2));

//get the highest (current) bid
PreparedStatement q3 = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=? ORDER BY bid DESC LIMIT 1");
q3.setInt(1, auctionID);
ResultSet result3 = q3.executeQuery();

double current_bid;
double min_bid; 
String currentwinner = "";

if(result3.first() == false){
	current_bid = Math.round((start_price + min_increment) * 100.00) / 100.00F;
	min_bid = current_bid;
	out.print("<p> Nobody has bid on this item yet! <p>");
	out.print("Bidding starts at $" + String.format("%.2f", current_bid));
} else {
	current_bid = result3.getDouble("bid");
	currentwinner = result3.getString("username");
	min_bid = Math.round((current_bid + min_increment) * 100.00) / 100.00F;
	out.print("<p> Current bid: $" + String.format("%.2f", current_bid));
	out.print("<br>");

	out.print("<br>");
	
	String url2AlertHome = "AlertHomePage.jsp?username=" + (String) session.getAttribute("username");
	out.print("<a href=\"" + url2AlertHome + "\"> My Alerts </a>");
	out.print("<p>");
	out.print("</form>");
	
}

String username = (String) session.getAttribute("username");

if(username == null){
	out.print("<br> You must be logged in to bid on an item. <br>");
} else if(username.equals(sellerID)){
	out.print("<p>");
} else if(username.equals(currentwinner)){
	out.print("<p> Your bid is currently the highest bid! <p>");
} else {
	out.print("<br>");


	//out.print(session.getAttribute("username"));
	//String userID = request.getQueryString().substring(request.getQueryString().indexOf('=') + 1);
	

}

if(username != null && !(LocalDateTime.now().isAfter(end))){
	String alertUser = (String)	(session.getAttribute("username"));

	
	String insert = "INSERT INTO AlertTable(FK_username, AlertType ,FK_auctionID, FK_is_over, FK_itemID, FK_item_name, FK_end_date_time)"
			+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
	//Create a Prepared SQL statement allowing you to introduce the parameters of the query
	PreparedStatement psInsert = con.prepareStatement(insert);
	
	//Create Strings
	String password = request.getParameter("password");
	String strAlertType = "Auction";
	String endTimeToInsert = result.getString("end_date_time").substring(0, 10) + "T" + result.getString("end_date_time").substring(11, result.getString("end_date_time").length() - 2);

	//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
	psInsert.setString(1, alertUser);
	psInsert.setString(2, strAlertType);
	psInsert.setInt(3, auctionID);
	psInsert.setInt(4, is_over);
	psInsert.setString(5, itemID);
	psInsert.setString(6, item_name);
	psInsert.setString(7,endTimeToInsert);



	//Run the query against the DB
	psInsert.executeUpdate();
	//out.print("userID" + userID);
	out.print("Alert created for " + alertUser + " !");
	out.print("<br>");

	out.print("<br>");
	
	out.print("<a href=\"index.jsp\"> Return to index </a>");



	//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.

	
	
	
}

%>

	<%con.close();%>
<a </a>
</body>
</html>