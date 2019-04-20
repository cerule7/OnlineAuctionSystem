<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete Auction</title>
</head>
<body>
<%

	String auctionID = request.getParameter("auctionID");

	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	try {
		String insert = "DELETE FROM Auction WHERE auctionID=?";
		PreparedStatement ps = con.prepareStatement(insert);
		ps.setString(1, auctionID);
		ps.executeUpdate();
		out.println("Auction deleted successfully.");
	} catch (Exception ex){
		out.print("Deleting auction failed...");
	}
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");

%>
</body>
</html>