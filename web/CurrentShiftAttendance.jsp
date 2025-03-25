<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điểm danh ca hiện tại</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .attendance-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
        }
        .table thead {
            background-color: #4e73df;
            color: white;
        }
        .badge-present {
            background-color: #1cc88a;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .badge-absent {
            background-color: #e74a3b;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .badge-waiting {
            background-color: #f6c23e;
            padding: 5px 10px;
            border-radius: 20px;
            color: #000;
        }
        .btn-action {
            min-width: 90px;
        }
        .employee-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>
<main id="main" class="main">

    <div class="container py-4">
        <div class="card attendance-card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0">
                    <i class="fas fa-clipboard-list me-2"></i>Điểm danh ca hiện tại
                </h4>
                <a href="WeeklyScheduleController?service=getAllAttendanceHistory" class="btn btn-light btn-sm">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                </a>
            </div>
            
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th width="25%">Nhân viên</th>
                                <th width="20%">Ca làm việc</th>
                                <th width="20%">Thời gian</th>
                                <th width="15%">Trạng thái</th>
                                <th width="20%">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${currentEmployees}" var="employee">
                                <c:forEach items="${currentShifts}" var="shift">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty employee.avatar}">
                                                        <img src="${employee.avatar}" alt="Avatar" class="employee-avatar">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="employee-avatar bg-secondary d-flex align-items-center justify-content-center">
                                                            <i class="fas fa-user text-white"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span>${employee.employeeName}</span>
                                            </div>
                                        </td>
                                        <td>${shift.shiftName}</td>
                                        <td>
                                            <span class="badge bg-info text-dark">
                                                ${fn:substring(shift.startTime, 0, 5)} - ${fn:substring(shift.endTime, 0, 5)}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty attendanceRecords and fn:contains(attendanceRecords, employee.employeeID)}">
                                                    <span class="badge-present">
                                                        <i class="fas fa-check-circle me-1"></i> Đã điểm danh
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-waiting">
                                                        <i class="fas fa-clock me-1"></i> Chưa điểm danh
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${empty attendanceRecords or !fn:contains(attendanceRecords, employee.employeeID)}">
                                                <form action="WeeklyScheduleController" method="post" class="d-inline">
                                                    <input type="hidden" name="service" value="markAttendance">
                                                    <input type="hidden" name="employeeId" value="${employee.employeeID}">
                                                    <input type="hidden" name="shiftId" value="${shift.shiftId}">
                                                    <button type="submit" name="isPresent" value="true" class="btn btn-success btn-sm btn-action me-1">
                                                        <i class="fas fa-user-check me-1"></i> Có mặt
                                                    </button>
                                                    <button type="submit" name="isPresent" value="false" class="btn btn-danger btn-sm btn-action">
                                                        <i class="fas fa-user-times me-1"></i> Vắng mặt
                                                    </button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                

            </div>
        </div>
    </div>
</main>
    <!-- Bootstrap 5 JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>