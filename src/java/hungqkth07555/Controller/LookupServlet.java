package Controller;

import Model.ConnectSQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "LookupServlet", urlPatterns = {"/LookupServlet"})
public class LookupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String certCode = request.getParameter("certCode");
        String imei = request.getParameter("imei");

        if (certCode != null && !certCode.trim().isEmpty()) {
            lookupCertificate(request, certCode.trim());
        }
        if (imei != null && !imei.trim().isEmpty()) {
            lookupWarrantyByImei(request, imei.trim());
        }

        request.getRequestDispatcher("lookup.jsp").forward(request, response);
    }

    private void lookupCertificate(HttpServletRequest request, String certCode) {
        String sql = "SELECT ic.cert_code, ic.overall_score, ic.quality_tier, ic.issued_at, "
                   + "d.device_id, d.imei, d.serial_number, d.status AS device_status, "
                   + "COALESCE(ibl.battery_health_percentage, 100) AS battery_health, "
                   + "COALESCE(ibl.charge_cycles, 0) AS charge_cycles, "
                   + "pm.model_name, sc.capacity_value, dc.color_name, u.full_name AS inspector_name "
                   + "FROM [quality_certificates] ic "
                   + "JOIN [devices] d ON ic.device_id = d.device_id "
                   + "JOIN [inspection_tickets] it ON ic.ticket_id = it.ticket_id "
                   + "LEFT JOIN [inspection_battery_logs] ibl ON it.ticket_id = ibl.ticket_id "
                   + "JOIN [iphone_variants] iv ON d.variant_id = iv.variant_id "
                   + "JOIN [iphone_models] pm ON iv.model_id = pm.model_id "
                   + "JOIN [iphone_capacities] sc ON iv.capacity_id = sc.capacity_id "
                   + "JOIN [iphone_colors] dc ON iv.color_id = dc.color_id "
                   + "LEFT JOIN [users] u ON it.inspector_id = u.user_id "
                   + "WHERE ic.cert_code = ?";

        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, certCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> cert = new HashMap<>();
                    String devStatus = rs.getString("device_status");
                    cert.put("certCode", rs.getString("cert_code"));
                    cert.put("overallScore", rs.getDouble("overall_score"));
                    cert.put("issuedAt", rs.getTimestamp("issued_at"));
                    cert.put("isValid", !"REJECTED".equalsIgnoreCase(devStatus) && !"RETURNED".equalsIgnoreCase(devStatus));
                    cert.put("deviceId", rs.getInt("device_id"));
                    cert.put("imei", rs.getString("imei"));
                    cert.put("serialNumber", rs.getString("serial_number"));
                    cert.put("qualityTier", rs.getString("quality_tier"));
                    cert.put("batteryHealth", rs.getInt("battery_health"));
                    cert.put("chargeCycles", rs.getInt("charge_cycles"));
                    cert.put("modelName", rs.getString("model_name"));
                    cert.put("capacity", rs.getString("capacity_value"));
                    cert.put("color", rs.getString("color_name"));
                    cert.put("inspectorName", rs.getString("inspector_name"));
                    request.setAttribute("certResult", cert);
                } else {
                    request.setAttribute("certError", "Không tìm thấy chứng nhận kiểm định với mã: " + certCode);
                }
            }
        } catch (Exception e) {
            request.setAttribute("certError", "Lỗi tra cứu chứng nhận: " + e.getMessage());
        }
    }

    private void lookupWarrantyByImei(HttpServletRequest request, String imei) {
        String sql = "SELECT d.device_id, d.imei, d.serial_number, "
                   + "COALESCE(qc.quality_tier, 'GRADE_A') AS quality_tier, "
                   + "pm.model_name, sc.capacity_value, dc.color_name, "
                   + "COALESCE(wp.package_name, N'Gói bảo hành tiêu chuẩn theo hạng QC') AS package_name, "
                   + "COALESCE(wp.duration_months, 6) AS duration_months, "
                   + "wp.coverage_terms, "
                   + "ewc.warranty_code, ewc.start_date, ewc.end_date, ewc.status AS warranty_status "
                   + "FROM [devices] d "
                   + "JOIN [iphone_variants] iv ON d.variant_id = iv.variant_id "
                   + "JOIN [iphone_models] pm ON iv.model_id = pm.model_id "
                   + "JOIN [iphone_capacities] sc ON iv.capacity_id = sc.capacity_id "
                   + "JOIN [iphone_colors] dc ON iv.color_id = dc.color_id "
                   + "LEFT JOIN [quality_certificates] qc ON d.device_id = qc.device_id "
                   + "LEFT JOIN [e_warranty_cards] ewc ON d.device_id = ewc.device_id "
                   + "LEFT JOIN [warranty_packages] wp ON ewc.package_id = wp.package_id "
                   + "WHERE d.imei = ?";

        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imei);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> w = new HashMap<>();
                    w.put("deviceId", rs.getInt("device_id"));
                    w.put("imei", rs.getString("imei"));
                    w.put("serialNumber", rs.getString("serial_number"));
                    w.put("qualityTier", rs.getString("quality_tier"));
                    w.put("modelName", rs.getString("model_name"));
                    w.put("capacity", rs.getString("capacity_value"));
                    w.put("color", rs.getString("color_name"));
                    w.put("packageName", rs.getString("package_name"));
                    w.put("durationMonths", rs.getInt("duration_months"));
                    w.put("coverageTerms", rs.getString("coverage_terms"));
                    w.put("warrantyCode", rs.getString("warranty_code"));
                    w.put("startDate", rs.getDate("start_date"));
                    w.put("endDate", rs.getDate("end_date"));
                    w.put("warrantyStatus", rs.getString("warranty_status"));
                    request.setAttribute("warrantyResult", w);
                } else {
                    request.setAttribute("warrantyError", "Không tìm thấy thiết bị có IMEI: " + imei);
                }
            }
        } catch (Exception e) {
            request.setAttribute("warrantyError", "Lỗi tra cứu bảo hành: " + e.getMessage());
        }
    }
}