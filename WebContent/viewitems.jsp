<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Item List</title>
</head>
<body>

<h1> List of Items on Site </h1>

<% 

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
Class.forName("com.mysql.jdbc.Driver");		
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");

PreparedStatement q = con.prepareStatement("SELECT * FROM Item");
ResultSet result = q.executeQuery();

out.print("<p>");

while(result.next()){
   out.print("<b>" + result.getString("item_name") + "</b> by " + result.getString("author") + "<p> ISBN: " + result.getString("itemID") + " Genre: " + result.getString("genre"));
   out.print("<p>");
}

out.print("<p>");
out.print("<a href=\"index.jsp\"> Return to index </a>");

%>

</body>
</html>