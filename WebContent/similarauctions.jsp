<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import = "main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Similar Auctions</title>
<h1 style="text-align: center">Similar Auctions</h1>
<hr>
</head>
<body>
<%
try{
	// Open the connection to the database
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	Class.forName("com.mysql.jdbc.Driver");		
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
	
	String auctionID = request.getParameter("auctionID");
	
	// Prepare SQL statements.
	String sqlQuery = "SELECT * FROM Auction LEFT JOIN Item ON Auction.ItemID = Item.ItemID";
	ResultSet result = con.prepareStatement(sqlQuery).executeQuery();

	sqlQuery += " WHERE Auction.auctionID = " + auctionID;
	ResultSet auction = con.prepareStatement(sqlQuery).executeQuery();
	auction.next();
	
	// Compare results to find similar auctions, record their indices.
	// Similar auctions are determined by counting how many 
	// attributes are the same between auctions and their items
	ArrayList<Integer> indices = new ArrayList<Integer>(10);
	int count = 0;
	while(result.next()){
		if(result.getString(9).equals(auctionID)){ continue; } // skip the auction we've selected.
		for(int i=1; i<=16; i++){
			if(result.getString(i).equals(auction.getString(i))){
				count++;
			}
		}
		if(count >= 4){
			indices.add(result.getRow());
		}
		count = 0;
	}
	
	// Print the resultant similar auctions.
	double highest = 0;
	String buyer = "N/A";
	while(!indices.isEmpty()){
		result.absolute(indices.remove(0));
		
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
	
} catch(Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>