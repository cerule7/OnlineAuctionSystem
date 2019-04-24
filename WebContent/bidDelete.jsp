<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bid Delete</title>
</head>
<body>
<div>
	To begin deleting an bid, fill in the auction id and user.  Caution: this will delete all bids the user made for that auction.  The user will however still be able to see alerts pertaining to auction.
	<br>
	<form  method="post" action="postDeleteBid.jsp">
	<br>
	AuctionID: <input name="auctionID" type="number" maxlength="11" />
	<br>
	User Name: <input name="userName" type="text" maxlength="21"/>
	<br>
	<input type="submit" value="submit"/>
	</form>
	<br>
</div>

</body>
</html>