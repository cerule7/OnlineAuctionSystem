<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%    try {

		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

		//Get parameters from the HTML form at the register.jsp
		String username = request.getParameter("Submit");
		
		if(request.getParameter("usertype") != null){
			usertype = (String) request.getParameter("usertype");
		} else usertype = "user";
		
		
		String insert = "INSERT INTO User(username, email, password, user_type)"
				+ "VALUES (?, ?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, username);
		ps.setString(2, email);
		ps.setString(3, password);
		ps.setString(4, usertype);
		//Run the query against the DB
		ps.executeUpdate();

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("Registration succeeded!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		/** if(ex instanceof MySQLIntegrityConstraintViolationException){
			System.out.print("rfreferfe");
		}**/
		out.print(ex);
	}%>
</body>
</html>