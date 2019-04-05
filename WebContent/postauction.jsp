<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Posted</title>
</head>

<!-- CREATE TABLE Auction(
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
); -->


<body>
<%
try {

	String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
	//Get the database connection
	Class.forName("com.mysql.jdbc.Driver");
			
	ApplicationDB db = new ApplicationDB();	
	Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	

	System.out.println(request.getParameter("hidden_isbn") + " " + request.getParameter("author") + " " +  request.getParameter("title") + " " + request.getParameter("num_pages"));

	
	//Get parameters from the HTML form at the register.jsp
	int isbn = Integer.parseInt(request.getParameter("hidden_isbn"));
	String author = request.getParameter("author");
	String title = request.getParameter("title");
	int num_pages = Integer.parseInt(request.getParameter("num_pages"));
	
	double startprice = Float.parseFloat(request.getParameter("startprice"));
	double minprice = Float.parseFloat(request.getParameter("minprice"));
	double minincrement =  Float.parseFloat(request.getParameter("minincrement"));
	String userID = (String) session.getAttribute("username");
	String start_date_time =  request.getParameter("start_date") + " " + request.getParameter("start_time");
	String end_date_time = request.getParameter("end_date") + " " + request.getParameter("end_time");
	
	String genre;
	
	//add in item to items database if not present
	if(request.getParameter("hidden_genre") == null){
		genre = (String) request.getParameter("genre");
		String insert = "INSERT INTO Item(item_name, author, total_sales, itemID, genre, num_pages)"
				+ "VALUES (?, ?, ?, ?, ?, ?)";
		PreparedStatement ps = con.prepareStatement(insert);
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, title);
		ps.setString(2, author);
		ps.setInt(3, 0);
		ps.setInt(4, isbn);
		ps.setString(5, genre);
		ps.setInt(6, num_pages);
		//Run the query against the DB
		ps.executeUpdate();
		
		String has_insert = "INSERT INTO Has(subcat_name, itemID)" + "VALUES (?, ?)";
		PreparedStatement ps9 = con.prepareStatement(has_insert);
		ps9.setString(1, genre);
		ps9.setInt(2, isbn);
		ps9.executeUpdate();
		
	} else genre = (String) request.getParameter("hidden_genre");
	
	int auctionID = 1;
	String lookup = "SELECT auctionID FROM Auction ORDER BY auctionID DESC LIMIT 1";
	PreparedStatement stmt = con.prepareStatement(lookup);
	ResultSet res = stmt.executeQuery();
	
	if(res.next() != false){
		auctionID = res.getInt("auctionID") + 1; 
	}

	//Make an insert statement for the auction table:
	String insert2 = "INSERT INTO Auction(start_price, min_price, sellerID, min_increment, end_date_time, start_date_time, itemID, item_name, auctionID)"
			+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	//Create a Prepared SQL statement allowing you to introduce the parameters of the query
	PreparedStatement ps2 = con.prepareStatement(insert2);

	//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
	ps2.setDouble(1, startprice);
	ps2.setDouble(2, minprice);
	ps2.setString(3, userID);
	ps2.setDouble(4, minincrement);
	ps2.setString(5, end_date_time);
	ps2.setString(6, start_date_time);
	ps2.setInt(7, isbn);
	ps2.setString(8, title);
	ps2.setInt(9, auctionID);
	//Run the query against the DB
	ps2.executeUpdate();

	String insert3 = "INSERT INTO Creates(auctionID, username)" + "VALUES(?, ?)";
	PreparedStatement ps3 = con.prepareStatement(insert3);
	
	ps3.setInt(1, auctionID);
	ps3.setString(2, userID);
	ps3.executeUpdate();
	
	//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
	con.close();

	out.print("Auction posted!");
	out.print("<p>");
	out.print("<a href=\"index.jsp\"> Return to index </a>");
	
} catch (Exception ex) {
	out.print(ex);
}

%>


</body>

</html>