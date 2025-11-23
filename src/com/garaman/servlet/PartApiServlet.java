package com.garaman.servlet;

import com.garaman.service.ImportService;
import com.garaman.entity.SparePart;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/parts")
public class PartApiServlet extends HttpServlet {
    
    private ImportService importService = new ImportService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        List<SparePart> parts = importService.getAllParts();
        String json = gson.toJson(parts);
        response.getWriter().write(json);
    }
}
