<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>New Auction</title>
</head>
<body>

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

<div>
	<form  method="post" action="registerquery.jsp">
	Starting price: <input name="startprice" type="number" min="0.01"/> 
	<br>
	Minimum price: <input name="minprice" type="number" min="0.01"/> 
	<br>
	Minimum increment: <input name="minincrement" type="number" min="0.01"/> 
	<br>
	End date (YYYY-MM-DD): <input name="date" type="text"/> 
	<br>
	End time (HH-MM-SS): <input name="date" type="text"/> 
	<br>
	Color: <input name="color" type="text"/> 
	<br>
<!-- to retrieve do request.getParameter("sex"); -->
	Sex
	<select name="sex">
	    <option value="M">M</option>
	    <option value="F">F</option>
	</select>
	<br>
	Age: <input name="age" type="number" min="0"/> 
	<br>
	Weight (lbs): <input name="weight" type="number" min="1"/> 
	<br>
	<input type="submit" value="submit"/>
	</form>
	<br>
</div>

</body>
</html>