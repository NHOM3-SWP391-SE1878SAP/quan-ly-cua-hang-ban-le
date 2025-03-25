<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector, entity.Attendance, entity.Employee, entity.Shift, entity.WeekDay" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Quản Lý Lịch Sử Chấm Công</title>

    <!-- Bootstrap & CSS -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">

    <style>
        .attendance-table th, .attendance-table td {
            text-align: center;
            vertical-align: middle;
        }
        .attendance-status {
            padding: 5px 10px;
            border-radius: 10px;
        }
        .present {
            background-color: #d4edda;
            color: #155724;
        }
        .absent {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>

<%@include file="HeaderAdmin.jsp"%>

<main id="main" class="main">
    <!-- Phần tiêu đề giữ nguyên -->
    
    <div class="container">
         <div class="d-flex mb-3">
           
      <a class="btn btn-primary ms-2" href="WeeklyScheduleController?service=viewCurrentShift" style="color: white; margin-top: 5px;">
        <i class="bi bi-people-fill"></i>
        <span>Điểm danh ca hiện tại</span>
    </a>
        </div>

        <table class="table table-bordered attendance-table">
            <thead class="table-light">
                <tr>
                    <th>Nhân viên</th>
                    <th>Ca làm việc</th>
                    <th>Ngày</th>
                    <th>Thời gian làm</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Vector<Attendance> attendanceList = (Vector<Attendance>) request.getAttribute("attendanceList");
                    
                    if (attendanceList != null) {
                        for (Attendance attendance : attendanceList) {
                            Employee employee = attendance.getEmployeesID();
                            Shift shift = attendance.getShiftsID();
                %>
                <tr>
                    <td><%= employee.getEmployeeName() %></td>
                    <td><%= shift.getShiftName() %></td>
                    <td><%= attendance.getWorkDate() %></td>
                    <td><%= shift.getStartTime() %> - <%= shift.getEndTime() %></td>
                    <td>
                        <span class="attendance-status <%= attendance.isPresent() ? "present" : "absent" %>">
                            <%= attendance.isPresent() ? "Có mặt" : "Vắng mặt" %>
                        </span>
                    </td>
                    <td>
                        <form action="WeeklyScheduleController" method="post">
                            <input type="hidden" name="service" value="updateAttendance">
                            <input type="hidden" name="attendanceId" value="<%= attendance.getId() %>">
                            <input type="hidden" name="isPresent" value="<%= !attendance.isPresent() %>">
                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-pencil"></i> Sửa
                            </button>
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</main>

<!-- Modal for Adding Attendance -->


<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/main.js"></script>

</body>
</html>
