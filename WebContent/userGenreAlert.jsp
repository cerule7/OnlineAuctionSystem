<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Alert Genre History</title>
</head>

<body>
<%
	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
	
	String userID = request.getParameter("username");
	
	PreparedStatement q = con.prepareStatement("SELECT * FROM AlertTable WHERE FK_username=? AND alertType = 'Genre Alert'");
	q.setString(1, userID);
	ResultSet result = q.executeQuery();
	
	out.print("<h1>" + userID + "'s Genre Alert History </h1>");
	
	if(result.first() == false){
		out.print("<p>");
		out.print(userID + " has not made any valid Genre alerts!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		return;
	} 
	
	result.absolute(0);
	
	while(result.next()){
		String alertType =  String.valueOf(result.getString("alertType"));
		if(alertType.equals("Genre Alert")){
			String genre = result.getString("genre");
			
			out.print("<p>");
			out.print("Genre: "+ genre);
			out.print("<p>");


			

			PreparedStatement q2 = con.prepareStatement("SELECT genre, auctionID FROM Item Inner JOIN Auction ON Item.itemID = Auction.itemID WHERE genre=?");
			q2.setString(1, genre);
			ResultSet resultCurrentAuction = q2.executeQuery();

			if(resultCurrentAuction.next() == false){
				out.print("No Auctions Exist for your Genre!");
				out.print("<p>");

				out.print("<br>");
			} else{
				while(resultCurrentAuction.next()){
					String auctionID= String.valueOf(resultCurrentAuction.getInt("auctionID"));
					out.print("<p>");
					
					PreparedStatement q3 = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
					q3.setString(1, auctionID);
					ResultSet wantedAuctions = q3.executeQuery();	
					
					
					while(wantedAuctions.next()){

							LocalDateTime end = LocalDateTime.parse(wantedAuctions.getString("end_date_time").substring(0, 10) + "T" + wantedAuctions.getString("end_date_time").substring(11));

							if(!LocalDateTime.now().isAfter(end)){
								
								try{
								String itemID = String.valueOf(wantedAuctions.getString("itemID"));
								String item_name = (wantedAuctions.getString("item_name"));

								out.print("Alert:  This auction matches your Genre alert! ");

								out.print("<p>");

								out.print("AuctionID: " + auctionID);
								out.print("<p>");
								out.print("ISBN: "+ itemID);
								out.print("<p>");
		
								out.print("Title: " +item_name);
								out.print("<p>");
		
								out.print("<form  method=\"get\" action=\"auction.jsp\">");
								out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
								out.print("<input type=\"submit\" value=\"View\"/>");
								out.print("</form>");
								out.print("<p>");
								}catch(Exception ex) {
									out.print(ex);
								}
							}
						out.print("<br>");
				}

					
					
		
					
				}

						/*
				PreparedStatement q3 = con.prepareStatement("SELECT * FROM Auction WHERE auctionID=?");
				q3.setString(1, strItemID);
				ResultSet wantedAuctions = q3.executeQuery();	
				
				
				while(wantedAuctions.next()){

						String auctionID = String.valueOf(wantedAuctions.getInt("auctionID"));
						LocalDateTime end = LocalDateTime.parse(wantedAuctions.getString("end_date_time").substring(0, 10) + "T" + wantedAuctions.getString("end_date_time").substring(11));

						if(!LocalDateTime.now().isAfter(end)){
							
							out.print("Alert:  This auction matches your book alert! ");

							out.print("<p>");

							out.print("Auction: " + auctionID);
							out.print("<p>");
							out.print("ISBN: "+ itemID);
							out.print("<p>");
	
							out.print("Title: " +item_name);
							out.print("<p>");
	
							out.print("<form  method=\"get\" action=\"auction.jsp\">");
							out.print("<input type=\"hidden\" name=\"auctionID\" value=\"" + auctionID + "\"/>");
							out.print("<input type=\"submit\" value=\"View\"/>");
							out.print("</form>");
							out.print("<p>");

						
						}
				
					out.print("<br>");
					
				}
				*/
				
					
					
					
					
			}
				
				
				
				
			}
		
	
		out.print("<br>");
		}
	
	
	//Close the connection
	con.close();
	
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");
%>
</body>

</html>