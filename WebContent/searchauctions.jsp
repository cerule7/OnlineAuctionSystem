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
		<legend>Search the list of auctions</legend>
		<input type="text" name="query">
		<input type="submit" value="Search">
		<br>
		I am searching for a...
		<select name="criteria" size=1>
			<option value="sellerID">Seller</option>
			<option value="min_increment">Minimum Price Increment</option>
			<option value="start_date_time">Auction Start Date (YYYY-MM-DD)</option>
			<option value="auctionID">Auction ID</option>
			<option value="item_name">Book Name</option>
			<option value="genre">Genre</option>
		</select>
		<br>
		I want the list displayed in...
		<select name="order">
			<option value="ASC">Ascending</option>
			<option value="DESC">Descending</option>
		</select>
		 order by
		 <select name="orderCriteria" size=1>
			<option value="sellerID">Seller</option>
			<option value="min_increment">Minimum Price Increment</option>
			<option value="start_date_time">Auction Start Date (YYYY-MM-DD)</option>
			<option value="auctionID">Auction ID</option>
			<option value="item_name">Book Name</option>
			<option value="genre">Genre</option>
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
			String[] query = request.getParameter("query").split(" ");
			String criteria = request.getParameter("criteria");
			String orderCriteria = request.getParameter("orderCriteria");
			String order = request.getParameter("order");
			String sqlQuery = "SELECT DISTINCT * FROM Auction WHERE ";
			
			// The search algorithm is dependent on the type of criteria for proper querying.
			if(criteria.equals("sellerID") || criteria.equals("item_name") ||
			   criteria.equals("genre")) {
				sqlQuery += criteria + " LIKE '%" + String.join(" ", query) + "%'";
				for(int i=0; i<query.length; i++) {
					sqlQuery += " OR " + criteria + " LIKE '%" + query[i] + "%'";
				}
			} else if(criteria.equals("start_date_time")) {
				if(query[0].equals("")) {
					// Blank searches should just show all auctions.
					sqlQuery += criteria + " LIKE '%'";
				} else {
					sqlQuery += criteria + " >= '" + query[0] + " 00:00:00'"
							 + " OR " + criteria + " <= '" + query[0] + " 23:59:59'";
				}
			} else {
				// min_increment or auctionID
				if(query[0].equals("")) {
					// Blank searches should just show all auctions.
					sqlQuery += criteria + " LIKE '%'";
				} else {
					sqlQuery += criteria + " = '" + query[0] + "'";
				}
			} 
			sqlQuery += " ORDER BY " + orderCriteria + " " + order;
			ResultSet result = con.prepareStatement(sqlQuery).executeQuery();
			
			// Display the search query result.
			out.println("<hr>");
			double highest = 0;
			String buyer = "N/A";
			
			// Display the list of all auctions. (copy/paste from browseauctions)
			while(result.next()){
				// Prepare query for fetching current auction's bids.
				ResultSet resultb = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=" 
					+ result.getInt(9)).executeQuery();
				
				
				// Find the auction's current bid
				while(resultb.next()){
					if(resultb.getDouble(3) > highest){
						highest = resultb.getDouble(3);
						buyer = resultb.getString(1);
					}
				}
				
				// Display the current iteration's Auction information the user.
				out.println("<h4>"+ result.getString(8) +"</h4>"); // Item name
				out.println("<h5> Auction ID: "+ result.getString(9) +"</h5>");
				out.println("<p>" + 
							"Sold by " + result.getString(3) + "<br>" +
							"Current bid: $" + String.format("%.2f", highest) + " by "+ buyer + "<br>" +
							"Minimum bid increment: $" + String.format("%.2f", result.getDouble(4)) + "<br>" +
							"Start Date: " + result.getString(6) + "<br>" +
							"End Date: " + result.getString(5) + "<br>" +
							"</p>" +
							"View Seller" + "<br>"); // Create link to user here.
				
				// Show options to view histories/profiles only if there exists at least 1 bid.
				if(!buyer.equals("N/A")){
					out.print("View Bid History" + "<br>" + // Create link to bidhistory.jsp here.
							  "View Current Bidder" + "<br>" ); // Create link to user here.
				}
				out.println("<hr>");
				
				// Reset highest bid and buyer variables for next loop iteration.
				highest = 0;
				buyer= "N/A";
			}
			
			out.print("<p style=\"font-size:13px; text-align:center;\"> " +
					  "End of query.</p>");
			con.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>