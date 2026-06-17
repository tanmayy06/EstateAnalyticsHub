package com.estate.controller;

import com.estate.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/predict")
public class PredictionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Read incoming operational parameter inputs from the client payload view
            String location = request.getParameter("location");
            double sqft = Double.parseDouble(request.getParameter("sqft"));
            int bhk = Integer.parseInt(request.getParameter("bhk"));
            int bath = Integer.parseInt(request.getParameter("bath"));
            
            Connection conn = DBConnection.getConnection();
            
            // Extract the analytical parameters matching the user's location input
            String query = "SELECT id, base_price_per_sqft, bhk_multiplier, bath_multiplier FROM locations WHERE location_name = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, location);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int locId = rs.getInt("id");
                double basePrice = rs.getDouble("base_price_per_sqft");
                double bhkMult = rs.getDouble("bhk_multiplier");
                double bathMult = rs.getDouble("bath_multiplier");
                
                // Parametric Regression Valuation Logic Calculation Simulation
                double predictedPrice = (basePrice * sqft) + (bhk * bhkMult * 120000) + (bath * bathMult * 60000);
                double finalPriceInLakhs = Math.round((predictedPrice / 100000.0) * 100.0) / 100.0;

                // Capture Session State Context to tie calculations to users
                HttpSession session = request.getSession(false);
                Integer userId = (session != null && session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : null;
                
                // Write transaction footmarks directly into historical logs
                String logQuery = "INSERT INTO prediction_logs (user_id, location_id, total_sqft, bhk, bathrooms, predicted_price) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement logPs = conn.prepareStatement(logQuery);
                if (userId != null) {
                    logPs.setInt(1, userId);
                } else {
                    logPs.setNull(1, java.sql.Types.INTEGER);
                }
                logPs.setInt(2, locId);
                logPs.setDouble(3, sqft);
                logPs.setInt(4, bhk);
                logPs.setInt(5, bath);
                logPs.setDouble(6, predictedPrice);
                logPs.executeUpdate();
                
                // Stream asynchronous structured string layout to front-end handler
                out.print("{\"success\": true, \"price\": \"" + finalPriceInLakhs + " Lakhs\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Target micro-market parameters not found.\"}");
            }
            conn.close();
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"System Runtime Pipeline Fault: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}