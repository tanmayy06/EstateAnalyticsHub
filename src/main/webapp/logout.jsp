<%
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("login.jsp?success=Session terminated safely. Authentication locked.");
%>