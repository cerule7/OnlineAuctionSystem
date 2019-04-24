<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>My Alerts</title>
</head>
<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	String userID = request.getQueryString().substring(request.getQueryString().indexOf('=') + 1);
	
	PreparedStatement q = con.prepareStatement("SELECT * FROM User WHERE username=?");
	q.setString(1, userID);
	ResultSet result = q.executeQuery();
	
	if(result.first() == false){
		out.print("<p>");
		out.print("This user does not exist!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} 

	out.print("<h2>" + userID + "\'s Alerts </h2>");
	out.println("<form method=\"post\" action=\"userAuctionAlert.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Item Alerts\">" + 
			"</form>");
	out.println("<form method=\"post\" action=\"userBookAlert.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Book Alerts\">" + 
			"</form>");
	out.println("<form method=\"post\" action=\"userGenreAlert.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Genre Alerts\">" + 
			"</form>");
	out.println("<form method=\"post\" action=\"userBidAlert.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Alerts for Items You have Bid On\">" + 
			"</form>");

	out.println("<form method=\"post\" action=\"userAutoBidAlert.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Alerts for Items You have AutoBid On\">" + 
			"</form>");

	
%>


</body>
</html>