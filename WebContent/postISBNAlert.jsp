<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ISBN Alert Posted</title>
</head>

<body>

<%


LocalDateTime now = LocalDateTime.now();

	
	try {
	
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		//Get parameters from the HTML form at the register.jsp
		String isbn = request.getParameter("hidden_isbn");
		String title = request.getParameter("title");
		String userID = (String) session.getAttribute("username");
		
		String startTime = now.toString();
		String alertType = "Book Alert";
		
		//add item to AlertTable
		if(request.getParameter("hidden_genre") == null){
			String insert = "INSERT INTO AlertTable(FK_item_name, FK_itemID, FK_username, date_set, alertType, genre)"
					+ "VALUES (?, ?, ?, ?, ?, ?)";
			String genreToInsert = (String) request.getParameter("genre");
			PreparedStatement ps = con.prepareStatement(insert);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, title);
			ps.setString(2, isbn);
			ps.setString(3, userID);
			ps.setString(4, startTime);
			ps.setString(5, alertType);
			ps.setString(6,genreToInsert);
			//Run the query against the DB
			ps.executeUpdate();
			
			out.print("<p>");
			out.print("Genre: " + genreToInsert);
			out.print("<p>");
			out.print("Title: " + title);
			out.print("<p>");
			out.print("ISBN: " + isbn);
			out.print("<p>");
			out.print("For User: " + userID);
			out.print("<p>");

			out.print("Starting: " + startTime);
			out.print("<p>");

			out.print("All matching your book will be shown in Book Alerts. ");
			out.print("<p>");



		} else {
		
			String genre = (String) request.getParameter("hidden_genre");
			String insert = "INSERT INTO AlertTable(genre, FK_item_name, FK_itemID, FK_username, date_set, alertType)"
					+ "VALUES (?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, genre);
			ps.setString(2, title);
			ps.setString(3, isbn);
			ps.setString(4, userID);
			ps.setString(5, startTime);
			ps.setString(6, alertType);
			//Run the query against the DB
			ps.executeUpdate();
			
			out.print("<p>");
			out.print("Genre: " + genre);
			out.print("<p>");
			out.print("Title: " + title);
			out.print("<p>");
			out.print("ISBN: " + isbn);
			out.print("<p>");
			out.print("For User: " + userID);
			out.print("<p>");
	
			out.print("Starting: " + startTime);
			out.print("<p>");
	
			out.print("For specific auctions please set alerts from  Add Alert for Auction Item on the Index page ");
			out.print("<p>");
	
	
			}
		
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();
		
			out.print("Alert posted!");
			out.print("<p>");
	
			out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}


%>


</body>

</html>