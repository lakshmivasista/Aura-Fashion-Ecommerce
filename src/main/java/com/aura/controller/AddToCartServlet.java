
package com.aura.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.aura.dao.CartDAO;
import com.aura.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // Determine the page to display after processing.
        boolean returnToCart =
                "cart".equals(request.getParameter("returnTo"));

        String redirectPath = returnToCart
                ? contextPath + "/cart"
                : contextPath + "/products";

        String invalidRequestPath = returnToCart
                ? contextPath + "/wishlist"
                : contextPath + "/products";

        // 1. Verify login.
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // 2. Validate product ID.
        int productId;

        try {
            productId = Integer.parseInt(
                    request.getParameter("productId"));

            if (productId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(invalidRequestPath);
            return;
        }

        // 3. Validate selected variant ID.
        int variantId;

        try {
            variantId = Integer.parseInt(
                    request.getParameter("variantId"));

            if (variantId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(invalidRequestPath);
            return;
        }

        // 4. Verify that the selected size belongs to this product.
        String validationQuery =
                "SELECT variant_id "
              + "FROM product_variants "
              + "WHERE variant_id = ? AND product_id = ?";

        boolean validVariant = false;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(validationQuery)
        ) {

            ps.setInt(1, variantId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                validVariant = rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(invalidRequestPath);
            return;
        }

        if (!validVariant) {
            response.sendRedirect(invalidRequestPath);
            return;
        }

        // 5. Add the selected product and size to the existing cart.
        CartDAO cartDAO = new CartDAO();
        cartDAO.addToCart(userId, productId, variantId);

        // 6. Redirect according to where the request originated.
        response.sendRedirect(redirectPath);
    }
}
