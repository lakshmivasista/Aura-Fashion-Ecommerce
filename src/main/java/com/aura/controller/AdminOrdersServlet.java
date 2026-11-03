package com.aura.controller;

import java.io.IOException;
import java.util.List;

import com.aura.dao.OrderDAO;
import com.aura.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        // Check admin role
        Object role = session.getAttribute("role");

        if (role == null || !"ADMIN".equals(role.toString())) {

            response.sendRedirect(
                    request.getContextPath() + "/home"
            );

            return;
        }

        // Fetch all customer orders
        OrderDAO orderDAO = new OrderDAO();

        List<Order> orders = orderDAO.getAllOrders();

        // Send orders to JSP
        request.setAttribute("orders", orders);

        // Display admin orders page
        request.getRequestDispatcher(
                "/WEB-INF/views/admin-orders.jsp"
        ).forward(request, response);
    }
}