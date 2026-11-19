package Controller;

import DAO.DeviceDAO;
import DTO.DeviceDetailDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DetailServlet", urlPatterns = {"/DetailServlet"})
public class DetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idRaw = request.getParameter("id");
        String imei = request.getParameter("imei");

        DeviceDAO dao = new DeviceDAO();
        DeviceDetailDTO detail = null;

        if (idRaw != null && !idRaw.trim().isEmpty()) {
            detail = dao.getFullDeviceDetail(Integer.parseInt(idRaw.trim()), null);
        } else if (imei != null && !imei.trim().isEmpty()) {
            detail = dao.getFullDeviceDetail(null, imei.trim());
        }

        request.setAttribute("detail", detail);
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // Chuyển sang trang đăng nhập nếu khách chưa đăng nhập
        if (userId == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        String action = request.getParameter("action");
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        DeviceDAO dao = new DeviceDAO();

        if ("review".equals(action)) {
            int overall = Integer.parseInt(request.getParameter("overallRating"));
            int qcRating = Integer.parseInt(request.getParameter("qcAccuracyRating"));
            String batRaw = request.getParameter("batteryPostUseRating");
            int batRating = (batRaw != null && !batRaw.trim().isEmpty()) ? Integer.parseInt(batRaw.trim()) : 5;
            String comment = request.getParameter("comment");
            String imageUrl = request.getParameter("reviewImageUrl");

            dao.addProductReview(userId, deviceId, overall, qcRating, batRating, comment, imageUrl);
        } else if ("report".equals(action)) {
            String complaintType = request.getParameter("complaintType");
            String content = request.getParameter("reportContent");
            dao.reportInaccurateInfo(userId, deviceId, complaintType, content);
        } else if ("question".equals(action)) {
            String questionContent = request.getParameter("questionContent");
            dao.createSupportTicket(userId, "[Device #" + deviceId + "] Hỏi tình trạng thiết bị", questionContent, "CONSULT");
        }

        response.sendRedirect("DetailServlet?id=" + deviceId + "&msg=success");
    }
}