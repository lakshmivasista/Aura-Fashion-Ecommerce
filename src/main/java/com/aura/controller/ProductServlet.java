
package com.aura.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.aura.dao.ProductDAO;
import com.aura.dao.WishlistDAO;
import com.aura.model.Product;
import com.aura.model.ProductVariant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();

        // 1. Get all products
        List<Product> products = dao.getAllProducts();

        // 2. Store variants for every product
        Map<Integer, List<ProductVariant>> productVariantsMap =
                new HashMap<>();

        for (Product product : products) {

            List<ProductVariant> variants =
                    dao.getVariantsByProductId(product.getProductId());

            productVariantsMap.put(
                    product.getProductId(),
                    variants
            );
        }

        // 3. Get the logged-in customer's wishlist product IDs
        Set<Integer> wishlistProductIds = new HashSet<>();

        HttpSession session = request.getSession(false);

        if (session != null
                && session.getAttribute("userId") instanceof Integer) {

            int userId = (Integer) session.getAttribute("userId");

            WishlistDAO wishlistDAO = new WishlistDAO();

            List<Product> wishlistProducts =
                    wishlistDAO.getWishlistProducts(userId);

            for (Product wishlistProduct : wishlistProducts) {

                wishlistProductIds.add(
                        wishlistProduct.getProductId()
                );
            }
        }

        // 4. Send products to JSP
        request.setAttribute("products", products);

        // 5. Send size variants to JSP
        request.setAttribute(
                "productVariantsMap",
                productVariantsMap
        );

        // 6. Send wishlist product IDs to JSP
        request.setAttribute(
                "wishlistProductIds",
                wishlistProductIds
        );

        // 7. Display the Shop page
        request.getRequestDispatcher(
                "/WEB-INF/views/products.jsp"
        ).forward(request, response);
    }
}
