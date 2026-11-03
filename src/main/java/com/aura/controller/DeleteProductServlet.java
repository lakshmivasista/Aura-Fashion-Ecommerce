package com.aura.controller;

import java.io.IOException;

import com.aura.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/products/delete")
public class DeleteProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ============================================================
        // CHECK LOGIN
        // ============================================================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        // ============================================================
        // CHECK ADMIN ROLE
        // ============================================================

        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }


        // ============================================================
        // GET PRODUCT ID
        // ============================================================

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


        // ============================================================
        // DELETE PRODUCT
        // ============================================================

        ProductDAO dao = new ProductDAO();

        boolean success = dao.deleteProduct(productId);


        // ============================================================
        // RESULT
        // ============================================================

        if (success) {

            response.sendRedirect(
                request.getContextPath() + "/admin/products"
            );

        } else {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/products?error=delete"
            );
        }
    }
}