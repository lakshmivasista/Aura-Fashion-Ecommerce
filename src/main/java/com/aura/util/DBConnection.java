
package com.aura.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {

    public static Connection getConnection() {

        try {
            Properties properties = new Properties();

            // Load local database configuration
            try (InputStream input = DBConnection.class
                    .getResourceAsStream("/db.properties")) {

                if (input != null) {
                    properties.load(input);
                }
            }

            // Environment variables take priority
            String url = System.getenv("AURA_DB_URL");
            String username = System.getenv("AURA_DB_USER");
            String password = System.getenv("AURA_DB_PASSWORD");

            // Use local properties when environment variables are absent
            if (url == null || url.isBlank()) {
                url = properties.getProperty("db.url");
            }

            if (username == null || username.isBlank()) {
                username = properties.getProperty("db.username");
            }

            if (password == null || password.isBlank()) {
                password = properties.getProperty("db.password");
            }

            if (url == null || username == null || password == null
                    || url.isBlank() || username.isBlank() || password.isBlank()) {

                throw new IllegalStateException(
                    "Database configuration is missing"
                );
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                url,
                username,
                password
            );

        } catch (Exception e) {

            System.err.println("Aura database connection failed");
            e.printStackTrace();

            return null;
        }
    }
}
