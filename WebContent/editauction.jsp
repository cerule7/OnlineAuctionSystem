<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Auction</title>
</head>

<body>

<%

int auctionID = Integer.parseInt(request.getParameter("auctionID"));

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");
		
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

PreparedStatement q = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
q.setInt(1, auctionID);
ResultSet result = q.executeQuery();

if(result.next() == false){
	out.print("Auction does not exist!");
	return;
} 

LocalDateTime start, end;
if(!request.getParameter("start_time").isEmpty() && !request.getParameter("start_date").isEmpty()){
	String start_date_time =  request.getParameter("start_date") + "T" + request.getParameter("start_time");
	try {
		start = LocalDateTime.parse(start_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid start time and date.");
		return;
	}
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET start_date_time = ? WHERE auctionID = ?");
	q2.setString(1, start_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
} else if(!request.getParameter("start_time").isEmpty()) {
	String start_time = request.getParameter("start_time");
	String current_date = result.getString("start_date_time").substring(0, 10);
	String start_date_time = current_date + "T" +  start_time; 
	
	try {
		start = LocalDateTime.parse(start_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid start time.");
		return;
	}
	
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET start_date_time = ? WHERE auctionID = ?");
	q2.setString(1, start_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
} else if(!request.getParameter("start_date").isEmpty()) {
	String start_date = request.getParameter("start_date");
	String current_time = result.getString("start_date_time").substring(11, 19);
	String start_date_time =  start_date + "T" +  current_time; 
	
	try {
		start = LocalDateTime.parse(start_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid start date.");
		return;
	}
	
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET start_date_time = ? WHERE auctionID = ?");
	q2.setString(1, start_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
}

if(!request.getParameter("end_time").isEmpty() && !request.getParameter("end_date").isEmpty()){
	String end_date_time =  request.getParameter("end_date")  + "T" + request.getParameter("end_time");
	try {
		end = LocalDateTime.parse(end_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid end time and date.");
		return;
	}
	System.out.println(end_date_time);
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET end_date_time = ? WHERE auctionID = ?");
	q2.setString(1, end_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
}  else if(!request.getParameter("end_time").isEmpty()) {
	String end_time = request.getParameter("end_time");
	String current_date = result.getString("end_date_time").substring(0, 10);
	String end_date_time =  current_date + "T" +  end_time; 
	System.out.println(end_date_time);
	try {
		end = LocalDateTime.parse(end_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid end time.");
		return;
	}
	
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET end_date_time = ? WHERE auctionID = ?");
	q2.setString(1, end_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
} else if(!request.getParameter("end_date").isEmpty()) {
	String end_date = request.getParameter("end_date");
	String current_time = result.getString("end_date_time").substring(11, 19);
	String end_date_time = end_date + "T" +  current_time; 
	System.out.println(end_date_time);
	try {
		start = LocalDateTime.parse(end_date_time);
	} catch (Exception ex) {
		out.print("Please enter a valid end date.");
		return;
	}
	
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET end_date_time = ? WHERE auctionID = ?");
	q2.setString(1, end_date_time);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
}

if(!request.getParameter("startprice").isEmpty()){
	double startprice = Float.parseFloat(request.getParameter("startprice"));
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET start_price = ? WHERE auctionID = ?");
	q2.setDouble(1, startprice);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
} 

if(!request.getParameter("minprice").isEmpty()){
	double minprice = Float.parseFloat(request.getParameter("minprice"));
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET min_price = ? WHERE auctionID = ?");
	q2.setDouble(1, minprice);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
} 

if(!request.getParameter("minincrement").isEmpty()){
	double minincrement =  Float.parseFloat(request.getParameter("minincrement"));
	PreparedStatement q2 = con.prepareStatement("UPDATE Auction SET min_increment = ? WHERE auctionID = ?");
	q2.setDouble(1, minincrement);
	q2.setInt(2, auctionID);
	q2.executeUpdate();
}

out.println("Update successful.");
out.print("<form  method=\"get\" action=\"auction.jsp\">");
out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
out.print("<input type=\"submit\" value=\"Go back to auction\"/>");
out.print("</form>");

%>

</body>


</html>