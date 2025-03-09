<%@ page import="java.util.Vector" %>
<%@ page import="entity.Shift" %>
<%@ page import="model.DAOWeeklySchedule" %>
<%@ page import="entity.Account" %>
<%@ page import="entity.Employee" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession sessionUser = request.getSession();
    Account account = (Account) sessionUser.getAttribute("account");
    Employee employee = (Employee) sessionUser.getAttribute("employee");

    if (account == null || employee == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    DAOWeeklySchedule dao = new DAOWeeklySchedule();
    Vector<Shift> shifts = dao.getAllShifts();
%>

<html>
<head>
    <title>Employee Attendance</title>
</head>
<body>
    <h2>Chấm công</h2>
    <form action="AttendanceController" method="post">
        <input type="hidden" name="action" value="markAttendance">
        <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">

        <label for="shiftID">Ca làm:</label>
        <select name="shiftID">
            <% for (Shift s : shifts) { %>
                <option value="<%= s.getShiftId() %>"><%= s.getShiftName() %></option>
            <% } %>
        </select>

        <label>Bạn có đi làm hôm nay không?</label>
        <input type="radio" name="isPresent" value="yes" checked> Có
        <input type="radio" name="isPresent" value="no"> Không

        <button type="submit">Chấm công</button>
    </form>

    <% if (request.getAttribute("message") != null) { %>
        <p><%= request.getAttribute("message") %></p>
    <% } %>
</body>
</html>
