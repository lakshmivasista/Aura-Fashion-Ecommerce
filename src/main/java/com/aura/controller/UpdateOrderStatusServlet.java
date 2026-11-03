package com.aura.controller;

import java.io.IOException;

import com.aura.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders/update-status")
public class UpdateOrderStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Check whether the user is logged in
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        // 2. Allow admins only
        Object role = session.getAttribute("role");

        if (!"ADMIN".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Access denied. Admins only.");
            return;
        }

        // 3. Read the submitted order ID
        String orderIdText = request.getParameter("orderId");

        String status = request.getParameter("status");

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdText);
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(
                    contextPath + "/admin/orders?error=invalid"
            );
            return;
        }

        // 4. Update the order status
        OrderDAO orderDAO = new OrderDAO();

        boolean updated = orderDAO.updateOrderStatus(orderId, status);

        // 5. Return to the orders page with the result
        if (updated) {
            response.sendRedirect(
                    contextPath + "/admin/orders?updated=true"
            );
        } else {
            response.sendRedirect(
                    contextPath + "/admin/orders?error=update"
            );
        }
    }
}