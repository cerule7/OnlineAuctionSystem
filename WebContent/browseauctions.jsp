<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta  http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Browse Auctions</title>
<!-- Displays the current instance of the Auction table in cells separated by <hr> tags. -->
</head>
<body>

	<!-- Form for sorting auction list -->
	<form method="post" action="">
		<fieldset>
			<legend>Sort by:</legend>
			<select name="criteria" size=1>
				<option value="sellerID">Seller</option>
				<option value="min_increment">Minimum Price Increment</option>
				<option value="start_date_time">Auction Start Date</option>
				<option value="auctionID">Auction ID</option>
				<option value="item_name">Book Name</option>
				<option value="genre">Genre</option>
				
			</select>
			<select name="order">
				<option value="ASC">Ascending</option>
				<option value="DESC">Descending</option>
			</select>
			<input type="submit" value="Sort">
		</fieldset>
	</form>

	<%
		try{
			// Open the connection to the database.
			String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
			Class.forName("com.mysql.jdbc.Driver");		
			ApplicationDB db = new ApplicationDB();	
			Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
			
			// Prepare query for displaying auctions.
			String criteria = request.getParameter("criteria");
			String order = request.getParameter("order");
			// The criteria string will be null if users do not click the sorting button.
			// The criteria string will also be null when the user initially visits the page.
			if(criteria == null){
				criteria = "auctionID";
			}
			// The order string follows the same pattern.
			if(order == null){
				order = "ASC";
			}
			ResultSet resulta = con.prepareStatement("SELECT * FROM Auction ORDER BY " +
			criteria + " " + order).executeQuery();
			
			out.println("<hr>");
			double highest = 0;
			String buyer = "N/A";
			
			// Display the list of all auctions.
			while(resulta.next()){
				// Prepare query for fetching current auction's bids.
				ResultSet resultb = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=" 
					+ resulta.getInt(9)).executeQuery();
				
				
				// Find the auction's current bid
				while(resultb.next()){
					if(resultb.getDouble(3) > highest){
						highest = resultb.getDouble(3);
						buyer = resultb.getString(1);
					}
				}
				
				// Display the current iteration's Auction information the user.
				out.println("<h4>"+ resulta.getString(8) +"</h4>"); // Item name
				out.println("<h5> Auction ID: "+ resulta.getString(9) +"</h5>");
				out.println("<p>" + 
							"Sold by " + resulta.getString(3) + "<br>" +
							"Current bid: $" + String.format("%.2f", highest) + " by "+ buyer + "<br>" +
							"Minimum bid increment: $" + String.format("%.2f", resulta.getDouble(4)) + "<br>" +
							"Start Date: " + resulta.getString(6) + "<br>" +
							"End Date: " + resulta.getString(5) + "<br>" +
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
					  "You've reached the end of the auctions list.</p>");
			con.close();
		} catch (Exception e){
			e.printStackTrace();
		}
	%>
</body>
</html>