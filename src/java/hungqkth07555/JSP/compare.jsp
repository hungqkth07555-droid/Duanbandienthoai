<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>So sánh giá & Thông tin kiểm định — iPhoneQCStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cps-red: #d70018;
            --cps-red-dark: #b80014;
            --cps-red-soft: #fff0f1;
            --bg-body: #f4f6f8;
            --text-main: #111827;
            --text-muted: #6b7280;
            --border-light: #e5e7eb;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .font-mono {
            font-family: 'JetBrains Mono', monospace;
        }

        /* ===== 1. TOP PROMO STRIP (ĐỒNG BỘ TRANG CHỦ) ===== */
        .top-promo-bar {
            background-color: #0b0d12;
            color: #ffffff;
            font-size: 0.76rem;
            padding: 6px 0;
            letter-spacing: 0.2px;
        }

        .promo-dot {
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: #38bdf8;
            margin-right: 6px;
        }

        /* ===== 2. MAIN RED HEADER & SEARCH BAR ===== */
        .main-header {
            background: linear-gradient(180deg, #e0051e 0%, #d70018 100%);
            position: sticky;
            top: 0;
            z-index: 1050;
            box-shadow: 0 4px 16px rgba(215, 0, 24, 0.22);
            padding: 10px 0;
        }

        .brand-box {
            color: #ffffff;
            text-decoration: none;
            font-weight: 800;
            font-size: 1.25rem;
            letter-spacing: -0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .brand-badge-s {
            background: #ffffff;
            color: var(--cps-red);
            font-weight: 900;
            font-size: 0.9rem;
            padding: 1px 7px;
            border-radius: 6px;
        }

        .header-pill-btn {
            background: rgba(255, 255, 255, 0.16);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 10px;
            padding: 7px 12px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .header-pill-btn:hover, .header-pill-btn.active {
            background: rgba(255, 255, 255, 0.3);
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.45);
        }

        /* Ô tìm kiếm tách riêng trên Header */
        .header-search-wrap {
            position: relative;
            flex-grow: 1;
            max-width: 520px;
            z-index: 1060;
        }

        .header-search-form {
            background: #ffffff;
            border-radius: 10px;
            display: flex;
            align-items: center;
            padding: 2px 6px 2px 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .header-search-form input {
            border: none;
            outline: none;
            box-shadow: none !important;
            font-size: 0.88rem;
            padding: 7px 8px;
            width: 100%;
            color: #111827;
        }

        .header-search-form button {
            background: var(--cps-red);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 5px 12px;
            font-size: 0.82rem;
            font-weight: 600;
        }

        .search-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(2px);
            z-index: 1045;
            display: none;
        }

        .search-backdrop.show {
            display: block;
        }

        .search-dropdown-panel {
            position: absolute;
            top: calc(100% + 10px);
            left: 0;
            right: 0;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 18px 40px rgba(0, 0, 0, 0.22);
            padding: 16px;
            display: none;
            z-index: 1065;
            border: 1px solid #e5e7eb;
        }

        .search-dropdown-panel.show {
            display: block;
        }

        .search-dropdown-panel::before {
            content: "";
            position: absolute;
            top: -7px;
            left: 36px;
            width: 14px;
            height: 14px;
            background: #ffffff;
            transform: rotate(45deg);
            border-left: 1px solid #e5e7eb;
            border-top: 1px solid #e5e7eb;
        }

        .trend-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 6px 8px;
            border-radius: 8px;
            text-decoration: none;
            color: #1f2937;
            font-size: 0.82rem;
            font-weight: 500;
            transition: background 0.15s;
        }

        .trend-item:hover {
            background: #f3f4f6;
            color: var(--cps-red);
        }

        .trend-item img {
            width: 28px;
            height: 28px;
            object-fit: contain;
            mix-blend-mode: multiply;
        }

        /* ===== 3. BENTO CARD & FILTER PILLS ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
            border: 1px solid #e5e7eb;
        }

        .mode-pill-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 7px 14px;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.18s ease;
        }

        .mode-pill-btn:hover {
            background: #e5e7eb;
            color: #111827;
        }

        .mode-pill-btn.active {
            background: var(--cps-red);
            color: #ffffff;
            border-color: var(--cps-red);
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.25);
        }

        /* ===== 4. BẢNG THỐNG KÊ & SO SÁNH ===== */
        .table-cps thead th {
            background-color: #f8fafc;
            color: #475569;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-weight: 700;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 12px 14px;
        }

        .table-cps tbody td {
            padding: 13px 14px;
            font-size: 0.9rem;
            border-color: #f1f5f9;
        }

        .save-badge {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
            font-size: 0.78rem;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 6px;
            display: inline-block;
        }

        .qc-badge-pill {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 11px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .qc-A { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .qc-B { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .qc-C { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }

        /* Cột đầu tiên dính cố định khi cuộn ngang trên màn nhỏ */
        .compare-matrix th.sticky-col {
            position: sticky;
            left: 0;
            z-index: 2;
            background-color: #f8fafc;
            color: #334155;
            font-size: 0.84rem;
            font-weight: 700;
            min-width: 190px;
            border-right: 1.5px solid #e2e8f0;
        }

        .device-col-header {
            min-width: 220px;
            background: #ffffff !important;
            vertical-align: top;
            padding: 16px !important;
        }

        .btn-cps-outline {
            border: 1.5px solid var(--cps-red);
            color: var(--cps-red);
            background: #ffffff;
            border-radius: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 6px 14px;
            transition: all 0.2s;
        }

        .btn-cps-outline:hover {
            background: var(--cps-red);
            color: #ffffff;
        }
    </style>
</head>
<body>

    <!-- MÀN CHE KHI BẤM VÀO THANH TÌM KIẾM -->
    <div class="search-backdrop" id="searchBackdrop" onclick="closeSearchDropdown()"></div>

    <!-- 1. TOP PROMO STRIP -->
    <div class="top-promo-bar">
        <div class="container d-flex flex-wrap justify-content-between align-items-center gap-2">
            <div>
                <span class="promo-dot"></span>
                <strong>Kiểm định phần cứng 30+ hạng mục</strong> • Minh bạch lịch sử thay thế linh kiện & chu kỳ sạc pin thực tế
            </div>
            <div class="d-none d-md-flex align-items-center gap-3 text-white-50">
                <span><i class="bi bi-shield-check text-info me-1"></i>Bảo hành 1 đổi 1 tới 12 tháng</span>
                <span><i class="bi bi-upc-scan text-warning me-1"></i>Tra cứu IMEI chuẩn Lab</span>
            </div>
        </div>
    </div>

    <!-- 2. MAIN RED HEADER (ĐỒNG BỘ VỚI INDEX.JSP) -->
    <header class="main-header">
        <div class="container">
            <div class="d-flex align-items-center justify-content-between gap-2 gap-lg-3">
                <!-- Logo -->
                <a href="home" class="brand-box">
                    <i class="bi bi-apple fs-4"></i>
                    <span>iPhoneQC</span>
                    <span class="brand-badge-s">LAB</span>
                </a>

                <!-- Nút Danh mục -->
                <a href="home#catalog" class="header-pill-btn d-none d-md-inline-flex">
                    <i class="bi bi-grid-fill"></i>
                    <span>Danh mục</span>
                </a>

                <!-- Thanh tìm kiếm tách riêng -->
                <div class="header-search-wrap">
                    <form action="home" method="get" class="header-search-form">
                        <i class="bi bi-search text-muted"></i>
                        <input type="text" name="keyword" placeholder="Bạn muốn tìm dòng iPhone nào hôm nay?"
                               autocomplete="off" onfocus="openSearchDropdown()">
                        <button type="submit">Tìm</button>
                    </form>

                    <div class="search-dropdown-panel" id="searchDropdownPanel">
                        <div class="small fw-bold text-dark mb-2">
                            <i class="bi bi-fire text-danger me-1"></i>Xu hướng tìm kiếm
                        </div>
                        <div class="row g-1">
                            <div class="col-6">
                                <a href="home?keyword=iPhone 17 Pro Max" class="trend-item">
                                    <img src="image/ip17pm.jpg" alt="17PM">
                                    <span>iPhone 17 Pro Max</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?keyword=iPhone 17" class="trend-item">
                                    <img src="image/ip17.jpg" alt="17">
                                    <span>iPhone 17 Lavender</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?keyword=iPhone 16 Pro Max" class="trend-item">
                                    <img src="image/ip16pm.jpg" alt="16PM">
                                    <span>iPhone 16 Pro Max</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?keyword=iPhone 16" class="trend-item">
                                    <img src="image/ip16.jpg" alt="16">
                                    <span>iPhone 16 Ultramarine</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Các nút chức năng bên phải -->
                <div class="d-flex align-items-center gap-2">
                    <a href="CompareServlet" class="header-pill-btn active">
                        <i class="bi bi-bar-chart-line"></i>
                        <span class="d-none d-xl-inline">So sánh QC</span>
                    </a>
                    <a href="WishlistServlet" class="header-pill-btn">
                        <i class="bi bi-heart"></i>
                        <span class="d-none d-xl-inline">Yêu thích</span>
                    </a>
                    <a href="SupportServlet" class="header-pill-btn">
                        <i class="bi bi-headset"></i>
                        <span class="d-none d-lg-inline">Hỗ trợ</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- 3. BREADCRUMB ĐIỀU HƯỚNG -->
    <div class="bg-white border-bottom py-2">
        <div class="container d-flex align-items-center justify-content-between">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item"><a href="home" class="text-decoration-none text-muted"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active fw-semibold text-dark" aria-current="page">So sánh giá & Thông tin kiểm định</li>
                </ol>
            </nav>
            <a href="home#catalog" class="btn btn-cps-outline btn-sm">
                <i class="bi bi-plus-lg me-1"></i>Chọn thêm máy để so sánh
            </a>
        </div>
    </div>

    <!-- 4. NỘI DUNG CHÍNH -->
    <main class="container my-4">

        <!-- KHỐI 1: BẢNG SO SÁNH GIÁ ĐA CHIỀU -->
        <div class="bento-card p-3 p-md-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <div>
                    <h5 class="fw-bold mb-1"><i class="bi bi-bar-chart-fill text-danger me-2"></i>Phân tích & So sánh giá thị trường theo tiêu chí</h5>
                    <p class="text-muted small mb-0">Thống kê biến động giá thực tế và mức tiết kiệm trung bình tại hệ thống iPhoneQC Lab</p>
                </div>
            </div>

            <!-- Các tab chế độ phân tích đồng bộ style nút lọc -->
            <div class="d-flex flex-wrap gap-2 mb-3 pb-3 border-bottom">
                <a class="mode-pill-btn ${currentMode == 'models' ? 'active' : ''}" href="CompareServlet?mode=models">
                    <i class="bi bi-phone"></i> Theo dòng iPhone
                </a>
                <a class="mode-pill-btn ${currentMode == 'capacities' ? 'active' : ''}" href="CompareServlet?mode=capacities">
                    <i class="bi bi-device-ssd"></i> Theo dung lượng
                </a>
                <a class="mode-pill-btn ${currentMode == 'tiers' ? 'active' : ''}" href="CompareServlet?mode=tiers">
                    <i class="bi bi-patch-check"></i> Theo cấp chất lượng
                </a>
                <a class="mode-pill-btn ${currentMode == 'battery' ? 'active' : ''}" href="CompareServlet?mode=battery">
                    <i class="bi bi-battery-charging"></i> Theo % dung lượng pin
                </a>
                <a class="mode-pill-btn ${currentMode == 'same_spec' ? 'active' : ''}" href="CompareServlet?mode=same_spec">
                    <i class="bi bi-layers"></i> Các máy cùng cấu hình
                </a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover table-cps align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Nhóm phân loại</th>
                            <th class="text-center">Số máy sẵn kho</th>
                            <th class="text-end">Giá thấp nhất</th>
                            <th class="text-end">Giá trung bình</th>
                            <th class="text-end">Giá cao nhất</th>
                            <th class="text-end">Tiết kiệm TB so với máy mới</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="st" items="${priceStats}">
                            <tr>
                                <td class="fw-bold text-dark">${st.groupLabel}</td>
                                <td class="text-center">
                                    <span class="badge bg-light text-dark border font-mono">${st.deviceCount} máy</span>
                                </td>
                                <td class="text-end font-mono text-secondary">
                                    <fmt:formatNumber value="${st.minPrice}" pattern="#,###"/> đ
                                </td>
                                <td class="text-end font-mono fw-bold" style="color: var(--cps-red);">
                                    <fmt:formatNumber value="${st.avgPrice}" pattern="#,###"/> đ
                                </td>
                                <td class="text-end font-mono text-secondary">
                                    <fmt:formatNumber value="${st.maxPrice}" pattern="#,###"/> đ
                                </td>
                                <td class="text-end">
                                    <span class="save-badge font-mono">
                                        <i class="bi bi-piggy-bank me-1"></i><fmt:formatNumber value="${st.avgSavings}" pattern="#,###"/> đ
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- KHỐI 2: BẢNG SO SÁNH KIỂM ĐỊNH CHI TIẾT GIỮA CÁC MÁY -->
        <div class="bento-card p-3 p-md-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <div>
                    <h5 class="fw-bold mb-1"><i class="bi bi-layout-split text-danger me-2"></i>So sánh thông tin kiểm định chi tiết giữa các iPhone</h5>
                    <p class="text-muted small mb-0">Đối chiếu trực tiếp thông số phần cứng, tình trạng pin và linh kiện từng mã IMEI</p>
                </div>
                <c:if test="${not empty comparedDevices}">
                    <span class="badge bg-dark rounded-pill font-mono px-3 py-2">Đang đối chiếu ${comparedDevices.size()} thiết bị</span>
                </c:if>
            </div>

            <c:if test="${empty comparedDevices}">
                <div class="text-center py-5 bg-light rounded-4 border">
                    <i class="bi bi-arrow-left-right fs-1 text-muted"></i>
                    <h6 class="fw-bold mt-3">Chưa có thiết bị nào trong danh sách đối chiếu</h6>
                    <p class="text-muted small mb-3">Hãy quay lại trang chủ và tích chọn ô "So sánh" trên các sản phẩm bạn quan tâm.</p>
                    <a href="home#catalog" class="btn btn-danger rounded-pill px-4 fw-semibold">Chọn máy từ kho</a>
                </div>
            </c:if>

            <c:if test="${not empty comparedDevices}">
                <div class="table-responsive rounded-3 border">
                    <table class="table table-bordered compare-matrix align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="sticky-col align-middle">
                                    <i class="bi bi-clipboard2-pulse text-danger me-1"></i>Tiêu chí kiểm định
                                </th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <th class="text-center device-col-header">
                                        <div class="fw-bold text-dark mb-1" style="font-size: 1rem;">
                                            ${d.modelName} ${d.capacityValue}
                                        </div>
                                        <span class="badge bg-light text-secondary border font-mono fw-normal">
                                            IMEI: ${d.imei}
                                        </span>
                                    </th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th class="sticky-col">Giá bán thực tế</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center fw-bold fs-5" style="color: var(--cps-red);">
                                        <fmt:formatNumber value="${d.price}" pattern="#,###"/> đ
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Tiết kiệm so với máy mới</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center">
                                        <span class="save-badge font-mono">
                                            Tiết kiệm <fmt:formatNumber value="${d.savingsAmount}" pattern="#,###"/> đ
                                        </span>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Điểm & Cấp độ QC</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center">
                                        <span class="qc-badge-pill font-mono ${d.qualityTier == 'GRADE_A' ? 'qc-A' : (d.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                            <i class="bi bi-patch-check-fill"></i>${d.qualityTier} • ${d.overallScore}/10 điểm
                                        </span>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Dung lượng Pin & Số lần sạc</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center">
                                        <div class="d-inline-flex align-items-center gap-2 mb-1">
                                            <strong class="font-mono fs-6">${d.batteryHealth}%</strong>
                                            <span class="text-muted small">(${d.chargeCycles} lần sạc)</span>
                                        </div>
                                        <div class="progress mx-auto" style="height: 5px; max-width: 140px;">
                                            <div class="progress-bar ${d.batteryHealth >= 90 ? 'bg-success' : 'bg-warning'}" style="width: ${d.batteryHealth}%"></div>
                                        </div>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Tình trạng linh kiện</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center">
                                        <span class="badge rounded-pill px-3 py-2 ${d.allOriginalParts ? 'bg-success bg-opacity-10 text-success border border-success border-opacity-25' : 'bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25'}">
                                            <i class="bi ${d.allOriginalParts ? 'bi-check-circle-fill' : 'bi-tools'} me-1"></i>
                                            ${d.allOriginalParts ? 'Zin nguyên bản 100%' : 'Có thay thế linh kiện chính hãng'}
                                        </span>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Ngoại hình & Bảo hành</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center fw-medium text-dark">
                                        ${d.cosmeticCondition} • <span class="text-primary fw-semibold">BH ${d.warrantyMonths} tháng</span>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th class="sticky-col">Cấu hình phần cứng</th>
                                <c:forEach var="d" items="${comparedDevices}">
                                    <td class="text-center small text-secondary fw-medium">
                                        ${d.chipset} • RAM ${d.ram} • ${d.screenSize}
                                    </td>
                                </c:forEach>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openSearchDropdown() {
            document.getElementById('searchDropdownPanel').classList.add('show');
            document.getElementById('searchBackdrop').classList.add('show');
        }

        function closeSearchDropdown() {
            document.getElementById('searchDropdownPanel').classList.remove('show');
            document.getElementById('searchBackdrop').classList.remove('show');
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeSearchDropdown();
        });
    </script>
</body>
</html>