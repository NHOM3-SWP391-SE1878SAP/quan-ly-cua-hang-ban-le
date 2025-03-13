<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, entity.WeeklySchedule, entity.Shift, entity.WeekDay, entity.Employee"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Slim - Lịch Làm Việc</title>

    <!-- Bootstrap & CSS -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">

    <style>
        .schedule-table th, .schedule-table td {
            text-align: center;
            vertical-align: middle;
        }
        .schedule-badge {
            background-color: #e3f2fd;
            padding: 5px 10px;
            border-radius: 10px;
            display: inline-block;
            min-width: 60px;
        }
    </style>
</head>

<%@include file="HeaderAdmin.jsp"%>

<main id="main" class="main">
    <div class="pagetitle">
        <h1>Quản Lý Lịch Làm Việc</h1>
    </div>

    <div class="container">
        <div class="d-flex mb-3">
            <button class="btn btn-primary ms-auto" data-bs-toggle="modal" data-bs-target="#addScheduleModal">
                <i class="bi-calendar-plus"></i> Thêm Lịch Làm Việc
            </button>
        </div>

                <table class="table table-bordered schedule-table">
                    <thead class="table-light">
                        <tr>
                            <th rowspan="2">Ca làm việc</th>
                            <% 
                            // Bạn có thể đã khai báo `weekDays` ở trên, vì vậy không cần khai báo lại ở đây.
                            Vector<WeekDay> weekDays = (Vector<WeekDay>) request.getAttribute("weekDays"); 
                            if (weekDays != null) {
                                for (WeekDay day : weekDays) { 
                            %>
                            <th><%= day.getWeekDay() %></th>
                            <% 
                                } 
                            } 
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        Vector<WeeklySchedule> schedules = (Vector<WeeklySchedule>) request.getAttribute("schedule");
                        Vector<Shift> shifts = (Vector<Shift>) request.getAttribute("shifts");

                        if (shifts != null) {
                            for (Shift shift : shifts) { 
                        %>
                        <tr>
                            <td>
                                <strong><%= shift.getShiftName() %></strong> <br>
                                <small><%= shift.getStartTime() %> - <%= shift.getEndTime() %></small>
                            </td>
                            <% 
                            if (weekDays != null) {
                                for (WeekDay day : weekDays) { 
                                    boolean hasSchedule = false;
                                    WeeklySchedule foundSchedule = null;

                                    if (schedules != null) {
                                        for (WeeklySchedule schedule : schedules) {
                                            if (schedule.getWeekDay().getId() == day.getId() &&
                                                schedule.getShift().getShiftId() == shift.getShiftId()) {
                                                hasSchedule = true;
                                                foundSchedule = schedule;  // Found the correct schedule
                                                break;
                                            }
                                        }
                                    }
                            %>
                            <td>
                                <% if (hasSchedule) { %>
                                    <span class="schedule-badge"><%= foundSchedule.getEmployee().getEmployeeName() %></span>
                                    <!-- Form for delete -->
                                    <form action="WeeklyScheduleController" method="POST" style="display:inline;">
                                        <input type="hidden" name="service" value="deleteSchedule">
                                        <input type="hidden" name="scheduleID" value="<%= foundSchedule.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                    </form>
                                <% } %>
                            </td>
                            <% 
                                } 
                            } 
                            %>
                        </tr>
                        <% 
                            } 
                        } 
                        %>
                    </tbody>
                </table>
    </div>
</main>

<!-- Modal for Adding Weekly Schedule -->
<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-labelledby="addScheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addScheduleModalLabel">Thêm Lịch Làm Việc</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="WeeklyScheduleController" method="POST">
                    <input type="hidden" name="service" value="addSchedule">

                    <div class="row">
                        <div class="col-md-6">
                            <label>Chọn Nhân Viên:</label>
                            <select name="employeeID" class="form-control" required>
                                <% 
                                Vector<Employee> employees = (Vector<Employee>) request.getAttribute("employees");
                                if (employees != null) {
                                    for (Employee employee : employees) { 
                                %>
                                <option value="<%= employee.getEmployeeID() %>"><%= employee.getEmployeeName() %></option>
                                <% 
                                    } 
                                } 
                                %>
                            </select>

                            <label>Chọn Ngày:</label>
                            <select name="weekDayID" class="form-control" required>
                                <% 
                                if (weekDays != null) {
                                    for (WeekDay day : weekDays) { 
                                %>
                                <option value="<%= day.getId() %>"><%= day.getWeekDay() %></option>
                                <% 
                                    } 
                                } 
                                %>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label>Chọn Ca Làm Việc:</label>
                            <select name="shiftID" class="form-control" required>
                                <% 
                                if (shifts != null) {
                                    for (Shift shift : shifts) { 
                                %>
                                <option value="<%= shift.getShiftId() %>">
                                    <%= shift.getShiftName() %> (<%= shift.getStartTime() %> - <%= shift.getEndTime() %>)
                                </option>
                                <% 
                                    } 
                                } 
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="text-center mt-3">
                        <button type="submit" class="btn btn-success">Thêm Lịch</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/main.js"></script>

<% 
    // Nếu có thông báo từ controller, hiển thị bằng JS
    String message = (String) request.getAttribute("message");
    if (message != null) { 
%>
    <script>
        // Sử dụng alert đơn giản
        alert("<%= message %>");
    </script>
<% 
    } 
%>

</body>
</html>
