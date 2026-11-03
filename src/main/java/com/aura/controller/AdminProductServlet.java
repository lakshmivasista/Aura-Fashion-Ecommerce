package com.aura.controller;

import java.io.IOException;
import java.util.List;

import com.aura.dao.ProductDAO;
import com.aura.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
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

        // Get all products
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();

        request.setAttribute("products", products);

        // Open admin products page
        request.getRequestDispatcher("/WEB-INF/views/admin-products.jsp")
               .forward(request, response);
    }
}