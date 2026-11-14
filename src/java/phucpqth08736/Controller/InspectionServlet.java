package Controller;

import DAO.DeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InspectionServlet", urlPatterns = {"/InspectionServlet"})
public class InspectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("inspection.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            int deviceId = Integer.parseInt(request.getParameter("deviceId"));
            int batteryHealth = Integer.parseInt(request.getParameter("batteryHealth"));
            int chargeCycles = Integer.parseInt(request.getParameter("chargeCycles"));
            
            DeviceDAO dao = new DeviceDAO();
            boolean success = dao.createInspectionTicket(deviceId, batteryHealth, chargeCycles);
            
            if (success) {
                response.sendRedirect("InspectionServlet?msg=success");
            } else {
                request.setAttribute("errorMessage", "Không thể chèn dữ liệu vào cơ sở dữ liệu.");
                request.getRequestDispatcher("inspection.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Hiển thị chính xác thông báo lỗi từ SQL Server lên web
            request.setAttribute("errorMessage", "Lỗi SQL: " + e.getMessage());
            request.getRequestDispatcher("inspection.jsp").forward(request, response);
        }
    }
}