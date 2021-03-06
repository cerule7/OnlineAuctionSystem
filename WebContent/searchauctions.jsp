<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!-- Lets the user specify an auction query with a String and ordering preferences-->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Auctions</title>
</head>
<body>
<!-- Search by form -->
<form action="">
	<fieldset>
		<legend>Search the list of auctions. Or, make a blank search to browse all auctions.</legend>
		<input type="text" name="query">
		<input type="submit" value="Search">
		<br>
		I am searching for a...
		<select name="criteria" size=1>
			<option value="item_name">Book Name</option>
			<option value="sellerID">Seller</option>
			<option value="min_increment">Minimum Price Increment</option>
			<option value="start_date_time">Auction Start Date (YYYY-MM-DD)</option>
			<option value="auctionID">Auction ID</option>
			<option value="subcat_name">Genre</option>
		</select>
		<br>
		I want the list displayed in...
		<select name="order">
			<option value="ASC">Ascending</option>
			<option value="DESC">Descending</option>
		</select>
		 order by
		 <select name="orderCriteria" size=1>
		 	<option value="relevance">Relevance</option>
		 	<option value="item_name">Book Name</option>
			<option value="sellerID">Seller</option>
			<option value="min_increment">Minimum Price Increment</option>
			<option value="start_date_time">Auction Start Date (YYYY-MM-DD)</option>
			<option value="auctionID">Auction ID</option>
			<option value="subcat_name">Genre</option>
		</select>
		<br>
		I want auctions that are
		<select name="activity" size=1>
			<option value="both">Active or Inactive</option>
			<option value="active">Active</option>
			<option value="inactive">Inactive</option>
		</select>
		.
	</fieldset>
</form>
	<%
		try{
			// Open the connection to the database
			String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
			Class.forName("com.mysql.jdbc.Driver");		
			ApplicationDB db = new ApplicationDB();	
			Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
			
			// Prepare the query for an SQL search.
			String temp = request.getParameter("query");
			String[] query = temp!= null ? temp.split(" ") : null;
			String criteria = request.getParameter("criteria");
			String orderCriteria = request.getParameter("orderCriteria");
			String order = request.getParameter("order");
			String activity = request.getParameter("activity");
			// Values will null when the page initially loads; they must be initialized.
			if(orderCriteria == null) orderCriteria = "auctionID";
			if(criteria == null) criteria = "auctionID";
			if(order == null) order = "ASC";
			if(activity == null) activity = "both";
			String sqlQuery = "SELECT DISTINCT * FROM Auction LEFT JOIN Has " + 
							  "ON Auction.ItemID = Has.ItemID WHERE ";
			
			// The search algorithm is dependent on the type of criteria for proper querying.
			if(query == null) {
				// When the page initially loads there is no query.
				sqlQuery += criteria + " LIKE '%'";
			} else if(query[0].equals("")) {
				// Blank searches should just show all auctions.
				sqlQuery += criteria + " LIKE '%'";
			} else if(criteria.equals("sellerID") || criteria.equals("item_name") || criteria.equals("genre")) {
				sqlQuery += criteria + " LIKE '%" + String.join(" ", query) + "%'";
				for(int i=0; i<query.length; i++) {
					sqlQuery += " OR " + criteria + " LIKE '%" + query[i] + "%'";
				}
			} else if(criteria.equals("start_date_time")) {
					sqlQuery += criteria + " >= '" + query[0] + " 00:00:00'"
							 + " AND " + criteria + " <= '" + query[0] + " 23:59:59'";
			} else {
				// min_increment or auctionID
				sqlQuery += criteria + " = '" + query[0] + "'";
			}
			
			if(activity.equals("active")) {
				sqlQuery += " AND start_date_time <= CURRENT_TIMESTAMP AND" +
							" end_date_time >= CURRENT_TIMESTAMP";
			} else if(activity.equals("inactive")){
				sqlQuery += " AND (start_date_time >= CURRENT_TIMESTAMP OR" +
						" end_date_time <= CURRENT_TIMESTAMP)";
			}
			
			if(!orderCriteria.equals("relevance")) {
				sqlQuery += " ORDER BY " + orderCriteria + " " + order;
			}
			ResultSet result = con.prepareStatement(sqlQuery).executeQuery();
			
			// Display the search query result.
			out.println("<hr>");
			double highest = 0; // highest is used as a pointer in the while loop below.
			String buyer = "N/A";
			while(result.next()){
				// Prepare query for fetching current auction's bid information.
				ResultSet resultb = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=" 
					+ result.getInt(9)).executeQuery();
				
				
				// Find the auction's current bid
				while(resultb.next()){
					if(resultb.getDouble(3) > highest){
						highest = resultb.getDouble(3);
						buyer = resultb.getString(1);
					}
				}
				
				// Display the current while loop iteration's Auction information the user.
				out.print("<h4>"+ result.getString(8) +"</h4>" + // Item name
						  "<h5> Auction ID: "+ result.getString(9) +"</h5>" +
						  "Genre: " + result.getString(11) + "<br>" +
						  "<p>" + 
						  "Sold by " + result.getString(3) + "<br>" +
						  "Starting price: $" + String.format("%.2f", result.getDouble(1)) + "<br>");
				
				if(highest > 0){
					out.print("Current bid: $" + String.format("%.2f", highest) + " by "+ buyer + "<br>");
				} else out.print("Current bid: No current bidders" + "<br>");
				
				out.print("Minimum bid increment: $" + String.format("%.2f", result.getDouble(4)) + "<br>" +
						  "Start Date: " + result.getString(6) + "<br>" +
						  "End Date: " + result.getString(5) + "<br>" +
						  "</p>" +
						  
						  //View auction
						  "<form  method=\"get\" action=\"auction.jsp\" \" style=\"display: inline\">" +
						  "<input type=\"hidden\" name=\"auctionID\" value=\"" + result.getString(9) + "\"/>" +
						  "<input type=\"submit\" value=\"View Auction\"/>" +
						  "</form>" +
						  		
						  // Similar Auctions Button
						  " <form  method=\"get\" action=\"similarauctions.jsp\" \" style=\"display: inline\">" +
						  "<input type=\"hidden\" name=\"auctionID\" value=\"" + result.getString(9) + "\"/>" +
						  "<input type=\"submit\" value=\"View Similar Auctions\"/>" +
						  "</form>" +
						  
						  // Seller History Button
						  " <form method=\"post\" action=\"profile.jsp?username=" + 
						  result.getString(3) +"\" style=\"display: inline\">" +
						  "<input type=\"submit\" value=\"View Seller\">" +
						  "</form>");
				
				// Show options to view histories/profiles only if there exists at least 1 bid.
				if(!buyer.equals("N/A")){
					// Buyer History Button
					out.print(" <form method=\"post\" action=\"profile.jsp?username=" + 
							  buyer +"\" style=\"display: inline\">" +
							  "<input type=\"submit\" value=\"View Current Bidder\">" +
							  "</form>" +
							  
							  // Bid History Button
							  " <form method=\"post\" action=\"bidhistory.jsp?auctionID=" + 
							  result.getString(9) +"\" style=\"display: inline\">" +
							  "<input type=\"submit\" value=\"Bid History\">" +
							  "</form>" +
							  "<br>");
				}
				out.println("<hr>");
				
				// Reset highest bid and buyer variables for next loop iteration.
				highest = 0;
				buyer= "N/A";
			}
			
			out.print("<p style=\"font-size:13px; text-align:center;\"> " +
					  "End of list.</p>");
			con.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>