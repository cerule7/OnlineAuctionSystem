<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>My Auctions</title>
</head>

<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	String sellerID = (String) session.getAttribute("username");
	
	PreparedStatement q = con.prepareStatement("SELECT * FROM Auction WHERE sellerID=?");
	q.setString(1, sellerID);
	ResultSet result = q.executeQuery();
	
	if(result.first() == false){
		out.print("<p>");
		out.print("You have not posted any auctions!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} 
	
	while(result.next()){
		String auctionID = String.valueOf(result.getInt("auctionID"));
		String item_name = result.getString("item_name");
		String start = result.getString("start_date_time");
		out.print("<form  method=\"get\" action=\"auction.jsp\">");
			out.print(item_name + " posted at " + start.substring(0, start.length() - 2) + "    ");
			out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
			out.print("<input type=\"submit\" value=\"View\"/>");
		out.print("</form>");
		out.print("<br>");
	}
	
	//Close the connection
	con.close();
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");
%>
</body>

</html>