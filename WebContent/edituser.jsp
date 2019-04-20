<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit User</title>
</head>
<body>

<%

String username = request.getParameter("userID");

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");
		
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

PreparedStatement q = con.prepareStatement("SELECT * FROM User WHERE username=?");
q.setString(1, username);
ResultSet result = q.executeQuery();

if(result.next() == false){
	out.print("User does not exist!");
	return;
} 

if(!request.getParameter("password").isEmpty()){
	String password = request.getParameter("password");
	PreparedStatement q2 = con.prepareStatement("UPDATE User SET password = ? WHERE username = ?");
	q2.setString(1, password);
	q2.setString(2, username);
	q2.executeUpdate();
} 

if(!request.getParameter("email").isEmpty()){
	String email = request.getParameter("email");
	PreparedStatement q2 = con.prepareStatement("UPDATE User SET email = ? WHERE username = ?");
	q2.setString(1, email);
	q2.setString(2, username);
	q2.executeUpdate();
} 

out.println("Update successful.");

out.print("<p>");
String profurl = "profile.jsp?username=" + username;
out.print("<a href=\"" + profurl + "\"> Back to profile </a>");
out.print("<p>");

%>
</body>
</html>