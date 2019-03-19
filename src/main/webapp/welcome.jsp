<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.Group21.OnlineAuctionSystem.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Welcome</title>
</head>

<body>
<%
	try {

		//Get the database connection
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at login.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		//Find username and password 
		String str = "SELECT * FROM User WHERE username = " + username + " AND password = " + password;
		ResultSet result = stmt.executeQuery(str);
		
		if(result.wasNull()){
			out.print("<p>");
			out.print("Login unsucessful. Try again.");
			out.print("</p>");
		} else {
			out.print("<p>");
			out.print("Hi " + username + "!");
			out.print("</p>");
		}
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Insert failed :()");
	}
%>


</body>

</html>