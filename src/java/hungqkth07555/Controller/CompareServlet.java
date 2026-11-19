package Controller;

import DAO.DeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CompareServlet", urlPatterns = {"/CompareServlet"})
public class CompareServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] ids = request.getParameterValues("ids");
        String mode = request.getParameter("mode");
        if (mode == null || mode.isEmpty()) mode = "models";

        DeviceDAO dao = new DeviceDAO();
        request.setAttribute("allDevices", dao.searchAndFilterDevices(null, null, null, null, null, null, null, null, null, null, null, null, null, null));
        request.setAttribute("comparedDevices", dao.getDevicesForComparison(ids));
        request.setAttribute("priceStats", dao.getPriceComparisonStats(mode));
        request.setAttribute("currentMode", mode);
        request.getRequestDispatcher("compare.jsp").forward(request, response);
    }
}