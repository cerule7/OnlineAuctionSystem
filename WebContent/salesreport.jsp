<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<!-- Import Statements -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h1>Get Sales Report For:</h1>
<div>
	<form>
		<input type = "text" name = "question">
	</form>
</div>
<%
	try {

		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		String search = request.getParameter("question");
		
		if(search != null){
			out.print("<p> Results for: "+search + "</p>");
			String insert = "SELECT * FROM Item WHERE item_name LIKE ?";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1,"%" +search+"%");
		
			ResultSet res = ps.executeQuery();
			out.print("<form method = \"get\" action = \"salesreportquery.jsp\">");
			while(res.next()){
				out.print("<p>" + res.getString("item_name")+"	" +"<button type=\"button\" name = \""+res.getString("item_name")+"\">Generate Report</button></p>");
			}
			out.print("</form>");
		}
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>