package com.aura.dao;

import com.aura.model.OrderItem;
import java.util.ArrayList;
import java.util.List;
import com.aura.model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import com.aura.util.DBConnection;

public class OrderDAO {

    // ============================================================
    // CREATE ORDER
    // Saves order, order items, and clears cart transactionally
    // ============================================================

    public int createOrder(
            int userId,
            int addressId,
            String paymentMethod) {

        Connection con = null;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);


            // ----------------------------------------------------
            // 1. Verify the delivery address belongs to this user
            // ----------------------------------------------------

            String addressQuery =
                    "SELECT address_id FROM addresses "
                  + "WHERE address_id = ? AND user_id = ?";

            try (PreparedStatement ps =
                         con.prepareStatement(addressQuery)) {

                ps.setInt(1, addressId);
                ps.setInt(2, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return -1;
                    }
                }
            }


            // ----------------------------------------------------
            // 2. Find the user's cart
            // ----------------------------------------------------

            int cartId = -1;

            String cartQuery =
                    "SELECT cart_id FROM cart WHERE user_id = ?";

            try (PreparedStatement ps =
                         con.prepareStatement(cartQuery)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        cartId = rs.getInt("cart_id");
                    }
                }
            }

            if (cartId == -1) {
                con.rollback();
                return -1;
            }


            // ----------------------------------------------------
            // 3. Calculate the order total from the database
            // ----------------------------------------------------

            double totalAmount;
            int itemCount;

            String totalQuery =
                    "SELECT COUNT(*) AS item_count, "
                  + "COALESCE(SUM(p.price * ci.quantity), 0) "
                  + "AS total_amount "
                  + "FROM cart_items ci "
                  + "JOIN products p "
                  + "ON ci.product_id = p.product_id "
                  + "WHERE ci.cart_id = ?";

            try (PreparedStatement ps =
                         con.prepareStatement(totalQuery)) {

                ps.setInt(1, cartId);

                try (ResultSet rs = ps.executeQuery()) {

                    rs.next();

                    itemCount = rs.getInt("item_count");
                    totalAmount = rs.getDouble("total_amount");
                }
            }

            if (itemCount == 0) {
                con.rollback();
                return -1;
            }


            // ----------------------------------------------------
            // 4. Insert the order
            // ----------------------------------------------------

            String orderQuery =
                    "INSERT INTO orders "
                  + "(user_id, address_id, total_amount, "
                  + "status, payment_method, created_at) "
                  + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

            int orderId;

            try (PreparedStatement ps =
                         con.prepareStatement(
                                 orderQuery,
                                 Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, userId);
                ps.setInt(2, addressId);
                ps.setDouble(3, totalAmount);
                ps.setString(4, "PLACED");
                ps.setString(5, paymentMethod);

                int rows = ps.executeUpdate();

                if (rows == 0) {
                    con.rollback();
                    return -1;
                }

                try (ResultSet rs = ps.getGeneratedKeys()) {

                    if (!rs.next()) {
                        con.rollback();
                        return -1;
                    }

                    orderId = rs.getInt(1);
                }
            }


            // ----------------------------------------------------
            // 5. Copy cart items into order_items
            // Preserves the selected size through variant_id
            // ----------------------------------------------------

            String orderItemsQuery =
                    "INSERT INTO order_items "
                  + "(order_id, product_id, variant_id, quantity, price) "
                  + "SELECT ?, ci.product_id, ci.variant_id, "
                  + "ci.quantity, p.price "
                  + "FROM cart_items ci "
                  + "JOIN products p "
                  + "ON ci.product_id = p.product_id "
                  + "WHERE ci.cart_id = ?";

            try (PreparedStatement ps =
                         con.prepareStatement(orderItemsQuery)) {

                ps.setInt(1, orderId);
                ps.setInt(2, cartId);

                int rows = ps.executeUpdate();

                if (rows == 0) {
                    con.rollback();
                    return -1;
                }
            }


            // ----------------------------------------------------
            // 6. Clear cart only after saving the order
            // ----------------------------------------------------

            String clearCartQuery =
                    "DELETE FROM cart_items WHERE cart_id = ?";

            try (PreparedStatement ps =
                         con.prepareStatement(clearCartQuery)) {

                ps.setInt(1, cartId);
                ps.executeUpdate();
            }


            // ----------------------------------------------------
            // 7. Commit all changes together
            // ----------------------------------------------------

            con.commit();

            return orderId;

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception rollbackException) {

                rollbackException.printStackTrace();
            }

            return -1;

        } finally {

            try {

                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }
 // ============================================================
 // GET ALL ORDERS FOR ADMIN
 // ============================================================

 public List<Order> getAllOrders() {

     List<Order> orders = new ArrayList<>();

     String query =
             "SELECT "
           + "o.order_id, "
           + "o.user_id, "
           + "o.address_id, "
           + "u.name AS customer_name, "
           + "u.email AS customer_email, "
           + "o.total_amount, "
           + "o.status, "
           + "o.payment_method, "
           + "o.created_at "
           + "FROM orders o "
           + "JOIN users u ON o.user_id = u.user_id "
           + "ORDER BY o.created_at DESC, o.order_id DESC";

     try (
         Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(query);
         ResultSet rs = ps.executeQuery()
     ) {

         while (rs.next()) {

             Order order = new Order();

             order.setOrderId(
                     rs.getInt("order_id")
             );

             order.setUserId(
                     rs.getInt("user_id")
             );

             order.setAddressId(
                     rs.getInt("address_id")
             );

             order.setCustomerName(
                     rs.getString("customer_name")
             );

             order.setCustomerEmail(
                     rs.getString("customer_email")
             );

             order.setTotalAmount(
                     rs.getDouble("total_amount")
             );

             order.setStatus(
                     rs.getString("status")
             );

             order.setPaymentMethod(
                     rs.getString("payment_method")
             );

             order.setCreatedAt(
                     rs.getTimestamp("created_at")
             );

             orders.add(order);
         }

     } catch (Exception e) {

         e.printStackTrace();
     }

     return orders;
 }
//============================================================
//UPDATE ORDER STATUS
//============================================================

public boolean updateOrderStatus(int orderId, String status) {

  // Accept only supported order statuses
  if (status == null ||
      !java.util.Set.of(
          "PLACED",
          "PROCESSING",
          "SHIPPED",
          "DELIVERED",
          "CANCELLED"
      ).contains(status)) {

      return false;
  }

  String query =
          "UPDATE orders SET status = ? WHERE order_id = ?";

  try (
      Connection con = DBConnection.getConnection();
      PreparedStatement ps = con.prepareStatement(query)
  ) {

      ps.setString(1, status);
      ps.setInt(2, orderId);

      return ps.executeUpdate() == 1;

  } catch (Exception e) {

      e.printStackTrace();
      return false;
  }
}
//============================================================
//GET ORDERS FOR A SPECIFIC CUSTOMER
//============================================================

public List<Order> getOrdersByUserId(int userId) {

 List<Order> orders = new ArrayList<>();

 String query =
         "SELECT order_id, user_id, address_id, "
       + "total_amount, status, payment_method, created_at "
       + "FROM orders "
       + "WHERE user_id = ? "
       + "ORDER BY created_at DESC, order_id DESC";

 try (
     Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement(query)
 ) {

     ps.setInt(1, userId);

     try (ResultSet rs = ps.executeQuery()) {

         while (rs.next()) {

             Order order = new Order();

             order.setOrderId(
                     rs.getInt("order_id")
             );

             order.setUserId(
                     rs.getInt("user_id")
             );

             order.setAddressId(
                     rs.getInt("address_id")
             );

             order.setTotalAmount(
                     rs.getDouble("total_amount")
             );

             order.setStatus(
                     rs.getString("status")
             );

             order.setPaymentMethod(
                     rs.getString("payment_method")
             );

             order.setCreatedAt(
                     rs.getTimestamp("created_at")
             );

             orders.add(order);
         }
     }

 } catch (Exception e) {

     e.printStackTrace();
 }

 return orders;
}

// ============================================================
// GET PRODUCTS PURCHASED IN A SPECIFIC ORDER
// ============================================================

public List<OrderItem> getOrderItemsByOrderId(int orderId) {

    List<OrderItem> items = new ArrayList<>();

    String query =
            "SELECT oi.product_id, "
          + "p.name AS product_name, "
          + "p.image_url, "
          + "pv.size AS item_size, "
          + "oi.quantity, "
          + "oi.price "
          + "FROM order_items oi "
          + "JOIN products p "
          + "ON oi.product_id = p.product_id "
          + "LEFT JOIN product_variants pv "
          + "ON oi.variant_id = pv.variant_id "
          + "WHERE oi.order_id = ? "
          + "ORDER BY oi.product_id";

    try (
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(query)
    ) {

        ps.setInt(1, orderId);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                OrderItem item = new OrderItem();

                item.setProductId(
                        rs.getInt("product_id")
                );

                item.setProductName(
                        rs.getString("product_name")
                );

                item.setImageUrl(
                        rs.getString("image_url")
                );

                item.setSize(
                        rs.getString("item_size")
                );

                item.setQuantity(
                        rs.getInt("quantity")
                );

                item.setPrice(
                        rs.getDouble("price")
                );

                items.add(item);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return items;
}

// ============================================================
// CANCEL ORDER FOR THE CUSTOMER WHO PLACED IT
// Only orders with PLACED status can be cancelled.
// ============================================================

public boolean cancelOrderByCustomer(int orderId, int userId) {

    String query =
            "UPDATE orders "
          + "SET status = 'CANCELLED' "
          + "WHERE order_id = ? "
          + "AND user_id = ? "
          + "AND status = 'PLACED'";

    try (
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(query)
    ) {

        ps.setInt(1, orderId);
        ps.setInt(2, userId);

        // Exactly one matching order must be updated.
        return ps.executeUpdate() == 1;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

}