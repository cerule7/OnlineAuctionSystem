<html>
   <head>
     Index
   </head>
   
   <body>
      <p>Click a link to login, log out or register.</p>
      <% if (session.getAttribute("username") == null) {
      		out.print("You are not logged in");
      } else out.print("Welcome " + (String) session.getAttribute("username")); %>
      
      <p>
      
      <form>
        <p>
         <% if(session.getAttribute("username") == null){
        	 out.print("<a href=\"login.jsp\"> Login </a>"); 
        	 out.print("<p>");
        	 out.print("<a href=\"register.jsp\"> Register </a>");
         }
        	 %>
        <p>
        <% if(session.getAttribute("username") != null) {
        	out.print("<a href=\"logout.jsp\"> Log out </a>"); 
        	out.print("<p>");
        	out.print("<a href=\"auctionstart.jsp\"> Post auction </a>");
        	out.print("<br>");
        	out.print("<a href=\"browseauctions.jsp\"> Browse auctions </a>");
        	out.print("<br>");
        	out.print("<a href=\"searchauctions.jsp\"> Search auctions </a>");
        	
        	// Search auctions form.
        	/*
        	out.print("<form action=\"searchauctions.jsp\">" +
        				"<fieldset>" +
						"<legend>Search the list of auctions</legend>" +
						"<input type=\"text\" name=\"query\">" +
						"<input type=\"submit\" value=\"Search\">" +
						"</fieldset>" +
						"</form>");
        	*/
        } %>
        <p>
        <% if (session.getAttribute("usertype") != null && ((String) session.getAttribute("usertype")).equals("admin")){
    	    out.print("<a href=\"makerep.jsp\"> Make customer representative accounts </a>");  
      	}
    	%>
      </form>
      

      
   </body>
</html>