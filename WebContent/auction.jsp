<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction</title>
</head>
<body>

<h2>Auction</h2>
<p>

<% 

String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
//Get the database connection
Class.forName("com.mysql.jdbc.Driver");

ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

int auctionID = Integer.parseInt(request.getParameter("auctionID"));

PreparedStatement q = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
q.setInt(1, auctionID);
ResultSet result = q.executeQuery();

if(result.next() == false){
	out.print("Auction does not exist!");
	return;
} 

String itemID = result.getString("itemID");
double start_price = result.getDouble("start_price");
String item_name = result.getString("item_name");
String sellerID = result.getString("sellerID");
double min_increment = result.getDouble("min_increment");
LocalDateTime start = LocalDateTime.parse(result.getString("start_date_time").substring(0, 10) + "T" + result.getString("start_date_time").substring(11));




LocalDateTime end = LocalDateTime.parse(result.getString("end_date_time").substring(0, 10) + "T" + result.getString("end_date_time").substring(11));

PreparedStatement q2 = con.prepareStatement("SELECT * FROM Item WHERE itemID=?");
q2.setString(1, itemID);
ResultSet result2 = q2.executeQuery();

if(result2.first() == false){ //this shouldn't happen
	out.print("Item does not exist!");
	return;
} 

String author = result2.getString("author");
String genre = result2.getString("genre");
int numpages = result2.getInt("num_pages");

out.print("<b>" + item_name + "</b> <br>");
out.print("Author: " + author + "<br>");
out.print("Genre: " + genre + " <br>");
out.print("Number of pages: " + String.valueOf(numpages)+ " <br>");
out.print("Sold by: " + sellerID + "<br>"); //this will be updated to link to the seller's profile

if(LocalDateTime.now().isBefore(start)){
	out.print("<p> This auction has not started yet. It will start at " + result.getString("start_date_time"));
	return; 
}

if(LocalDateTime.now().isAfter(end)){
	int is_over = result.getInt("is_over");
	if(is_over == 0){
		PreparedStatement q8 = con.prepareStatement("UPDATE Auction SET is_over=1 WHERE auctionID=?");
		q8.setInt(1, auctionID);
		q8.executeUpdate();
		int total_sales = result2.getInt("total_sales");
		PreparedStatement q9 = con.prepareStatement("UPDATE Item SET total_sales=? WHERE itemID=?");
		q9.setInt(1, total_sales + 1);
		q9.setString(2, itemID);
		q9.executeUpdate();
	}
	PreparedStatement q33 = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=? ORDER BY bid DESC LIMIT 1");
	q33.setInt(1, auctionID);
	ResultSet result33 = q33.executeQuery();
	if(result33.first() == false || result33.getDouble("bid") < result.getDouble("min_price")){
	  out.print("<p> Nobody won this item. <p>");
	} else {
		double current_bid2 = result33.getDouble("bid");
		String winner = result33.getString("username");
		out.print("<p> The winner was " + winner + " with a bid of $" + String.format("%.2f", current_bid2));
	} 
	return;
}

out.print("Auction ends at: " + result.getString("end_date_time").substring(0, 10) + " " + result.getString("end_date_time").substring(11, result.getString("end_date_time").length() - 2));

//get the highest (current) bid
PreparedStatement q3 = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=? ORDER BY bid DESC LIMIT 1");
q3.setInt(1, auctionID);
ResultSet result3 = q3.executeQuery();

double current_bid;
double min_bid; 
String currentwinner = "";

if(result3.first() == false){
	current_bid = Math.round((start_price + min_increment) * 100.00) / 100.00F;
	min_bid = current_bid;
	out.print("<p> Nobody has bid on this item yet! <p>");
	out.print("Bidding starts at $" + String.format("%.2f", current_bid));
} else {
	current_bid = result3.getDouble("bid");
	currentwinner = result3.getString("username");
	min_bid = Math.round((current_bid + min_increment) * 100.00) / 100.00F;
	out.print("<p> Current bid: $" + String.format("%.2f", current_bid));
}

String username = (String) session.getAttribute("username");

if(username == null){
	out.print("<br> You must be logged in to bid on an item. <br>");
} else if(username.equals(sellerID)){
	out.print("<p>");
} else if(username.equals(currentwinner)){
	out.print("<p> Your bid is currently the highest bid! <p>");
} else {
	out.print("<br>");
	out.print("You must bid at least $" + String.format("%.2f", min_bid));
	out.print("<br>");
	out.print("<form  method=\"post\" action=\"postbid.jsp\">");
	String regex = "^\\d*(\\.\\d{0,2})?$";
	out.print("Enter bid here: ");
	out.print("<input name=\"bid\" type=\"text\" pattern=\"" + regex + "\"/>");
	out.print("<p> If you want to create an automatic bid instead, enter the following information: <p>");
	out.print("Automatic increment: ");
	out.print("<input name=\"auto_increment\" type=\"text\" pattern=\"" + regex + "\"/>");
	out.print("<p>Upper limit (enter 0.00 if none): ");
	out.print("<input name=\"upper_limit\" type=\"text\" pattern=\"" + regex + "\"/>");
	out.print("<input type=\"hidden\" name=\"min_bid\" value=\"" + min_bid + "\"/>");
	out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
	out.print("<input type=\"hidden\" name=\"date_time\" value=\"" + LocalDateTime.now().toString() + "\"/>");
	out.print("<input type=\"hidden\" name=\"min_increment\" value=\"" + min_increment + "\"/>");
	out.print("<input type=\"hidden\" name=\"username\" value=\"" + username + "\"/>");
	out.print("<br>");
	out.print("<input type=\"submit\" value=\"Bid\"/>");
	out.print("</form>");
}

out.print("<h3> Questions about this item: </h3>");
//Vlad works his magic here
%>
	<% //Statement sta = con.createStatement(); 
		PreparedStatement sta = con.prepareStatement("SELECT * FROM Question WHERE itemID=? AND auctionID =?");
		sta.setString(1, itemID);
		sta.setInt(2,Integer.parseInt(request.getParameter("auctionID")));
	    ResultSet res = sta.executeQuery();
	    while (res.next()) {
	    	out.print("<p>"+res.getString("userID")+":	"+res.getString("question")+"</p>");
	    	
	    	PreparedStatement ans= con.prepareStatement("SELECT * FROM Answer WHERE questionID = ?");
	    	ans.setString(1, res.getString("questionID"));
	    	
	    	ResultSet answers = ans.executeQuery();
	    	while(answers.next()){
	    		out.print("<p style=\"padding-left: 15px;\">"+answers.getString("answer")+"</p>");
	    	}
	    	if((String) session.getAttribute("usertype")=="admin" || (String) session.getAttribute("usertype")=="cust_rep"){
	    		out.print("<form method = \"post\" action =\"answer.jsp\"><input type = \"text\" name = \"answer\">");
	    		out.print("<input type =\"submit\" name = \"go\"/>");
	    		out.print("<input type=\"hidden\" name = \"user\" value = \""+res.getString("userID")+"\"/>");
	    		out.print("<input type=\"hidden\" name = \"auctionID\" value = \""+res.getString("auctionID")+"\"/>");
	    		out.print("<input type=\"hidden\" name = \"questionID\" value = \""+res.getString("questionID")+"\"/>");
	    		out.print("</form>");
	    	}
	    	
	    	}
	      session.setAttribute("auctionID", Integer.toString(auctionID));
	      session.setAttribute("itemID", itemID);
	      //out.print(session.getAttribute("itemID"));
	      out.print("<h3> Submit Question:"+" </h3>");
	           
	%>
	<div>
		<form method = "post" action = "questions.jsp">
		  	<input type="text" name ="question"/>
		  	<input type ="submit" name = "submit"/>
		</form>
	</div>
	<%con.close();%>
<a href = "searchquestions.jsp">Search for Questions and Answers</a>
</body>
</html>