package com.estate.controller;

import com.estate.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GetLocationsServlet")
public class GetLocationsServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String city = request.getParameter("city");
        ArrayList<String> locationList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT location_name FROM locations WHERE city = ? ORDER BY location_name ASC")) {
            
            ps.setString(1, city);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    locationList.add(rs.getString("location_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Convert plain list to standard JSON structure array text format
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < locationList.size(); i++) {
            json.append("\"").append(locationList.get(i).replace("\"", "\\\"")).append("\"");
            if (i < locationList.size() - 1) json.append(",");
        }
        json.append("]");
        
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}