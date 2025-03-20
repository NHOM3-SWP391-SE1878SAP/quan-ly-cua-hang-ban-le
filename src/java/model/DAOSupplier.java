package model;

import entity.GoodReceipt;
import entity.Supplier;
import entity.SupplierPayment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOSupplier extends DBConnect {
    
    public List<GoodReceipt> getGoodReceipts(int supplierId, String fromDate, String toDate) {
        List<GoodReceipt> list = new ArrayList<>();
        String sql = "SELECT * FROM [GoodsReceipt] WHERE [SuppliersID]=?";
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND [ReceivedDate] >= ?";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND [ReceivedDate] <= ?";
        }
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, supplierId);
            int paramIndex = 2;
            if (fromDate != null && !fromDate.isEmpty()) {
                st.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                st.setString(paramIndex, toDate);
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                GoodReceipt receipt = new GoodReceipt();
                receipt.setGoodReceiptID(rs.getInt("ID"));
                receipt.setReceivedDate(rs.getDate("ReceivedDate"));
                receipt.setTotalCost(rs.getInt("TotalCost"));
                receipt.setSupplier(getSupplierById(rs.getInt("SuppliersID")));
                list.add(receipt);
            }
        } catch (SQLException e) {
            System.out.println("getGoodReceipts: " + e.getMessage());
        }
        return list;
    }
    
    public List<SupplierPayment> getSupplierPayments(int supplierId, String fromDate, String toDate) {
        List<SupplierPayment> list = new ArrayList<>();
        String sql = "SELECT * FROM SupplierPayments WHERE SupplierID=?";
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND PaymentDate >= ?";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND PaymentDate <= ?";
        }
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, supplierId);
            int paramIndex = 2;
            if (fromDate != null && !fromDate.isEmpty()) {
                st.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                st.setString(paramIndex, toDate);
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                SupplierPayment payment = new SupplierPayment();
                payment.setSupplierPaymentID(rs.getInt("PaymentID"));
                payment.setAmountPaid(rs.getInt("AmountPaid"));
                payment.setPaymentDate(rs.getDate("PaymentDate"));
                payment.setPaymentMethod(rs.getString("PaymentMethod"));
                payment.setNotes(rs.getString("Notes"));
                payment.setSupplier(getSupplierById(rs.getInt("SupplierID")));
                list.add(payment);
            }
        } catch (SQLException e) {
            System.out.println("getSupplierPayments: " + e.getMessage());
        }
        return list;
    }
    
    public int addSupplierPayment(SupplierPayment payment) {
        String sql = "INSERT INTO SupplierPayments (SupplierID, AmountPaid, PaymentDate, " +
                    "PaymentMethod, Notes) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, payment.getSupplier().getId());
            st.setInt(2, payment.getAmountPaid());
            st.setDate(3, new java.sql.Date(payment.getPaymentDate().getTime()));
            st.setString(4, payment.getPaymentMethod());
            st.setString(5, payment.getNotes());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addSupplierPayment: " + e.getMessage());
        }
        return 0;
    }
    
    public int updateSupplierBalance(int supplierId, int amountPaid) {
        String sql = "UPDATE Suppliers SET CurrentDebt = CurrentDebt - ? WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, amountPaid);
            st.setInt(2, supplierId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateSupplierBalance: " + e.getMessage());
        }
        return 0;
    }
    
    // Add new supplier
    public int addSupplier(Supplier supplier) {
        String sql = "INSERT INTO Suppliers (SupplierCode, SupplierName, CompanyName, TaxCode, " +
                    "Phone, Address, Email, Region, Ward, CreatedBy, CreatedDate, Notes, Status, " +
                    "SupplierGroup, TotalPurchase, CurrentDebt) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, supplier.getSupplierCode());
            st.setString(2, supplier.getSupplierName());
            st.setString(3, supplier.getCompanyName());
            st.setString(4, supplier.getTaxCode());
            st.setString(5, supplier.getPhone());
            st.setString(6, supplier.getAddress());
            st.setString(7, supplier.getEmail());
            st.setString(8, supplier.getRegion());
            st.setString(9, supplier.getWard());
            st.setString(10, supplier.getCreatedBy());
            st.setString(11, supplier.getCreatedDate());
            st.setString(12, supplier.getNotes());
            st.setBoolean(13, supplier.isStatus());
            st.setString(14, supplier.getSupplierGroup());
            st.setDouble(15, supplier.getTotalPurchase());
            st.setDouble(16, supplier.getCurrentDebt());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Update supplier
    public int updateSupplier(Supplier supplier) {
        String sql = "UPDATE Suppliers SET SupplierCode=?, SupplierName=?, CompanyName=?, " +
                    "TaxCode=?, Phone=?, Address=?, Email=?, Region=?, Ward=?, " +
                    "Notes=?, Status=?, SupplierGroup=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, supplier.getSupplierCode());
            st.setString(2, supplier.getSupplierName());
            st.setString(3, supplier.getCompanyName());
            st.setString(4, supplier.getTaxCode());
            st.setString(5, supplier.getPhone());
            st.setString(6, supplier.getAddress());
            st.setString(7, supplier.getEmail());
            st.setString(8, supplier.getRegion());
            st.setString(9, supplier.getWard());
            st.setString(10, supplier.getNotes());
            st.setBoolean(11, supplier.isStatus());
            st.setString(12, supplier.getSupplierGroup());
            st.setInt(13, supplier.getId());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Delete supplier
    public int deleteSupplier(int id) {
        String sql = "DELETE FROM Suppliers WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Get all suppliers
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierCode(rs.getString("SupplierCode"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setCompanyName(rs.getString("CompanyName"));
                s.setTaxCode(rs.getString("TaxCode"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                s.setRegion(rs.getString("Region"));
                s.setWard(rs.getString("Ward"));
                s.setCreatedBy(rs.getString("CreatedBy"));
                s.setCreatedDate(rs.getString("CreatedDate"));
                s.setNotes(rs.getString("Notes"));
                s.setStatus(rs.getBoolean("Status"));
                s.setSupplierGroup(rs.getString("SupplierGroup"));
                s.setTotalPurchase(rs.getDouble("TotalPurchase"));
                s.setCurrentDebt(rs.getDouble("CurrentDebt"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("getAllSuppliers: " + e.getMessage());
        }
        return list;
    }
    
    // Get supplier by ID
    public Supplier getSupplierById(int id) {
        String sql = "SELECT * FROM Suppliers WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierCode(rs.getString("SupplierCode"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setCompanyName(rs.getString("CompanyName"));
                s.setTaxCode(rs.getString("TaxCode"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                s.setRegion(rs.getString("Region"));
                s.setWard(rs.getString("Ward"));
                s.setCreatedBy(rs.getString("CreatedBy"));
                s.setCreatedDate(rs.getString("CreatedDate"));
                s.setNotes(rs.getString("Notes"));
                s.setStatus(rs.getBoolean("Status"));
                s.setSupplierGroup(rs.getString("SupplierGroup"));
                s.setTotalPurchase(rs.getDouble("TotalPurchase"));
                s.setCurrentDebt(rs.getDouble("CurrentDebt"));
                return s;
            }
        } catch (SQLException e) {
            System.out.println("getSupplierById: " + e.getMessage());
        }
        return null;
    }
    
    // Search suppliers with filters
    public List<Supplier> searchSuppliers(String code, String name, String phone, String group) {
        List<Supplier> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Suppliers WHERE 1=1");
        ArrayList<Object> params = new ArrayList<>();
        
        if (code != null && !code.trim().isEmpty()) {
            sql.append(" AND SupplierCode LIKE ?");
            params.add("%" + code + "%");
        }
        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND SupplierName LIKE ?");
            params.add("%" + name + "%");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql.append(" AND Phone LIKE ?");
            params.add("%" + phone + "%");
        }
        if (group != null && !group.trim().isEmpty()) {
            sql.append(" AND SupplierGroup = ?");
            params.add(group);
        }
        
        try {
            PreparedStatement st = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("searchSuppliers: " + e.getMessage());
        }
        return list;
    }
}
