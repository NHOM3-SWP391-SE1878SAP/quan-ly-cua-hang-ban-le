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
    <div class="pagetitle">
        <h1>Chấm Công</h1>
    </div>

    <div class="container">
        


                <table class="table table-bordered attendance-table">
                    <thead class="table-light">
                        <tr>
                            <th>Nhân viên</th>
                            <th>Ca làm việc</th>
                            <th>Ngày</th>
                            <th>Thời gian làm</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Vector<Attendance> attendanceList = (Vector<Attendance>) request.getAttribute("attendanceList");
                            Vector<Shift> shifts = (Vector<Shift>) request.getAttribute("shifts");

                            if (attendanceList != null) {
                                // Obtenez l'heure actuelle
                                java.util.Date currentTime = new java.util.Date();
                                for (Attendance attendance : attendanceList) {
                                    Employee employee = attendance.getEmployeesID();  // Utilisation correcte du getter
                                    Shift shift = attendance.getShiftsID();  // Utilisation correcte du getter
                                    
                                    // Vérifiez si le quart de travail est passé et l'état de la présence
                                    String statusClass = "absent"; // Par défaut, absent
                                    String statusText = "Vắng mặt";

                                    if (attendance.isPresent()) {
                                        statusClass = "present";
                                        statusText = "Có mặt";
                                    } else if (shift.getEndTime().before(currentTime)) {
                                        statusText = "Vắng mặt";
                                    }

                        %>
                        <tr>
                            <td><%= employee.getEmployeeName() %></td>
                            <td><%= shift.getShiftName() %></td>
                            <td><%= attendance.getWorkDate() %></td>
                            <td><%= shift.getStartTime() %> - <%= shift.getEndTime() %></td>
                            <td>
                                <span class="attendance-status <%= statusClass %>"><%= statusText %></span>
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
