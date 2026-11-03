<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Locale, com.aura.model.Product, com.aura.model.ProductVariant" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String productImageFile(String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) return "";
        String cleaned = imageUrl.replace("\\", "/");
        int slash = cleaned.lastIndexOf('/');
        String fileName = slash >= 0 ? cleaned.substring(slash + 1) : cleaned;
        if (fileName.equals(".") || fileName.equals("..")) return "";
        return fileName;
    }
%>

<%
    String contextPath = request.getContextPath();

    List<Product> products = (List<Product>) request.getAttribute("products");
    Product selectedProduct = (Product) request.getAttribute("selectedProduct");
    List<ProductVariant> selectedVariants =
            (List<ProductVariant>) request.getAttribute("selectedVariants");

    String errorMessage = (String) request.getAttribute("tryOnError");
    String successMessage = (String) request.getAttribute("tryOnSuccess");
    String generatedImage = (String) request.getAttribute("generatedImageData");

    Object generatedProductId = request.getAttribute("generatedProductId");
    String selectedProductId = generatedProductId != null
            ? String.valueOf(generatedProductId) : request.getParameter("productId");
    if (selectedProductId == null) selectedProductId = "";

    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null || selectedCategory.isBlank()) {
        selectedCategory = request.getParameter("category");
    }
    if (selectedCategory == null || selectedCategory.isBlank()) {
        selectedCategory = "one-pieces";
    }

    String selectedPhotoType = (String) request.getAttribute("selectedGarmentPhotoType");
    if (selectedPhotoType == null || selectedPhotoType.isBlank()) {
        selectedPhotoType = request.getParameter("garmentPhotoType");
    }
    if (selectedPhotoType == null || selectedPhotoType.isBlank()) {
        selectedPhotoType = "model";
    }

    boolean hasResult = generatedImage != null && !generatedImage.isBlank();
    String selectedImageFile = selectedProduct == null
            ? "" : productImageFile(selectedProduct.getImageUrl());
    String selectedImageSrc = selectedImageFile.isEmpty()
            ? "" : contextPath + "/assets/images/products/" + selectedImageFile;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aura | Virtual Try-On Studio</title>
    <style>
        :root {
            --bg: #f8f5f2;
            --surface: #fff;
            --primary: #51352f;
            --primary-dark: #39251f;
            --text: #302923;
            --muted: #847970;
            --border: #eee6df;
            --success: #286b42;
            --success-bg: #eaf6ed;
            --error: #a12d20;
            --error-bg: #fff0ed;
            --shadow: 0 12px 35px rgba(64, 43, 34, .07);
        }

        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
            line-height: 1.6;
        }
        button, input, select { font: inherit; }
        .navbar {
            position: sticky;
            top: 0;
            z-index: 10;
            min-height: 76px;
            padding: 14px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            background: rgba(255,255,255,.96);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(12px);
        }
        .brand { display: flex; align-items: center; gap: 12px; }
        .brand-mark {
            width: 43px; height: 43px; display: grid; place-items: center;
            border-radius: 13px; background: var(--primary); color: white;
            font-family: Georgia, serif; font-size: 24px;
        }
        .brand-name {
            margin: 0; font-family: Georgia, serif; font-size: 23px;
            letter-spacing: 2px;
        }
        .brand-subtitle {
            display: block; margin-top: 1px; color: var(--muted);
            font-size: 10px; letter-spacing: 1.5px; text-transform: uppercase;
        }
        .nav-link, .secondary-btn {
            display: inline-flex; align-items: center; justify-content: center;
            padding: 10px 15px; border: 1px solid var(--border);
            border-radius: 9px; background: #fff; color: var(--primary);
            text-decoration: none; font-size: 12px; font-weight: 700;
            cursor: pointer; transition: .2s ease;
        }
        .nav-link:hover, .secondary-btn:hover {
            border-color: var(--primary); background: var(--bg);
        }
        .page-container { width: min(1180px, 92%); margin: 0 auto; padding: 35px 0 55px; }
        .breadcrumb { margin-bottom: 19px; color: var(--muted); font-size: 11px; letter-spacing: 1px; }
        .breadcrumb span { color: var(--primary); font-weight: 700; }
        .hero {
            position: relative; overflow: hidden; padding: 43px; margin-bottom: 28px;
            border-radius: 20px; background: linear-gradient(120deg, #493029, #725448);
            color: white; box-shadow: var(--shadow);
        }
        .hero::after {
            content: ""; position: absolute; top: -120px; right: 7%;
            width: 260px; height: 260px; border: 1px solid rgba(255,255,255,.15);
            border-radius: 50%; box-shadow: 0 0 0 30px rgba(255,255,255,.025), 0 0 0 60px rgba(255,255,255,.025);
            pointer-events: none;
        }
        .hero-content { position: relative; z-index: 1; max-width: 650px; }
        .eyebrow {
            margin: 0 0 12px; color: #e4cfc0; font-size: 11px;
            font-weight: 700; letter-spacing: 2.5px; text-transform: uppercase;
        }
        .hero h1 { margin: 0 0 12px; font-family: Georgia, serif; font-size: clamp(30px,4vw,45px); font-weight: 500; line-height: 1.2; }
        .hero p { margin: 0; color: #eee2da; font-size: 14px; line-height: 1.9; }
        .hero-tags { display: flex; flex-wrap: wrap; gap: 9px; margin-top: 22px; }
        .hero-tag { padding: 7px 11px; border: 1px solid rgba(255,255,255,.2); border-radius: 30px; background: rgba(255,255,255,.08); color: #f3e6dc; font-size: 11px; }
        .alert {
            display: flex; align-items: flex-start; gap: 10px; padding: 14px 17px;
            margin-bottom: 22px; border: 1px solid transparent; border-radius: 10px; font-size: 13px;
        }
        .alert-success { color: var(--success); background: var(--success-bg); border-color: #d2e8d8; }
        .alert-error { color: var(--error); background: var(--error-bg); border-color: #f0d3ce; }
        .studio-heading { margin: 0 0 18px; }
        .studio-heading h2 { margin: 0 0 4px; font-family: Georgia, serif; font-size: 27px; font-weight: 500; }
        .studio-heading p { margin: 0; color: var(--muted); font-size: 13px; }
        .studio-layout { display: grid; grid-template-columns: minmax(0,1fr) minmax(0,1fr); align-items: start; gap: 22px; }
        .panel {
            min-width: 0; padding: 25px; border: 1px solid var(--border);
            border-radius: 16px; background: var(--surface); box-shadow: 0 5px 22px rgba(64,43,34,.035);
        }
        .panel-heading { display: flex; align-items: center; gap: 12px; margin-bottom: 22px; }
        .step-number {
            width: 38px; height: 38px; display: grid; place-items: center; flex-shrink: 0;
            border-radius: 11px; background: #f1e8e1; color: var(--primary);
            font-family: Georgia, serif; font-size: 19px;
        }
        .panel-heading h3 { margin: 0; font-family: Georgia, serif; font-size: 21px; font-weight: 500; }
        .panel-heading p { margin: 2px 0 0; color: var(--muted); font-size: 11px; }
        .field { margin-bottom: 20px; }
        .field-label { display: block; margin-bottom: 8px; color: #5d5047; font-size: 12px; font-weight: 700; }
        .required-mark { color: #a53d35; }
        .upload-box {
            position: relative; min-height: 240px; overflow: hidden; display: flex;
            flex-direction: column; align-items: center; justify-content: center;
            padding: 20px; border: 1.5px dashed #d8c6b8; border-radius: 13px;
            background: #fcfaf8; text-align: center; transition: .2s ease;
        }
        .upload-box:hover, .upload-box.drag-over { border-color: var(--primary); background: #f6eee8; }
        .upload-icon {
            width: 52px; height: 52px; display: grid; place-items: center; margin-bottom: 12px;
            border-radius: 15px; background: #eee2d8; color: var(--primary); font-size: 25px;
        }
        .upload-box strong { margin-bottom: 5px; font-size: 14px; }
        .upload-box p { max-width: 280px; margin: 0 0 13px; color: var(--muted); font-size: 11px; }
        .file-input { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); white-space: nowrap; clip-path: inset(50%); }
        .browse-btn {
            display: inline-flex; justify-content: center; padding: 10px 15px;
            border: 1px solid var(--primary); border-radius: 8px; background: #fff;
            color: var(--primary); cursor: pointer; font-size: 12px; font-weight: 700;
        }
        .browse-btn:hover { background: var(--primary); color: white; }
        .person-preview { display: none; width: 100%; max-height: 380px; margin: 0 auto 12px; border-radius: 9px; object-fit: contain; background: #f2ebe5; }
        .remove-photo { display: none; margin-top: 10px; border: none; background: transparent; color: var(--error); cursor: pointer; font-size: 12px; font-weight: 700; }
        .form-select {
            width: 100%; min-height: 45px; padding: 11px 13px; border: 1px solid #e4d9d0;
            border-radius: 9px; outline: none; background: #fff; color: var(--text); font-size: 13px;
        }
        .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(81,53,47,.08); }
        .hint { margin: 7px 0 0; color: var(--muted); font-size: 11px; line-height: 1.6; }
        .product-preview {
            display: grid; grid-template-columns: 105px minmax(0,1fr); align-items: center;
            gap: 16px; min-height: 130px; padding: 12px; margin-top: 13px;
            border: 1px solid #eee4dc; border-radius: 12px; background: #fcfaf8;
        }
        .product-preview img { width: 105px; height: 135px; border-radius: 8px; background: #f0e9e3; object-fit: contain; }
        .product-preview h4 { margin: 0 0 6px; font-family: Georgia, serif; font-size: 17px; font-weight: 500; overflow-wrap: anywhere; }
        .preview-price { margin: 0 0 5px; color: var(--primary); font-size: 17px; font-weight: 800; }
        .preview-note { margin: 0; color: var(--muted); font-size: 11px; }
        .product-empty { margin: 0; padding: 18px; border: 1px dashed #d8c6b8; border-radius: 10px; color: var(--muted); font-size: 12px; text-align: center; }
        .consent-box { display: flex; align-items: flex-start; gap: 10px; padding: 14px; margin: 22px 0; border: 1px solid #eee4dc; border-radius: 10px; background: #fcfaf8; }
        .consent-box input { margin-top: 4px; accent-color: var(--primary); }
        .consent-box label { color: #6e6259; font-size: 11px; line-height: 1.7; }
        .generate-btn {
            width: 100%; min-height: 51px; display: inline-flex; align-items: center; justify-content: center;
            gap: 9px; padding: 13px 18px; border: none; border-radius: 10px;
            background: var(--primary); color: white; cursor: pointer; font-size: 13px; font-weight: 800; transition: .2s ease;
        }
        .generate-btn:hover:not(:disabled) { background: var(--primary-dark); transform: translateY(-2px); }
        .generate-btn:disabled { cursor: not-allowed; opacity: .7; }
        .privacy-note { margin: 12px 0 0; color: var(--muted); text-align: center; font-size: 10px; line-height: 1.7; }
        .result-section { margin-top: 28px; }
        .result-panel { overflow: hidden; border: 1px solid var(--border); border-radius: 17px; background: white; box-shadow: var(--shadow); }
        .result-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 13px; padding: 22px 25px; border-bottom: 1px solid var(--border); }
        .result-header h2 { margin: 0 0 4px; font-family: Georgia, serif; font-size: 25px; font-weight: 500; }
        .result-header p { margin: 0; color: var(--muted); font-size: 12px; }
        .result-badge { padding: 7px 11px; border-radius: 30px; background: var(--success-bg); color: var(--success); font-size: 11px; font-weight: 800; }
        .result-content { padding: 25px; }
        .result-image-wrap { max-width: 600px; margin: 0 auto; overflow: hidden; border: 1px solid #eee4dc; border-radius: 13px; background: #f7f2ed; text-align: center; }
        .result-image { display: block; width: 100%; max-height: 760px; object-fit: contain; }
        .result-actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 11px; margin-top: 20px; }
        .buy-panel { max-width: 600px; margin: 22px auto 0; padding: 20px; border: 1px solid var(--border); border-radius: 13px; background: #fcfaf8; }
        .buy-panel h3 { margin: 0 0 5px; font-family: Georgia, serif; font-size: 21px; font-weight: 500; }
        .buy-panel > p { margin: 0 0 16px; color: var(--muted); font-size: 12px; }
        .buy-row { display: grid; grid-template-columns: minmax(0,1fr) auto; gap: 12px; align-items: end; }
        .add-cart-btn { min-height: 45px; padding: 11px 18px; border: 0; border-radius: 9px; background: var(--primary); color: white; font-size: 12px; font-weight: 800; cursor: pointer; }
        .add-cart-btn:hover { background: var(--primary-dark); }
        .add-cart-btn:disabled { opacity: .55; cursor: not-allowed; }
        .footer { margin-top: 40px; padding-top: 21px; border-top: 1px solid var(--border); color: var(--muted); text-align: center; font-size: 10px; letter-spacing: .8px; }
        @media (max-width: 820px) {
            .studio-layout { grid-template-columns: 1fr; }
            .hero { padding: 32px 25px; }
            .panel { padding: 21px; }
        }
        @media (max-width: 500px) {
            .navbar { padding: 13px 4%; }
            .brand-name { font-size: 19px; }
            .brand-subtitle { font-size: 9px; letter-spacing: 1px; }
            .brand-mark { width: 38px; height: 38px; }
            .nav-link { padding: 9px; font-size: 11px; }
            .page-container { width: 92%; padding-top: 23px; }
            .hero { padding: 27px 21px; border-radius: 15px; }
            .hero h1 { font-size: 31px; }
            .hero p { font-size: 13px; }
            .panel { padding: 16px; }
            .upload-box { min-height: 220px; }
            .product-preview { grid-template-columns: 84px minmax(0,1fr); gap: 12px; }
            .product-preview img { width: 84px; height: 112px; }
            .result-content { padding: 13px; }
            .result-header { padding: 18px; }
            .buy-row { grid-template-columns: 1fr; }
            .add-cart-btn { width: 100%; }
        }
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { scroll-behavior: auto !important; transition: none !important; animation: none !important; }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">
        <div class="brand-mark">A</div>
        <div>
            <h2 class="brand-name">AURA</h2>
            <span class="brand-subtitle">Virtual Try-On Studio</span>
        </div>
    </div>
    <a class="nav-link" href="<%= contextPath %>/products">← Shop Collection</a>
</nav>

<main class="page-container">
    <div class="breadcrumb">AURA &nbsp;/&nbsp; PERSONAL STYLE &nbsp;/&nbsp; <span>VIRTUAL TRY-ON</span></div>

    <section class="hero">
        <div class="hero-content">
            <p class="eyebrow">Your Style, Reimagined</p>
            <h1>See it on you</h1>
            <p>Found a piece you love? Choose a garment from the Aura collection, upload your photo, and let AI create a virtual try-on preview just for you</p>
            <div class="hero-tags">
                <span class="hero-tag">✧ AI-powered preview</span>
                <span class="hero-tag">♡ Your chosen garment</span>
                <span class="hero-tag">✦ Made for your style</span>
            </div>
        </div>
    </section>

    <% if (successMessage != null && !successMessage.isBlank()) { %>
        <div class="alert alert-success" role="status"><span aria-hidden="true">✓</span><span><%= escapeHtml(successMessage) %></span></div>
    <% } %>
    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        <div class="alert alert-error" role="alert"><span aria-hidden="true">⚠</span><span><%= escapeHtml(errorMessage) %></span></div>
    <% } %>

    <div class="studio-heading">
        <h2>Your Try-On Studio</h2>
        <p>Complete the two steps below to create your virtual look</p>
    </div>

    <form id="tryOnForm" action="<%= contextPath %>/virtual-try-on" method="post" enctype="multipart/form-data">
        <div class="studio-layout">
            <section class="panel">
                <div class="panel-heading">
                    <div class="step-number">01</div>
                    <div><h3>Your Photo</h3><p>Upload a clear photo of yourself</p></div>
                </div>

                <div class="field">
                    <label class="field-label" for="personPhoto">Upload a Photo <span class="required-mark">*</span></label>
                    <div class="upload-box" id="uploadBox">
                        <div class="upload-icon" id="uploadIcon">↑</div>
                        <img id="personPreview" class="person-preview" alt="Preview of your selected photo">
                        <strong id="uploadTitle">Bring your look to life</strong>
                        <p id="uploadDescription">For best results, use a clear, well-lit photo showing your body and current outfit</p>
                        <label for="personPhoto" class="browse-btn" id="browseButton">Choose Photo</label>
                        <input type="file" class="file-input" id="personPhoto" name="personPhoto" accept="image/jpeg,image/png,image/webp" required>
                        <button type="button" class="remove-photo" id="removePhoto">Remove photo</button>
                    </div>
                    <p class="hint">Accepted formats: JPG, PNG or WebP · Maximum size: 10 MB</p>
                </div>

                <div class="field">
                    <label class="field-label" for="category">Garment Category <span class="required-mark">*</span></label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="one-pieces" <%= "one-pieces".equals(selectedCategory) ? "selected" : "" %>>Dresses &amp; One-Pieces</option>
                        <option value="tops" <%= "tops".equals(selectedCategory) ? "selected" : "" %>>Tops</option>
                        <option value="bottoms" <%= "bottoms".equals(selectedCategory) ? "selected" : "" %>>Bottoms</option>
                    </select>
                    <p class="hint">Choose the category that best matches the selected garment</p>
                </div>
            </section>

            <section class="panel">
                <div class="panel-heading">
                    <div class="step-number">02</div>
                    <div><h3>Your Outfit</h3><p>Select the product you want to try on</p></div>
                </div>

                <div class="field">
                    <label class="field-label" for="productId">Choose an Aura Product <span class="required-mark">*</span></label>
                    <% if (products != null && !products.isEmpty()) { %>
                        <select class="form-select" name="productId" id="productId" required>
                            <option value="">Select a garment...</option>
                            <% for (Product product : products) {
                                String productName = product.getName() == null ? "Unnamed Product" : product.getName();
                                String imageFile = productImageFile(product.getImageUrl());
                                String imageSrc = imageFile.isEmpty() ? "" : contextPath + "/assets/images/products/" + imageFile;
                            %>
                                <option value="<%= product.getProductId() %>"
                                        data-name="<%= escapeHtml(productName) %>"
                                        data-price="<%= String.format(Locale.US, "%.2f", product.getPrice()) %>"
                                        data-image="<%= escapeHtml(imageSrc) %>"
                                        <%= String.valueOf(product.getProductId()).equals(selectedProductId) ? "selected" : "" %>>
                                    <%= escapeHtml(productName) %> — ₹<%= String.format(Locale.US, "%.2f", product.getPrice()) %>
                                </option>
                            <% } %>
                        </select>

                        <div class="product-preview" id="productPreview" style="display:none">
                            <img id="selectedProductImage" alt="Selected Aura garment">
                            <div>
                                <h4 id="selectedProductName"></h4>
                                <p class="preview-price" id="selectedProductPrice"></p>
                                <p class="preview-note">This garment will be sent to the AI model with your uploaded photo</p>
                            </div>
                        </div>
                    <% } else { %>
                        <p class="product-empty">No products are available right now. Please return to the collection and try again later</p>
                    <% } %>
                </div>

                <div class="field">
                    <label class="field-label" for="garmentPhotoType">Product Image Type</label>
                    <select class="form-select" name="garmentPhotoType" id="garmentPhotoType">
                        <option value="model" <%= "model".equals(selectedPhotoType) ? "selected" : "" %>>Worn by a model</option>
                        <option value="flat-lay" <%= "flat-lay".equals(selectedPhotoType) ? "selected" : "" %>>Flat-lay product photo</option>
                    </select>
                    <p class="hint">Choose the format that best describes your product's existing image</p>
                </div>
            </section>
        </div>

        <div class="consent-box">
            <input type="checkbox" id="photoConsent" name="photoConsent" value="yes" required>
            <label for="photoConsent">I confirm that I have permission to use the uploaded photo, I understand that my photo and the selected garment image will be sent to the hosted AI service to generate the preview, and I agree to this processing for the try-on request</label>
        </div>

        <button type="submit" class="generate-btn" id="generateButton" <%= products == null || products.isEmpty() ? "disabled" : "" %>>
            <span aria-hidden="true">✨</span> Generate My Look
        </button>
        <p class="privacy-note">Your photo is processed for this request and is not saved by this page to Aura's database. The external AI service processes the images to generate your preview</p>
    </form>

    <% if (hasResult) { %>
        <section class="result-section" id="tryOnResult">
            <div class="result-panel">
                <div class="result-header">
                    <div><h2>Your New Look</h2><p>Here's your AI-generated virtual try-on preview</p></div>
                    <span class="result-badge">✓ Generation complete</span>
                </div>
                <div class="result-content">
                    <div class="result-image-wrap">
                        <img class="result-image" src="<%= generatedImage %>" alt="AI-generated virtual try-on result">
                    </div>

                    <% if (selectedProduct != null) { %>
                        <div class="buy-panel">
                            <h3>Love this look?</h3>
                            <p>Select your size and add the exact Aura garment you tried on to your cart</p>
                            <% if (selectedVariants != null && !selectedVariants.isEmpty()) { %>
                                <form id="addTriedOnToCartForm" method="post" action="<%= contextPath %>/add-to-cart">
                                    <input type="hidden" name="productId" value="<%= selectedProduct.getProductId() %>">
                                    <div class="buy-row">
                                        <div>
                                            <label class="field-label" for="variantId">Choose your size</label>
                                            <select class="form-select" id="variantId" name="variantId" required>
                                                <option value="">Select size</option>
                                                <% for (ProductVariant variant : selectedVariants) {
                                                    String size = variant.getSize() == null ? "" : variant.getSize();
                                                %>
                                                    <option value="<%= variant.getVariantId() %>"><%= escapeHtml(size) %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <button type="submit" class="add-cart-btn">Add to Cart</button>
                                    </div>
                                </form>
                            <% } else { %>
                                <p class="hint">Sizes are not currently available for this product</p>
                            <% } %>
                        </div>
                    <% } %>

                    <div class="result-actions">
                        <a class="secondary-btn" href="<%= contextPath %>/virtual-try-on">Try Another Look</a>
                        <a class="secondary-btn" href="<%= contextPath %>/products">Continue Shopping</a>
                        <a class="secondary-btn" href="<%= generatedImage %>" download="aura-virtual-try-on.png">Download Preview</a>
                    </div>
                    <p class="privacy-note">AI-generated previews are estimates and may not accurately represent actual fit, fabric, colour, or appearance</p>
                </div>
            </div>
        </section>
    <% } %>

    <footer class="footer">AURA &nbsp;·&nbsp; YOUR STYLE, REIMAGINED</footer>
</main>

<script>
(function () {
    const photoInput = document.getElementById("personPhoto");
    const preview = document.getElementById("personPreview");
    const uploadBox = document.getElementById("uploadBox");
    const uploadIcon = document.getElementById("uploadIcon");
    const uploadTitle = document.getElementById("uploadTitle");
    const uploadDescription = document.getElementById("uploadDescription");
    const browseButton = document.getElementById("browseButton");
    const removeButton = document.getElementById("removePhoto");
    const productSelect = document.getElementById("productId");
    const productPreview = document.getElementById("productPreview");
    const selectedProductImage = document.getElementById("selectedProductImage");
    const selectedProductName = document.getElementById("selectedProductName");
    const selectedProductPrice = document.getElementById("selectedProductPrice");
    const form = document.getElementById("tryOnForm");
    const generateButton = document.getElementById("generateButton");
    let previewUrl = null;

    function clearPreviewUrl() {
        if (previewUrl) {
            URL.revokeObjectURL(previewUrl);
            previewUrl = null;
        }
    }

    function resetPhotoPreview() {
        clearPreviewUrl();
        preview.removeAttribute("src");
        preview.style.display = "none";
        uploadIcon.style.display = "";
        uploadTitle.textContent = "Bring your look to life";
        uploadDescription.textContent = "For best results, use a clear, well-lit photo showing your body and current outfit";
        browseButton.textContent = "Choose Photo";
        removeButton.style.display = "none";
        if (photoInput) photoInput.value = "";
    }

    function showSelectedPhoto(file) {
        if (!file) {
            resetPhotoPreview();
            return;
        }
        const allowedTypes = ["image/jpeg", "image/png", "image/webp"];
        if (!allowedTypes.includes(file.type)) {
            alert("Please select a JPG, PNG or WebP image");
            resetPhotoPreview();
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            alert("Your photo must be 10 MB or smaller");
            resetPhotoPreview();
            return;
        }

        clearPreviewUrl();
        previewUrl = URL.createObjectURL(file);
        preview.onload = function () {
            if (preview.naturalWidth > 0 && preview.naturalHeight > 0) {
                uploadIcon.style.display = "none";
                uploadTitle.textContent = file.name;
                uploadDescription.textContent = "Your photo is ready for the try-on request";
                browseButton.textContent = "Choose Another Photo";
                removeButton.style.display = "inline-block";
            } else {
                alert("The selected file could not be previewed");
                resetPhotoPreview();
            }
        };
        preview.onerror = function () {
            alert("The selected file could not be previewed");
            resetPhotoPreview();
        };
        preview.src = previewUrl;
        preview.style.display = "block";
    }

    if (photoInput) {
        photoInput.addEventListener("change", function () {
            showSelectedPhoto(photoInput.files && photoInput.files[0]);
        });
    }
    if (removeButton) removeButton.addEventListener("click", resetPhotoPreview);

    if (uploadBox && photoInput) {
        uploadBox.addEventListener("dragover", function (event) {
            event.preventDefault();
            uploadBox.classList.add("drag-over");
        });
        uploadBox.addEventListener("dragleave", function () {
            uploadBox.classList.remove("drag-over");
        });
        uploadBox.addEventListener("drop", function (event) {
            event.preventDefault();
            uploadBox.classList.remove("drag-over");
            const file = event.dataTransfer.files[0];
            if (!file) return;
            try {
                const transfer = new DataTransfer();
                transfer.items.add(file);
                photoInput.files = transfer.files;
                showSelectedPhoto(file);
            } catch (error) {
                alert("Please use Choose Photo to select your image");
            }
        });
    }

    function updateProductPreview() {
        if (!productSelect || !productPreview) return;
        const option = productSelect.options[productSelect.selectedIndex];
        if (!option || !option.value) {
            productPreview.style.display = "none";
            selectedProductImage.removeAttribute("src");
            return;
        }
        selectedProductName.textContent = option.dataset.name || option.textContent;
        selectedProductPrice.textContent = "₹" + (option.dataset.price || "");
        const imageSrc = option.dataset.image || "";
        if (imageSrc) {
            selectedProductImage.style.display = "block";
            selectedProductImage.src = imageSrc;
        } else {
            selectedProductImage.removeAttribute("src");
            selectedProductImage.style.display = "none";
        }
        productPreview.style.display = "grid";
    }

    if (productSelect) {
        productSelect.addEventListener("change", updateProductPreview);
        updateProductPreview();
    }

    if (form && generateButton) {
        form.addEventListener("submit", function (event) {
            if (productSelect && !productSelect.value) {
                event.preventDefault();
                alert("Please select an Aura product");
                return;
            }
            if (!photoInput || !photoInput.files || photoInput.files.length === 0) {
                event.preventDefault();
                alert("Please upload your photo first");
                return;
            }
            const consent = document.getElementById("photoConsent");
            if (!consent || !consent.checked) {
                event.preventDefault();
                alert("Please confirm your photo-processing consent");
                return;
            }
            generateButton.disabled = true;
            generateButton.textContent = "Generating your look... Please wait";
        });
    }
})();
</script>
</body>
</html>
