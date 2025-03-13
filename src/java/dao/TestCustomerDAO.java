package dao;

import model.Customer;
import java.util.List;

public class TestCustomerDAO {
    public static void main(String[] args) {
        System.out.println("🚀 Bắt đầu test CustomerDAO...");

        CustomerDAO customerDAO = new CustomerDAO();

        List<Customer> customers = customerDAO.getAllCustomers();
        if (customers.isEmpty()) {
            System.out.println("❌ Không có khách hàng nào!");
        } else {
            System.out.println("✅ Lấy danh sách khách hàng thành công!");
            for (Customer c : customers) {
                System.out.println("📌 ID: " + c.getId() + ", Name: " + c.getCustomerName() + ", Phone: " + c.getPhone());
            }
        }
    }
}
