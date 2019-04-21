<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
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
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

		//Get parameters from the HTML form at login.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		//Find username and password 
		PreparedStatement q = con.prepareStatement("SELECT * FROM User WHERE username=? AND password=?");
		q.setString(1, username);
		q.setString(2, password);
	//	String str = "SELECT * FROM User WHERE username="+username+" AND password=" + password;
		//ResultSet result = stmt.executeQuery(str);
		ResultSet result = q.executeQuery();
		
		if(result.next() == false){
			out.print("<p>");
			out.print("Login unsucessful. Try again.");
			out.print("</p>");
		} else {
			out.print("<p>");
			//this gets the usertype
			String type = result.getString(4);
			//adds username and user type to the session
			session.setAttribute("username", username);
			session.setAttribute("usertype", type);
			out.print("Hi " + (String) session.getAttribute("username") + "!");
			out.print("<p>");
			out.print("Your account type is \"" + (String) session.getAttribute("usertype") + "\"");
			out.print("</p> <p>");
			out.print("<a href=\"index.jsp\"> Return to index </a>");
		}
		
		//Close the connection
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>


</body>

</html>