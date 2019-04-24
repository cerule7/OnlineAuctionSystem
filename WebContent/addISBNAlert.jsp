<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ISBN Alert</title>
</head>
<body>

<div>
<form  method="post" action="postISBNAlert.jsp">

<%
	try {
		
		//Get parameters from the HTML form at auctionstart.jsp
		String isbn = request.getParameter("isbn");
		
		if(isbn.length() !=  10){
			out.print("The ISBN must be 10 numbers long.");
			return;
		}

		//Get the database connection
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	


		
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
			out.print("<input type=\"hidden\" name=\"num_pages\" value=\"" + num_pages + "\"/>");
			out.print("<input type=\"hidden\" name=\"hidden_genre\" value=\"" + genre + "\"/>");
			out.print("<input type=\"hidden\" name=\"author\" value=\"" + author +  "\"/>");
			out.print("<input type=\"hidden\" name=\"title\" value=\"" + title + "\"/>");
		} else {
			out.print("<br>");
			out.print("Author: ");
			out.print("<input name=\"author\" type=\"text\" maxlength=\"99\"");
			out.print("<br>");
			out.print("Title: ");
			out.print("<input name=\"title\" type=\"text\" maxlength=\"99\"");
			out.print("<br>");
			out.print("Number of pages: ");
			out.print("<input name=\"num_pages\" type=\"number\"");
			out.print("<br>");
			out.print("Genre: ");
			out.print("<select name=\"genre\">");
				out.print("<option value=\"Biography\">Biography</option>");
				out.print("<option value=\"Classics\">Classics</option>");
				out.print("<option value=\"Fiction\">Fiction</option>");
				out.print("<option value=\"History\">History</option>");
				out.print("<option value=\"Horror\">Horror</option>");
				out.print("<option value=\"Mystery\">Mystery</option>");
				out.print("<option value=\"Non-fiction\">Non-fiction</option>");
				out.print("<option value=\"Romance\">Romance</option>");
				out.print("<option value=\"Science\">Science</option>");
				out.print("<option value=\"Sci-fi\">Sci-fi</option>");
				out.print("<option value=\"Poetry\">Poetry</option>");
			out.print("</select>");
		}
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>


<input type="submit" value="submit"/>
</form>


</div>

</body>
</html>