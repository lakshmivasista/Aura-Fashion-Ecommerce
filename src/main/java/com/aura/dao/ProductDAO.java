package com.aura.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.aura.model.Product;
import com.aura.model.ProductVariant;
import com.aura.util.DBConnection;

public class ProductDAO {

    // ============================================================
    // GET ALL PRODUCTS
    // ============================================================

    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "SELECT p.product_id, p.name, p.price, p.image_url, "
                  + "GROUP_CONCAT(v.size) AS sizes "
                  + "FROM products p "
                  + "LEFT JOIN product_variants v "
                  + "ON p.product_id = v.product_id "
                  + "GROUP BY p.product_id";

            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setSizes(rs.getString("sizes"));

                list.add(p);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // ============================================================
    // GET SINGLE PRODUCT BY ID
    // ============================================================

    public Product getProductById(int productId) {

        Product product = null;

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "SELECT p.product_id, p.name, p.price, p.image_url, "
                  + "GROUP_CONCAT(v.size) AS sizes "
                  + "FROM products p "
                  + "LEFT JOIN product_variants v "
                  + "ON p.product_id = v.product_id "
                  + "WHERE p.product_id = ? "
                  + "GROUP BY p.product_id";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                product = new Product();

                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setSizes(rs.getString("sizes"));
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return product;
    }


    // ============================================================
    // GET VARIANTS / SIZES BY PRODUCT ID
    // ============================================================

    public List<ProductVariant> getVariantsByProductId(int productId) {

        List<ProductVariant> variants = new ArrayList<>();

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "SELECT variant_id, product_id, size "
                  + "FROM product_variants "
                  + "WHERE product_id = ? "
                  + "ORDER BY variant_id";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ProductVariant variant = new ProductVariant();

                variant.setVariantId(rs.getInt("variant_id"));
                variant.setProductId(rs.getInt("product_id"));
                variant.setSize(rs.getString("size"));

                variants.add(variant);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return variants;
    }


    // ============================================================
    // ADD PRODUCT
    // ============================================================

    public boolean addProduct(Product product, String[] sizes) {

        Connection con = null;
        PreparedStatement productPs = null;
        PreparedStatement variantPs = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            String productQuery =
                    "INSERT INTO products(name, price, image_url) "
                  + "VALUES (?, ?, ?)";

            productPs = con.prepareStatement(
                    productQuery,
                    PreparedStatement.RETURN_GENERATED_KEYS
            );

            productPs.setString(1, product.getName());
            productPs.setDouble(2, product.getPrice());
            productPs.setString(3, product.getImageUrl());

            int productRows = productPs.executeUpdate();

            if (productRows == 0) {

                con.rollback();
                return false;
            }

            rs = productPs.getGeneratedKeys();

            if (!rs.next()) {

                con.rollback();
                return false;
            }

            int productId = rs.getInt(1);

            if (sizes != null && sizes.length > 0) {

                String variantQuery =
                        "INSERT INTO product_variants(product_id, size) "
                      + "VALUES (?, ?)";

                variantPs = con.prepareStatement(variantQuery);

                for (String size : sizes) {

                    variantPs.setInt(1, productId);
                    variantPs.setString(2, size);

                    variantPs.addBatch();
                }

                variantPs.executeBatch();
            }

            con.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception rollbackException) {

                rollbackException.printStackTrace();
            }

            return false;

        } finally {

            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (productPs != null) {
                    productPs.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (variantPs != null) {
                    variantPs.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

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
    // UPDATE PRODUCT
    // ============================================================

    public boolean updateProduct(Product product, String[] sizes) {

        Connection con = null;
        PreparedStatement productPs = null;
        PreparedStatement deleteVariantPs = null;
        PreparedStatement variantPs = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);


            // 1. Update product

            String productQuery =
                    "UPDATE products "
                  + "SET name = ?, price = ?, image_url = ? "
                  + "WHERE product_id = ?";

            productPs = con.prepareStatement(productQuery);

            productPs.setString(1, product.getName());
            productPs.setDouble(2, product.getPrice());
            productPs.setString(3, product.getImageUrl());
            productPs.setInt(4, product.getProductId());

            int productRows = productPs.executeUpdate();

            if (productRows == 0) {

                con.rollback();
                return false;
            }


            // 2. Delete old sizes

            String deleteVariantQuery =
                    "DELETE FROM product_variants "
                  + "WHERE product_id = ?";

            deleteVariantPs = con.prepareStatement(deleteVariantQuery);

            deleteVariantPs.setInt(1, product.getProductId());

            deleteVariantPs.executeUpdate();


            // 3. Insert new sizes

            if (sizes != null && sizes.length > 0) {

                String variantQuery =
                        "INSERT INTO product_variants(product_id, size) "
                      + "VALUES (?, ?)";

                variantPs = con.prepareStatement(variantQuery);

                for (String size : sizes) {

                    variantPs.setInt(1, product.getProductId());
                    variantPs.setString(2, size);

                    variantPs.addBatch();
                }

                variantPs.executeBatch();
            }


            // 4. Commit

            con.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception rollbackException) {

                rollbackException.printStackTrace();
            }

            return false;

        } finally {

            try {

                if (productPs != null) {
                    productPs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (deleteVariantPs != null) {
                    deleteVariantPs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (variantPs != null) {
                    variantPs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

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
    // DELETE PRODUCT SAFELY
    // ============================================================

    public boolean deleteProduct(int productId) {

        Connection con = null;

        PreparedStatement cartPs = null;
        PreparedStatement orderPs = null;
        PreparedStatement deletePs = null;

        ResultSet cartRs = null;
        ResultSet orderRs = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);


            // ----------------------------------------------------
            // 1. Check cart_items
            // ----------------------------------------------------

            String cartQuery =
                    "SELECT COUNT(*) "
                  + "FROM cart_items "
                  + "WHERE product_id = ?";

            cartPs = con.prepareStatement(cartQuery);

            cartPs.setInt(1, productId);

            cartRs = cartPs.executeQuery();

            if (cartRs.next()) {

                int cartCount = cartRs.getInt(1);

                if (cartCount > 0) {

                    con.rollback();
                    return false;
                }
            }


            // ----------------------------------------------------
            // 2. Check order_items
            // ----------------------------------------------------

            String orderQuery =
                    "SELECT COUNT(*) "
                  + "FROM order_items "
                  + "WHERE product_id = ?";

            orderPs = con.prepareStatement(orderQuery);

            orderPs.setInt(1, productId);

            orderRs = orderPs.executeQuery();

            if (orderRs.next()) {

                int orderCount = orderRs.getInt(1);

                if (orderCount > 0) {

                    con.rollback();
                    return false;
                }
            }


            // ----------------------------------------------------
            // 3. Delete product
            // ----------------------------------------------------

            String deleteQuery =
                    "DELETE FROM products "
                  + "WHERE product_id = ?";

            deletePs = con.prepareStatement(deleteQuery);

            deletePs.setInt(1, productId);

            int deletedRows = deletePs.executeUpdate();

            if (deletedRows == 0) {

                con.rollback();
                return false;
            }


            // ----------------------------------------------------
            // 4. Commit
            // ----------------------------------------------------

            con.commit();

            return true;


        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception rollbackException) {

                rollbackException.printStackTrace();
            }

            return false;


        } finally {

            try {

                if (cartRs != null) {
                    cartRs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (orderRs != null) {
                    orderRs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (cartPs != null) {
                    cartPs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (orderPs != null) {
                    orderPs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

            try {

                if (deletePs != null) {
                    deletePs.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }

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
}