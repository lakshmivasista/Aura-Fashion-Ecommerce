package com.aura.model;

public class CartItem {

    private int cartItemId;

    private String productName;

    private double price;

    private int quantity;

    private String imageUrl;

    // Selected product size
    private String size;


    // ============================================================
    // CART ITEM ID
    // ============================================================

    public int getCartItemId() {

        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {

        this.cartItemId = cartItemId;
    }


    // ============================================================
    // PRODUCT NAME
    // ============================================================

    public String getProductName() {

        return productName;
    }

    public void setProductName(String productName) {

        this.productName = productName;
    }


    // ============================================================
    // PRICE
    // ============================================================

    public double getPrice() {

        return price;
    }

    public void setPrice(double price) {

        this.price = price;
    }


    // ============================================================
    // QUANTITY
    // ============================================================

    public int getQuantity() {

        return quantity;
    }

    public void setQuantity(int quantity) {

        this.quantity = quantity;
    }


    // ============================================================
    // IMAGE
    // ============================================================

    public String getImageUrl() {

        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {

        this.imageUrl = imageUrl;
    }


    // ============================================================
    // SIZE
    // ============================================================

    public String getSize() {

        return size;
    }

    public void setSize(String size) {

        this.size = size;
    }
}