<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Alert Bid History</title>
</head>

<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	

	String userID = request.getParameter("username");
	String sqlQuery = "SELECT DISTINCT * FROM Auction LEFT JOIN Has " + 
			  "ON Auction.ItemID = Has.ItemID WHERE ";
	PreparedStatement q = con.prepareStatement("SELECT * FROM AlertTable WHERE FK_username=? AND alertType = 'Bid'");
	q.setString(1, userID);
	ResultSet resultOrig = q.executeQuery();
	
	out.print("<h1>" + userID + "'s Alert Bid History </h1>");
	ArrayList<String> auctionBidsDisplayed = new ArrayList<String>();

	if(resultOrig.first() == false){
		out.print("<p>");
		out.print(userID + " has not made any valid Bid alerts!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} else{
	
		resultOrig.absolute(0);
		
		while(resultOrig.next()){
			out.print("<p>");
			String auctionID = String.valueOf(resultOrig.getInt("FK_auctionID"));
			
			//Get Auction info
			PreparedStatement qAuction = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
			qAuction.setInt(1, resultOrig.getInt("FK_auctionID"));
			ResultSet result = qAuction.executeQuery();

			if(result.next() == false){
				out.print("Auction does not exist!");
				return;
			} 
			boolean toShow = true;
		    for (int i = 0; i < auctionBidsDisplayed.size(); i++) {
		    	if(auctionBidsDisplayed.get(i).equals(auctionID)){
			        //out.print("DONT SHOW");
			        toShow= false;
			        break;

		    	}
		     }
	
		    if(toShow){
				out.print(auctionID);

			String itemID = result.getString("itemID");
			double start_price = result.getDouble("start_price");
			String item_name = result.getString("item_name");
			String sellerID = result.getString("sellerID");
			double min_increment = result.getDouble("min_increment");
			LocalDateTime start = LocalDateTime.parse(result.getString("start_date_time").substring(0, 10) + "T" + result.getString("start_date_time").substring(11));
			LocalDateTime end = LocalDateTime.parse(result.getString("end_date_time").substring(0, 10) + "T" + result.getString("end_date_time").substring(11));

			
			//Get Highest Bid
			

			//get the highest (current) bid
			PreparedStatement q3 = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=? ORDER BY bid DESC LIMIT 1");
			q3.setInt(1, resultOrig.getInt("FK_auctionID"));
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
				out.print("<p> Current Winner: "+ currentwinner);

			}
			
			//compare currentwinner to user
			
			if(currentwinner.equals(userID)){
				out.print("<p>You are Currently Winning!<p>");
				
			}else{
				
				out.print("<p>Alert!!!! You have been OutBid!<p>");
				out.print("<form  method=\"get\" action=\"auction.jsp\">");
				out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
				out.print("<input type=\"submit\" value=\"View\"/>");
				out.print("</form>");
				out.print("<p>");
		
				
				
				
			}
			
			
			auctionBidsDisplayed.add(auctionID);

	
		}
		}
	}
	
	//Close the connection
	con.close();
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");
%>
</body>

</html>