package com.os.mavenproject1.util;

import java.text.NumberFormat;
import java.util.Locale;

public class CurrencyFormatter {
    
    public static String format(int amount) {
        NumberFormat formatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return formatter.format(amount);
    }
} 