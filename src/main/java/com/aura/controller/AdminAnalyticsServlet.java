
package com.aura.controller;

import java.io.IOException;
import java.util.Map;

import com.aura.dao.AnalyticsDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/analytics")
public class AdminAnalyticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AnalyticsDAO analyticsDAO = new AnalyticsDAO();

    // ============================================================
    // DISPLAY ADMIN ANALYTICS
    // ============================================================

    @Override
    protected void doGet(HttpServletRequest request,
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

        // 2. Verify ADMIN role
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/home");
            return;
        }

        // 3. Fetch live statistics from the database
        Map<String, Object> summary =
                analyticsDAO.getStoreSummary();

        Map<String, Integer> orderStatusCounts =
                analyticsDAO.getOrderStatusCounts();

        // 4. Pass the results to the JSP
        request.setAttribute("summary", summary);

        request.setAttribute(
                "orderStatusCounts",
                orderStatusCounts
        );

        // 5. Display the Analytics page
        request.getRequestDispatcher(
                "/WEB-INF/views/admin-analytics.jsp"
        ).forward(request, response);
    }
}
