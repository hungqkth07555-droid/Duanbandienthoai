package Controller;

import Model.ConnectSQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 15,      // Tối đa 15MB / ảnh
        maxRequestSize = 1024 * 1024 * 50    // Tối đa 50MB / lần gửi
)
public class AdminServlet extends HttpServlet {

    private boolean isAuthorizedStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            return false;
        }
        String role = (String) session.getAttribute("role");
        return role != null && !"CUSTOMER".equalsIgnoreCase(role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!isAuthorizedStaff(request)) {
            response.sendRedirect("AuthServlet");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "devices";
        }
        request.setAttribute("activeTab", tab);

        try (Connection conn = new ConnectSQL().getConnection()) {
            loadDashboardData(conn, request);

            String verifyCert = request.getParameter("verifyCert");
            if (verifyCert != null && !verifyCert.trim().isEmpty()) {
                verifyCertificateAdmin(conn, request, verifyCert.trim());
                request.setAttribute("activeTab", "qc");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu quản trị: " + e.getMessage());
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!isAuthorizedStaff(request)) {
            response.sendRedirect("AuthServlet");
            return;
        }

        HttpSession session = request.getSession(false);
        int staffId = (Integer) session.getAttribute("userId");
        String ip = request.getRemoteAddr();
        String action = request.getParameter("action");
        String redirectTab = request.getParameter("tab") != null ? request.getParameter("tab") : "devices";

        try (Connection conn = new ConnectSQL().getConnection()) {
            switch (action) {
                case "add_model":
                    handleAddModel(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "update_model":
                    handleUpdateModel(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "add_capacity":
                    handleAddCapacity(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "add_color":
                    handleAddColor(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "add_variant":
                    handleAddVariant(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "save_spec":
                    handleSaveSpec(conn, request, staffId, ip);
                    redirectTab = "catalog";
                    break;
                case "add_device":
                    handleAddDevice(conn, request, staffId, ip);
                    redirectTab = "devices";
                    break;
                case "update_device":
                    handleUpdateDevice(conn, request, staffId, ip);
                    redirectTab = "devices";
                    break;
                case "add_device_media":
                    handleAddDeviceMedia(conn, request, staffId, ip);
                    redirectTab = "devices";
                    break;
                case "change_device_status":
                    handleChangeDeviceStatus(conn, request, staffId, ip);
                    redirectTab = "devices";
                    break;
                case "submit_qc":
                    handleSubmitQC(conn, request, staffId, ip);
                    redirectTab = "qc";
                    break;
                case "save_price_matrix":
                    handleSavePriceMatrix(conn, request, staffId, ip);
                    redirectTab = "pricing";
                    break;
                case "save_depreciation_rule":
                    handleSaveDepreciationRule(conn, request, staffId, ip);
                    redirectTab = "pricing";
                    break;
                case "calculate_and_save_price":
                    handleCalculateAndSavePrice(conn, request, staffId, ip);
                    redirectTab = "pricing";
                    break;
                case "add_fault":
                    handleAddFault(conn, request, staffId, ip);
                    redirectTab = "standards";
                    break;
                case "add_part":
                    handleAddPart(conn, request, staffId, ip);
                    redirectTab = "standards";
                    break;
                case "add_criterion":
                    handleAddCriterion(conn, request, staffId, ip);
                    redirectTab = "standards";
                    break;
                case "add_warranty_package":
                    handleAddWarrantyPackage(conn, request, staffId, ip);
                    redirectTab = "warranty";
                    break;
                case "assign_device_warranty":
                    handleAssignDeviceWarranty(conn, request, staffId, ip);
                    redirectTab = "warranty";
                    break;
                case "create_staff_account":
                    handleCreateStaffAccount(conn, request, staffId, ip);
                    redirectTab = "staff";
                    break;
                case "update_staff_role":
                    handleUpdateStaffRole(conn, request, staffId, ip);
                    redirectTab = "staff";
                    break;
                case "delete_staff_account":
                    handleDeleteStaffAccount(conn, request, staffId, ip);
                    redirectTab = "staff";
                    break;
                default:
                    break;
            }
            response.sendRedirect("AdminServlet?tab=" + redirectTab + "&msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminServlet?tab=" + redirectTab + "&err=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    // =========================================================================
    // HÀM XỬ LÝ UPLOAD FILE ẢNH TỪ MÁY TÍNH VÀO THƯ MỤC image/
    // =========================================================================
    private String saveUploadedImage(HttpServletRequest req, String inputName) throws Exception {
        String contentType = req.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("multipart/")) {
            return null;
        }
        Part filePart = req.getPart(inputName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String submittedName = filePart.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        String rawFileName = Paths.get(submittedName).getFileName().toString();
        String safeFileName = System.currentTimeMillis() + "_" + rawFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String deployImageDir = req.getServletContext().getRealPath("/image");
        File deployDir = new File(deployImageDir);
        if (!deployDir.exists()) {
            deployDir.mkdirs();
        }
        Path deployFilePath = Paths.get(deployImageDir, safeFileName);
        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, deployFilePath, StandardCopyOption.REPLACE_EXISTING);
        }

        try {
            File buildWebDir = new File(req.getServletContext().getRealPath("/"));
            File projectRoot = (buildWebDir.getParentFile() != null) ? buildWebDir.getParentFile().getParentFile() : null;
            if (projectRoot != null) {
                File srcImageDir = new File(projectRoot, "web" + File.separator + "image");
                if (srcImageDir.exists() && srcImageDir.isDirectory()) {
                    Files.copy(deployFilePath, Paths.get(srcImageDir.getAbsolutePath(), safeFileName), StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } catch (Exception ignored) {
        }

        return "image/" + safeFileName;
    }

    // =========================================================================
    // 1. DANH MỤC & THÔNG SỐ KỸ THUẬT
    // =========================================================================
    private void handleAddModel(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [iphone_models] ([model_name], [generation], [release_year], [original_msrp], [status]) VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, req.getParameter("modelName").trim());
            ps.setString(2, req.getParameter("generation").trim());
            ps.setInt(3, Integer.parseInt(req.getParameter("releaseYear")));
            ps.setBigDecimal(4, new BigDecimal(req.getParameter("originalMsrp")));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    AuthServlet.logStaffAudit(staffId, "CREATE", "iphone_models", rs.getInt(1), "Thêm dòng iPhone: " + req.getParameter("modelName"), ip);
                }
            }
        }
    }

    private void handleUpdateModel(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int modelId = Integer.parseInt(req.getParameter("modelId"));
        String sql = "UPDATE [iphone_models] SET [model_name] = ?, [generation] = ?, [release_year] = ?, [original_msrp] = ?, [status] = ? WHERE [model_id] = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, req.getParameter("modelName").trim());
            ps.setString(2, req.getParameter("generation").trim());
            ps.setInt(3, Integer.parseInt(req.getParameter("releaseYear")));
            ps.setBigDecimal(4, new BigDecimal(req.getParameter("originalMsrp")));
            ps.setString(5, req.getParameter("status"));
            ps.setInt(6, modelId);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "UPDATE", "iphone_models", modelId, "Cập nhật dòng iPhone #" + modelId, ip);
    }

    private void handleAddCapacity(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String val = req.getParameter("capacityValue").trim().toUpperCase();
        String sql = "IF NOT EXISTS (SELECT 1 FROM [iphone_capacities] WHERE [capacity_value] = ?) INSERT INTO [iphone_capacities] ([capacity_value]) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, val);
            ps.setString(2, val);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "iphone_capacities", 0, "Thêm dung lượng: " + val, ip);
    }

    private void handleAddColor(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String name = req.getParameter("colorName").trim();
        String hex = req.getParameter("hexCode").trim();
        String sql = "IF NOT EXISTS (SELECT 1 FROM [iphone_colors] WHERE [color_name] = ?) INSERT INTO [iphone_colors] ([color_name], [hex_code]) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, name);
            ps.setString(3, hex);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "iphone_colors", 0, "Thêm màu sắc: " + name, ip);
    }

    private void handleAddVariant(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [iphone_variants] ([model_id], [capacity_id], [color_id], [model_number], [sku]) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, Integer.parseInt(req.getParameter("modelId")));
            ps.setInt(2, Integer.parseInt(req.getParameter("capacityId")));
            ps.setInt(3, Integer.parseInt(req.getParameter("colorId")));
            ps.setString(4, req.getParameter("modelNumber").trim());
            ps.setString(5, req.getParameter("sku").trim().toUpperCase());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    AuthServlet.logStaffAudit(staffId, "CREATE", "iphone_variants", rs.getInt(1), "Tạo biến thể SKU: " + req.getParameter("sku"), ip);
                }
            }
        }
    }

    private void handleSaveSpec(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int modelId = Integer.parseInt(req.getParameter("modelId"));
        boolean exists = false;
        try (PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM [iphone_specifications] WHERE [model_id] = ?")) {
            chk.setInt(1, modelId);
            exists = chk.executeQuery().next();
        }

        if (exists) {
            String sql = "UPDATE [iphone_specifications] SET [screen_size]=?, [chipset]=?, [ram]=?, [camera_specs]=?, "
                       + "[battery_capacity_mah]=?, [charging_tech]=?, [biometrics_type]=? WHERE [model_id]=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, req.getParameter("screenSize"));
                ps.setString(2, req.getParameter("chipset"));
                ps.setString(3, req.getParameter("ram"));
                ps.setString(4, req.getParameter("cameraSpecs"));
                ps.setInt(5, Integer.parseInt(req.getParameter("batteryCapacityMah")));
                ps.setString(6, req.getParameter("chargingTech"));
                ps.setString(7, req.getParameter("biometricsType"));
                ps.setInt(8, modelId);
                ps.executeUpdate();
            }
        } else {
            String sql = "INSERT INTO [iphone_specifications] ([model_id], [screen_size], [chipset], [ram], [camera_specs], "
                       + "[battery_capacity_mah], [charging_tech], [biometrics_type]) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, modelId);
                ps.setString(2, req.getParameter("screenSize"));
                ps.setString(3, req.getParameter("chipset"));
                ps.setString(4, req.getParameter("ram"));
                ps.setString(5, req.getParameter("cameraSpecs"));
                ps.setInt(6, Integer.parseInt(req.getParameter("batteryCapacityMah")));
                ps.setString(7, req.getParameter("chargingTech"));
                ps.setString(8, req.getParameter("biometricsType"));
                ps.executeUpdate();
            }
        }
        AuthServlet.logStaffAudit(staffId, "UPDATE", "iphone_specifications", modelId, "Cập nhật thông số kỹ thuật model #" + modelId, ip);
    }

    // =========================================================================
    // 2. KHO THIẾT BỊ (THÊM MỚI, CHỈNH SỬA, UPLOAD ẢNH, VIDEO, TRẠNG THÁI)
    // =========================================================================
    private void handleAddDevice(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int variantId = Integer.parseInt(req.getParameter("variantId"));
        String imei = req.getParameter("imei").trim();
        String serial = req.getParameter("serialNumber").trim().toUpperCase();
        String origin = req.getParameter("originCountry").trim();
        String status = req.getParameter("status");
        boolean isVisible = "1".equals(req.getParameter("isVisible"));

        String dupSql = "SELECT 1 FROM [devices] WHERE [imei] = ? OR [serial_number] = ?";
        try (PreparedStatement chk = conn.prepareStatement(dupSql)) {
            chk.setString(1, imei);
            chk.setString(2, serial);
            if (chk.executeQuery().next()) {
                throw new Exception("Mã IMEI (" + imei + ") hoặc Serial (" + serial + ") đã tồn tại trong kho, vui lòng nhập mã khác!");
            }
        }

        String sql = "INSERT INTO [devices] ([variant_id], [imei], [serial_number], [origin_country], [status], [is_visible]) VALUES (?, ?, ?, ?, ?, ?)";
        int deviceId = 0;
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, variantId);
            ps.setString(2, imei);
            ps.setString(3, serial);
            ps.setString(4, origin);
            ps.setString(5, status);
            ps.setBoolean(6, isVisible);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    deviceId = rs.getInt(1);
                }
            }
        }

        String coverImg = saveUploadedImage(req, "coverImageFile");
        if (coverImg == null) {
            coverImg = req.getParameter("coverImage");
        }
        if (coverImg != null && !coverImg.trim().isEmpty()) {
            insertMedia(conn, deviceId, "IMAGE", coverImg.trim(), true);
        }

        String extraImg = saveUploadedImage(req, "extraImageFile");
        if (extraImg == null) {
            extraImg = req.getParameter("extraImage");
        }
        if (extraImg != null && !extraImg.trim().isEmpty()) {
            insertMedia(conn, deviceId, "IMAGE", extraImg.trim(), false);
        }

        String videoUrl = req.getParameter("videoUrl");
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            insertMedia(conn, deviceId, "VIDEO", videoUrl.trim(), false);
        }

        String priceRaw = req.getParameter("sellingPrice");
        if (priceRaw != null && !priceRaw.trim().isEmpty()) {
            BigDecimal price = new BigDecimal(priceRaw.trim());
            String pSql = "INSERT INTO [device_price_logs] ([device_id], [suggested_selling_price], [actual_selling_price], [market_adjustment], [changed_by]) "
                        + "VALUES (?, ?, ?, 0, ?)";
            try (PreparedStatement pPs = conn.prepareStatement(pSql)) {
                pPs.setInt(1, deviceId);
                pPs.setBigDecimal(2, price);
                pPs.setBigDecimal(3, price);
                pPs.setInt(4, staffId);
                pPs.executeUpdate();
            }
        }

        AuthServlet.logStaffAudit(staffId, "CREATE", "devices", deviceId, "Nhập thiết bị mới IMEI: " + imei + " | Serial: " + serial, ip);
    }

    private void handleUpdateDevice(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        int variantId = Integer.parseInt(req.getParameter("variantId"));
        String imei = req.getParameter("imei").trim();
        String serial = req.getParameter("serialNumber").trim().toUpperCase();
        String origin = req.getParameter("originCountry").trim();
        String status = req.getParameter("status");
        boolean isVisible = "1".equals(req.getParameter("isVisible"));

        // Kiểm tra trùng IMEI/Serial với các máy KHÁC trong kho
        String dupSql = "SELECT 1 FROM [devices] WHERE ([imei] = ? OR [serial_number] = ?) AND [device_id] <> ?";
        try (PreparedStatement chk = conn.prepareStatement(dupSql)) {
            chk.setString(1, imei);
            chk.setString(2, serial);
            chk.setInt(3, deviceId);
            if (chk.executeQuery().next()) {
                throw new Exception("Mã IMEI (" + imei + ") hoặc Serial (" + serial + ") đã thuộc về một thiết bị khác!");
            }
        }

        String sql = "UPDATE [devices] SET [variant_id] = ?, [imei] = ?, [serial_number] = ?, [origin_country] = ?, [status] = ?, [is_visible] = ? WHERE [device_id] = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            ps.setString(2, imei);
            ps.setString(3, serial);
            ps.setString(4, origin);
            ps.setString(5, status);
            ps.setBoolean(6, isVisible);
            ps.setInt(7, deviceId);
            ps.executeUpdate();
        }

        // Cập nhật giá bán mới nếu có nhập
        String priceRaw = req.getParameter("sellingPrice");
        if (priceRaw != null && !priceRaw.trim().isEmpty()) {
            BigDecimal newPrice = new BigDecimal(priceRaw.trim());
            String pSql = "INSERT INTO [device_price_logs] ([device_id], [suggested_selling_price], [actual_selling_price], [market_adjustment], [changed_by]) "
                        + "VALUES (?, ?, ?, 0, ?)";
            try (PreparedStatement pPs = conn.prepareStatement(pSql)) {
                pPs.setInt(1, deviceId);
                pPs.setBigDecimal(2, newPrice);
                pPs.setBigDecimal(3, newPrice);
                pPs.setInt(4, staffId);
                pPs.executeUpdate();
            }
        }

        // Cập nhật ảnh đại diện mới nếu có chọn file từ máy hoặc nhập link mới
        String coverImg = saveUploadedImage(req, "coverImageFile");
        if (coverImg == null) {
            coverImg = req.getParameter("coverImage");
        }
        if (coverImg != null && !coverImg.trim().isEmpty()) {
            try (PreparedStatement reset = conn.prepareStatement("UPDATE [device_media] SET [is_cover] = 0 WHERE [device_id] = ? AND [media_type] = 'IMAGE'")) {
                reset.setInt(1, deviceId);
                reset.executeUpdate();
            }
            insertMedia(conn, deviceId, "IMAGE", coverImg.trim(), true);
        }

        AuthServlet.logStaffAudit(staffId, "UPDATE", "devices", deviceId, "Chỉnh sửa thông tin thiết bị #" + deviceId + " (IMEI: " + imei + ")", ip);
    }

    private void handleAddDeviceMedia(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        String mediaType = req.getParameter("mediaType");

        String uploadedPath = saveUploadedImage(req, "mediaFile");
        String mediaUrl = (uploadedPath != null) ? uploadedPath : req.getParameter("mediaUrl");

        if (mediaUrl == null || mediaUrl.trim().isEmpty()) {
            throw new Exception("Vui lòng chọn file ảnh từ máy hoặc nhập đường dẫn Media!");
        }

        boolean isCover = "1".equals(req.getParameter("isCover")) && "IMAGE".equals(mediaType);

        if (isCover) {
            try (PreparedStatement reset = conn.prepareStatement("UPDATE [device_media] SET [is_cover] = 0 WHERE [device_id] = ? AND [media_type] = 'IMAGE'")) {
                reset.setInt(1, deviceId);
                reset.executeUpdate();
            }
        }
        insertMedia(conn, deviceId, mediaType, mediaUrl.trim(), isCover);
        AuthServlet.logStaffAudit(staffId, "UPDATE", "device_media", deviceId, "Cập nhật " + mediaType + " cho thiết bị #" + deviceId, ip);
    }

    private void insertMedia(Connection conn, int deviceId, String type, String url, boolean isCover) throws Exception {
        String sql = "INSERT INTO [device_media] ([device_id], [media_type], [media_url], [is_cover]) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setString(2, type);
            ps.setString(3, url);
            ps.setBoolean(4, isCover);
            ps.executeUpdate();
        }
    }

    private void handleChangeDeviceStatus(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        String mode = req.getParameter("mode");
        String sql;
        String desc;

        if ("publish".equals(mode)) {
            sql = "UPDATE [devices] SET [status] = 'IN_STOCK', [is_visible] = 1 WHERE [device_id] = ?";
            desc = "Công khai thiết bị #" + deviceId + " lên website";
        } else if ("hide".equals(mode)) {
            sql = "UPDATE [devices] SET [is_visible] = 0 WHERE [device_id] = ?";
            desc = "Ẩn thiết bị #" + deviceId + " khỏi danh sách bán";
        } else {
            sql = "UPDATE [devices] SET [status] = 'SOLD', [is_visible] = 0 WHERE [device_id] = ?";
            desc = "Chuyển trạng thái thiết bị #" + deviceId + " sang ĐÃ BÁN";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CHANGE_STATUS", "devices", deviceId, desc, ip);
    }

    // =========================================================================
    // 3. KIỂM ĐỊNH QC, CHẤM ĐIỂM TỰ ĐỘNG, PHÂN HẠNG A/B/C & PHÁT HÀNH CHỨNG NHẬN
    // =========================================================================
    private void handleSubmitQC(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        String ticketType = req.getParameter("ticketType");
        double cosmeticScore = Double.parseDouble(req.getParameter("cosmeticScore"));
        int batteryHealth = Integer.parseInt(req.getParameter("batteryHealth"));
        int chargeCycles = Integer.parseInt(req.getParameter("chargeCycles"));
        boolean isOriginalBattery = "1".equals(req.getParameter("isOriginalBattery"));
        double componentScore = Double.parseDouble(req.getParameter("componentScore"));
        double functionScore = Double.parseDouble(req.getParameter("functionScore"));

        double wCos = 0.30, wBat = 0.25, wComp = 0.25, wFunc = 0.20;
        String wSql = "SELECT [category], SUM([weight]) AS total_w FROM [quality_grading_criteria] GROUP BY [category]";
        try (PreparedStatement wPs = conn.prepareStatement(wSql); ResultSet rs = wPs.executeQuery()) {
            double sumAll = 0;
            Map map = new HashMap();
            while (rs.next()) {
                double val = rs.getDouble("total_w");
                map.put(rs.getString("category"), val);
                sumAll += val;
            }
            if (sumAll > 0) {
                wCos = (map.containsKey("COSMETIC") ? (Double) map.get("COSMETIC") : 0.30) / sumAll;
                wBat = (map.containsKey("BATTERY") ? (Double) map.get("BATTERY") : 0.25) / sumAll;
                wComp = (map.containsKey("COMPONENT") ? (Double) map.get("COMPONENT") : 0.25) / sumAll;
                wFunc = (map.containsKey("FUNCTION") ? (Double) map.get("FUNCTION") : 0.20) / sumAll;
            }
        }

        double batScore10 = batteryHealth / 10.0;
        double overallRaw = (cosmeticScore * wCos) + (batScore10 * wBat) + (componentScore * wComp) + (functionScore * wFunc);
        double overallScore = BigDecimal.valueOf(overallRaw).setScale(2, RoundingMode.HALF_UP).doubleValue();

        String suggestedTier = overallScore >= 9.0 ? "GRADE_A" : (overallScore >= 8.0 ? "GRADE_B" : "GRADE_C");
        String confirmedTier = req.getParameter("confirmedTier");
        if (confirmedTier == null || "AUTO".equals(confirmedTier)) {
            confirmedTier = suggestedTier;
        }

        int ticketId = 0;
        String tSql = "INSERT INTO [inspection_tickets] ([device_id], [inspector_id], [status]) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(tSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, deviceId);
            ps.setInt(2, staffId);
            ps.setString(3, ticketType);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) ticketId = rs.getInt(1);
            }
        }

        String batTier = batteryHealth >= 95 ? "GRADE_A" : (batteryHealth >= 85 ? "GRADE_B" : "GRADE_C");
        String bSql = "INSERT INTO [inspection_battery_logs] ([ticket_id], [battery_health_percentage], [charge_cycles], [is_original_battery], [battery_warning_status], [quality_tier]) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(bSql)) {
            ps.setInt(1, ticketId);
            ps.setInt(2, batteryHealth);
            ps.setInt(3, chargeCycles);
            ps.setBoolean(4, isOriginalBattery);
            ps.setBoolean(5, batteryHealth < 80);
            ps.setString(6, batTier);
            ps.executeUpdate();
        }

        String cosmeticLabel = req.getParameter("cosmeticLabel");
        String notes = req.getParameter("notes");
        String dSql = "INSERT INTO [inspection_details] ([ticket_id], [check_item], [result_status], [grade_value], [notes]) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(dSql)) {
            ps.setInt(1, ticketId);
            ps.setString(2, "Ngoại hình khung viền & mặt kính");
            ps.setString(3, cosmeticScore >= 8.0 ? "PASSED" : "WARN");
            ps.setString(4, cosmeticLabel);
            ps.setString(5, notes);
            ps.executeUpdate();

            ps.setInt(1, ticketId);
            ps.setString(2, "Kiểm tra chức năng toàn diện (FaceID, Camera, Sóng, Cảm ứng)");
            ps.setString(3, functionScore >= 8.0 ? "PASSED" : "FAILED");
            ps.setString(4, functionScore + "/10");
            ps.setString(5, "Đề xuất hệ thống: " + suggestedTier + " | Xác nhận QC: " + confirmedTier);
            ps.executeUpdate();
        }

        String partIdRaw = req.getParameter("partId");
        int partId = 1;
        if (partIdRaw != null && !partIdRaw.isEmpty()) {
            partId = Integer.parseInt(partIdRaw);
        } else {
            try (PreparedStatement pChk = conn.prepareStatement("SELECT TOP 1 part_id FROM [iphone_parts_catalog]");
                 ResultSet rs = pChk.executeQuery()) {
                if (rs.next()) partId = rs.getInt(1);
            }
        }
        boolean isOriginalPart = "1".equals(req.getParameter("isOriginalPart"));
        boolean isGenuineReplaced = "1".equals(req.getParameter("isGenuineReplaced"));

        String proofImg = saveUploadedImage(req, "proofImageFile");
        if (proofImg == null) {
            proofImg = req.getParameter("proofImageUrl");
        }

        String cSql = "INSERT INTO [inspection_component_checks] ([ticket_id], [part_id], [is_original], [is_genuine_replaced], [icloud_status], [sim_lock_status], [blacklisted_check], [proof_image_url]) "
                    + "VALUES (?, ?, ?, ?, 'CLEAN', 'UNLOCKED', 'CLEAN', ?)";
        try (PreparedStatement ps = conn.prepareStatement(cSql)) {
            ps.setInt(1, ticketId);
            ps.setInt(2, partId);
            ps.setBoolean(3, isOriginalPart);
            ps.setBoolean(4, isGenuineReplaced);
            ps.setString(5, (proofImg != null && !proofImg.trim().isEmpty()) ? proofImg.trim() : null);
            ps.executeUpdate();
        }

        if ("1".equals(req.getParameter("issueCert"))) {
            String pdfUrl = req.getParameter("pdfReportUrl");
            Integer existingCertId = null;
            try (PreparedStatement chk = conn.prepareStatement("SELECT TOP 1 cert_id FROM [quality_certificates] WHERE [device_id] = ?")) {
                chk.setInt(1, deviceId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (rs.next()) existingCertId = rs.getInt(1);
                }
            }

            if (existingCertId != null) {
                String uCert = "UPDATE [quality_certificates] SET [ticket_id]=?, [overall_score]=?, [quality_tier]=?, [issued_at]=GETDATE(), [pdf_report_url]=? WHERE [cert_id]=?";
                try (PreparedStatement ps = conn.prepareStatement(uCert)) {
                    ps.setInt(1, ticketId);
                    ps.setDouble(2, overallScore);
                    ps.setString(3, confirmedTier);
                    ps.setString(4, (pdfUrl != null && !pdfUrl.trim().isEmpty()) ? pdfUrl.trim() : null);
                    ps.setInt(5, existingCertId);
                    ps.executeUpdate();
                }
            } else {
                String certCode = String.format("QC-2026-%04d", deviceId * 10 + (ticketId % 10));
                String iCert = "INSERT INTO [quality_certificates] ([cert_code], [device_id], [ticket_id], [overall_score], [quality_tier], [pdf_report_url]) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(iCert)) {
                    ps.setString(1, certCode);
                    ps.setInt(2, deviceId);
                    ps.setInt(3, ticketId);
                    ps.setDouble(4, overallScore);
                    ps.setString(5, confirmedTier);
                    ps.setString(6, (pdfUrl != null && !pdfUrl.trim().isEmpty()) ? pdfUrl.trim() : null);
                    ps.executeUpdate();
                }
            }
        }

        AuthServlet.logStaffAudit(staffId, "CREATE", "inspection_tickets", ticketId,
                "Kiểm định (" + ticketType + ") thiết bị #" + deviceId + " -> Điểm: " + overallScore + " | Hạng: " + confirmedTier, ip);
    }

    private void verifyCertificateAdmin(Connection conn, HttpServletRequest req, String certCode) throws Exception {
        String sql = "SELECT qc.cert_code, qc.overall_score, qc.quality_tier, qc.issued_at, qc.pdf_report_url, "
                   + "d.imei, d.serial_number, d.status AS device_status, m.model_name, cap.capacity_value, col.color_name "
                   + "FROM [quality_certificates] qc "
                   + "JOIN [devices] d ON qc.device_id = d.device_id "
                   + "JOIN [iphone_variants] v ON d.variant_id = v.variant_id "
                   + "JOIN [iphone_models] m ON v.model_id = m.model_id "
                   + "JOIN [iphone_capacities] cap ON v.capacity_id = cap.capacity_id "
                   + "JOIN [iphone_colors] col ON v.color_id = col.color_id "
                   + "WHERE qc.cert_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, certCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map c = new HashMap();
                    c.put("certCode", rs.getString("cert_code"));
                    c.put("overallScore", rs.getDouble("overall_score"));
                    c.put("qualityTier", rs.getString("quality_tier"));
                    c.put("issuedAt", rs.getTimestamp("issued_at"));
                    c.put("pdfReportUrl", rs.getString("pdf_report_url"));
                    c.put("imei", rs.getString("imei"));
                    c.put("serialNumber", rs.getString("serial_number"));
                    c.put("deviceStatus", rs.getString("device_status"));
                    c.put("modelName", rs.getString("model_name"));
                    c.put("capacity", rs.getString("capacity_value"));
                    c.put("color", rs.getString("color_name"));
                    req.setAttribute("verifiedCert", c);
                } else {
                    req.setAttribute("verifyError", "Không tìm thấy chứng nhận QC mã: " + certCode);
                }
            }
        }
    }

    // =========================================================================
    // 4. ĐỊNH GIÁ TỰ ĐỘNG, BẢNG GIÁ THAM CHIẾU & KHẤU HAO
    // =========================================================================
    private void handleSavePriceMatrix(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int variantId = Integer.parseInt(req.getParameter("variantId"));
        BigDecimal baseNew = new BigDecimal(req.getParameter("baseNewPrice"));
        BigDecimal baseUsed = new BigDecimal(req.getParameter("baseUsedPrice"));

        boolean exists = false;
        try (PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM [pricing_reference_matrices] WHERE [variant_id] = ?")) {
            chk.setInt(1, variantId);
            exists = chk.executeQuery().next();
        }

        if (exists) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE [pricing_reference_matrices] SET [base_new_price]=?, [base_used_price]=?, [updated_at]=GETDATE() WHERE [variant_id]=?")) {
                ps.setBigDecimal(1, baseNew);
                ps.setBigDecimal(2, baseUsed);
                ps.setInt(3, variantId);
                ps.executeUpdate();
            }
        } else {
            try (PreparedStatement ps = conn.prepareStatement("INSERT INTO [pricing_reference_matrices] ([variant_id], [base_new_price], [base_used_price]) VALUES (?, ?, ?)")) {
                ps.setInt(1, variantId);
                ps.setBigDecimal(2, baseNew);
                ps.setBigDecimal(3, baseUsed);
                ps.executeUpdate();
            }
        }
        AuthServlet.logStaffAudit(staffId, "UPDATE", "pricing_reference_matrices", variantId, "Cập nhật bảng giá tham chiếu variant #" + variantId, ip);
    }

    private void handleSaveDepreciationRule(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [depreciation_rules] ([rule_type], [min_val], [max_val], [deduction_amount], [deduction_percentage]) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, req.getParameter("ruleType"));
            ps.setBigDecimal(2, new BigDecimal(req.getParameter("minVal")));
            ps.setBigDecimal(3, new BigDecimal(req.getParameter("maxVal")));
            ps.setBigDecimal(4, new BigDecimal(req.getParameter("deductionAmount")));
            ps.setBigDecimal(5, new BigDecimal(req.getParameter("deductionPercentage")));
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "depreciation_rules", 0, "Thêm quy tắc giảm giá/khấu hao: " + req.getParameter("ruleType"), ip);
    }

    private void handleCalculateAndSavePrice(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        BigDecimal marketAdj = new BigDecimal(req.getParameter("marketAdjustment") != null && !req.getParameter("marketAdjustment").isEmpty()
                ? req.getParameter("marketAdjustment") : "0");

        String infoSql = "SELECT COALESCE(prm.base_used_price, m.original_msrp * 0.78, 18000000) AS base_used, "
                       + "COALESCE(YEAR(GETDATE()) - m.release_year, 1) AS age_years, "
                       + "COALESCE(qc.quality_tier, 'GRADE_B') AS tier, "
                       + "COALESCE(ibl.battery_health_percentage, 90) AS bat_pct, "
                       + "COALESCE(ibl.is_original_battery, 1) AS orig_bat "
                       + "FROM [devices] d "
                       + "JOIN [iphone_variants] v ON d.variant_id = v.variant_id "
                       + "JOIN [iphone_models] m ON v.model_id = m.model_id "
                       + "LEFT JOIN [pricing_reference_matrices] prm ON v.variant_id = prm.variant_id "
                       + "LEFT JOIN [quality_certificates] qc ON d.device_id = qc.device_id "
                       + "LEFT JOIN [inspection_tickets] it ON qc.ticket_id = it.ticket_id "
                       + "LEFT JOIN [inspection_battery_logs] ibl ON it.ticket_id = ibl.ticket_id "
                       + "WHERE d.device_id = ?";

        double baseUsed = 18000000;
        int age = 1, batPct = 90;
        String tier = "GRADE_B";
        boolean origBat = true;

        try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    baseUsed = rs.getDouble("base_used");
                    age = Math.max(0, rs.getInt("age_years"));
                    tier = rs.getString("tier");
                    batPct = rs.getInt("bat_pct");
                    origBat = rs.getBoolean("orig_bat");
                }
            }
        }

        double cosmeticScore = "GRADE_A".equals(tier) ? 99 : ("GRADE_B".equals(tier) ? 97 : 94);
        int replacedCount = origBat ? 0 : 1;

        double totalDeduction = 0;
        String rSql = "SELECT [rule_type], [min_val], [max_val], [deduction_amount], [deduction_percentage] FROM [depreciation_rules]";
        try (PreparedStatement ps = conn.prepareStatement(rSql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String type = rs.getString("rule_type");
                double minV = rs.getDouble("min_val");
                double maxV = rs.getDouble("max_val");
                double amt = rs.getDouble("deduction_amount");
                double pct = rs.getDouble("deduction_percentage");

                boolean matched = false;
                if ("AGE".equals(type) && age >= minV && age <= maxV) matched = true;
                if ("COSMETIC_GRADE".equals(type) && cosmeticScore >= minV && cosmeticScore <= maxV) matched = true;
                if ("BATTERY_LEVEL".equals(type) && batPct >= minV && batPct <= maxV) matched = true;
                if ("REPLACED_PART".equals(type) && replacedCount >= minV && replacedCount <= maxV) matched = true;

                if (matched) {
                    totalDeduction += amt + (baseUsed * pct / 100.0);
                }
            }
        }

        double suggestedSell = Math.max(3000000, baseUsed - totalDeduction);
        double suggestedBuyin = Math.round((suggestedSell * 0.82) / 10000.0) * 10000.0;
        suggestedSell = Math.round(suggestedSell / 10000.0) * 10000.0;

        String customSellRaw = req.getParameter("customSellingPrice");
        BigDecimal suggestedSellBD = BigDecimal.valueOf(suggestedSell);
        BigDecimal suggestedBuyinBD = BigDecimal.valueOf(suggestedBuyin);
        BigDecimal actualSellBD = (customSellRaw != null && !customSellRaw.trim().isEmpty())
                ? new BigDecimal(customSellRaw.trim())
                : suggestedSellBD.add(marketAdj);

        String logSql = "INSERT INTO [device_price_logs] ([device_id], [suggested_buyin_price], [suggested_selling_price], [actual_selling_price], [market_adjustment], [changed_by]) "
                      + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(logSql)) {
            ps.setInt(1, deviceId);
            ps.setBigDecimal(2, suggestedBuyinBD);
            ps.setBigDecimal(3, suggestedSellBD);
            ps.setBigDecimal(4, actualSellBD);
            ps.setBigDecimal(5, marketAdj);
            ps.setInt(6, staffId);
            ps.executeUpdate();
        }

        AuthServlet.logStaffAudit(staffId, "UPDATE", "device_price_logs", deviceId,
                "Định giá thiết bị #" + deviceId + " | Thu mua: " + suggestedBuyinBD + " | Bán: " + actualSellBD, ip);
    }

    // =========================================================================
    // 5. TIÊU CHUẨN QC, BẢO HÀNH & TÀI KHOẢN QUẢN LÝ (TẠO, ĐỔI QUYỀN, XÓA)
    // =========================================================================
    private void handleAddFault(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [hardware_fault_catalog] ([fault_code], [fault_name], [category]) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, req.getParameter("faultCode").trim().toUpperCase());
            ps.setString(2, req.getParameter("faultName").trim());
            ps.setString(3, req.getParameter("category").trim());
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "hardware_fault_catalog", 0, "Thêm lỗi phần cứng: " + req.getParameter("faultCode"), ip);
    }

    private void handleAddPart(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String partName = req.getParameter("partName").trim();
        String sql = "IF NOT EXISTS (SELECT 1 FROM [iphone_parts_catalog] WHERE [part_name] = ?) INSERT INTO [iphone_parts_catalog] ([part_name]) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, partName);
            ps.setString(2, partName);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "iphone_parts_catalog", 0, "Thêm danh mục linh kiện: " + partName, ip);
    }

    private void handleAddCriterion(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [quality_grading_criteria] ([criterion_name], [category], [weight]) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, req.getParameter("criterionName").trim());
            ps.setString(2, req.getParameter("category"));
            ps.setBigDecimal(3, new BigDecimal(req.getParameter("weight")));
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "quality_grading_criteria", 0, "Thêm tiêu chí chấm điểm: " + req.getParameter("criterionName"), ip);
    }

    private void handleAddWarrantyPackage(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String sql = "INSERT INTO [warranty_packages] ([package_name], [duration_months], [coverage_terms], [quality_tier_applied]) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, req.getParameter("packageName").trim());
            ps.setInt(2, Integer.parseInt(req.getParameter("durationMonths")));
            ps.setString(3, req.getParameter("coverageTerms").trim());
            ps.setString(4, req.getParameter("qualityTierApplied"));
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "warranty_packages", 0, "Thiết lập gói bảo hành: " + req.getParameter("packageName"), ip);
    }

    private void handleAssignDeviceWarranty(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int deviceId = Integer.parseInt(req.getParameter("deviceId"));
        int packageId = Integer.parseInt(req.getParameter("packageId"));
        int months = Integer.parseInt(req.getParameter("durationMonths"));

        int orderId = 0;
        try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 order_id FROM [order_items] WHERE [device_id] = ? ORDER BY order_id DESC")) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) orderId = rs.getInt(1);
            }
        }
        if (orderId == 0) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 order_id FROM [orders] ORDER BY order_id DESC");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) orderId = rs.getInt(1);
            }
        }
        if (orderId == 0) {
            String ordSql = "INSERT INTO [orders] ([order_code], [user_id], [recipient_name], [recipient_phone], [shipping_address], [shipping_method], [total_amount], [final_amount], [order_status]) "
                          + "VALUES (?, ?, N'Kích hoạt bảo hành tại quầy', '0900000000', N'iPhoneQC Lab', N'Tại cửa hàng', 0, 0, 'DELIVERED')";
            try (PreparedStatement ps = conn.prepareStatement(ordSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, "ORD-WAR-" + System.currentTimeMillis());
                ps.setInt(2, staffId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) orderId = rs.getInt(1);
                }
            }
        }

        String wCode = "BH-2026-" + deviceId + "-" + (int) (Math.random() * 900 + 100);
        String sql = "INSERT INTO [e_warranty_cards] ([warranty_code], [device_id], [order_id], [package_id], [start_date], [end_date], [status]) "
                   + "VALUES (?, ?, ?, ?, GETDATE(), DATEADD(MONTH, ?, GETDATE()), 'ACTIVE')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, wCode);
            ps.setInt(2, deviceId);
            ps.setInt(3, orderId);
            ps.setInt(4, packageId);
            ps.setInt(5, months);
            ps.executeUpdate();
        }
        AuthServlet.logStaffAudit(staffId, "CREATE", "e_warranty_cards", deviceId, "Cấp bảo hành " + wCode + " (" + months + " tháng) cho máy #" + deviceId, ip);
    }

    private void handleCreateStaffAccount(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        String fullName = req.getParameter("fullName").trim();
        String email = req.getParameter("email").trim();
        String phone = req.getParameter("phone").trim();
        String password = req.getParameter("password").trim();
        String roleCode = req.getParameter("roleCode");

        int newUserId = 0;
        String uSql = "INSERT INTO [users] ([email], [phone_number], [password_hash], [full_name], [status]) VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (PreparedStatement ps = conn.prepareStatement(uSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setString(3, password);
            ps.setString(4, fullName);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) newUserId = rs.getInt(1);
            }
        }

        if (newUserId > 0 && !"CUSTOMER".equalsIgnoreCase(roleCode)) {
            String ensureRole = "IF NOT EXISTS (SELECT 1 FROM [roles] WHERE [role_code] = ?) "
                              + "INSERT INTO [roles] ([role_code], [role_name]) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(ensureRole)) {
                ps.setString(1, roleCode);
                ps.setString(2, roleCode);
                ps.setString(3, "Vai trò " + roleCode);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO [user_roles] ([user_id], [role_id]) SELECT ?, [role_id] FROM [roles] WHERE [role_code] = ?")) {
                ps.setInt(1, newUserId);
                ps.setString(2, roleCode);
                ps.executeUpdate();
            }
        }

        AuthServlet.logStaffAudit(staffId, "CREATE", "users", newUserId, "Tạo tài khoản trên web: " + email + " (" + roleCode + ")", ip);
    }

    private void handleUpdateStaffRole(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int targetUserId = Integer.parseInt(req.getParameter("targetUserId"));
        String roleCode = req.getParameter("roleCode");
        String status = req.getParameter("status");

        try (PreparedStatement ps = conn.prepareStatement("UPDATE [users] SET [status] = ?, [updated_at] = GETDATE() WHERE [user_id] = ?")) {
            ps.setString(1, status);
            ps.setInt(2, targetUserId);
            ps.executeUpdate();
        }

        try (PreparedStatement del = conn.prepareStatement("DELETE FROM [user_roles] WHERE [user_id] = ?")) {
            del.setInt(1, targetUserId);
            del.executeUpdate();
        }

        if (!"CUSTOMER".equalsIgnoreCase(roleCode)) {
            String ensureRole = "IF NOT EXISTS (SELECT 1 FROM [roles] WHERE [role_code] = ?) "
                              + "INSERT INTO [roles] ([role_code], [role_name]) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(ensureRole)) {
                ps.setString(1, roleCode);
                ps.setString(2, roleCode);
                ps.setString(3, "Vai trò " + roleCode);
                ps.executeUpdate();
            }
            try (PreparedStatement ins = conn.prepareStatement(
                    "INSERT INTO [user_roles] ([user_id], [role_id]) SELECT ?, [role_id] FROM [roles] WHERE [role_code] = ?")) {
                ins.setInt(1, targetUserId);
                ins.setString(2, roleCode);
                ins.executeUpdate();
            }
        }

        AuthServlet.logStaffAudit(staffId, "UPDATE", "users", targetUserId, "Đổi quyền tài khoản #" + targetUserId + " -> " + roleCode + " (" + status + ")", ip);
    }

    private void handleDeleteStaffAccount(Connection conn, HttpServletRequest req, int staffId, String ip) throws Exception {
        int targetUserId = Integer.parseInt(req.getParameter("targetUserId"));
        if (targetUserId == staffId) {
            throw new Exception("Không thể tự xóa tài khoản đang đăng nhập!");
        }

        try (PreparedStatement logDel = conn.prepareStatement("DELETE FROM [staff_audit_logs] WHERE [staff_id] = ?")) {
            logDel.setInt(1, targetUserId);
            logDel.executeUpdate();
        }

        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM [users] WHERE [user_id] = ?")) {
            ps.setInt(1, targetUserId);
            ps.executeUpdate();
        } catch (SQLException fkEx) {
            throw new Exception("Tài khoản này đã phát sinh đơn hàng hoặc phiếu kiểm định QC nên không thể xóa cứng — hãy chuyển trạng thái sang LOCKED!");
        }

        AuthServlet.logStaffAudit(staffId, "DELETE", "users", targetUserId, "Xóa vĩnh viễn tài khoản #" + targetUserId + " khỏi CSDL", ip);
    }

    // =========================================================================
    // TẢI DỮ LIỆU HIỂN THỊ TRÊN CỔNG QUẢN TRỊ
    // =========================================================================
    private void loadDashboardData(Connection conn, HttpServletRequest req) throws Exception {
        List models = new ArrayList();
        String mSql = "SELECT m.*, s.screen_size, s.chipset, s.ram, s.camera_specs, s.battery_capacity_mah, s.charging_tech, s.biometrics_type "
                    + "FROM [iphone_models] m LEFT JOIN [iphone_specifications] s ON m.model_id = s.model_id ORDER BY m.model_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(mSql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map row = new HashMap();
                row.put("modelId", rs.getInt("model_id"));
                row.put("modelName", rs.getString("model_name"));
                row.put("generation", rs.getString("generation"));
                row.put("releaseYear", rs.getObject("release_year"));
                row.put("originalMsrp", rs.getBigDecimal("original_msrp"));
                row.put("status", rs.getString("status"));
                row.put("screenSize", rs.getString("screen_size"));
                row.put("chipset", rs.getString("chipset"));
                row.put("ram", rs.getString("ram"));
                row.put("cameraSpecs", rs.getString("camera_specs"));
                row.put("batteryCapacityMah", rs.getObject("battery_capacity_mah"));
                row.put("chargingTech", rs.getString("charging_tech"));
                row.put("biometricsType", rs.getString("biometrics_type"));
                models.add(row);
            }
        }
        req.setAttribute("models", models);

        List capacities = new ArrayList();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM [iphone_capacities] ORDER BY capacity_id"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map r = new HashMap();
                r.put("capacityId", rs.getInt("capacity_id"));
                r.put("capacityValue", rs.getString("capacity_value"));
                capacities.add(r);
            }
        }
        req.setAttribute("capacities", capacities);

        List colors = new ArrayList();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM [iphone_colors] ORDER BY color_id"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map r = new HashMap();
                r.put("colorId", rs.getInt("color_id"));
                r.put("colorName", rs.getString("color_name"));
                r.put("hexCode", rs.getString("hex_code"));
                colors.add(r);
            }
        }
        req.setAttribute("colors", colors);

        List variants = new ArrayList();
        String vSql = "SELECT v.*, m.model_name, cap.capacity_value, col.color_name, prm.base_new_price, prm.base_used_price "
                    + "FROM [iphone_variants] v "
                    + "JOIN [iphone_models] m ON v.model_id = m.model_id "
                    + "JOIN [iphone_capacities] cap ON v.capacity_id = cap.capacity_id "
                    + "JOIN [iphone_colors] col ON v.color_id = col.color_id "
                    + "LEFT JOIN [pricing_reference_matrices] prm ON v.variant_id = prm.variant_id "
                    + "ORDER BY v.variant_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(vSql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map r = new HashMap();
                r.put("variantId", rs.getInt("variant_id"));
                r.put("modelName", rs.getString("model_name"));
                r.put("capacityValue", rs.getString("capacity_value"));
                r.put("colorName", rs.getString("color_name"));
                r.put("modelNumber", rs.getString("model_number"));
                r.put("sku", rs.getString("sku"));
                r.put("baseNewPrice", rs.getBigDecimal("base_new_price"));
                r.put("baseUsedPrice", rs.getBigDecimal("base_used_price"));
                variants.add(r);
            }
        }
        req.setAttribute("variants", variants);

        List devices = new ArrayList();
        String dSql = "SELECT d.*, m.model_name, cap.capacity_value, col.color_name, "
                    + "qc.cert_code, qc.overall_score, qc.quality_tier, "
                    + "(SELECT TOP 1 media_url FROM [device_media] dm WHERE dm.device_id = d.device_id AND dm.is_cover = 1) AS cover_img, "
                    + "(SELECT TOP 1 actual_selling_price FROM [device_price_logs] dpl WHERE dpl.device_id = d.device_id ORDER BY dpl.log_id DESC) AS actual_price, "
                    + "(SELECT TOP 1 suggested_buyin_price FROM [device_price_logs] dpl WHERE dpl.device_id = d.device_id ORDER BY dpl.log_id DESC) AS buyin_price "
                    + "FROM [devices] d "
                    + "JOIN [iphone_variants] v ON d.variant_id = v.variant_id "
                    + "JOIN [iphone_models] m ON v.model_id = m.model_id "
                    + "JOIN [iphone_capacities] cap ON v.capacity_id = cap.capacity_id "
                    + "JOIN [iphone_colors] col ON v.color_id = col.color_id "
                    + "LEFT JOIN [quality_certificates] qc ON d.device_id = qc.device_id "
                    + "ORDER BY d.device_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(dSql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map r = new HashMap();
                r.put("deviceId", rs.getInt("device_id"));
                r.put("variantId", rs.getInt("variant_id"));
                r.put("imei", rs.getString("imei"));
                r.put("serialNumber", rs.getString("serial_number"));
                r.put("originCountry", rs.getString("origin_country"));
                r.put("status", rs.getString("status"));
                r.put("isVisible", rs.getBoolean("is_visible"));
                r.put("modelName", rs.getString("model_name"));
                r.put("capacityValue", rs.getString("capacity_value"));
                r.put("colorName", rs.getString("color_name"));
                r.put("certCode", rs.getString("cert_code"));
                r.put("overallScore", rs.getObject("overall_score"));
                r.put("qualityTier", rs.getString("quality_tier"));
                r.put("coverImg", rs.getString("cover_img"));
                r.put("actualPrice", rs.getBigDecimal("actual_price"));
                r.put("buyinPrice", rs.getBigDecimal("buyin_price"));
                devices.add(r);
            }
        }
        req.setAttribute("devices", devices);

        req.setAttribute("faults", querySimpleList(conn, "SELECT * FROM [hardware_fault_catalog] ORDER BY fault_id DESC"));
        req.setAttribute("parts", querySimpleList(conn, "SELECT * FROM [iphone_parts_catalog] ORDER BY part_id"));
        req.setAttribute("criteria", querySimpleList(conn, "SELECT * FROM [quality_grading_criteria] ORDER BY criterion_id"));
        req.setAttribute("depreciationRules", querySimpleList(conn, "SELECT * FROM [depreciation_rules] ORDER BY rule_id DESC"));
        req.setAttribute("warrantyPackages", querySimpleList(conn, "SELECT * FROM [warranty_packages] ORDER BY package_id"));
        req.setAttribute("warrantyCards", querySimpleList(conn,
                "SELECT ewc.*, d.imei, m.model_name, wp.package_name, wp.duration_months "
              + "FROM [e_warranty_cards] ewc JOIN [devices] d ON ewc.device_id = d.device_id "
              + "JOIN [iphone_variants] v ON d.variant_id = v.variant_id JOIN [iphone_models] m ON v.model_id = m.model_id "
              + "JOIN [warranty_packages] wp ON ewc.package_id = wp.package_id ORDER BY ewc.card_id DESC"));
        req.setAttribute("staffList", querySimpleList(conn,
                "SELECT u.user_id, u.full_name, u.email, u.phone_number, u.status, COALESCE(r.role_code, 'CUSTOMER') AS role_code, r.role_name "
              + "FROM [users] u LEFT JOIN [user_roles] ur ON u.user_id = ur.user_id LEFT JOIN [roles] r ON ur.role_id = r.role_id "
              + "ORDER BY u.user_id DESC"));
    }

    private List querySimpleList(Connection conn, String sql) throws Exception {
        List list = new ArrayList();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            int cols = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                Map row = new HashMap();
                for (int i = 1; i <= cols; i++) {
                    row.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
                }
                list.add(row);
            }
        }
        return list;
    }
}