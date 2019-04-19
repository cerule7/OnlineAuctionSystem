<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
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
		PreparedStatement update =con.prepareStatement("INSERT INTO Answer (userID, itemID, answer, auctionID, questionID) VALUES (?,?,?,?,?);");

		update.setString(1, (String) session.getAttribute("username"));
		update.setString(2, (String) session.getAttribute("itemID"));
		update.setString(3,request.getParameter("answer"));
		update.setInt(4, Integer.parseInt(request.getParameter("auctionID")));
		update.setInt(5, Integer.parseInt(request.getParameter("questionID")));
		
		update.executeUpdate();
		//Get parameters from the HTML form at login.jsp
		//out.print(request.getParameter("answer"));
		//Close the connection
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
	response.sendRedirect("auction.jsp?auctionID="+(String) session.getAttribute("auctionID"));
%>
</body>
</html>