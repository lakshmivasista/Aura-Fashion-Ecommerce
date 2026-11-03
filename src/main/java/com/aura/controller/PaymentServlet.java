package com.aura.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.aura.dao.CartDAO;
import com.aura.model.CartItem;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        CartDAO dao = new CartDAO();
        List<CartItem> cartItems = dao.getCartItems(userId);

        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getPrice() * item.getQuantity();
        }

        request.setAttribute("total", total);

        request.getRequestDispatcher("/WEB-INF/views/payment.jsp")
               .forward(request, response);
    }
}