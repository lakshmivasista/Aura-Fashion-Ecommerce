package com.aura.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.aura.dao.CartDAO;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        String action = request.getParameter("action");

        CartDAO dao = new CartDAO();
        dao.updateQuantity(cartItemId, action);

        response.sendRedirect("cart");
    }
}