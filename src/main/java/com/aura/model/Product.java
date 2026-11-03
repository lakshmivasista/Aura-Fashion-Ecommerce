package com.aura.model;

public class Product {

    private int productId;
    private String name;
    private double price;
    private String imageUrl;
    private String sizes;

    // ✅ Default constructor
    public Product() {}

    // ✅ Parameterized constructor
    public Product(int productId, String name, double price, String imageUrl, String sizes) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.imageUrl = imageUrl;
        this.sizes = sizes;
    }

    // ✅ Getters & Setters

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getSizes() {
        return sizes;
    }

    // ✅ SAFETY: handle null values
    public void setSizes(String sizes) {
        if (sizes == null || sizes.trim().isEmpty()) {
            this.sizes = "M";  // default fallback
        } else {
            this.sizes = sizes;
        }
    }

    // ✅ Optional (for debugging / printing)
    @Override
    public String toString() {
        return "Product [id=" + productId +
               ", name=" + name +
               ", price=" + price +
               ", image=" + imageUrl +
               ", sizes=" + sizes + "]";
    }
}