document.addEventListener("DOMContentLoaded", function () {
    // Chọn link Customers trong menu
    let customersLink = document.getElementById("customers-link");

    if (customersLink) {
        customersLink.addEventListener("click", function (event) {
            event.preventDefault(); // Ngăn chặn tải lại trang

            // Gửi request AJAX để lấy nội dung từ customers.jsp
            fetch("customers.jsp")
                .then(response => response.text()) // Chuyển đổi response thành HTML
                .then(data => {
                    document.getElementById("main-content").innerHTML = data; // Load vào main-content
                })
                .catch(error => console.error("Lỗi khi tải customers.jsp:", error));
        });
    }
});
