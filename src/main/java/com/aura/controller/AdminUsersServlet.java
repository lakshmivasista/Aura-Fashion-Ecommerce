
package com.aura.controller;

import java.io.IOException;
import java.util.List;

import com.aura.dao.UserDAO;
import com.aura.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    // ============================================================
    // DISPLAY REGISTERED USERS
    // ============================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Check whether the user is logged in
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        // 2. Verify ADMIN role
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/home");
            return;
        }

        // 3. Retrieve registered users
        List<User> users = userDAO.getAllUsers();

        // 4. Pass the data to the JSP
        request.setAttribute("users", users);
        request.setAttribute("totalUsers", users.size());

        // 5. Display the Admin Users page
        request.getRequestDispatcher(
                "/WEB-INF/views/admin-users.jsp"
        ).forward(request, response);
    }
}
