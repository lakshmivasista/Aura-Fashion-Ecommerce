package com.aura.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.aura.dao.UserDAO;
import com.aura.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user != null) {

            HttpSession session = request.getSession(true);

            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());

            System.out.println("SESSION SET: " + user.getUserId());
            System.out.println("ROLE: " + user.getRole());

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {

                response.sendRedirect(request.getContextPath() + "/admin/dashboard");

            } else {

                response.sendRedirect(request.getContextPath() + "/home");
            }

        } 
       else {
            response.getWriter().println("Invalid Login");
        }
        
    }
}