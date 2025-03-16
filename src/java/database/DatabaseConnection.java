package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=slim10;";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "Long2002@";

    private Connection conn;

    public DatabaseConnection() {
        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Kết nối đến SQL Server
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✅ Database connected successfully!");

        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver not found! Hãy kiểm tra thư viện JDBC.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kết nối SQL Server! Kiểm tra lại thông tin kết nối.");
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return conn;
    }

    public static void main(String[] args) {
        DatabaseConnection db = new DatabaseConnection();
        if (db.getConnection() == null) {
            System.out.println("❌ Không thể kết nối database!");
        }
    }
}
