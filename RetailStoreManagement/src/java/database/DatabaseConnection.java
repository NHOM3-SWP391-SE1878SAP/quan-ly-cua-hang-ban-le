package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConnection {
    private static final String URL = "jdbc:sqlserver://DESKTOP-F488CFL\\LONG:1433;databaseName=slim;encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "Long2002@";

    private Connection conn;

    public DatabaseConnection() {
        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Kết nối đến SQL Server
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
           

        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
            
        }
    }

    public Connection getConnection() {
        return conn;
    }

    public ResultSet getData(String sql) {
        ResultSet rs = null;
        try {
            Statement state = conn.createStatement(
                ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE
            );
            rs = state.executeQuery(sql);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return rs;
    }

    public static void main(String[] args) {
        DatabaseConnection db = new DatabaseConnection();
    }
}
