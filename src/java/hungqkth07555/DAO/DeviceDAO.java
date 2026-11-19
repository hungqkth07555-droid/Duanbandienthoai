package DAO;
import Model.ConnectSQL;
import DTO.DeviceDetailDTO;
import DTO.DeviceDetailDTO.ComponentCheck;
import DTO.DeviceDetailDTO.InspectionDetail;
import DTO.DeviceDetailDTO.PriceHistoryItem;
import DTO.DeviceDetailDTO.QuestionItem;
import DTO.DeviceDetailDTO.ReviewItem;
import DTO.ProductDTO;
import DTO.ProductDTO.ComplaintItem;
import DTO.ProductDTO.PriceStatItem;
import DTO.ProductDTO.SearchHistoryItem;
import DTO.ProductDTO.StockNotificationItem;
import DTO.ProductDTO.SupportTicketItem;
import DTO.ProductDTO.VariantItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DeviceDAO {

    private static final String BASE_SELECT_SQL =
        "SELECT d.device_id, d.variant_id, m.model_name, c.capacity_value, col.color_name, col.hex_code, " +
        "v.model_number, v.sku, d.imei, d.serial_number, d.origin_country, d.status, " +
        "ISNULL(dm.media_url, 'https://via.placeholder.com/300') AS media_url, " +
        "ISNULL(dpl.actual_selling_price, 0) AS actual_selling_price, " +
        "ISNULL(prm.base_new_price, ISNULL(dpl.suggested_selling_price, ISNULL(m.original_msrp * 25000, 0))) AS base_new_price, " +
        "it.ticket_id, qc.cert_code, ISNULL(qc.overall_score, 0) AS overall_score, " +
        "ISNULL(qc.quality_tier, 'GRADE_A') AS quality_tier, " +
        "ISNULL(ibl.battery_health_percentage, 100) AS battery_health_percentage, " +
        "ISNULL(ibl.charge_cycles, 0) AS charge_cycles, " +
        "ISNULL(ibl.is_original_battery, 1) AS is_original_battery, " +
        "ISNULL(ibl.battery_warning_status, 0) AS battery_warning_status, " +
        "ISNULL(comp.replaced_count, 0) AS replaced_count, " +
        "ISNULL(wp.duration_months, 6) AS warranty_months, " +
        "ISNULL(wp.package_name, N'Bảo hành tiêu chuẩn') AS package_name, " +
        "wp.coverage_terms, " +
        "ISNULL(cos.grade_value, N'Đẹp 99%') AS cosmetic_condition, " +
        "spec.screen_size, spec.chipset, spec.ram, spec.camera_specs, " +
        "ISNULL(spec.battery_capacity_mah, 0) AS battery_capacity_mah, spec.charging_tech, spec.biometrics_type " +
        "FROM devices d " +
        "JOIN iphone_variants v ON d.variant_id = v.variant_id " +
        "JOIN iphone_models m ON v.model_id = m.model_id " +
        "JOIN iphone_capacities c ON v.capacity_id = c.capacity_id " +
        "JOIN iphone_colors col ON v.color_id = col.color_id " +
        "LEFT JOIN iphone_specifications spec ON m.model_id = spec.model_id " +
        "LEFT JOIN pricing_reference_matrices prm ON v.variant_id = prm.variant_id " +
        "OUTER APPLY (SELECT TOP 1 actual_selling_price, suggested_selling_price FROM device_price_logs WHERE device_id = d.device_id ORDER BY changed_at DESC, log_id DESC) dpl " +
        "OUTER APPLY (SELECT TOP 1 media_url FROM device_media WHERE device_id = d.device_id AND media_type = 'IMAGE' ORDER BY is_cover DESC, media_id ASC) dm " +
        "OUTER APPLY (SELECT TOP 1 ticket_id FROM inspection_tickets WHERE device_id = d.device_id ORDER BY inspection_date DESC, ticket_id DESC) it " +
        "OUTER APPLY (SELECT TOP 1 cert_code, overall_score, quality_tier FROM quality_certificates WHERE device_id = d.device_id ORDER BY issued_at DESC, cert_id DESC) qc " +
        "OUTER APPLY (SELECT TOP 1 battery_health_percentage, charge_cycles, is_original_battery, battery_warning_status FROM inspection_battery_logs WHERE ticket_id = it.ticket_id ORDER BY battery_log_id DESC) ibl " +
        "OUTER APPLY (SELECT SUM(CASE WHEN is_original = 0 THEN 1 ELSE 0 END) AS replaced_count FROM inspection_component_checks WHERE ticket_id = it.ticket_id) comp " +
        "OUTER APPLY (SELECT TOP 1 package_name, duration_months, coverage_terms FROM warranty_packages WHERE quality_tier_applied = ISNULL(qc.quality_tier, 'GRADE_A') ORDER BY duration_months DESC) wp " +
        "OUTER APPLY (SELECT TOP 1 grade_value FROM inspection_details WHERE ticket_id = it.ticket_id AND check_item LIKE N'%Ngoại hình%' ORDER BY detail_id ASC) cos ";

    private void mapProductRow(ResultSet rs, ProductDTO dto) throws SQLException {
        dto.setDeviceId(rs.getInt("device_id"));
        dto.setVariantId(rs.getInt("variant_id"));
        dto.setModelName(rs.getString("model_name"));
        dto.setCapacityValue(rs.getString("capacity_value"));
        dto.setColorName(rs.getString("color_name"));
        dto.setHexCode(rs.getString("hex_code"));
        dto.setModelNumber(rs.getString("model_number"));
        dto.setSku(rs.getString("sku"));
        dto.setImei(rs.getString("imei"));
        dto.setSerialNumber(rs.getString("serial_number"));
        dto.setOriginCountry(rs.getString("origin_country"));
        dto.setStatus(rs.getString("status"));
        dto.setCoverImage(rs.getString("media_url"));

        double price = rs.getDouble("actual_selling_price");
        double newPrice = rs.getDouble("base_new_price");
        dto.setPrice(price);
        dto.setBaseNewPrice(newPrice);
        dto.setSavingsAmount(newPrice > price ? (newPrice - price) : 0);

        dto.setCertCode(rs.getString("cert_code"));
        dto.setOverallScore(rs.getDouble("overall_score"));
        dto.setQualityTier(rs.getString("quality_tier"));
        dto.setBatteryHealth(rs.getInt("battery_health_percentage"));
        dto.setChargeCycles(rs.getInt("charge_cycles"));
        dto.setOriginalBattery(rs.getBoolean("is_original_battery"));
        dto.setBatteryWarning(rs.getBoolean("battery_warning_status"));
        dto.setAllOriginalParts(rs.getInt("replaced_count") == 0);
        dto.setWarrantyMonths(rs.getInt("warranty_months"));
        dto.setWarrantyPackageName(rs.getString("package_name"));
        dto.setCosmeticCondition(rs.getString("cosmetic_condition"));
        dto.setScreenSize(rs.getString("screen_size"));
        dto.setChipset(rs.getString("chipset"));
        dto.setRam(rs.getString("ram"));
        dto.setCameraSpecs(rs.getString("camera_specs"));
        dto.setBatteryCapacityMah(rs.getInt("battery_capacity_mah"));
    }

    public List<ProductDTO> searchAndFilterDevices(
            String keyword, String imei, String minPrice, String maxPrice, String budget,
            String capacity, String color, String qualityTier, String minBattery,
            String partStatus, String minWarranty, String cosmetic, String usageNeed, String sort) {

        List<ProductDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT_SQL + " WHERE d.is_visible = 1 AND d.status = 'IN_STOCK' ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND m.model_name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (imei != null && !imei.trim().isEmpty()) {
            sql.append(" AND d.imei LIKE ? ");
            params.add("%" + imei.trim() + "%");
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            sql.append(" AND ISNULL(dpl.actual_selling_price, 0) >= ? ");
            params.add(Double.parseDouble(minPrice.trim()));
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            sql.append(" AND ISNULL(dpl.actual_selling_price, 0) <= ? ");
            params.add(Double.parseDouble(maxPrice.trim()));
        }
        if (budget != null && !budget.trim().isEmpty()) {
            sql.append(" AND ISNULL(dpl.actual_selling_price, 0) <= ? ");
            params.add(Double.parseDouble(budget.trim()));
        }
        if (capacity != null && !capacity.trim().isEmpty()) {
            sql.append(" AND c.capacity_value = ? ");
            params.add(capacity.trim());
        }
        if (color != null && !color.trim().isEmpty()) {
            sql.append(" AND col.color_name = ? ");
            params.add(color.trim());
        }
        if (qualityTier != null && !qualityTier.trim().isEmpty()) {
            sql.append(" AND ISNULL(qc.quality_tier, 'GRADE_A') = ? ");
            params.add(qualityTier.trim());
        }
        if (minBattery != null && !minBattery.trim().isEmpty()) {
            sql.append(" AND ISNULL(ibl.battery_health_percentage, 100) >= ? ");
            params.add(Integer.parseInt(minBattery.trim()));
        }
        if ("ORIGINAL".equals(partStatus)) {
            sql.append(" AND ISNULL(comp.replaced_count, 0) = 0 ");
        } else if ("REPLACED".equals(partStatus)) {
            sql.append(" AND ISNULL(comp.replaced_count, 0) > 0 ");
        }
        if (minWarranty != null && !minWarranty.trim().isEmpty()) {
            sql.append(" AND ISNULL(wp.duration_months, 6) >= ? ");
            params.add(Integer.parseInt(minWarranty.trim()));
        }
        if (cosmetic != null && !cosmetic.trim().isEmpty()) {
            sql.append(" AND ISNULL(cos.grade_value, N'Đẹp 99%') LIKE ? ");
            params.add("%" + cosmetic.trim() + "%");
        }
        if ("GAMING".equals(usageNeed)) {
            sql.append(" AND (m.model_name LIKE '%Pro%' OR spec.chipset LIKE '%A16%' OR spec.chipset LIKE '%A17%') ");
        } else if ("CAMERA".equals(usageNeed)) {
            sql.append(" AND (m.model_name LIKE '%Pro%' OR spec.camera_specs LIKE '%48MP%') ");
        } else if ("BATTERY".equals(usageNeed)) {
            sql.append(" AND (m.model_name LIKE '%Max%' OR m.model_name LIKE '%Plus%' OR spec.battery_capacity_mah >= 4000) ");
        } else if ("COMPACT".equals(usageNeed)) {
            sql.append(" AND m.model_name NOT LIKE '%Max%' AND m.model_name NOT LIKE '%Plus%' ");
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY dpl.actual_selling_price ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY dpl.actual_selling_price DESC ");
        } else if ("score_desc".equals(sort)) {
            sql.append(" ORDER BY qc.overall_score DESC ");
        } else if (budget != null && !budget.trim().isEmpty()) {
            sql.append(" ORDER BY qc.overall_score DESC, dpl.actual_selling_price DESC ");
        } else {
            sql.append(" ORDER BY d.device_id DESC ");
        }

        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDTO dto = new ProductDTO();
                    mapProductRow(rs, dto);
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void saveSearchHistory(int userId, String keyword, String filterSummary) {
        if ((keyword == null || keyword.trim().isEmpty()) && (filterSummary == null || filterSummary.trim().isEmpty())) {
            return;
        }
        String sql = "INSERT INTO user_search_histories (user_id, search_keyword, applied_filters_json) VALUES (?, ?, ?)";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, keyword != null ? keyword.trim() : "");
            ps.setString(3, filterSummary);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<SearchHistoryItem> getSearchHistories(int userId) {
        List<SearchHistoryItem> list = new ArrayList<>();
        String sql = "SELECT TOP 10 search_id, search_keyword, applied_filters_json, created_at " +
                     "FROM user_search_histories WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SearchHistoryItem item = new SearchHistoryItem();
                    item.setSearchId(rs.getInt("search_id"));
                    item.setKeyword(rs.getString("search_keyword"));
                    item.setFilters(rs.getString("applied_filters_json"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public DeviceDetailDTO getFullDeviceDetail(Integer deviceId, String imei) {
        DeviceDetailDTO dto = null;
        StringBuilder sql = new StringBuilder(BASE_SELECT_SQL + " WHERE 1=1 ");
        if (deviceId != null) {
            sql.append(" AND d.device_id = ? ");
        } else if (imei != null && !imei.trim().isEmpty()) {
            sql.append(" AND d.imei = ? ");
        } else {
            return null;
        }

        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (deviceId != null) {
                ps.setInt(1, deviceId);
            } else {
                ps.setString(1, imei.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new DeviceDetailDTO();
                    mapProductRow(rs, dto);
                    int ticketId = rs.getInt("ticket_id");
                    dto.setTicketId(ticketId);
                    dto.setChargingTech(rs.getString("charging_tech"));
                    dto.setBiometricsType(rs.getString("biometrics_type"));
                    dto.setCoverageTerms(rs.getString("coverage_terms"));

                    dto.setComponentChecks(getComponentChecks(conn, ticketId));
                    dto.setInspectionDetails(getInspectionDetails(conn, ticketId));
                    dto.setPriceHistory(getPriceHistory(conn, dto.getDeviceId()));
                    dto.setReviews(getProductReviews(conn, dto.getDeviceId()));
                    dto.setDeviceQuestions(getDeviceQuestions(conn, dto.getDeviceId()));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    private List<ComponentCheck> getComponentChecks(Connection conn, int ticketId) throws SQLException {
        List<ComponentCheck> list = new ArrayList<>();
        String sql = "SELECT cc.*, p.part_name, it.inspection_date " +
                     "FROM inspection_component_checks cc " +
                     "JOIN iphone_parts_catalog p ON cc.part_id = p.part_id " +
                     "JOIN inspection_tickets it ON cc.ticket_id = it.ticket_id " +
                     "WHERE cc.ticket_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComponentCheck item = new ComponentCheck();
                    item.setPartName(rs.getString("part_name"));
                    item.setOriginal(rs.getBoolean("is_original"));
                    item.setGenuineReplaced(rs.getBoolean("is_genuine_replaced"));
                    item.setIcloudStatus(rs.getString("icloud_status"));
                    item.setSimLockStatus(rs.getString("sim_lock_status"));
                    item.setBlacklistedCheck(rs.getString("blacklisted_check"));
                    item.setProofImageUrl(rs.getString("proof_image_url"));
                    item.setInspectionDate(rs.getTimestamp("inspection_date"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<InspectionDetail> getInspectionDetails(Connection conn, int ticketId) throws SQLException {
        List<InspectionDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, it.inspection_date, u.full_name AS inspector_name " +
                     "FROM inspection_details d " +
                     "JOIN inspection_tickets it ON d.ticket_id = it.ticket_id " +
                     "JOIN users u ON it.inspector_id = u.user_id " +
                     "WHERE d.ticket_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InspectionDetail item = new InspectionDetail();
                    item.setCheckItem(rs.getString("check_item"));
                    item.setResultStatus(rs.getString("result_status"));
                    item.setGradeValue(rs.getString("grade_value"));
                    item.setNotes(rs.getString("notes"));
                    item.setInspectionDate(rs.getTimestamp("inspection_date"));
                    item.setInspectorName(rs.getString("inspector_name"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<PriceHistoryItem> getPriceHistory(Connection conn, int deviceId) throws SQLException {
        List<PriceHistoryItem> list = new ArrayList<>();
        String sql = "SELECT * FROM device_price_logs WHERE device_id = ? ORDER BY changed_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PriceHistoryItem item = new PriceHistoryItem();
                    item.setSuggestedSellingPrice(rs.getDouble("suggested_selling_price"));
                    item.setActualSellingPrice(rs.getDouble("actual_selling_price"));
                    item.setMarketAdjustment(rs.getDouble("market_adjustment"));
                    item.setChangedAt(rs.getTimestamp("changed_at"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<ReviewItem> getProductReviews(Connection conn, int deviceId) throws SQLException {
        List<ReviewItem> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name FROM product_reviews r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.device_id = ? ORDER BY r.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewItem item = new ReviewItem();
                    item.setFullName(rs.getString("full_name"));
                    item.setOverallRating(rs.getInt("overall_rating"));
                    item.setQcAccuracyRating(rs.getInt("qc_accuracy_rating"));
                    item.setBatteryPostUseRating(rs.getInt("battery_post_use_rating"));
                    item.setComment(rs.getString("comment"));
                    item.setReviewImageUrl(rs.getString("review_image_url"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private List<QuestionItem> getDeviceQuestions(Connection conn, int deviceId) throws SQLException {
        List<QuestionItem> list = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name FROM support_tickets t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "WHERE t.subject LIKE ? ORDER BY t.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%[Device #" + deviceId + "]%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuestionItem item = new QuestionItem();
                    item.setFullName(rs.getString("full_name"));
                    item.setMessage(rs.getString("message"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    public void addProductReview(int userId, int deviceId, int overall, int qcRating, int batRating, String comment, String imageUrl) {
        String sql = "INSERT INTO product_reviews (user_id, device_id, overall_rating, qc_accuracy_rating, battery_post_use_rating, comment, review_image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, deviceId);
            ps.setInt(3, overall);
            ps.setInt(4, qcRating);
            ps.setInt(5, batRating);
            ps.setString(6, comment);
            ps.setString(7, (imageUrl != null && !imageUrl.trim().isEmpty()) ? imageUrl.trim() : null);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void reportInaccurateInfo(int userId, Integer deviceId, String complaintType, String content) {
        String sql = "INSERT INTO customer_complaints (user_id, device_id, complaint_type, content, status) VALUES (?, ?, ?, ?, 'OPEN')";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (deviceId != null) {
                ps.setInt(2, deviceId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, complaintType);
            ps.setString(4, content);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void createSupportTicket(int userId, String subject, String message, String supportType) {
        String sql = "INSERT INTO support_tickets (user_id, subject, message, support_type, status) VALUES (?, ?, ?, ?, 'OPEN')";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, message);
            ps.setString(4, supportType);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ProductDTO> getWishlistByUser(int userId) {
        List<ProductDTO> list = new ArrayList<>();
        String sql = BASE_SELECT_SQL + " JOIN user_wishlists w ON d.device_id = w.device_id WHERE w.user_id = ? ORDER BY w.created_at DESC";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDTO dto = new ProductDTO();
                    mapProductRow(rs, dto);
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addToWishlist(int userId, int deviceId) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM user_wishlists WHERE user_id = ? AND device_id = ?) " +
                     "INSERT INTO user_wishlists (user_id, device_id) VALUES (?, ?)";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, deviceId);
            ps.setInt(3, userId);
            ps.setInt(4, deviceId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeFromWishlist(int userId, int deviceId) {
        String sql = "DELETE FROM user_wishlists WHERE user_id = ? AND device_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, deviceId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void subscribeStockNotification(int userId, int variantId, String preferredTier) {
        String sql = "INSERT INTO stock_notifications (user_id, variant_id, preferred_quality_tier, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, variantId);
            ps.setString(3, preferredTier);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<VariantItem> getAllVariants() {
        List<VariantItem> list = new ArrayList<>();
        String sql = "SELECT v.variant_id, m.model_name, c.capacity_value, col.color_name, v.model_number " +
                     "FROM iphone_variants v " +
                     "JOIN iphone_models m ON v.model_id = m.model_id " +
                     "JOIN iphone_capacities c ON v.capacity_id = c.capacity_id " +
                     "JOIN iphone_colors col ON v.color_id = col.color_id";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                VariantItem item = new VariantItem();
                item.setVariantId(rs.getInt("variant_id"));
                item.setLabel(rs.getString("model_name") + " - " + rs.getString("capacity_value") + " - " + rs.getString("color_name") + " (" + rs.getString("model_number") + ")");
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<StockNotificationItem> getStockNotificationsByUser(int userId) {
        List<StockNotificationItem> list = new ArrayList<>();
        String sql = "SELECT sn.notification_id, sn.preferred_quality_tier, sn.status, sn.created_at, " +
                     "m.model_name, c.capacity_value, col.color_name " +
                     "FROM stock_notifications sn " +
                     "JOIN iphone_variants v ON sn.variant_id = v.variant_id " +
                     "JOIN iphone_models m ON v.model_id = m.model_id " +
                     "JOIN iphone_capacities c ON v.capacity_id = c.capacity_id " +
                     "JOIN iphone_colors col ON v.color_id = col.color_id " +
                     "WHERE sn.user_id = ? ORDER BY sn.created_at DESC";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockNotificationItem item = new StockNotificationItem();
                    item.setModelName(rs.getString("model_name"));
                    item.setCapacity(rs.getString("capacity_value"));
                    item.setColor(rs.getString("color_name"));
                    item.setTier(rs.getString("preferred_quality_tier"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DeviceDetailDTO> getDevicesForComparison(String[] ids) {
        List<DeviceDetailDTO> list = new ArrayList<>();
        if (ids == null || ids.length == 0) {
            List<ProductDTO> defaults = searchAndFilterDevices(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
            for (int i = 0; i < Math.min(3, defaults.size()); i++) {
                DeviceDetailDTO detail = getFullDeviceDetail(defaults.get(i).getDeviceId(), null);
                if (detail != null) list.add(detail);
            }
            return list;
        }
        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr.trim());
                DeviceDetailDTO detail = getFullDeviceDetail(id, null);
                if (detail != null) list.add(detail);
            } catch (NumberFormatException ignored) {}
        }
        return list;
    }

    public List<PriceStatItem> getPriceComparisonStats(String groupByMode) {
        List<PriceStatItem> list = new ArrayList<>();
        String groupCol;
        String labelExpr;
        switch (groupByMode != null ? groupByMode : "models") {
            case "capacities":
                groupCol = "c.capacity_value";
                labelExpr = "c.capacity_value";
                break;
            case "tiers":
                groupCol = "ISNULL(qc.quality_tier, 'GRADE_A')";
                labelExpr = "ISNULL(qc.quality_tier, 'GRADE_A')";
                break;
            case "battery":
                groupCol = "CASE WHEN ISNULL(ibl.battery_health_percentage,100) >= 95 THEN N'Pin 95% - 100%' WHEN ISNULL(ibl.battery_health_percentage,100) >= 88 THEN N'Pin 88% - 94%' ELSE N'Pin dưới 88%' END";
                labelExpr = groupCol;
                break;
            case "same_spec":
                groupCol = "m.model_name + ' (' + c.capacity_value + ')'";
                labelExpr = groupCol;
                break;
            default:
                groupCol = "m.model_name";
                labelExpr = "m.model_name";
                break;
        }

        String sql = "SELECT " + labelExpr + " AS group_label, " +
                     "COUNT(d.device_id) AS device_count, " +
                     "MIN(dpl.actual_selling_price) AS min_price, " +
                     "AVG(dpl.actual_selling_price) AS avg_price, " +
                     "MAX(dpl.actual_selling_price) AS max_price, " +
                     "AVG(ISNULL(prm.base_new_price, dpl.suggested_selling_price) - dpl.actual_selling_price) AS avg_savings " +
                     "FROM devices d " +
                     "JOIN iphone_variants v ON d.variant_id = v.variant_id " +
                     "JOIN iphone_models m ON v.model_id = m.model_id " +
                     "JOIN iphone_capacities c ON v.capacity_id = c.capacity_id " +
                     "LEFT JOIN pricing_reference_matrices prm ON v.variant_id = prm.variant_id " +
                     "OUTER APPLY (SELECT TOP 1 actual_selling_price, suggested_selling_price FROM device_price_logs WHERE device_id = d.device_id ORDER BY changed_at DESC) dpl " +
                     "OUTER APPLY (SELECT TOP 1 ticket_id FROM inspection_tickets WHERE device_id = d.device_id ORDER BY inspection_date DESC) it " +
                     "OUTER APPLY (SELECT TOP 1 quality_tier FROM quality_certificates WHERE device_id = d.device_id ORDER BY issued_at DESC) qc " +
                     "OUTER APPLY (SELECT TOP 1 battery_health_percentage FROM inspection_battery_logs WHERE ticket_id = it.ticket_id ORDER BY battery_log_id DESC) ibl " +
                     "WHERE d.status = 'IN_STOCK' " +
                     "GROUP BY " + groupCol;

        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PriceStatItem item = new PriceStatItem();
                item.setGroupLabel(rs.getString("group_label"));
                item.setDeviceCount(rs.getInt("device_count"));
                item.setMinPrice(rs.getDouble("min_price"));
                item.setAvgPrice(rs.getDouble("avg_price"));
                item.setMaxPrice(rs.getDouble("max_price"));
                item.setAvgSavings(rs.getDouble("avg_savings"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SupportTicketItem> getUserSupportTickets(int userId) {
        List<SupportTicketItem> list = new ArrayList<>();
        String sql = "SELECT * FROM support_tickets WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupportTicketItem item = new SupportTicketItem();
                    item.setTicketId(rs.getInt("ticket_id"));
                    item.setSubject(rs.getString("subject"));
                    item.setMessage(rs.getString("message"));
                    item.setSupportType(rs.getString("support_type"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ComplaintItem> getAllComplaints(int userId) {
        List<ComplaintItem> list = new ArrayList<>();
        String sql = "SELECT c.*, d.imei FROM customer_complaints c " +
                     "LEFT JOIN devices d ON c.device_id = d.device_id " +
                     "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComplaintItem item = new ComplaintItem();
                    item.setComplaintId(rs.getInt("complaint_id"));
                    item.setDeviceId((Integer) rs.getObject("device_id"));
                    item.setImei(rs.getString("imei"));
                    item.setComplaintType(rs.getString("complaint_type"));
                    item.setContent(rs.getString("content"));
                    item.setStatus(rs.getString("status"));
                    item.setResolutionNote(rs.getString("resolution_note"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void replyComplaint(int complaintId, String resolutionNote) {
        String sql = "UPDATE customer_complaints SET resolution_note = ?, status = 'RESOLVED' WHERE complaint_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resolutionNote);
            ps.setInt(2, complaintId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
// Xóa Ticket hỗ trợ / câu hỏi tình trạng thiết bị
    public void deleteSupportTicket(int ticketId) {
        String sql = "DELETE FROM support_tickets WHERE ticket_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa Khiếu nại / Báo cáo thông tin sai
    public void deleteComplaint(int complaintId) {
        String sql = "DELETE FROM customer_complaints WHERE complaint_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa toàn bộ lịch sử tìm kiếm của người dùng
    public void clearSearchHistory(int userId) {
        String sql = "DELETE FROM user_search_histories WHERE user_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa Đánh giá sản phẩm
    public void deleteProductReview(int reviewId) {
        String sql = "DELETE FROM product_reviews WHERE review_id = ?";
        try (Connection conn = ConnectSQL.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}