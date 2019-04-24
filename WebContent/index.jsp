<html>
	<head>
	<h1 style="text-align:center">Welcome to bookBay!</h1> 
	</head>
   <body>
      <%
      if (session.getAttribute("username") == null) {
      		out.print("You are not logged in. ");
      		out.print("Login or register to use bookBay.");
      		out.print("<p>");
      } else out.print("Welcome " + (String) session.getAttribute("username") + "!");
      %>
      
      <form>
         <%
         if(session.getAttribute("username") == null){
        	 out.print("<a href=\"login.jsp\"> Login </a>"); 
        	 out.print("<p>");
        	 out.print("<a href=\"register.jsp\"> Register </a>");
         }
        if(session.getAttribute("username") != null) {
        	String url = "profile.jsp?username=" + (String) session.getAttribute("username");
        	out.print("<a href=\"" + url + "\">View Profile</a>");
        	out.print("  <a href=\"logout.jsp\">Log out</a>"); 
        	out.print("<p>");
        	out.print("<a href=\"auctionstart.jsp\"> Post auction </a>");
        	out.print("<br>");
        	out.print("<a href=\"searchauctions.jsp\"> Search or Browse Auctions </a>");
        	out.print("<br>");
         	out.print("<a href=\"searchquestions.jsp\"> Search Q/A </a>");
         	
        	if (((String) session.getAttribute("usertype")).equals("admin")){
        	    out.print("<p> <a href=\"makerep.jsp\"> Make customer representative accounts </a>");  
                out.print("<p> <a href = \"salesreport.jsp\">Generate Sales Report</a>");
          	}
        	out.print("<p>");
        	
        	if (((String) session.getAttribute("usertype")).equals("admin") || ((String) session.getAttribute("usertype")).equals("cust_rep")){
                out.print("<p> <a href = \"bidDelete.jsp\">Delete Bids</a>");
          	}
        	out.print("<p>");

           	String url2 = "AlertHomePage.jsp?username=" + (String) session.getAttribute("username");
        	out.print("<a href=\"" + url2 + "\"> My Alerts </a>");
        	out.print("<p>");
        	String url3 = "addAlertforItem.jsp?username=" + (String) session.getAttribute("username");
        	out.print("<a href=\"" + url3 + "\"> Add Alert for Auction Item </a>");
        	out.print("<p>");
        	out.print("<a href=\"createAlertforISBN.jsp\">  Add Alert for a Particular Book by ISBN </a>");
        	out.print("<p>");
        	out.print("<a href=\"createAlertforGenre.jsp\">  Add Alert for a Particular Genre </a>");
        	out.print("<p>");




        } 
        %>
      </form>
      

      
   </body>
</html>
