package Controller;

import DAO.DeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/WishlistServlet"})
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = 1;
        String action = request.getParameter("action");
        DeviceDAO dao = new DeviceDAO();

        if ("add".equals(action)) {
            int deviceId = Integer.parseInt(request.getParameter("deviceId"));
            dao.addToWishlist(userId, deviceId);
            response.sendRedirect("WishlistServlet?msg=added");
            return;
        } else if ("remove".equals(action)) {
            int deviceId = Integer.parseInt(request.getParameter("deviceId"));
            dao.removeFromWishlist(userId, deviceId);
            response.sendRedirect("WishlistServlet?msg=removed");
            return;
        }

        request.setAttribute("wishlist", dao.getWishlistByUser(userId));
        request.setAttribute("variants", dao.getAllVariants());
        request.setAttribute("notifications", dao.getStockNotificationsByUser(userId));
        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int userId = 1;
        int variantId = Integer.parseInt(request.getParameter("variantId"));
        String preferredTier = request.getParameter("preferredTier");

        DeviceDAO dao = new DeviceDAO();
        dao.subscribeStockNotification(userId, variantId, preferredTier);
        response.sendRedirect("WishlistServlet?msg=subscribed");
    }
}
