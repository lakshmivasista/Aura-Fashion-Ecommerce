
package com.aura.controller;

import java.io.IOException;

import com.aura.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Validate order ID
        int orderId;

        try {
            orderId = Integer.parseInt(
                    request.getParameter("orderId")
            );

            if (orderId <= 0) {
                throw new NumberFormatException("Invalid order ID");
            }

        } catch (NumberFormatException e) {

            session.setAttribute("cancelOrderMessage", "invalid");

            response.sendRedirect(contextPath + "/my-orders");
            return;
        }

        // Cancel the customer's eligible order
        OrderDAO orderDAO = new OrderDAO();

        boolean cancelled =
                orderDAO.cancelOrderByCustomer(orderId, userId);

        // Store a one-time message in the session
        if (cancelled) {
            session.setAttribute("cancelOrderMessage", "success");
        } else {
            session.setAttribute("cancelOrderMessage", "failed");
        }

        // Redirect to a clean URL without query parameters
        response.sendRedirect(contextPath + "/my-orders");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "Use the order cancellation form."
        );
    }
}
