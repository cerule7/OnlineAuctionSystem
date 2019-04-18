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
<%! public static String getTotalSales(Connection con){
	String report = "";
	
		try{
			String insert = "SELECT ROUND(SUM(bid), 2) from Completed_Auctions;";
			PreparedStatement ps = con.prepareStatement(insert);
			ResultSet res = ps.executeQuery();
			if(res.next()){
				report+=Double.toString(res.getDouble("ROUND(SUM(bid), 2)"));
				}
			}catch(Exception ex){
			//out.print(ex);
			}
		
	return report;} 
	
	//this makes a table for earnings per itemtype -> item
	public static String getSalesPerItem(Connection con){
		String thing = "";
		try{
			String subcat_query = "SELECT * from Subcategory;";
			PreparedStatement ps = con.prepareStatement(subcat_query);
			ResultSet res = ps.executeQuery();
			thing+="<h2>Categories</h2><tb>";
			
				while(res.next()){
					String name =res.getString("subcat_name");
					thing += "<tr><p>" + name;
					String item_query = "SELECT item_name FROM Items genre = ?";
					
					PreparedStatement items = con.prepareStatement(item_query);
					items.setString(1, name);
					ResultSet rs = items.executeQuery();
					
					while(rs.next()){
						thing += rs.getString("item_name");
					}
					
					thing+="</p></tr>";
					//String subcat_sales = "";
					//PreparedStatement ps = con.prepareStatement(subcat_query);
					//ResultSet res = ps.executeQuery();
				}
			
			thing+="</tb>";
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
		out.print("<p>Total Sales: $" +getTotalSales(con) + "</p>");
		out.print(getSalesPerItem(con));
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>

</body>
</html>