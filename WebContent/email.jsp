<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="main.*"%>
<!-- Import Statements -->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
   <head>
     Email
   </head>
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
        <% if(session.getAttribute("username") != null) out.print("<a href=\"logout.jsp\"> Log out </a>"); %>
        <p>
        <% if (session.getAttribute("usertype") != null && ((String) session.getAttribute("usertype")).equals("admin")){
    	    out.print("<a href=\"makerep.jsp\"> Make customer representative accounts </a>");  
      	}
    	%>
   <body>
   	<a href = "sendemail.jsp">Send Mail</a>
   	<p>Inbox</p>
      <div>
      	<tr>
    		<th>From</th>
    		<th>Date</th>
    		<% %>
  		</tr>
      	<form></form>
      </div>
      
   </body>
</html>