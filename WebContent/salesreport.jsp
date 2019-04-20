<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<!-- Import Statements -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title></title>
</head>
<body>
<h1>Get Sales Report For:</h1>
<%! public static String getBestItems(Connection con){
	String report = "";
	
	try{
		String insert = "SELECT item_name, sum(bid) as bid FROM Best_Items group by itemID ORDER BY bid DESC";
		PreparedStatement ps = con.prepareStatement(insert);
		ResultSet res = ps.executeQuery();
		if(res.next()){
			report+="Item: " +res.getString("item_name")+"		$"+Double.toString(res.getDouble("bid"));
			}
		}catch(Exception ex){
		report += ex;
		}

		return report;
}
	public static String getBestSeller(Connection con){
		String report = "";
	
		try{
			String insert = "SELECT sellerID, SUM(BID) as revenue FROM Max_Bid GROUP BY sellerID ORDER BY revenue DESC";
			PreparedStatement ps = con.prepareStatement(insert);
			ResultSet res = ps.executeQuery();
			if(res.next()){
				report+="Seller " +res.getString("sellerID")+"		$"+Double.toString(res.getDouble("revenue"));
				}
			}catch(Exception ex){
			//out.print(ex);
			}

			return report;
	}
	public static String getBestBuyer(Connection con){
		String report = "";
		
		try{
			String insert = "SELECT * FROM Best_Buyers";
			PreparedStatement ps = con.prepareStatement(insert);
			ResultSet res = ps.executeQuery();
			if(res.next()){
				report+="User " +res.getString("user")+"		$"+Double.toString(res.getDouble("revenue"));
				}
			}catch(Exception ex){
			//out.print(ex);
			}
	
			return report;
	}
	public static String getTotalSales(Connection con){
	String report = "";
	
		try{
			String insert = "SELECT ROUND(SUM(bid), 2) from Completed_Auctions";
			PreparedStatement ps = con.prepareStatement(insert);
			ResultSet res = ps.executeQuery();
			if(res.next()){
				report+=res.getDouble("ROUND(SUM(bid), 2)");
				}
			}catch(Exception ex){
			//out.print(ex);
			}
		
		return "$"+report;} 
	
	//this makes a table for earnings per itemtype -> item
	public static String getSalesPerItem(Connection con, String genre){
		String thing = "";
		try{
			String insert = "SELECT item_name, SUM(bid) as revenue FROM Genre_Sales WHERE subcat_name = ? GROUP BY itemID";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, genre);
			ResultSet res = ps.executeQuery();
			while(res.next()){
				thing+="<p style=\"padding-left: 20px;\">"+res.getString("item_name")+ " $"+res.getDouble("revenue")+"</p>"+'\n';
				}
			}catch(Exception ex){
			//out.print(ex);
			thing +="no";
		}
		return thing;
	};
	public static String getSalesPerGenre(Connection con){
		String thing = "";
		try{
			
			thing+="<h2>Categories</h2>";
			String insert = "SELECT subcat_name, sum(bid) as revenue FROM Genre_Sales GROUP BY subcat_name";
			PreparedStatement ps = con.prepareStatement(insert);
			ResultSet res = ps.executeQuery();
			while(res.next()){
				thing+="<p>"+res.getString("subcat_name")+ " $"+res.getDouble("revenue")+"</p>";
				thing +=getSalesPerItem(con, res.getString("subcat_name"));
				}
			}catch(Exception ex){
			//out.print(ex);
			thing +="no";
		}
		return thing;
	};

	%>

<%
	try {

		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
		
		//list of auctions done, this is to avoid redundant queries
		out.print("<p>Total Sales: " +getTotalSales(con) + "</p>");
		out.print(getSalesPerGenre(con));
		
		out.print("<h2>Best:</h2>");
		
		out.print("<h3 style=\"padding-left: 15px;\">Buyer: " +getBestBuyer(con));
		out.print("<h3 style=\"padding-left: 15px;\">" +getBestItems(con)+"</h3>");
		out.print("<h3 style=\"padding-left: 15px;\">" +getBestSeller(con)+"</h3>");
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>

</body>
</html>