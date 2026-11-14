package Controller;

import DAO.DeviceDAO;
import DTO.ProductDTO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int userId = 1; // Mặc định user_id = 1

        String keyword = request.getParameter("keyword");
        String imei = request.getParameter("imei");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String budget = request.getParameter("budget");
        String capacity = request.getParameter("capacity");
        String color = request.getParameter("color");
        String qualityTier = request.getParameter("qualityTier");
        String minBattery = request.getParameter("minBattery");
        String partStatus = request.getParameter("partStatus");
        String minWarranty = request.getParameter("minWarranty");
        String cosmetic = request.getParameter("cosmetic");
        String usageNeed = request.getParameter("usageNeed");
        String sort = request.getParameter("sort");

        DeviceDAO dao = new DeviceDAO();
        List<ProductDTO> productList = dao.searchAndFilterDevices(
                keyword, imei, minPrice, maxPrice, budget,
                capacity, color, qualityTier, minBattery,
                partStatus, minWarranty, cosmetic, usageNeed, sort
        );

        // Ghi nhận lịch sử tìm kiếm nếu người dùng có nhập từ khóa hoặc bộ lọc
        StringBuilder filterLog = new StringBuilder();
        if (imei != null && !imei.isEmpty()) {
            filterLog.append("IMEI:").append(imei).append("; ");
        }
        if (budget != null && !budget.isEmpty()) {
            filterLog.append("Ngân sách:").append(budget).append("; ");
        }
        if (capacity != null && !capacity.isEmpty()) {
            filterLog.append("Dung lượng:").append(capacity).append("; ");
        }
        if (qualityTier != null && !qualityTier.isEmpty()) {
            filterLog.append("Grade:").append(qualityTier).append("; ");
        }
        if (usageNeed != null && !usageNeed.isEmpty()) {
            filterLog.append("Nhu cầu:").append(usageNeed).append("; ");
        }
        dao.saveSearchHistory(userId, keyword, filterLog.toString());

        request.setAttribute("products", productList);
        request.setAttribute("searchHistories", dao.getSearchHistories(userId));
        request.setAttribute("variants", dao.getAllVariants());
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
