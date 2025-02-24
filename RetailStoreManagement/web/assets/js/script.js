document.addEventListener("DOMContentLoaded", function () {
    loadCustomers();

    document.getElementById("search-box").addEventListener("keyup", function () {
        let searchValue = this.value;
        fetch("CustomerServlet?search=" + searchValue)
            .then(response => response.text())
            .then(data => document.getElementById("customer-list").innerHTML = data);
    });

    document.addEventListener("click", function (event) {
        if (event.target.classList.contains("delete-btn")) {
            let id = event.target.getAttribute("data-id");
            fetch("CustomerServlet?action=delete&id=" + id, { method: "POST" })
                .then(() => loadCustomers());
        }
        
        if (event.target.classList.contains("edit-btn")) {
            document.getElementById("customer-id").value = event.target.getAttribute("data-id");
            document.getElementById("customer-name").value = event.target.getAttribute("data-name");
            document.getElementById("customer-phone").value = event.target.getAttribute("data-phone");
            document.getElementById("customer-address").value = event.target.getAttribute("data-address");
            document.getElementById("customer-points").value = event.target.getAttribute("data-points");
        }
    });

    function loadCustomers() {
        fetch("CustomerServlet")
            .then(response => response.text())
            .then(data => document.getElementById("customer-list").innerHTML = data);
    }
});
