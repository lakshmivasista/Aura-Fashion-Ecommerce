
package com.aura.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import com.aura.util.DBConnection;

public class AnalyticsDAO {

    // ============================================================
    // GET STORE SUMMARY
    // ============================================================

    public Map<String, Object> getStoreSummary() {

        Map<String, Object> summary = new LinkedHashMap<>();

        // Default values in case the database query fails.
        summary.put("totalUsers", 0);
        summary.put("totalProducts", 0);
        summary.put("totalOrders", 0);
        summary.put("deliveredOrders", 0);
        summary.put("cancelledOrders", 0);
        summary.put("deliveredOrderValue", 0.0);

        String query =
                "SELECT "
              + "(SELECT COUNT(*) FROM users) AS total_users, "
              + "(SELECT COUNT(*) FROM products) AS total_products, "
              + "(SELECT COUNT(*) FROM orders) AS total_orders, "
              + "(SELECT COUNT(*) FROM orders "
              + " WHERE UPPER(COALESCE(status, '')) = 'DELIVERED') "
              + " AS delivered_orders, "
              + "(SELECT COUNT(*) FROM orders "
              + " WHERE UPPER(COALESCE(status, '')) = 'CANCELLED') "
              + " AS cancelled_orders, "
              + "(SELECT COALESCE(SUM(total_amount), 0) "
              + " FROM orders "
              + " WHERE UPPER(COALESCE(status, '')) = 'DELIVERED') "
              + " AS delivered_order_value";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                summary.put("totalUsers",
                        rs.getInt("total_users"));

                summary.put("totalProducts",
                        rs.getInt("total_products"));

                summary.put("totalOrders",
                        rs.getInt("total_orders"));

                summary.put("deliveredOrders",
                        rs.getInt("delivered_orders"));

                summary.put("cancelledOrders",
                        rs.getInt("cancelled_orders"));

                summary.put("deliveredOrderValue",
                        rs.getDouble("delivered_order_value"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return summary;
    }

    // ============================================================
    // GET ORDER STATUS BREAKDOWN
    // ============================================================

    public Map<String, Integer> getOrderStatusCounts() {

        Map<String, Integer> statusCounts =
                new LinkedHashMap<>();

        // Ensure every standard status appears, even with zero orders.
        statusCounts.put("PLACED", 0);
        statusCounts.put("PROCESSING", 0);
        statusCounts.put("SHIPPED", 0);
        statusCounts.put("DELIVERED", 0);
        statusCounts.put("CANCELLED", 0);

        String query =
                "SELECT UPPER(COALESCE(status, 'UNKNOWN')) "
              + "AS order_status, COUNT(*) AS total "
              + "FROM orders "
              + "GROUP BY UPPER(COALESCE(status, 'UNKNOWN'))";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                String status = rs.getString("order_status");
                int count = rs.getInt("total");

                // Also retain any unexpected status values.
                statusCounts.put(status, count);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return statusCounts;
    }
}
