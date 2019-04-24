<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Alert for Genre</title>
</head>
<body>

<div>
<form  method="post" action="postGenreAlert.jsp">

<%
	try {
		
		
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	


		con.close();

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
				
	} catch (Exception ex) {
		out.print(ex);
	}
%>


<input type="submit" value="submit"/>
</form>


</div>

</body>
</html>