
package com.aura.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.aura.model.Product;
import com.aura.util.DBConnection;

import java.util.LinkedHashMap;
import java.util.Map;

public class WishlistDAO {

    // ============================================================
    // ADD PRODUCT TO WISHLIST
    // ============================================================

    public boolean addToWishlist(int userId, int productId) {

        if (userId <= 0 || productId <= 0) {
            return false;
        }

        String query =
                "INSERT INTO wishlist (user_id, product_id) "
              + "VALUES (?, ?) "
              + "ON DUPLICATE KEY UPDATE product_id = VALUES(product_id)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ps.executeUpdate();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================================
    // REMOVE PRODUCT FROM WISHLIST
    // ============================================================

    public boolean removeFromWishlist(int userId, int productId) {

        if (userId <= 0 || productId <= 0) {
            return false;
        }

        String query =
                "DELETE FROM wishlist "
              + "WHERE user_id = ? AND product_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================================
    // GET ALL WISHLIST PRODUCTS FOR A CUSTOMER
    // ============================================================

    public List<Product> getWishlistProducts(int userId) {

        List<Product> products = new ArrayList<>();

        if (userId <= 0) {
            return products;
        }

        String query =
                "SELECT p.product_id, p.name, p.price, p.image_url "
              + "FROM wishlist w "
              + "JOIN products p ON w.product_id = p.product_id "
              + "WHERE w.user_id = ? "
              + "ORDER BY w.added_at DESC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Product product = new Product();

                    product.setProductId(
                            rs.getInt("product_id")
                    );

                    product.setName(
                            rs.getString("name")
                    );

                    product.setPrice(
                            rs.getDouble("price")
                    );

                    product.setImageUrl(
                            rs.getString("image_url")
                    );

                    products.add(product);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // ============================================================
    // CHECK WHETHER A PRODUCT IS ALREADY WISHLISTED
    // ============================================================

    public boolean isInWishlist(int userId, int productId) {

        if (userId <= 0 || productId <= 0) {
            return false;
        }

        String query =
                "SELECT 1 FROM wishlist "
              + "WHERE user_id = ? AND product_id = ? "
              + "LIMIT 1";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

public Map<Integer, Map<Integer, String>> getWishlistVariants(int userId) {

    Map<Integer, Map<Integer, String>> variantsByProduct =
            new LinkedHashMap<>();

    String query =
            "SELECT pv.product_id, pv.variant_id, pv.size "
          + "FROM product_variants pv "
          + "JOIN wishlist w "
          + "ON pv.product_id = w.product_id "
          + "WHERE w.user_id = ? "
          + "ORDER BY w.added_at DESC, "
          + "FIELD(pv.size, 'XS', 'S', 'M', 'L', 'XL', 'XXL')";

    try (
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(query)
    ) {

        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                int productId = rs.getInt("product_id");
                int variantId = rs.getInt("variant_id");
                String size = rs.getString("size");

                variantsByProduct
                    .computeIfAbsent(
                        productId,
                        id -> new LinkedHashMap<>()
                    )
                    .put(variantId, size);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return variantsByProduct;
}

}
