<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<!-- Import Statements -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="ISO-8859-1">
<title>Register</title>
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

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the register.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");

		/* lazy User table schema reference.
		CREATE TABLE User(
    	username varchar(20),
    	email varchar(50) NOT NULL UNIQUE, 
    	password varchar(20) NOT NULL,
    	user_type varchar(25) NOT NULL,
    	primary key (username)
		);
		*/
		
		//Make an insert statement for the User table:
		String insert = "INSERT INTO User(username, email, password, user_type)"
				+ "VALUES (?, ?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, username);
		ps.setString(2, email);
		ps.setString(3, password);
		ps.setString(4, "user");
		//Run the query against the DB
		ps.executeUpdate();

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("Registration succeeded!");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>