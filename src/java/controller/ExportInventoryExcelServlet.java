package controller;

import entity.GoodReceipt;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;
import jxl.Workbook;
import jxl.write.*;
import jxl.write.Number;
import model.GoodReceiptDAO;

public class ExportInventoryExcelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private GoodReceiptDAO goodReceiptDAO;

    @Override
    public void init() throws ServletException {
        goodReceiptDAO = new GoodReceiptDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Thiết lập header để tải file Excel
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=phieu_nhap_hang.xls");

            // Lấy danh sách phiếu nhập hàng từ database
            List<GoodReceipt> goodReceipts = goodReceiptDAO.getAllGoodReceipts();

            try ( // Ghi dữ liệu vào file Excel
                    OutputStream out = response.getOutputStream()) {
                WritableWorkbook workbook = Workbook.createWorkbook(out);
                WritableSheet sheet = workbook.createSheet("Phiếu Nhập Hàng", 0);

                // Định dạng cho tiêu đề
                WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);
                WritableCellFormat headerFormat = new WritableCellFormat(headerFont);

                // Định dạng cho số tiền
                NumberFormat currencyFormat = new NumberFormat("#,##0 VNĐ");
                WritableCellFormat moneyFormat = new WritableCellFormat(currencyFormat);

                // Định dạng cho ngày tháng
                DateFormat dateFormat = new DateFormat("dd/MM/yyyy HH:mm");
                WritableCellFormat dateTimeFormat = new WritableCellFormat(dateFormat);

                // Ghi tiêu đề cột
                sheet.addCell(new Label(0, 0, "Mã nhập hàng", headerFormat));
                sheet.addCell(new Label(1, 0, "Thời gian", headerFormat));
                sheet.addCell(new Label(2, 0, "Nhà cung cấp", headerFormat));
                sheet.addCell(new Label(3, 0, "Tổng tiền", headerFormat));

                // Thiết lập độ rộng cột
                sheet.setColumnView(0, 15);
                sheet.setColumnView(1, 25);
                sheet.setColumnView(2, 30);
                sheet.setColumnView(3, 20);

                // Ghi dữ liệu phiếu nhập hàng
                int row = 1;
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

                for (GoodReceipt receipt : goodReceipts) {
                    sheet.addCell(new Label(0, row, "PN" + String.format("%06d", receipt.getGoodReceiptID())));

                    if (receipt.getReceivedDate() != null) {
                        sheet.addCell(new DateTime(1, row, receipt.getReceivedDate(), dateTimeFormat));
                    } else {
                        sheet.addCell(new Label(1, row, ""));
                    }

                    Supplier supplier = receipt.getSupplier();
                    sheet.addCell(new Label(2, row, supplier != null ? supplier.getSupplierName() : ""));

                    sheet.addCell(new Number(3, row, receipt.getTotalCost(), moneyFormat));

                    row++;
                }

                workbook.write();
                workbook.close();
                out.flush();
            }

        } catch (IOException | WriteException e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("Lỗi khi xuất file Excel: " + e.getMessage());
        }
    }
}
