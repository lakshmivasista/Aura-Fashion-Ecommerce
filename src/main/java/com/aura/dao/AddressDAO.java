package com.aura.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.aura.model.Address;
import com.aura.util.DBConnection;

public class AddressDAO {

    // ============================================================
    // ADD ADDRESS
    // ============================================================

    public int addAddress(Address address) {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // If this address is marked as default,
            // remove default status from previous addresses.
            if (address.isDefaultAddress()) {

                String resetQuery =
                        "UPDATE addresses "
                      + "SET is_default = FALSE "
                      + "WHERE user_id = ?";

                PreparedStatement resetPs =
                        con.prepareStatement(resetQuery);

                resetPs.setInt(1, address.getUserId());

                resetPs.executeUpdate();

                resetPs.close();
            }


            // Insert new address

            String query =
                    "INSERT INTO addresses "
                  + "(user_id, full_name, phone, pincode, city, state, country, address_line, is_default) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(
                    query,
                    PreparedStatement.RETURN_GENERATED_KEYS
            );

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getPincode());
            ps.setString(5, address.getCity());
            ps.setString(6, address.getState());

            // Country is India for Aura
            ps.setString(7, "India");

            ps.setString(8, address.getAddressLine());
            ps.setBoolean(9, address.isDefaultAddress());


            int rows = ps.executeUpdate();

            if (rows == 0) {
                return -1;
            }


            // Get generated address ID

            rs = ps.getGeneratedKeys();

            if (rs.next()) {

                return rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            try {

                if (rs != null) {
                    rs.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {

                if (ps != null) {
                    ps.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {

                if (con != null) {
                    con.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return -1;
    }

    // ============================================================
    // GET DELIVERY ADDRESS BY ADDRESS ID
    // ============================================================

    public Address getAddressById(int addressId) {

        Address address = null;

        String query =
                "SELECT address_id, user_id, full_name, phone, "
              + "pincode, city, state, country, address_line, is_default "
              + "FROM addresses "
              + "WHERE address_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {

            ps.setInt(1, addressId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    address = new Address();

                    address.setAddressId(
                            rs.getInt("address_id")
                    );

                    address.setUserId(
                            rs.getInt("user_id")
                    );

                    address.setFullName(
                            rs.getString("full_name")
                    );

                    address.setPhone(
                            rs.getString("phone")
                    );

                    address.setPincode(
                            rs.getString("pincode")
                    );

                    address.setCity(
                            rs.getString("city")
                    );

                    address.setState(
                            rs.getString("state")
                    );

                    address.setCountry(
                            rs.getString("country")
                    );

                    address.setAddressLine(
                            rs.getString("address_line")
                    );

                    address.setDefaultAddress(
                            rs.getBoolean("is_default")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return address;
    }

}