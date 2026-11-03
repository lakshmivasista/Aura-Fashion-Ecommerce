
package com.aura.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.aura.dao.WishlistDAO;
import com.aura.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    // ============================================================
    // DISPLAY WISHLIST
    // ============================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Verify customer login
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // 2. Retrieve this customer's wishlist products
        List<Product> wishlistProducts =
                wishlistDAO.getWishlistProducts(userId);

        // 3. Retrieve actual variant IDs and sizes for each product
        Map<Integer, Map<Integer, String>> wishlistVariantsMap =
                wishlistDAO.getWishlistVariants(userId);

        // 4. Read and remove the one-time wishlist message
        String message =
                (String) session.getAttribute("wishlistMessage");

        if (message != null) {
            session.removeAttribute("wishlistMessage");
        }

        // 5. Pass data to the JSP
        request.setAttribute("wishlistProducts", wishlistProducts);
        request.setAttribute("wishlistVariantsMap", wishlistVariantsMap);
        request.setAttribute("wishlistMessage", message);

        // 6. Display the Wishlist page
        request.getRequestDispatcher(
                "/WEB-INF/views/wishlist.jsp"
        ).forward(request, response);
    }

    // ============================================================
    // ADD OR REMOVE WISHLIST PRODUCTS
    // ============================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Verify customer login
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // 2. Determine where to return after the action
        boolean returnToProducts =
                "products".equals(request.getParameter("returnTo"));

        String redirectPath = returnToProducts
                ? contextPath + "/products"
                : contextPath + "/wishlist";

        // 3. Validate product ID
        int productId;

        try {
            productId = Integer.parseInt(
                    request.getParameter("productId")
            );

            if (productId <= 0) {
                throw new NumberFormatException("Invalid product ID");
            }

        } catch (NumberFormatException e) {

            if (!returnToProducts) {
                session.setAttribute("wishlistMessage", "invalid");
            } else {
                session.removeAttribute("wishlistMessage");
            }

            response.sendRedirect(redirectPath);
            return;
        }

        // 4. Process the requested wishlist action
        String action = request.getParameter("action");

        String message;

        if ("add".equals(action)) {

            boolean success =
                    wishlistDAO.addToWishlist(userId, productId);

            message = success ? "added" : "error";

        } else if ("remove".equals(action)) {

            boolean success =
                    wishlistDAO.removeFromWishlist(userId, productId);

            message = success ? "removed" : "error";

        } else {

            message = "invalid";
        }

        // 5. Show feedback only on the Wishlist page
        if (returnToProducts) {
            session.removeAttribute("wishlistMessage");
        } else {
            session.setAttribute("wishlistMessage", message);
        }

        // 6. Redirect to the appropriate page
        response.sendRedirect(redirectPath);
    }
}
