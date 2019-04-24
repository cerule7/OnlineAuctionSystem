<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Alert Auction History</title>
</head>

<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	String userID = request.getParameter("username");
	
	PreparedStatement q = con.prepareStatement("SELECT * FROM AlertTable WHERE FK_username=?");
	q.setString(1, userID);
	ResultSet result = q.executeQuery();
	
	out.print("<h1>" + userID + "'s Alert Auction History </h1>");
	
	if(result.first() == false){
		out.print("<p>");
		out.print(userID + " has not made any valid auction alerts!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} 
	
	result.absolute(0);
	
	while(result.next()){
		String alertType =  String.valueOf(result.getString("alertType"));
		if(alertType.equals("Auction")){
			LocalDateTime end = LocalDateTime.parse(result.getString("FK_end_date_time").substring(0, 10) + "T" + result.getString("FK_end_date_time").substring(11));
		if(!LocalDateTime.now().isAfter(end)){
			String auctionID = String.valueOf(result.getInt("FK_auctionID"));
			String itemID = result.getString("FK_itemID");
			String item_name = result.getString("FK_item_name");
			
			out.print("Auction: " + auctionID);
			out.print("<p>");
			out.print("ISBN: "+ itemID);
			out.print("<p>");

			out.print("Title: " +item_name);
			out.print("<p>");

			out.print("<form  method=\"get\" action=\"auction.jsp\">");
			out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
			out.print("<input type=\"submit\" value=\"View\"/>");
			out.print("</form>");
			out.print("<p>");

			
		
	
		out.print("<br>");
		}}
	}
	
	//Close the connection
	con.close();
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");
%>
</body>

</html>