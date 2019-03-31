<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>New Auction</title>
</head>
<body>

<%
	try {

		//Get the database connection
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

		//Get parameters from the HTML form at auctionstart.jsp
		String isbn = request.getParameter("isbn");
		
		//Find username and password 
		PreparedStatement q = con.prepareStatement("SELECT * FROM Item WHERE itemID=?");
		q.setString(1, isbn);
		ResultSet result = q.executeQuery();
		
		Boolean found = false;
		
		String author = "";
		String title = "";
		String genre = "";
		String num_pages = "";
		
		if(result.next() == false){
			out.print("<p>");
			out.print("Book not found. Please enter the item's information below.");
			out.print("</p>");
		} else {
			out.print("<p>");
			out.print("Book found! We've filled in the item information for you.");
			out.print("<p>");
			title = result.getString(1);
			author = result.getString(2);
			genre = result.getString(5);
			num_pages = result.getString(6);
			found = true;
		}
		
		//Close the connection
		con.close();
		
		out.print("<div>");
		out.print("<form  method=\"post\" action=\"postauction.jsp\">");
		out.print("<input type=\"hidden\" name=\"hidden_isbn\" value=" + isbn + ">");
		if(found){
			out.print("<p>");
			out.print("Author: " + author);
			out.print("<p>");
			out.print("Title: " + title);
			out.print("<p>");
			out.print("Number of pages: " + num_pages);
			out.print("<p>");
			out.print("Genre: " + genre);
			out.print("<p>");
			out.print("<input type=\"hidden\" name=\"num_pages\" value=\"num_pages\">");
			out.print("<input type=\"hidden\" name=\"hidden_genre\" value=\"genre\">");
			out.print("<input type=\"hidden\" name=\"author\" value=\"author\">");
			out.print("<input type=\"hidden\" name=\"title\" value=\"title\">");
		} else {
			out.print("<br>");
			out.print("Author: ");
			out.print("<input name=\"author\" type=\"text\"");
			out.print("<br>");
			out.print("Title: ");
			out.print("<input name=\"title\" type=\"text\"");
			out.print("<br>");
			out.print("Number of pages: ");
			out.print("<input name=\"num_pages\" type=\"number\"");
			out.print("<br>");
			out.print("Genre: ");
			out.print("<select name=\"genre\">");
				out.print("<option value=\"biography\">Biography</option>");
				out.print("<option value=\"classics\">Classics</option>");
				out.print("<option value=\"graphic_novel\">Graphic Novel</option>");
				out.print("<option value=\"history\">History</option>");
				out.print("<option value=\"horror\">Horror</option>");
				out.print("<option value=\"poetry\">Poetry</option>");
				out.print("<option value=\"sci_fi\">Sci-fi</option>");
			out.print("</select>");
		}
		
		out.print("<br>");
		out.print("Starting price: <input name=\"startprice\" type=\"number\" min=\"0.01\" />");
		out.print("<br>");
		out.print("Minimum price: <input name=\"minprice\" type=\"number\" min=\"0.01\" />"); 
		out.print("<br>");
		out.print("Minimum increment: <input name=\"minincrement\" type=\"number\" min=\"0.01\"/> ");
		out.print("<br>");
		out.print("Start date (YYYY-MM-DD): <input name=\"start_date\" pattern=\"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\" type=\"text\"/>");
		out.print("<br>");
		out.print("Start time (HH:MM:SS): <input name=\"start_time\" pattern=\"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\" type=\"text\"/>");
		out.print("<br>");
		out.print("End date (YYYY-MM-DD): <input name=\"end_date\" pattern=\"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\" type=\"text\"/>");
		out.print("<br>");
		out.print("End time (HH:MM:SS): <input name=\"end_time\" pattern=\"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\" type=\"text\"/>");
		out.print("<br>");
		out.print("<input type=\"submit\" value=\"submit\"/>");
		out.print("</form>");
		out.print("</div>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>

</body>
</html>