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
        <a href="register.jsp"> Register </a>
        <p>
        <a href="login.jsp"> Login </a>
        <p>
        <a href="logout.jsp"> Log out </a>
      </form>
      
   </body>
</html>