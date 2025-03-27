package model;

import entity.Account;
import entity.Employee;
import entity.Role;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Data Access Object for Account
 */
public class DAOAccount extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOAccount.class.getName());
    
    /**
     * Constructor
     */
    public DAOAccount() {
        super();
    }
    
    /**
     * Extract Account object from ResultSet
     * @param rs ResultSet containing account data
     * @return Account object
     * @throws SQLException if a database access error occurs
     */
    private Account extractAccountFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("ID");
        String userName = rs.getString("UserName");
        String password = rs.getString("Password");
        String email = rs.getString("Email");
        String phone = rs.getString("Phone");
        String address = rs.getString("Address");
        int roleID = rs.getInt("RoleID");
        
        // Lấy Role từ ID
        Role role = getRoleById(roleID);
        
        return new Account(id, userName, password, email, phone, address, role);
    }
    
    /**
     * Kiểm tra thông tin đăng nhập
     * @param userName Tên đăng nhập
     * @param password Mật khẩu
     * @return Account object nếu đăng nhập thành công, null nếu thất bại
     */
    public Account checkLogin(String userName, String password) {
        Account account = null;
        String sql = "SELECT * FROM Accounts WHERE UserName = ? AND Password = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, userName);
            pst.setString(2, password);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                account = extractAccountFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking login for user: " + userName, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return account;
    }
    
    /**
     * Lấy thông tin vai trò theo RoleID
     * @param roleID ID của vai trò
     * @return Role object
     */
    private Role getRoleById(int roleID) {
        Role role = null;
        String sql = "SELECT * FROM Roles WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, roleID);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                role = new Role(roleID, rs.getString("RoleName"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving role with ID: " + roleID, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return role;
    }
    
    /**
     * Get all accounts from database
     * @return List containing all accounts
     */
    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return accounts;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Accounts";
        
        try {
            pst = conn.prepareStatement(sql);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                Account account = extractAccountFromResultSet(rs);
                accounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving account list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return accounts;
    }
    
    /**
     * Get account information by ID
     * @param accountId ID of the account to retrieve
     * @return Account object or null if not found
     */
    public Account getAccountById(int accountId) {
        Account account = null;
        String sql = "SELECT * FROM Accounts WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, accountId);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                account = extractAccountFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving account with ID: " + accountId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return account;
    }
    
    /**
     * Get account by username
     * @param userName Username to search for
     * @return Account object or null if not found
     */
    public Account getAccountByUsername(String userName) {
        Account account = null;
        String sql = "SELECT * FROM Accounts WHERE UserName = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, userName);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                account = extractAccountFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving account with username: " + userName, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return account;
    }
    
    /**
     * Add new account to database
     * @param account Account object to add
     * @return true if successful, false if failed
     */
    public boolean addAccount(Account account) {
        String sql = "INSERT INTO Accounts (UserName, Password, Email, Phone, Address, RoleID) VALUES (?, ?, ?, ?, ?, ?)";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, account.getUserName());
            pst.setString(2, account.getPassword());
            pst.setString(3, account.getEmail());
            pst.setString(4, account.getPhone());
            pst.setString(5, account.getAddress());
            pst.setInt(6, account.getRole().getRoleID());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new account: " + account.getUserName(), ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }
    
    /**
     * Update account information
     * @param account Account object with updated information
     * @return true if successful, false if failed
     */
    public boolean updateAccount(Account account) {
        String sql = "UPDATE Accounts SET UserName = ?, Password = ?, Email = ?, Phone = ?, Address = ?, RoleID = ? WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, account.getUserName());
            pst.setString(2, account.getPassword());
            pst.setString(3, account.getEmail());
            pst.setString(4, account.getPhone());
            pst.setString(5, account.getAddress());
            pst.setInt(6, account.getRole().getRoleID());
            pst.setInt(7, account.getId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating account with ID: " + account.getId(), ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }
    
    /**
     * Delete account from database
     * @param accountId ID of the account to delete
     * @return true if successful, false if failed
     */
    public boolean deleteAccount(int accountId) {
        String sql = "DELETE FROM Accounts WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, accountId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting account with ID: " + accountId, ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }

    public Employee getEmployeeByAccountID(int accountID) {
        Employee employee = null;
        String sql = "SELECT * FROM Employees WHERE AccountsID = ? and isAvailable = 1";
        
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, accountID);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                employee = new Employee(
                        rs.getInt("ID"),
                        rs.getString("EmployeeName"),
                        rs.getString("Avatar"),
                        rs.getDate("DoB"),
                    rs.getBoolean("Gender"),
                        rs.getInt("Salary"),
                        rs.getString("CCCD"),
                        rs.getBoolean("IsAvailable"),
                        new Account(accountID, "", "", "", "", "", null) // Chỉ cần Account ID
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return employee;
    }
    
    /**
     * Get Employee by employeeID
     */
    public Employee getEmployeeByID(int employeeID) {
        Employee employee = null;
        String sql = "SELECT e.*, a.* FROM Employees e " +
                    "LEFT JOIN Accounts a ON e.AccountsID = a.ID " +
                    "WHERE e.ID = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, employeeID);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    employee = new Employee();
                    employee.setEmployeeID(rs.getInt("ID"));
                    employee.setEmployeeName(rs.getString("EmployeeName"));
                    // ... set other employee fields
                    
                    // Set Account information if exists
                    if (rs.getInt("AccountsID") != 0) {
                        Account account = new Account();
                        account.setId(rs.getInt("AccountsID"));
                        account.setUserName(rs.getString("UserName"));
                        // ... set other account fields
                        employee.setAccount(account);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, "Error getting employee by ID: " + employeeID, ex);
        }
        
        return employee;
    }
    
    public Account checkLogin1(String userName, String plainPassword) {
    Account account = null;
    String sql = "SELECT * FROM Accounts WHERE UserName = ?";
    
    try (PreparedStatement pst = conn.prepareStatement(sql)) {
        pst.setString(1, userName);
        
        try (ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                String storedHash = rs.getString("Password");
                
                // Thêm các kiểm tra an toàn
                if (storedHash == null || storedHash.trim().isEmpty()) {
                    LOGGER.warning("Empty password hash for user: " + userName);
                    return null;
                }
                
                try {
                    if (BCrypt.checkpw(plainPassword, storedHash)) {
                        account = extractAccountFromResultSet(rs);
                    }
                } catch (IllegalArgumentException e) {
                    LOGGER.log(Level.SEVERE, "Invalid hash format for user: " + userName, e);
                    return null;
                }
            }
        }
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Database error during login", ex);
    }
    
    return account;
}
// Trong DAOAccount.java
public boolean updatePassword(int accountId, String newHashedPassword) {
    String sql = "UPDATE Accounts SET Password = ? WHERE ID = ?";
    
    if (getConnection() == null) {
        LOGGER.severe("Error: Cannot connect to database!");
        return false;
    }
    
    try (PreparedStatement pst = conn.prepareStatement(sql)) {
        pst.setString(1, newHashedPassword);
        pst.setInt(2, accountId);
        int rowsAffected = pst.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error updating password for account ID: " + accountId, ex);
        return false;
    }
}
    /**
     * Main method to test the DAO
     */
public static void main(String[] args) {
    DAOAccount dao = new DAOAccount();
    
    // Test case 1: Đăng nhập đúng
    Account acc1 = dao.checkLogin1("admin", "admin123");
    System.out.println(acc1 != null ? "Đăng nhập thành công" : "Sai thông tin");
    

}

public Account getUserByEmail(String email) {
        String sql = "SELECT id, username, password, email, phone, address, RoleID " +
                     "FROM Accounts WHERE email = ?;";

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                // Tạo đối tượng Account và gán các giá trị từ ResultSet
                Account account = new Account();
                account.setId(rs.getInt("id"));
                account.setUserName(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setAddress(rs.getString("address"));

                // Lấy RoleID và tìm role tương ứng
                int roleId = rs.getInt("RoleID");
                DAORole roleDAO = new DAORole();  // Truyền connection vào RoleDAO
                Role role = roleDAO.getRoleById(roleId);  // Truy vấn để lấy Role từ RoleID
                account.setRole(role);

                return account;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi trong getUserByEmail: " + e.getMessage());
        }

        return null; // Trả về null nếu không tìm thấy user
    }

public void changePass(int id, String newPass) {
        try {
            String sql = "UPDATE Accounts SET password = ? WHERE id = ?";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, newPass);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }
}