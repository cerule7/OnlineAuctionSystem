<html>
	<head>
	<h1 style="text-align:center">Welcome to bookBay!</h1> 
	</head>
   <body>
      <p>Click a link to login, log out or register.</p>
      <% if (session.getAttribute("username") == null) {
      		out.print("You are not logged in");
      } else out.print("Welcome " + (String) session.getAttribute("username") + "!"); %>
      
      <form>
         <% if(session.getAttribute("username") == null){
        	 out.print("<a href=\"login.jsp\"> Login </a>"); 
        	 out.print("<p>");
        	 out.print("<a href=\"register.jsp\"> Register </a>");
         }
        	 %>
        <% if(session.getAttribute("username") != null) {
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
        } %>
      </form>
      

      
   </body>
</html>
