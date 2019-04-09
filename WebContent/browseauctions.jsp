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
				<option value="item_name">Item Name</option>
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
			ResultSet resulta = con.prepareStatement("SELECT * FROM Auction").executeQuery();
			
			/* Auction table reference:
				CREATE TABLE Auction(
    				start_price Double NOT NULL,
    				min_price Double,
    				sellerID Int NOT NULL,
    				min_increment Double NOT NULL,
    				end_date_time DateTime NOT NULL,
    				start_date_time DateTime NOT NULL,
    				itemID int NOT NULL,
    				item_name char(20) NOT NULL,
    				auctionID int,
    				primary key(auctionID),
          			foreign key(itemID, item_name) references Item(itemID, item_name) ON DELETE CASCADE ON UPDATE CASCADE
				);			
			*/
			
			out.println("<hr>");
			double highest = 0;
			while(resulta.next()){
				// Prepare query for fetching current auction's bids.
				ResultSet resultb = con.prepareStatement("SELECT * FROM Bids_on WHERE auctionID=" 
					+ resulta.getInt(9)).executeQuery();
				
				
				// Find the auction's current bid
				while(resultb.next()){
					if(resultb.getDouble(3) > highest){
						highest = resultb.getDouble(3);
					}
				}
				
				// Display the current Auction tuple as a cell
				out.println("<h4>"+ resulta.getString(8) +"</h4>"); // Item name
				out.println("<h5> Auction ID: "+ resulta.getString(9) +"</h5>");
				out.println("<p>" + 
							"Sold by " + resulta.getString(3) + "<br>" +
							"Current bid: $" + String.format("%.2f", highest) + "<br>" +
							"Minimum bid increment: $" + String.format("%.2f", resulta.getDouble(4)) + "<br>" +
							"Start Date: " + resulta.getString(6) + "<br>" +
							"End Date: " + resulta.getString(5) + "<br>" +
							"</p>");
				out.println("<hr>");
				
				// Reset highest bid pointer
				highest = 0;
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