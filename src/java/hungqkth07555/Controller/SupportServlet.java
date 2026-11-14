package Controller;

import DAO.DeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SupportServlet", urlPatterns = {"/SupportServlet"})
public class SupportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = 1;
        String action = request.getParameter("action");
        DeviceDAO dao = new DeviceDAO();

        if ("deleteTicket".equals(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            dao.deleteSupportTicket(ticketId);
            response.sendRedirect("SupportServlet?msg=deleted");
            return;
        } else if ("deleteComplaint".equals(action)) {
            int complaintId = Integer.parseInt(request.getParameter("complaintId"));
            dao.deleteComplaint(complaintId);
            response.sendRedirect("SupportServlet?msg=deleted");
            return;
        }

        request.setAttribute("tickets", dao.getUserSupportTickets(userId));
        request.setAttribute("complaints", dao.getAllComplaints(userId));
        request.getRequestDispatcher("support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int userId = 1;
        String action = request.getParameter("action");
        DeviceDAO dao = new DeviceDAO();

        if ("createTicket".equals(action)) {
            String supportType = request.getParameter("supportType");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            dao.createSupportTicket(userId, subject, message, supportType);
        } else if ("createComplaint".equals(action)) {
            String complaintType = request.getParameter("complaintType");
            String deviceIdRaw = request.getParameter("deviceId");
            Integer deviceId = (deviceIdRaw != null && !deviceIdRaw.trim().isEmpty()) ? Integer.parseInt(deviceIdRaw.trim()) : null;
            String content = request.getParameter("content");
            dao.reportInaccurateInfo(userId, deviceId, complaintType, content);
        } else if ("replyComplaint".equals(action)) {
            int complaintId = Integer.parseInt(request.getParameter("complaintId"));
            String resolutionNote = request.getParameter("resolutionNote");
            dao.replyComplaint(complaintId, resolutionNote);
        }

        response.sendRedirect("SupportServlet?msg=success");
    }
}
