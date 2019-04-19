<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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

		//Get parameters from the HTML form at login.jsp
		int auctionID = Integer.parseInt(request.getParameter("auctionID"));
		//PreparedStatement ps = con.prepareStatement("SELECT * FROM Auction WHERE auctionID = ?;");
		//ps.setInt(1, auctionID);
		//ResultSet res = ps.executeQuery();
		/**
		int itemID=0;
		if(res.next()){
			//itemID = res.getInt("itemID");
		};
		*/
		String question = request.getParameter("question");
		out.print("<p>"+question+"</p>");
		
		
		
		//Close the connection
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>