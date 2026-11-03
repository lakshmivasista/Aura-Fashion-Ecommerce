package com.aura.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import com.aura.dao.ProductDAO;
import com.aura.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/products/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class AddProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/add-product.jsp")
               .forward(request, response);
    }


    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check admin
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }


        // Get form data
        String name = request.getParameter("name");
        String priceText = request.getParameter("price");

        // Get selected sizes
        String[] sizes = request.getParameterValues("sizes");

        // Get uploaded image
        Part imagePart = request.getPart("image");


        // Basic validation
        if (name == null || name.trim().isEmpty()
                || priceText == null || priceText.trim().isEmpty()
                || imagePart == null
                || imagePart.getSize() == 0
                || sizes == null || sizes.length == 0) {

            response.getWriter().println("Please fill all fields and select at least one size.");
            return;
        }


        double price;

        try {

            price = Double.parseDouble(priceText);

        } catch (NumberFormatException e) {

            response.getWriter().println("Invalid price.");
            return;
        }


        // Get original filename
        String originalFileName = imagePart.getSubmittedFileName();

        if (originalFileName == null || originalFileName.isBlank()) {
            response.getWriter().println("Please select an image.");
            return;
        }


        // Extract extension
        String extension = "";

        int dotIndex = originalFileName.lastIndexOf(".");

        if (dotIndex >= 0) {
            extension = originalFileName.substring(dotIndex);
        }


        // Generate unique filename
        String fileName = UUID.randomUUID().toString() + extension;


        // Locate product image folder
        String uploadPath =
                getServletContext().getRealPath("/assets/images/products");

        if (uploadPath == null) {
            response.getWriter().println("Unable to locate image folder.");
            return;
        }


        Path uploadDirectory = Paths.get(uploadPath);

        // Create folder if it doesn't exist
        Files.createDirectories(uploadDirectory);


        // Save image
        Path imagePath = uploadDirectory.resolve(fileName);

        try (InputStream inputStream = imagePart.getInputStream()) {

            Files.copy(
                inputStream,
                imagePath,
                StandardCopyOption.REPLACE_EXISTING
            );
        }


        // Create Product object
        Product product = new Product();

        product.setName(name.trim());
        product.setPrice(price);
        product.setImageUrl(fileName);


        // Save product + variants
        ProductDAO dao = new ProductDAO();

        boolean success = dao.addProduct(product, sizes);


        if (success) {

            // Go back to product management
            response.sendRedirect(
                request.getContextPath() + "/admin/products"
            );

        } else {

            // If database insertion fails, remove uploaded image
            try {
                Files.deleteIfExists(imagePath);
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.getWriter().println(
                "Failed to add product. Please try again."
            );
        }
    }
}