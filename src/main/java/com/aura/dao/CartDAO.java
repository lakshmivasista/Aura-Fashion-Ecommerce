package com.aura.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.aura.util.DBConnection;
import com.aura.model.CartItem;

public class CartDAO {

    // ============================================================
    // GET CART ID BY USER
    // ============================================================

    public int getCartIdByUser(int userId) {

        int cartId = -1;

        try {

            Connection con = DBConnection.getConnection();

            String query = "SELECT cart_id FROM cart WHERE user_id=?";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                cartId = rs.getInt("cart_id");

            } else {

                String insert =
                        "INSERT INTO cart(user_id) VALUES(?)";

                PreparedStatement ps2 =
                        con.prepareStatement(
                                insert,
                                Statement.RETURN_GENERATED_KEYS
                        );

                ps2.setInt(1, userId);

                ps2.executeUpdate();

                ResultSet keys = ps2.getGeneratedKeys();

                if (keys.next()) {
                    cartId = keys.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return cartId;
    }


    // ============================================================
    // ADD PRODUCT TO CART WITH SELECTED VARIANT
    // ============================================================

    public void addToCart(int userId, int productId, int variantId) {

        try {

            Connection con = DBConnection.getConnection();

            int cartId = getCartIdByUser(userId);

            if (cartId == -1) {
                return;
            }


            // Check whether this exact product + size already exists
            String checkQuery =
                    "SELECT quantity "
                  + "FROM cart_items "
                  + "WHERE cart_id=? "
                  + "AND product_id=? "
                  + "AND variant_id=?";

            PreparedStatement checkPs =
                    con.prepareStatement(checkQuery);

            checkPs.setInt(1, cartId);
            checkPs.setInt(2, productId);
            checkPs.setInt(3, variantId);

            ResultSet rs = checkPs.executeQuery();


            if (rs.next()) {

                // =================================================
                // EXISTING PRODUCT + SAME SIZE
                // Increase quantity
                // =================================================

                int qty = rs.getInt("quantity");

                String updateQuery =
                        "UPDATE cart_items "
                      + "SET quantity=? "
                      + "WHERE cart_id=? "
                      + "AND product_id=? "
                      + "AND variant_id=?";

                PreparedStatement ps =
                        con.prepareStatement(updateQuery);

                ps.setInt(1, qty + 1);
                ps.setInt(2, cartId);
                ps.setInt(3, productId);
                ps.setInt(4, variantId);

                ps.executeUpdate();

            } else {

                // =================================================
                // NEW PRODUCT + SIZE
                // =================================================

                String insertQuery =
                        "INSERT INTO cart_items "
                      + "(cart_id, product_id, variant_id, quantity) "
                      + "VALUES (?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(insertQuery);

                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                ps.setInt(3, variantId);
                ps.setInt(4, 1);

                ps.executeUpdate();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }


    // ============================================================
    // GET CART ITEMS
    // ============================================================

    public List<CartItem> getCartItems(int userId) {

        List<CartItem> list = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "SELECT ci.cart_item_id, "
                  + "p.name, "
                  + "p.price, "
                  + "p.image_url, "
                  + "v.size, "
                  + "ci.quantity "
                  + "FROM cart_items ci "
                  + "JOIN cart c "
                  + "ON ci.cart_id = c.cart_id "
                  + "JOIN products p "
                  + "ON ci.product_id = p.product_id "
                  + "JOIN product_variants v "
                  + "ON ci.variant_id = v.variant_id "
                  + "WHERE c.user_id=?";

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                CartItem item = new CartItem();

                item.setCartItemId(
                        rs.getInt("cart_item_id")
                );

                item.setProductName(
                        rs.getString("name")
                );

                item.setPrice(
                        rs.getDouble("price")
                );

                item.setQuantity(
                        rs.getInt("quantity")
                );

                item.setImageUrl(
                        rs.getString("image_url")
                );

                // Selected size
                item.setSize(
                        rs.getString("size")
                );

                list.add(item);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // ============================================================
    // REMOVE ITEM
    // ============================================================

    public void removeItem(int cartItemId) {

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "DELETE FROM cart_items "
                  + "WHERE cart_item_id=?";

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, cartItemId);

            ps.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }


    // ============================================================
    // CLEAR CART
    // ============================================================

    public void clearCart(int userId) {

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "DELETE ci "
                  + "FROM cart_items ci "
                  + "JOIN cart c "
                  + "ON ci.cart_id = c.cart_id "
                  + "WHERE c.user_id=?";

            PreparedStatement ps =
                    con.prepareStatement(query);

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }


    // ============================================================
    // UPDATE QUANTITY
    // ============================================================

    public void updateQuantity(int cartItemId, String action) {

        try {

            Connection con = DBConnection.getConnection();

            if ("increase".equals(action)) {

                String query =
                        "UPDATE cart_items "
                      + "SET quantity = quantity + 1 "
                      + "WHERE cart_item_id=?";

                PreparedStatement ps =
                        con.prepareStatement(query);

                ps.setInt(1, cartItemId);

                ps.executeUpdate();

            } else if ("decrease".equals(action)) {

                String query =
                        "UPDATE cart_items "
                      + "SET quantity = quantity - 1 "
                      + "WHERE cart_item_id=? "
                      + "AND quantity > 1";

                PreparedStatement ps =
                        con.prepareStatement(query);

                ps.setInt(1, cartItemId);

                ps.executeUpdate();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}