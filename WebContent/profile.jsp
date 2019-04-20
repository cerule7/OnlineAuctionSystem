<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Profile</title>
</head>
<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	String userID = request.getQueryString().substring(request.getQueryString().indexOf('=') + 1);
	
	PreparedStatement q = con.prepareStatement("SELECT * FROM User WHERE username=?");
	q.setString(1, userID);
	ResultSet result = q.executeQuery();
	
	if(result.first() == false){
		out.print("<p>");
		out.print("This user does not exist!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} 

	out.print("<h2>" + userID + "\'s profile </h2>");
	out.println("<form method=\"post\" action=\"userauctions.jsp?username=" + userID +"\" style=\"display: inline\">" +
			"<input type=\"submit\" value=\"View Auction History\">" + 
			"</form>");
	
	if(session.getAttribute("username") != null && ((String) session.getAttribute("usertype")).equals("admin") || ((String) session.getAttribute("usertype")).equals("cust_rep")){
		out.println("<p>");
		out.println("<form method\"post\" action=\"deleteuser.jsp\">");
		out.print("<input type=\"hidden\" name=\"username\" value=\"" + userID + "\"/>");
		out.println("<input type=\"submit\" value=\"Delete User\"/>");
		out.print("</form>");
	}
	
%>


</body>
</html>