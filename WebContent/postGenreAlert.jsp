<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Genre Alert Posted</title>
</head>

<body>

<%



	try {
	
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		//Get parameters from the HTML form at the register.jsp
		String genre = request.getParameter("genre");
		String userID = (String) session.getAttribute("username");

		String alertType = "Genre Alert";
		
		//add item to AlertTable
		
			String insert = "INSERT INTO AlertTable(genre, FK_username, alertType)"
					+ "VALUES (?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, genre);
			ps.setString(2, userID);
			ps.setString(3, alertType);
			//Run the query against the DB
			ps.executeUpdate();
			
			out.print("Alert for : " + userID);

			out.print("<p>");
			out.print("Genre: " + genre);

			out.print("<p>");
	
			out.print("created.");
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