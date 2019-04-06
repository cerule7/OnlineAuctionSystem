<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Post Bid</title>
</head>
<body>

<%

double bid = Double.parseDouble(request.getParameter("bid"));
double min_bid = Double.parseDouble(request.getParameter("min_bid"));
double auto_increment = Double.parseDouble(request.getParameter("auto_increment"));
double min_increment = Double.parseDouble(request.getParameter("min_increment"));
double upper_limit = Double.parseDouble(request.getParameter("upper_limit"));
int auctionID = Integer.parseInt(request.getParameter("auctionID"));
String userID = (String) session.getAttribute("username");
String date_time = request.getParameter("date_time") + "T" + request.getParameter("date_time");


if(bid < min_bid) {
	out.print("You must bid at least " + min_bid + "! <p>");
	return;
}

if(auto_increment != 0 && auto_increment < min_increment) {
	out.print("Your auto increment must be at least " + min_increment + "! <p>");
	return;
}

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");
		
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

//manual bid
if(auto_increment == 0){
String insert = "INSERT INTO Bids_on(username, auctionID, bid, autoIncrement_amount, datetime, upperLimit"
		+ "VALUES (?, ?, ?, ?, ?, ?)";
PreparedStatement ps = con.prepareStatement(insert);
ps.setString(1, userID);
ps.setInt(2, auctionID);
ps.setDouble(3, bid);
ps.setDouble(4, 0.00);
ps.setString(5, date_time);
ps.setDouble(5, 0.00);
ps.executeUpdate();

con.close();
out.print("Bid successful!");
}


%>

</body>
</html>