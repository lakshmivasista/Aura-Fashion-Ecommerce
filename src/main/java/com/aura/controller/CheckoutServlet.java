package com.aura.controller;

import java.io.IOException;
import java.util.Set;

import com.aura.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Set<String> PAYMENT_METHODS = Set.of(
            "Cash on Delivery",
            "Credit / Debit Card",
            "UPI / PhonePe",
            "Net Banking",
            "Wallets"
    );

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Verify that the user is logged in
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");


        // 2. Verify that a delivery address was saved
        Object addressValue = session.getAttribute("addressId");

        if (!(addressValue instanceof Integer)) {

            response.sendRedirect(contextPath + "/address");
            return;
        }

        int addressId = (Integer) addressValue;


        // 3. Read and validate the selected payment method
        String paymentMethod = request.getParameter("paymentMethod");

        if (paymentMethod == null
                || !PAYMENT_METHODS.contains(paymentMethod)) {

            response.sendRedirect(
                    contextPath + "/payment?error=method"
            );
            return;
        }


        // 4. Create the order in MySQL
        OrderDAO orderDAO = new OrderDAO();

        int orderId = orderDAO.createOrder(
                userId,
                addressId,
                paymentMethod
        );


        // 5. Continue only if the order was created successfully
        if (orderId > 0) {

            session.setAttribute("orderId", orderId);

            response.sendRedirect(
                    contextPath + "/order-success"
            );

        } else {

            // Keep the user from seeing a false success page
            response.sendRedirect(
                    contextPath + "/payment?error=order"
            );
        }
    }
}