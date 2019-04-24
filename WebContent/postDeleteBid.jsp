<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete Bid Result</title>
</head>

<body>

<%



	try {
	
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		String auctionId = request.getParameter("auctionID");
		String userID = (String) session.getAttribute("username");

		
		//add item to AlertTable
		
			String delete = "DELETE FROM Bids_on WHERE username =? And auctionID =?";
			PreparedStatement ps = con.prepareStatement(delete);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, userID);
			ps.setString(2, auctionId);
			//Run the query against the DB
			ps.executeUpdate();
			
			out.print("Bid deletion for : " + userID);

			out.print("<p>");
			out.print("On AuctionID: " + auctionId);

			out.print("<p>");
	
			out.print("completed.");
			out.print("<p>");
	
	
				
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();
		
			out.print("<p>");
	
			out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}


%>


</body>

</html>