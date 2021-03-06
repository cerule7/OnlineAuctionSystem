<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Post Bid</title>
</head>
<body>

<%

double auto_increment = 0;
double upper_limit = 0;

double bid = 0;
double min_bid = Double.parseDouble(request.getParameter("min_bid"));

if(request.getParameter("bid").isEmpty() && request.getParameter("auto_increment").isEmpty()){
	out.print("You must enter a manual or automatic bid.");
	return;
}

if(!request.getParameter("bid").isEmpty() && !request.getParameter("auto_increment").isEmpty()){
	out.print("You cannot enter a manual bid and an auto bid at the same time");
	return;
}

//manual bid
if(!request.getParameter("bid").isEmpty()) {
	 bid = Double.parseDouble(request.getParameter("bid"));
}

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

//auto bid 
if(!request.getParameter("auto_increment").isEmpty()) {
	auto_increment = Double.parseDouble(request.getParameter("auto_increment"));
	if(!request.getParameter("upper_limit").isEmpty()) {
		upper_limit = Double.parseDouble(request.getParameter("upper_limit"));
	}
	bid = min_bid + auto_increment;
	if(upper_limit != 0 && bid > upper_limit){
		out.print("Your automatic bid is higher than your upper limit.");
		return;
	}
	String q1 = "SELECT * FROM Bids_on WHERE auctionID=? AND username =? AND autoIncrement_amount != 0";
	PreparedStatement ps0 = con.prepareStatement(q1);
	ps0.setInt(1, Integer.parseInt(request.getParameter("auctionID")));
	ps0.setString(2, (String) session.getAttribute("username"));
	ResultSet result = ps0.executeQuery();
	if(result.next()){
		out.print("You already made an auto-bid on this auction!");
		return;
	}
}

double min_increment = Double.parseDouble(request.getParameter("min_increment"));
int auctionID = Integer.parseInt(request.getParameter("auctionID"));
String userID = (String) session.getAttribute("username");
String date_time = request.getParameter("date_time").substring(0, 10) + "T" + request.getParameter("date_time").substring(11, 19);

//System.out.println(date_time);

if(auto_increment == 0 && bid < min_bid - 0.001) {
	out.print("You must bid at least " + String.format("%.2f", min_bid) + "! <p>");
	out.print("<form  method=\"get\" action=\"auction.jsp\">");
	out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
	out.print("<input type=\"submit\" value=\"Return to auction\"/>");
	out.print("</form>");
	return;
}

if(auto_increment != 0 && auto_increment < min_increment) {
	out.print("Your auto increment must be at least " + String.format("%.2f", min_increment) + "! <p>");
	return;
}


String insert = "INSERT INTO Bids_on(username, auctionID, bid, autoIncrement_amount, datetime, upperLimit)"
		+ "VALUES (?, ?, ?, ?, ?, ?)";
PreparedStatement ps = con.prepareStatement(insert);
ps.setString(1, userID);
ps.setInt(2, auctionID);
ps.setDouble(3, bid);
ps.setDouble(4, auto_increment);
ps.setString(5, date_time);
ps.setDouble(6, upper_limit);
ps.executeUpdate();

//find all the autobids
String q = "SELECT * FROM Bids_on WHERE auctionID=? AND autoIncrement_amount != 0 AND upperLimit < ? AND username <> ? GROUP BY username ORDER BY datetime DESC";
PreparedStatement ps2 = con.prepareStatement(q);
ps2.setInt(1, auctionID);
ps2.setDouble(2, (bid + min_increment));
ps2.setString(3, userID);
ResultSet result = ps2.executeQuery();


//go through all the autobids (oldest to newest)
if(result.first() != false){
	result.absolute(0);
	//the highest bid so far
	double current_highest = bid;
	while(result.next()){
			double my_auto_increment = result.getDouble("autoIncrement_amount");
			String my_userID = result.getString("username");
			double my_limit = result.getDouble("upperLimit");
			double my_bid = current_highest + my_auto_increment;
			String my_date = LocalDateTime.now().toString().substring(0, 10) + "T" + LocalDateTime.now().toString().substring(11, 19);
			
			if(my_limit == 0.00 || my_bid <= my_limit){
				Thread.sleep(1000);
				//System.out.println("current highest " + current_highest + " this autobid of " + my_bid + " will be by " + my_userID);
				
				//make auto bid
				String insert2 = "INSERT INTO Bids_on(username, auctionID, bid, autoIncrement_amount, datetime, upperLimit)"
						+ "VALUES (?, ?, ?, ?, ?, ?)";
				PreparedStatement ps3 = con.prepareStatement(insert2);
				ps3.setString(1, my_userID);
				ps3.setInt(2, auctionID);
				ps3.setDouble(3, my_bid);
				ps3.setDouble(4, my_auto_increment);
				ps3.setString(5, my_date);
				ps3.setDouble(6, my_limit);
				ps3.executeUpdate();
				
				current_highest = bid;
			}
	}
}
//Now set up Alerts

String FK_username = (String) session.getAttribute("username");
int FK_auctionID = Integer.parseInt(request.getParameter("auctionID"));
String alertType;

//AutoBid Alerts
if(upper_limit!=0){
	alertType = "Auto";
	
	
}else{
	alertType = "Bid";

}


String insertAlert = "INSERT INTO AlertTable(FK_username, AlertType ,FK_auctionID)"
		+ "VALUES (?, ?, ?)";
//Create a Prepared SQL statement allowing you to introduce the parameters of the query
PreparedStatement psInsertAlert = con.prepareStatement(insertAlert);


//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
psInsertAlert.setString(1, FK_username);
psInsertAlert.setString(2, alertType);
psInsertAlert.setInt(3, FK_auctionID);




//Run the query against the DB
psInsertAlert.executeUpdate();


con.close();
out.print("Bid successful!");

out.print("<form  method=\"get\" action=\"auction.jsp\">");
	out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
	out.print("<input type=\"submit\" value=\"Return to auction\"/>");
out.print("</form>");

%>

<p> 

</body>
</html>