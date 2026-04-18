package com.campus.eventsystem.controller;

import com.campus.eventsystem.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/hello-servlet")
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            response.getWriter().println("DB Connected Successfully!");
        } else {
            response.getWriter().println("DB Connection Failed!");
        }
    }
}