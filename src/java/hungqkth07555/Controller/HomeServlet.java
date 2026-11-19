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

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int userId = 1; // Mặc định user_id = 1

        String searchFlag = request.getParameter("search");
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
        if (hasText(imei)) {
            filterLog.append("IMEI:").append(imei).append("; ");
        }
        if (hasText(budget)) {
            filterLog.append("Ngân sách:").append(budget).append("; ");
        }
        if (hasText(capacity)) {
            filterLog.append("Dung lượng:").append(capacity).append("; ");
        }
        if (hasText(qualityTier)) {
            filterLog.append("Grade:").append(qualityTier).append("; ");
        }
        if (hasText(usageNeed)) {
            filterLog.append("Nhu cầu:").append(usageNeed).append("; ");
        }
        dao.saveSearchHistory(userId, keyword, filterLog.toString());

        request.setAttribute("products", productList);
        request.setAttribute("searchHistories", dao.getSearchHistories(userId));
        request.setAttribute("variants", dao.getAllVariants());

        // Chuyển sang trang kết quả riêng (search.jsp) nếu có tìm kiếm, lọc hoặc sắp xếp
        boolean isSearchOrFilter = searchFlag != null
                || hasText(keyword)
                || hasText(imei)
                || hasText(minPrice)
                || hasText(maxPrice)
                || hasText(budget)
                || hasText(capacity)
                || hasText(color)
                || hasText(qualityTier)
                || hasText(minBattery)
                || hasText(partStatus)
                || hasText(minWarranty)
                || hasText(cosmetic)
                || hasText(usageNeed)
                || hasText(sort);

        if (isSearchOrFilter) {
            request.getRequestDispatcher("search.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}