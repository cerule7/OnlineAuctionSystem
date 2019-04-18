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
<%! public static String getTotalSales(Connection con, ArrayList<Integer> done){
	String report = "";
	double sum=0;
	for(int e: done){
		double s = 0;
		try{
			String insert = "SELECT MAX(bid) AS price FROM Bids_on WHERE auctionID = ?;";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setInt(1, e);
			ResultSet res = ps.executeQuery();
			if(res.next()){
				s=res.getDouble("price");
				}
			}catch(Exception ex){
			//out.print(ex);
			}
		sum +=s;
	}
	report += Double.toString(sum);
	return report;} 
	
	//this makes a table for earnings per itemtype -> item
	/**
	public static String getSalesPerItem(Connection con, ArrayList<Integer> done){
		String thing = "";
		try{
			String subcat_query = "SELECT * from Subcategory;";
			PreparedStatement ps = con.prepareStatement(subcat_query);
			ResultSet res = ps.executeQuery();
			thing+="<tb>";
				while(res.next()){
					String name =res.getString("subcat_name");
					String subcat_sales = "";
					PreparedStatement ps = con.prepareStatement(subcat_query);
					ResultSet res = ps.executeQuery();
				}
			thing+="</tb>";
			}catch(Exception ex){
			//out.print(ex);
		}
		return thing;
	};
	**/
	public static ArrayList<Integer> auctionsConcluded(Connection con){
		ArrayList<Integer> done = new ArrayList<Integer>();
		try{
			String subcat_query = "SELECT auctionID from Bids_on WHERE auctionID IN (SELECT auctionID FROM Auction WHERE IS_OVER = 1);";
			PreparedStatement ps = con.prepareStatement(subcat_query);
			ResultSet res = ps.executeQuery();
			while(res.next()){
				done.add(res.getInt("auctionID"));
				}
			}catch(Exception ex){
			//out.print(ex);
		}
		
		return done;
	}
	%>

<%
	try {

		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");
		
		//list of auctions done, this is to avoid redundant queries
		ArrayList<Integer> done = auctionsConcluded(con);
		out.print("<p>Total Sales: $" +getTotalSales(con, done) + "</p>");
		//out.print(getSalesPerItem(con, done));
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>

</body>
</html>