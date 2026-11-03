package com.aura.controller;

import java.io.IOException;
import java.util.List;

import com.aura.dao.AddressDAO;
import com.aura.dao.CartDAO;
import com.aura.model.Address;
import com.aura.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    // ============================================================
    // SHOW ADDRESS PAGE
    // ============================================================

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        int userId =
                (int) session.getAttribute("userId");


        // Get cart items

        CartDAO cartDAO = new CartDAO();

        List<CartItem> cartItems =
                cartDAO.getCartItems(userId);


        // Calculate total

        double total = 0;

        for (CartItem item : cartItems) {

            total +=
                    item.getPrice() * item.getQuantity();
        }


        // Send total to JSP

        request.setAttribute("total", total);


        // Open address page

        request.getRequestDispatcher(
                "/WEB-INF/views/address.jsp"
        ).forward(request, response);
    }


    // ============================================================
    // SAVE ADDRESS
    // ============================================================

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        int userId =
                (int) session.getAttribute("userId");


        // --------------------------------------------------------
        // Read form values
        // --------------------------------------------------------

        String name =
                request.getParameter("name");

        String phone =
                request.getParameter("phone");

        String pincode =
                request.getParameter("pincode");

        String city =
                request.getParameter("city");

        String state =
                request.getParameter("state");

        String addressLine =
                request.getParameter("address");

        String defaultAddressValue =
                request.getParameter("defaultAddress");


        boolean defaultAddress =
                "on".equals(defaultAddressValue);


        // --------------------------------------------------------
        // Create Address object
        // --------------------------------------------------------

        Address address = new Address();

        address.setUserId(userId);
        address.setFullName(name);
        address.setPhone(phone);
        address.setPincode(pincode);
        address.setCity(city);
        address.setState(state);
        address.setCountry("India");
        address.setAddressLine(addressLine);
        address.setDefaultAddress(defaultAddress);


        // --------------------------------------------------------
        // Save address
        // --------------------------------------------------------

        AddressDAO dao = new AddressDAO();

        int addressId =
                dao.addAddress(address);


        // --------------------------------------------------------
        // Check result
        // --------------------------------------------------------

        if (addressId == -1) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/address?error=save"
            );

            return;
        }


        // --------------------------------------------------------
        // Store address ID in session
        // --------------------------------------------------------

        session.setAttribute(
                "addressId",
                addressId
        );


        // --------------------------------------------------------
        // Continue to payment
        // --------------------------------------------------------

        response.sendRedirect(
                request.getContextPath()
                + "/payment"
        );
    }
}