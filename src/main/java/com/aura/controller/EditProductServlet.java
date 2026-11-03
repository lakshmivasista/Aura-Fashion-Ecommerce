package com.aura.controller;

import java.io.IOException;

import com.aura.dao.ProductDAO;
import com.aura.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/products/edit")
public class EditProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ============================================================
    // SHOW EDIT PRODUCT PAGE
    // ============================================================

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check admin role
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get product ID
        String idText = request.getParameter("id");

        if (idText == null || idText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        int productId;

        try {
            productId = Integer.parseInt(idText);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // Get product from database
        ProductDAO dao = new ProductDAO();

        Product product = dao.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // Send product to JSP
        request.setAttribute("product", product);

        request.getRequestDispatcher("/WEB-INF/views/edit-product.jsp")
               .forward(request, response);
    }


    // ============================================================
    // UPDATE PRODUCT
    // ============================================================

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check admin role
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Get product ID
        String productIdText = request.getParameter("productId");

        if (productIdText == null || productIdText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        int productId;

        try {
            productId = Integer.parseInt(productIdText);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }


        // Get updated product name
        String name = request.getParameter("name");

        // Get updated price
        String priceText = request.getParameter("price");

        // Get selected sizes
        String[] sizes = request.getParameterValues("sizes");


        // Validate name
        if (name == null || name.trim().isEmpty()) {
            response.getWriter().println("Product name is required.");
            return;
        }


        // Validate price
        double price;

        try {

            price = Double.parseDouble(priceText);

        } catch (Exception e) {

            response.getWriter().println("Invalid price.");
            return;
        }


        // At least one size should be selected
        if (sizes == null || sizes.length == 0) {
            response.getWriter().println("Please select at least one size.");
            return;
        }


        // Create Product object
        Product product = new Product();

        product.setProductId(productId);
        product.setName(name.trim());
        product.setPrice(price);


        // Get existing image
        ProductDAO dao = new ProductDAO();

        Product existingProduct = dao.getProductById(productId);

        if (existingProduct == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        // Keep existing image
        product.setImageUrl(existingProduct.getImageUrl());


        // Update database
        boolean success = dao.updateProduct(product, sizes);


        if (success) {

            response.sendRedirect(request.getContextPath() + "/admin/products");

        } else {

            response.getWriter().println(
                "Failed to update product. Please try again."
            );
        }
    }
}