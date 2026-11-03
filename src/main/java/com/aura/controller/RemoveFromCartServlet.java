package com.aura.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.aura.dao.CartDAO;

@WebServlet("/remove-item")
public class RemoveFromCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

        CartDAO dao = new CartDAO();
        dao.removeItem(cartItemId);

        response.sendRedirect("cart");
    }
}