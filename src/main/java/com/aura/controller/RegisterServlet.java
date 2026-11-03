package com.aura.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.aura.model.User;
import com.aura.dao.UserDAO;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // 👉 THIS IS IMPORTANT (to open JSP page)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }

    // 👉 keep this (you already had it)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // create user object
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        // call DAO
        UserDAO dao = new UserDAO();
        boolean status = dao.registerUser(user);

        if (status) {
        	    response.sendRedirect("login");
        } else {
            response.getWriter().println("Something went wrong!");
        }
    }
}