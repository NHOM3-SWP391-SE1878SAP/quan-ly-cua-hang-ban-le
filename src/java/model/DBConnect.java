package model;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnect {

    protected Connection conn = null;
    private static final Logger LOGGER = Logger.getLogger(DBConnect.class.getName());
    
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=SlimDemo2;encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123456";

    /**
     * Constructor with connection parameters
     * @param URL Database connection URL
     * @param userName Database username
     * @param password Database password
     */
    public DBConnect(String URL, String userName, String password) {
        try {
            // Load driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Open connection
            openConnection(URL, userName, password);
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "SQL Server driver not found", ex);
        }
    }

    /**
     * Default constructor
     */
    public DBConnect() {
        this(URL, USERNAME, PASSWORD);
    }

    /**
     * Open database connection
     * @param url Connection URL
     * @param username Database username
     * @param password Database password
     * @return true if connection successful, false otherwise
     */
    public boolean openConnection(String url, String username, String password) {
        try {
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(url, username, password);
                LOGGER.info("Successfully connected to database");
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database connection error: " + ex.getMessage(), ex);
        }
        return false;
    }
    
    /**
     * Open connection with default parameters
     * @return true if connection successful, false otherwise
     */
    public boolean openConnection() {
        return openConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Close database connection
     * @return true if closed successfully, false otherwise
     */
    public boolean closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                conn = null;
                LOGGER.info("Database connection closed");
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error closing database connection: " + ex.getMessage(), ex);
        }
        return false;
    }

    /**
     * Get current connection
     * @return Connection object
     */
    public Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                openConnection();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking connection status: " + ex.getMessage(), ex);
        }
        return conn;
    }

    /**
     * Execute SELECT query and return ResultSet
     * @param sql SQL statement
     * @return ResultSet containing query results
     */
    public ResultSet executeQuery(String sql) {
        ResultSet rs = null;
        try {
            if (conn == null || conn.isClosed()) {
                openConnection();
            }
            
            Statement stmt = conn.createStatement(
                    ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            rs = stmt.executeQuery(sql);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error executing query: " + sql, ex);
        }
        return rs;
    }
    
    /**
     * Execute SELECT query with PreparedStatement
     * @param sql SQL statement with ? parameters
     * @param params Array of parameters
     * @return ResultSet containing query results
     */
    public ResultSet executeQuery(String sql, Object... params) {
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try {
            if (conn == null || conn.isClosed()) {
                openConnection();
            }
            
            pstmt = conn.prepareStatement(sql,
                    ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            
            // Set parameters
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            
            rs = pstmt.executeQuery();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error executing parameterized query: " + sql, ex);
        }
        return rs;
    }
    
    /**
     * Execute INSERT, UPDATE, DELETE statement
     * @param sql SQL statement
     * @return Number of affected rows
     */
    public int executeUpdate(String sql) {
        int result = 0;
        Statement stmt = null;
        try {
            if (conn == null || conn.isClosed()) {
                openConnection();
            }
            
            stmt = conn.createStatement();
            result = stmt.executeUpdate(sql);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error executing update: " + sql, ex);
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing Statement", ex);
            }
        }
        return result;
    }
    
    /**
     * Execute INSERT, UPDATE, DELETE with PreparedStatement
     * @param sql SQL statement with ? parameters
     * @param params Array of parameters
     * @return Number of affected rows
     */
    public int executeUpdate(String sql, Object... params) {
        int result = 0;
        PreparedStatement pstmt = null;
        try {
            if (conn == null || conn.isClosed()) {
                openConnection();
            }
            
            pstmt = conn.prepareStatement(sql);
            
            // Set parameters
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            
            result = pstmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error executing parameterized update: " + sql, ex);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
        return result;
    }

    /**
     * Legacy method for backward compatibility
     */
    public ResultSet getData(String sql) {
        return executeQuery(sql);
    }

    /**
     * Main method to test connection
     */
    public static void main(String[] args) {
        DBConnect db = new DBConnect();
        if (db.getConnection() != null) {
            System.out.println("Connection successful!");
            db.closeConnection();
        } else {
            System.out.println("Connection failed!");
        }
    }
}
