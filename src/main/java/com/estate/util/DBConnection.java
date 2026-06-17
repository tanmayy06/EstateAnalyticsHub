package com.estate.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Port 3306 connects directly to your active local server engine instance
    private static final String URL = "jdbc:mysql://localhost:3306/estate_analytics?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    
    // CRITICAL: Change this text if you set a different password during your MySQL server wizard installation setup!
    private static final String PASSWORD = "admin123"; 

    static {
        try {
            // Force-load the latest v9.7.0 MySQL driver class into the web engine memory runtime loop
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("CRITICAL FAULT: MySQL JDBC Driver bridge linkage failure.");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}