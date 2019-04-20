<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete User</title>
</head>
<body>
<%

	String userID = request.getParameter("username");

	if(userID.equals((String) session.getAttribute("username"))){
		out.println("You can't delete yourself!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	}

	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	
	try {
	String insert = "DELETE FROM User WHERE username=?";
	PreparedStatement ps = con.prepareStatement(insert);
	ps.setString(1, userID);
	ps.executeUpdate();
	out.println("User deleted successfully.");
	} catch (Exception ex){
		out.print("Deleting user failed...");
	}
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");

%>
</body>
</html>