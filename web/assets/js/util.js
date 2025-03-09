// Format currency in VND
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount);
}

// Format number with thousand separator
function formatNumber(number) {
    return new Intl.NumberFormat('vi-VN').format(number);
}

// Parse currency string back to number
function parseCurrency(currencyString) {
    return parseFloat(currencyString.replace(/[^\d]/g, ''));
}

// Format date to dd/MM/yyyy
function formatDate(date) {
    if (!date) return '';
    const d = new Date(date);
    return d.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

// Format datetime to dd/MM/yyyy HH:mm
function formatDateTime(date) {
    if (!date) return '';
    const d = new Date(date);
    return d.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// Validate number input
function validateNumberInput(input, min = null, max = null) {
    const value = parseFloat(input.value);
    if (isNaN(value)) {
        return false;
    }
    if (min !== null && value < min) {
        return false;
    }
    if (max !== null && value > max) {
        return false;
    }
    return true;
}
