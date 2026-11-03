
package com.aura.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.aura.dao.AddressDAO;
import com.aura.dao.OrderDAO;
import com.aura.model.Address;
import com.aura.model.Order;
import com.aura.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Verify that the customer is logged in
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        // 2. Get the logged-in customer's ID
        int userId = (Integer) session.getAttribute("userId");

        OrderDAO orderDAO = new OrderDAO();
        AddressDAO addressDAO = new AddressDAO();

        // 3. Retrieve only this customer's orders
        List<Order> orders = orderDAO.getOrdersByUserId(userId);

        // 4. Retrieve products for each order
        Map<Integer, List<OrderItem>> orderItemsMap =
                new HashMap<>();

        // 5. Retrieve the delivery address for each order
        Map<Integer, Address> orderAddressesMap =
                new HashMap<>();

        if (orders != null) {

            for (Order order : orders) {

                int orderId = order.getOrderId();

                List<OrderItem> items =
                        orderDAO.getOrderItemsByOrderId(orderId);

                orderItemsMap.put(orderId, items);

                Address address =
                        addressDAO.getAddressById(order.getAddressId());

                // Use order ID as the key for the JSP
                if (address != null && address.getUserId() == userId) {
                    orderAddressesMap.put(orderId, address);
                }
            }
        }

        // 6. Pass all order information to the JSP
        request.setAttribute("orders", orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.setAttribute("orderAddressesMap", orderAddressesMap);

        // 7. Display the My Orders page
        request.getRequestDispatcher(
                "/WEB-INF/views/my-orders.jsp"
        ).forward(request, response);
    }
}
