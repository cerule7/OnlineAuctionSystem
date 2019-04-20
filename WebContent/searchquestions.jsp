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
<div>
	<h1>Questions</h1>
	<form>
		<input type="text" name ="question"/>
		  <input type ="submit" name = "submit"/>
	</form>
</div>
<%
	try {

		//Get the database connection
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		if(request.getParameter("question")!=null){
			PreparedStatement ps =con.prepareStatement("SELECT * FROM Question WHERE question LIKE ?;");
			ps.setString(1,"%"+request.getParameter("question")+"%");
			
			ResultSet rs = ps.executeQuery();
			out.print("<p>Results For: "+request.getParameter("question")+"</p>");
			while(rs.next()){
				out.print("<p><a href = \"auction.jsp?auctionID=\""+rs.getString("auctionID")+">"+rs.getString("question")+"</a></p>");
			}
		}
		
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
	%>
	<div>
	<h1>Answers</h1>
	<form>
		<input type="text" name ="answer"/>
		  <input type ="submit" name = "submit"/>
	</form>
</div>
<%
try {

	//Get the database connection
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	if(request.getParameter("answer")!=null){
		PreparedStatement ps =con.prepareStatement("SELECT * FROM Answer WHERE answer LIKE ?;");
		ps.setString(1,"%"+request.getParameter("answer")+"%");
		
		ResultSet rs = ps.executeQuery();
		out.print("<p>Results For: "+request.getParameter("answer")+"</p>");
		while(rs.next()){
			out.print("<p><a href = \"auction.jsp?auctionID=\""+rs.getString("auctionID")+">"+rs.getString("answer")+"</a></p>");
		}
	}
	
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}

%>
</body>
</html>