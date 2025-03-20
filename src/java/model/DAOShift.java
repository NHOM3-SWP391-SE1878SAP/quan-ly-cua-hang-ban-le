package model;

import entity.Shift;
import java.sql.*;
import java.util.Vector;

public class DAOShift extends DBConnect {

    // Lấy tất cả các ca làm việc
    public Vector<Shift> getAllShifts() {
        Vector<Shift> shifts = new Vector<>();
        String sql = "SELECT * FROM Shifts";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                shifts.add(new Shift(
                        rs.getInt("ID"),
                        rs.getString("ShiftName"),
                        rs.getTime("StartTime"),
                        rs.getTime("EndTime")
                ));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return shifts;
    }

    // Lấy thông tin một ca làm việc theo ID
    public Shift getShiftById(int shiftID) {
        Shift shift = null;
        String sql = "SELECT * FROM Shifts WHERE ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, shiftID);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                shift = new Shift(
                        rs.getInt("ID"),
                        rs.getString("ShiftName"),
                        rs.getTime("StartTime"),
                        rs.getTime("EndTime")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return shift;
    }

    // Thêm một ca làm việc mới
    public boolean addShift(Shift shift) {
        String sql = "INSERT INTO Shifts (ShiftName, StartTime, EndTime) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, shift.getShiftName());
            pstmt.setTime(2, (Time) shift.getStartTime());
            pstmt.setTime(3, (Time) shift.getEndTime());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Cập nhật thông tin ca làm việc
    public boolean updateShift(Shift shift) {
        String sql = "UPDATE Shifts SET ShiftName = ?, StartTime = ?, EndTime = ? WHERE ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, shift.getShiftName());
            pstmt.setTime(2, (Time) shift.getStartTime());
            pstmt.setTime(3, (Time) shift.getEndTime());
            pstmt.setInt(4, shift.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Xóa một ca làm việc
    public boolean deleteShift(int shiftID) {
        String sql = "DELETE FROM Shifts WHERE ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, shiftID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
