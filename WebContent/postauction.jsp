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

<body>

<%

double startprice = Float.parseFloat(request.getParameter("startprice"));
double minprice = Float.parseFloat(request.getParameter("minprice"));
double minincrement =  Float.parseFloat(request.getParameter("minincrement"));
String start_date_time =  request.getParameter("start_date").substring(0, 10) + "T" + request.getParameter("start_time").substring(11);
String end_date_time = request.getParameter("end_date").substring(0, 10)  + "T" + request.getParameter("end_time").substring(11);

LocalDateTime start, end;

try {
	start = LocalDateTime.parse(start_date_time);
} catch (Exception ex) {
	out.print("Please enter a valid start date.");
	return;
}
try {
	end = LocalDateTime.parse(end_date_time);
} catch (Exception ex) {
	out.print("Please enter a valid end date.");
	return;
}

LocalDateTime now = LocalDateTime.now();

if (startprice < 0.01 || minprice < 0.01 || minincrement < 0.01 || start.isAfter(end) || start.equals(end) || start.isBefore(now)){
	out.print("Something went wrong! Fix these errors in your auction: <p>");
	if (startprice < 0.01) out.print("Starting price must be at least 0.01.  <p>");
	if (minprice < 0.01) out.print("Minimum price must be at least 0.01.  <p>");
	if (minincrement < 0.01) out.print("Minimum increment must be at least 0.01.  <p>");
	if (start.isAfter(end) || start.equals(end)) out.print("Start date and time must be before end date and time.  <p>");
	if (start.isBefore(now)) out.print("Start date and time must be after current date and time.  <p>");
	return;
} else {
	
	try {
	
		String url = "jdbc:mysql://cs336db.cdyhppvxgk6o.us-east-2.rds.amazonaws.com/cs336db";
		//Get the database connection
		Class.forName("com.mysql.jdbc.Driver");
				
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "admin", "rutgers4");	
		
		//Get parameters from the HTML form at the register.jsp
		String isbn = request.getParameter("hidden_isbn");
		String author = request.getParameter("author");
		String title = request.getParameter("title");
		int num_pages = Integer.parseInt(request.getParameter("num_pages"));
		String userID = (String) session.getAttribute("username");
		
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
			ps.setString(4, isbn);
			ps.setString(5, genre);
			ps.setInt(6, num_pages);
			//Run the query against the DB
			ps.executeUpdate();
			
			String has_insert = "INSERT INTO Has(subcat_name, itemID)" + "VALUES (?, ?)";
			PreparedStatement ps9 = con.prepareStatement(has_insert);
			ps9.setString(1, genre);
			ps9.setString(2, isbn);
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
		ps2.setString(7, isbn);
		ps2.setString(8, title);
		ps2.setInt(9, auctionID);
		//Run the query against the DB
		ps2.executeUpdate();
	
		String insert3 = "INSERT INTO Creates(auctionID, username)" + "VALUES(?, ?)";
		PreparedStatement ps3 = con.prepareStatement(insert3);
		
		ps3.setInt(1, auctionID);
		ps3.setString(2, userID);
		ps3.executeUpdate();
		
		String insert4 = "INSERT INTO Is_for(auctionID, itemID)" + "VALUES(?,?)";
		PreparedStatement ps4 = con.prepareStatement(insert4);
		
		ps4.setInt(1, auctionID);
		ps4.setString(2, isbn);
		ps4.executeUpdate();
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
	
		out.print("Auction posted!");
		out.print("<p>");
		out.print("<a href=\"index.jsp\"> Return to index </a>");
		
	} catch (Exception ex) {
		out.print(ex);
	}
}

%>


</body>

</html>