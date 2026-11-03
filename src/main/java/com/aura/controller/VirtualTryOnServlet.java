
package com.aura.controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import java.util.List;
import java.util.Locale;

import com.aura.dao.ProductDAO;
import com.aura.model.Product;
import com.aura.model.ProductVariant;
import com.aura.util.FashnTryOnService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/virtual-try-on")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 12 * 1024 * 1024
)
public class VirtualTryOnServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String VIEW =
            "/WEB-INF/views/virtual-try-on.jsp";

    private static final String PRODUCT_IMAGE_FOLDER =
            "/assets/images/products/";

    private static final long MAX_IMAGE_SIZE =
            10L * 1024 * 1024;

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        showPage(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            processTryOn(request);

        } catch (IllegalStateException e) {

            getServletContext().log(
                "Virtual try-on request size or upload error",
                e
            );

            request.setAttribute(
                "tryOnError",
                "Your upload is too large or the request could not be processed. Please use images under 10 MB each"
            );

        } catch (InterruptedException e) {

            Thread.currentThread().interrupt();

            request.setAttribute(
                "tryOnError",
                "Image generation was interrupted. Please try again"
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                "tryOnError",
                e.getMessage()
            );

        } catch (Exception e) {

            getServletContext().log(
                "Virtual try-on generation failed",
                e
            );

            request.setAttribute(
                "tryOnError",
                "We couldn't generate your try-on image right now. The hosted AI service may be busy. Please try again later"
            );
        }

        showPage(request, response);
    }

    private void processTryOn(HttpServletRequest request)
            throws Exception {

        String productIdValue =
                request.getParameter("productId");

        if (productIdValue == null
                || productIdValue.isBlank()) {

            throw new IllegalArgumentException(
                "Please select a product first"
            );
        }

        int productId;

        try {
            productId = Integer.parseInt(
                productIdValue.trim()
            );
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "Please select a valid product"
            );
        }

        if (productId <= 0) {
            throw new IllegalArgumentException(
                "Please select a valid product"
            );
        }

        String category = request.getParameter("category");
        String garmentPhotoType =
                request.getParameter("garmentPhotoType");

        if (category == null || category.isBlank()) {
            category = "one-pieces";
        }

        if (garmentPhotoType == null
                || garmentPhotoType.isBlank()) {
            garmentPhotoType = "model";
        }

        Product product =
                productDAO.getProductById(productId);

        if (product == null) {
            throw new IllegalArgumentException(
                "The selected product could not be found"
            );
        }

        Part personPart =
                request.getPart("personPhoto");

        if (personPart == null
                || personPart.getSize() == 0) {

            throw new IllegalArgumentException(
                "Please upload a photo of yourself"
            );
        }

        if (personPart.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                "Your photo must be 10 MB or smaller"
            );
        }

        String personMimeType =
                personPart.getContentType();

        validateMimeType(personMimeType, "Your photo");

        byte[] personBytes;

        try (InputStream input =
                    personPart.getInputStream()) {
            personBytes = input.readAllBytes();
        }

        if (personBytes.length == 0) {
            throw new IllegalArgumentException(
                "The uploaded photo is empty. Please select another image"
            );
        }

        String originalFileName =
                personPart.getSubmittedFileName();

        if (originalFileName == null
                || originalFileName.isBlank()) {
            originalFileName = "customer-photo";
        } else {
            originalFileName =
                    originalFileName.replace("\\", "/");

            int slash = originalFileName.lastIndexOf('/');

            if (slash >= 0) {
                originalFileName =
                        originalFileName.substring(slash + 1);
            }
        }

        String storedImageUrl = product.getImageUrl();

        if (storedImageUrl == null
                || storedImageUrl.isBlank()) {

            throw new IllegalArgumentException(
                "This product doesn't have an image available for try-on"
            );
        }

        storedImageUrl =
                storedImageUrl.replace("\\", "/");

        int lastSlash = storedImageUrl.lastIndexOf('/');

        String imageFileName = lastSlash >= 0
                ? storedImageUrl.substring(lastSlash + 1)
                : storedImageUrl;

        if (imageFileName.isBlank()
                || ".".equals(imageFileName)
                || "..".equals(imageFileName)) {

            throw new IllegalArgumentException(
                "The selected product image is invalid"
            );
        }

        String imageResourcePath =
                PRODUCT_IMAGE_FOLDER + imageFileName;

        byte[] garmentBytes;

        try (InputStream imageStream =
                    getServletContext().getResourceAsStream(
                        imageResourcePath
                    )) {

            if (imageStream == null) {
                throw new IllegalArgumentException(
                    "The selected product image could not be loaded. Please check its image file in Aura's assets folder"
                );
            }

            garmentBytes = imageStream.readAllBytes();
        }

        if (garmentBytes.length > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                "The selected product image is too large for virtual try-on"
            );
        }

        String garmentMimeType =
                detectImageMimeType(imageFileName);

        if (garmentMimeType == null) {
            garmentMimeType =
                    detectImageMimeType(garmentBytes);
        }

        if (garmentMimeType == null) {
            throw new IllegalArgumentException(
                "The selected product image must be JPEG, PNG, or WebP"
            );
        }

        FashnTryOnService service =
                new FashnTryOnService();

        byte[] generatedBytes = service.generateTryOn(
            personBytes,
            personMimeType,
            originalFileName,
            garmentBytes,
            garmentMimeType,
            imageFileName,
            category,
            garmentPhotoType
        );

        if (generatedBytes == null
                || generatedBytes.length == 0) {

            throw new IOException(
                "The hosted AI service returned an empty image"
            );
        }

        String resultMimeType =
                detectImageMimeType(generatedBytes);

        if (resultMimeType == null) {
            throw new IOException(
                "The generated file was not a supported image"
            );
        }

        String generatedImage =
                "data:" + resultMimeType
                + ";base64,"
                + Base64.getEncoder().encodeToString(
                    generatedBytes
                );

        request.setAttribute(
            "generatedImageData",
            generatedImage
        );

        request.setAttribute(
            "generatedProductId",
            productId
        );

        request.setAttribute(
            "tryOnSuccess",
            "Your virtual try-on image has been generated!"
        );

        request.setAttribute(
            "selectedCategory",
            category
        );

        request.setAttribute(
            "selectedGarmentPhotoType",
            garmentPhotoType
        );
    }

    private void showPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products =
                productDAO.getAllProducts();

        request.setAttribute("products", products);

        /*
         * Also load the chosen product and its actual variants.
         * This allows the result page to offer the same sizes
         * stored in Aura's database.
         */
        String selectedId = request.getParameter("productId");

        Object generatedProductId =
                request.getAttribute("generatedProductId");

        if (generatedProductId != null) {
            selectedId = String.valueOf(generatedProductId);
        }

        Product selectedProduct = null;
        List<ProductVariant> selectedVariants = null;

        if (selectedId != null && !selectedId.isBlank()) {
            try {
                int productId = Integer.parseInt(selectedId);

                if (productId > 0) {
                    selectedProduct =
                            productDAO.getProductById(productId);

                    if (selectedProduct != null) {
                        selectedVariants =
                                productDAO.getVariantsByProductId(
                                    productId
                                );
                    }
                }

            } catch (NumberFormatException e) {
                getServletContext().log(
                    "Invalid product ID on Virtual Try-On page"
                );
            }
        }

        request.setAttribute(
            "selectedProduct",
            selectedProduct
        );

        request.setAttribute(
            "selectedVariants",
            selectedVariants
        );

        request.getRequestDispatcher(VIEW)
                .forward(request, response);
    }

    private void validateMimeType(
            String mimeType,
            String description) {

        if (mimeType == null
                || !(
                    "image/jpeg".equalsIgnoreCase(mimeType)
                    || "image/png".equalsIgnoreCase(mimeType)
                    || "image/webp".equalsIgnoreCase(mimeType)
                )) {

            throw new IllegalArgumentException(
                description
                + " must be a JPEG, PNG, or WebP image"
            );
        }
    }

    private String detectImageMimeType(String fileName) {

        if (fileName == null) {
            return null;
        }

        String lower = fileName.toLowerCase(Locale.ROOT);

        if (lower.endsWith(".jpg")
                || lower.endsWith(".jpeg")) {
            return "image/jpeg";
        }

        if (lower.endsWith(".png")) {
            return "image/png";
        }

        if (lower.endsWith(".webp")) {
            return "image/webp";
        }

        return null;
    }

    private String detectImageMimeType(byte[] bytes) {

        if (bytes == null || bytes.length < 12) {
            return null;
        }

        // PNG signature
        if ((bytes[0] & 0xFF) == 0x89
                && bytes[1] == 0x50
                && bytes[2] == 0x4E
                && bytes[3] == 0x47
                && bytes[4] == 0x0D
                && bytes[5] == 0x0A
                && bytes[6] == 0x1A
                && bytes[7] == 0x0A) {
            return "image/png";
        }

        // JPEG signature
        if ((bytes[0] & 0xFF) == 0xFF
                && (bytes[1] & 0xFF) == 0xD8
                && (bytes[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }

        // WebP signature
        if (bytes[0] == 'R'
                && bytes[1] == 'I'
                && bytes[2] == 'F'
                && bytes[3] == 'F'
                && bytes[8] == 'W'
                && bytes[9] == 'E'
                && bytes[10] == 'B'
                && bytes[11] == 'P') {
            return "image/webp";
        }

        return null;
    }
}
