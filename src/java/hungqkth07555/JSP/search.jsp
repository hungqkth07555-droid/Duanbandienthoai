<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm${not empty param.keyword ? ': '.concat(param.keyword) : ''} — iPhoneQCStore Lab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cps-red: #d70018;
            --cps-red-dark: #b80014;
            --cps-red-soft: #fff0f1;
            --bg-body: #f4f6f8;
            --text-main: #111827;
            --text-muted: #6b7280;
        }

        html { scroll-behavior: smooth; }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .font-mono { font-family: 'JetBrains Mono', monospace; }

        /* ===== 1. TOP PROMO STRIP ===== */
        .top-promo-bar {
            background-color: #0b0d12;
            color: #ffffff;
            font-size: 0.76rem;
            padding: 6px 0;
        }

        .promo-dot {
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: #38bdf8;
            margin-right: 6px;
            box-shadow: 0 0 8px #38bdf8;
        }

        /* ===== 2. MAIN RED HEADER ===== */
        .main-header {
            background: linear-gradient(180deg, #e0051e 0%, #d70018 100%);
            position: sticky;
            top: 0;
            z-index: 1055;
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
            font-size: 0.88rem;
            padding: 1px 7px;
            border-radius: 6px;
        }

        .header-pill-btn {
            background: rgba(255, 255, 255, 0.16);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 10px;
            padding: 7px 12px;
            font-size: 0.79rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            white-space: nowrap;
            cursor: pointer;
        }

        .header-pill-btn:hover, .header-pill-btn.active {
            background: #ffffff;
            color: var(--cps-red);
            border-color: #ffffff;
        }

        .filter-active-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #fde047;
            box-shadow: 0 0 6px #fde047;
            display: inline-block;
        }

        .btn-header-login {
            background: #ffffff;
            color: var(--cps-red);
            border: none;
            border-radius: 10px;
            padding: 7px 13px;
            font-size: 0.8rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
            white-space: nowrap;
        }

        .header-search-wrap {
            position: relative;
            flex-grow: 1;
            max-width: 450px;
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
            font-size: 0.86rem;
            padding: 7px 8px;
            width: 100%;
            color: #111827;
            font-weight: 500;
        }

        .header-search-form button {
            background: var(--cps-red);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 5px 12px;
            font-size: 0.8rem;
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

        .search-backdrop.show { display: block; }

        /* Dropdown Bộ lọc Danh mục */
        .category-dropdown-panel {
            position: absolute;
            top: calc(100% + 12px);
            left: 12px;
            right: 12px;
            max-width: 980px;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 22px 48px rgba(15, 23, 42, 0.28);
            padding: 20px 22px;
            display: none;
            z-index: 1070;
            border: 1px solid #e5e7eb;
            max-height: 84vh;
            overflow-y: auto;
        }

        .category-dropdown-panel.show { display: block; }

        .category-dropdown-panel .form-control,
        .category-dropdown-panel .form-select {
            font-size: 0.82rem;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            padding: 7px 10px;
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

        .search-dropdown-panel.show { display: block; }

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
        }

        .trend-item:hover { background: #f3f4f6; color: var(--cps-red); }
        .trend-item img { width: 30px; height: 30px; object-fit: contain; mix-blend-mode: multiply; }

        /* ===== 3. BREADCRUMB & SEARCH HEADER ===== */
        .breadcrumb-strip {
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            padding: 9px 0;
            font-size: 0.8rem;
        }

        .breadcrumb-strip a {
            color: #4b5563;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb-strip a:hover { color: var(--cps-red); }

        .search-result-heading {
            font-size: 1.15rem;
            font-weight: 700;
            color: #374151;
            text-align: center;
            margin: 18px 0 14px;
        }

        .search-result-heading strong {
            color: #111827;
            font-weight: 800;
        }

        /* Dải thẻ lọc nhanh (Pill tabs) */
        .tag-pills-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 14px;
        }

        .cps-tag-pill {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            color: #374151;
            border-radius: 8px;
            padding: 6px 13px;
            font-size: 0.8rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.16s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .cps-tag-pill:hover {
            border-color: var(--cps-red);
            color: var(--cps-red);
        }

        .cps-tag-pill.active {
            background: var(--cps-red-soft);
            border-color: var(--cps-red);
            color: var(--cps-red);
            font-weight: 700;
        }

        /* Thanh Sắp xếp theo */
        .sort-pills-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 18px;
        }

        .sort-pill-btn {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            color: #374151;
            border-radius: 8px;
            padding: 6px 14px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.16s ease;
        }

        .sort-pill-btn:hover {
            border-color: #9ca3af;
            color: #111827;
        }

        .sort-pill-btn.active {
            background: var(--cps-red-soft);
            border-color: var(--cps-red);
            color: var(--cps-red);
        }

        /* ===== 4. THẺ SẢN PHẨM KẾT QUẢ TÌM KIẾM (CELLPHONES STYLE) ===== */
        .search-product-card {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
            padding: 14px 14px 12px;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
        }

        .search-product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.1);
            border-color: #cbd5e1;
        }

        .discount-ribbon {
            position: absolute;
            top: 0;
            left: 0;
            background: linear-gradient(135deg, #d70018 0%, #ef4444 100%);
            color: #fff;
            font-size: 0.72rem;
            font-weight: 800;
            padding: 3px 11px 4px 10px;
            border-radius: 13px 0 11px 0;
            z-index: 3;
            box-shadow: 0 2px 6px rgba(215, 0, 24, 0.22);
        }

        .qc-top-right-tag {
            position: absolute;
            top: 8px;
            right: 8px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            font-size: 0.67rem;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 6px;
            z-index: 3;
        }

        .qc-top-right-tag.grade-a {
            background: #ecfdf5;
            color: #059669;
            border-color: #a7f3d0;
        }

        .card-img-stage {
            height: 185px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 14px;
            margin-bottom: 10px;
            text-decoration: none;
        }

        .card-img-stage img {
            max-height: 172px;
            max-width: 85%;
            object-fit: contain;
            transition: transform 0.28s ease;
        }

        .search-product-card:hover .card-img-stage img {
            transform: scale(1.05);
        }

        .card-device-title {
            font-size: 0.88rem;
            font-weight: 700;
            color: #111827;
            text-decoration: none;
            line-height: 1.38;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 2.4rem;
            margin-bottom: 6px;
        }

        .card-device-title:hover { color: var(--cps-red); }

        .price-line {
            display: flex;
            align-items: baseline;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 8px;
        }

        .price-main-red {
            color: var(--cps-red);
            font-size: 1.04rem;
            font-weight: 800;
        }

        .price-old-gray {
            color: #9ca3af;
            text-decoration: line-through;
            font-size: 0.76rem;
            font-weight: 500;
        }

        .qc-summary-box {
            background: #f3f4f6;
            border-radius: 8px;
            padding: 6px 9px;
            font-size: 0.72rem;
            color: #374151;
            line-height: 1.38;
            margin-bottom: 10px;
        }

        .card-bottom-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 8px;
            border-top: 1px solid #f1f5f9;
        }

        .badge-2h {
            background: #3b82f6;
            color: #ffffff;
            font-size: 0.68rem;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .heart-btn-blue {
            color: #2563eb;
            font-size: 1.05rem;
            text-decoration: none;
            transition: transform 0.18s, color 0.18s;
        }

        .heart-btn-blue:hover {
            color: var(--cps-red);
            transform: scale(1.15);
        }

        /* ===== 5. CỘT PHẢI: THÔNG TIN LIÊN QUAN ===== */
        .related-sidebar-card {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
        }

        .related-info-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 11px 12px;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            background: #ffffff;
            text-decoration: none;
            color: #1f2937;
            margin-bottom: 10px;
            transition: all 0.18s ease;
        }

        .related-info-item:last-child { margin-bottom: 0; }

        .related-info-item:hover {
            border-color: var(--cps-red);
            background: #fffafa;
            transform: translateX(2px);
        }

        .related-info-title {
            font-size: 0.77rem;
            font-weight: 700;
            line-height: 1.35;
            text-transform: uppercase;
            color: #111827;
        }

        .related-info-sub {
            font-size: 0.71rem;
            color: #6b7280;
            margin-top: 2px;
        }

        /* Floating dock */
        .floating-dock {
            position: fixed;
            right: 18px;
            bottom: 22px;
            z-index: 1040;
            display: flex;
            flex-direction: column;
            gap: 8px;
            align-items: flex-end;
        }

        .btn-back-top {
            background: rgba(31, 41, 55, 0.9);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 7px 14px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
        }

        .btn-float-contact {
            background: var(--cps-red);
            color: #fff;
            border-radius: 10px;
            padding: 8px 14px;
            font-size: 0.82rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            box-shadow: 0 4px 14px rgba(215, 0, 24, 0.35);
        }

        .site-footer {
            background: #ffffff;
            border-top: 1px solid #e5e7eb;
            margin-top: 48px;
            padding: 36px 0 24px;
            font-size: 0.84rem;
            color: #4b5563;
        }

        .footer-link {
            color: #4b5563;
            text-decoration: none;
            display: block;
            padding: 4px 0;
        }

        .footer-link:hover { color: var(--cps-red); }
    </style>
</head>
<body>

    <c:set var="hasAnyFilter" value="${not empty param.keyword or not empty param.imei or not empty param.budget or not empty param.usageNeed or not empty param.minPrice or not empty param.maxPrice or not empty param.capacity or not empty param.color or not empty param.qualityTier or not empty param.minBattery or not empty param.partStatus or not empty param.minWarranty or not empty param.cosmetic}" />

    <div class="search-backdrop" id="searchBackdrop" onclick="closeAllHeaderDropdowns()"></div>

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

    <!-- 2. MAIN RED HEADER -->
    <header class="main-header">
        <div class="container position-relative">
            <div class="d-flex align-items-center justify-content-between gap-2">
                <!-- Logo về Trang chủ -->
                <a href="home" class="brand-box" title="Quay về Trang chủ">
                    <i class="bi bi-apple fs-4"></i>
                    <span>iPhoneQC</span>
                    <span class="brand-badge-s">LAB</span>
                </a>

                <!-- Nút Danh mục mở Bộ lọc -->
                <button type="button" id="btnCategoryToggle" class="header-pill-btn ${hasAnyFilter ? 'active' : ''}" onclick="toggleCategoryDropdown()">
                    <i class="bi bi-grid-fill"></i>
                    <span>Danh mục</span>
                    <c:if test="${hasAnyFilter}">
                        <span class="filter-active-dot"></span>
                    </c:if>
                    <i class="bi bi-chevron-down small"></i>
                </button>

                <!-- Thanh tìm kiếm giữ nguyên từ khóa đang tìm -->
                <div class="header-search-wrap">
                    <form action="home" method="get" class="header-search-form">
                        <input type="hidden" name="search" value="1">
                        <i class="bi bi-search text-muted"></i>
                        <input type="text" id="headerSearchInput" name="keyword" value="${param.keyword}"
                               placeholder="Bạn muốn tìm dòng iPhone nào hôm nay?" autocomplete="off"
                               onfocus="openSearchDropdown()">
                        <c:if test="${not empty param.keyword}">
                            <a href="home?search=1" class="text-muted text-decoration-none px-1" title="Xóa từ khóa">
                                <i class="bi bi-x-circle-fill"></i>
                            </a>
                        </c:if>
                        <button type="submit">Tìm</button>
                    </form>

                    <div class="search-dropdown-panel" id="searchDropdownPanel">
                        <c:if test="${not empty searchHistories}">
                            <div class="mb-3 pb-2 border-bottom">
                                <div class="small fw-bold text-dark mb-2"><i class="bi bi-clock-history text-danger me-1"></i>Lịch sử tìm kiếm</div>
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="h" items="${searchHistories}">
                                        <a href="home?search=1&keyword=${h.keyword}" class="badge bg-light text-dark border text-decoration-none fw-medium px-2 py-1">
                                            ${empty h.keyword ? 'Lọc nâng cao' : h.keyword}
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <div class="small fw-bold text-dark mb-2">
                            <i class="bi bi-fire text-danger me-1"></i>Xu hướng tìm kiếm
                        </div>
                        <div class="row g-1">
                            <div class="col-6">
                                <a href="home?search=1&keyword=iPhone 17 Pro Max" class="trend-item">
                                    <img src="image/ip17pm.jpg" alt="17PM"><span>iPhone 17 Pro Max</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?search=1&keyword=iPhone 17" class="trend-item">
                                    <img src="image/ip17.jpg" alt="17"><span>iPhone 17 Lavender</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?search=1&keyword=iPhone 16 Pro Max" class="trend-item">
                                    <img src="image/ip16pm.jpg" alt="16PM"><span>iPhone 16 Pro Max</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?search=1&keyword=iPhone 16" class="trend-item">
                                    <img src="image/ip16.jpg" alt="16"><span>iPhone 16 Ultramarine</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Các nút chức năng bên phải -->
                <div class="d-flex align-items-center gap-1 gap-xl-2">
                    <a href="LookupServlet" class="header-pill-btn"><i class="bi bi-patch-check"></i><span class="d-none d-xl-inline">Tra cứu QC</span></a>
                    <a href="CompareServlet" class="header-pill-btn"><i class="bi bi-bar-chart-line"></i><span class="d-none d-xl-inline">So sánh</span></a>
                    <a href="WishlistServlet" class="header-pill-btn"><i class="bi bi-heart"></i><span class="d-none d-xl-inline">Yêu thích</span></a>
                    <a href="SupportServlet" class="header-pill-btn"><i class="bi bi-headset"></i><span class="d-none d-xxl-inline">Hỗ trợ</span></a>

                    <c:choose>
                        <c:when test="${empty sessionScope.userId}">
                            <a href="AuthServlet" class="btn-header-login ms-1">
                                <i class="bi bi-person-circle fs-6"></i><span>Đăng nhập</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown ms-1">
                                <button class="btn-header-login dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-check-fill"></i>
                                    <span class="d-none d-md-inline">${sessionScope.fullName}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 mt-2 p-2 small">
                                    <li class="px-3 py-2 bg-light rounded-3 mb-1">
                                        <div class="fw-bold text-dark">${sessionScope.fullName}</div>
                                        <div class="text-muted font-mono" style="font-size: 0.72rem;">Vai trò: ${sessionScope.role}</div>
                                    </li>
                                    <c:if test="${sessionScope.role != 'CUSTOMER'}">
                                        <li><a class="dropdown-item rounded-2 fw-semibold text-primary py-2" href="AdminServlet"><i class="bi bi-speedometer2 me-2"></i>Cổng quản trị</a></li>
                                    </c:if>
                                    <li><a class="dropdown-item rounded-2 py-2" href="WishlistServlet"><i class="bi bi-heart me-2 text-danger"></i>Yêu thích</a></li>
                                    <li><a class="dropdown-item rounded-2 text-danger fw-semibold py-2" href="AuthServlet?action=logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- BẢNG BỘ LỌC DANH MỤC THẢ XUỐNG -->
            <div class="category-dropdown-panel" id="categoryDropdownPanel">
                <div class="d-flex justify-content-between align-items-center pb-3 mb-3 border-bottom">
                    <div class="fw-bold text-dark">
                        <i class="bi bi-funnel-fill text-danger me-1"></i>Bộ lọc kiểm định QC Lab
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="home?search=1" class="cps-tag-pill text-decoration-none"><i class="bi bi-arrow-counterclockwise"></i> Xóa bộ lọc</a>
                        <button type="button" class="btn-close" onclick="closeAllHeaderDropdowns()"></button>
                    </div>
                </div>

                <form action="home" method="get">
                    <input type="hidden" name="search" value="1">
                    <input type="hidden" name="keyword" value="${param.keyword}">
                    <div class="row g-2">
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-muted mb-1">Lọc theo mã IMEI</label>
                            <input type="text" name="imei" value="${param.imei}" class="form-control font-mono" placeholder="Nhập số IMEI...">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-danger fw-semibold mb-1">Ngân sách tối đa (VNĐ)</label>
                            <input type="number" name="budget" value="${param.budget}" class="form-control" placeholder="VD: 23000000">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-danger fw-semibold mb-1">Gợi ý theo nhu cầu</label>
                            <select name="usageNeed" class="form-select">
                                <option value="">Tất cả nhu cầu</option>
                                <option value="GAMING" ${param.usageNeed == 'GAMING' ? 'selected' : ''}>Chơi game / Chip mạnh</option>
                                <option value="CAMERA" ${param.usageNeed == 'CAMERA' ? 'selected' : ''}>Chụp ảnh / Quay phim Pro</option>
                                <option value="BATTERY" ${param.usageNeed == 'BATTERY' ? 'selected' : ''}>Pin trâu / Màn hình lớn</option>
                                <option value="COMPACT" ${param.usageNeed == 'COMPACT' ? 'selected' : ''}>Nhỏ gọn / Dùng cơ bản</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-muted mb-1">Cấp độ kiểm định QC</label>
                            <select name="qualityTier" class="form-select">
                                <option value="">Tất cả phân hạng</option>
                                <option value="GRADE_A" ${param.qualityTier == 'GRADE_A' ? 'selected' : ''}>Grade A (Xuất sắc)</option>
                                <option value="GRADE_B" ${param.qualityTier == 'GRADE_B' ? 'selected' : ''}>Grade B (Tốt)</option>
                                <option value="GRADE_C" ${param.qualityTier == 'GRADE_C' ? 'selected' : ''}>Grade C (Khá)</option>
                            </select>
                        </div>

                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">Giá từ (VNĐ)</label>
                            <input type="number" name="minPrice" value="${param.minPrice}" class="form-control" placeholder="10000000">
                        </div>
                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">Giá đến (VNĐ)</label>
                            <input type="number" name="maxPrice" value="${param.maxPrice}" class="form-control" placeholder="35000000">
                        </div>
                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">Dung lượng</label>
                            <select name="capacity" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="128GB" ${param.capacity == '128GB' ? 'selected' : ''}>128GB</option>
                                <option value="256GB" ${param.capacity == '256GB' ? 'selected' : ''}>256GB</option>
                                <option value="512GB" ${param.capacity == '512GB' ? 'selected' : ''}>512GB</option>
                                <option value="1TB" ${param.capacity == '1TB' ? 'selected' : ''}>1TB</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">Màu sắc</label>
                            <select name="color" class="form-select">
                                <option value="">Tất cả màu</option>
                                <option value="Titan Sa Mạc" ${param.color == 'Titan Sa Mạc' ? 'selected' : ''}>Titan Sa Mạc</option>
                                <option value="Titan Tự Nhiên" ${param.color == 'Titan Tự Nhiên' ? 'selected' : ''}>Titan Tự Nhiên</option>
                                <option value="Xanh Ultramarine" ${param.color == 'Xanh Ultramarine' ? 'selected' : ''}>Xanh Ultramarine</option>
                                <option value="Xanh Đậm" ${param.color == 'Xanh Đậm' ? 'selected' : ''}>Xanh Đậm</option>
                                <option value="Tím Lavender" ${param.color == 'Tím Lavender' ? 'selected' : ''}>Tím Lavender</option>
                                <option value="Tím" ${param.color == 'Tím' ? 'selected' : ''}>Tím</option>
                                <option value="Trắng" ${param.color == 'Trắng' ? 'selected' : ''}>Trắng</option>
                                <option value="Đen" ${param.color == 'Đen' ? 'selected' : ''}>Đen</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">% Pin tối thiểu</label>
                            <input type="number" name="minBattery" value="${param.minBattery}" class="form-control" placeholder="VD: 90">
                        </div>
                        <div class="col-6 col-md-2">
                            <label class="form-label small text-muted mb-1">Linh kiện</label>
                            <select name="partStatus" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="ORIGINAL" ${param.partStatus == 'ORIGINAL' ? 'selected' : ''}>Zin nguyên bản</option>
                                <option value="REPLACED" ${param.partStatus == 'REPLACED' ? 'selected' : ''}>Thay chính hãng</option>
                            </select>
                        </div>

                        <div class="col-6 col-md-4">
                            <label class="form-label small text-muted mb-1">Thời hạn bảo hành</label>
                            <select name="minWarranty" class="form-select">
                                <option value="">Tất cả gói bảo hành</option>
                                <option value="3" ${param.minWarranty == '3' ? 'selected' : ''}>Từ 3 tháng trở lên</option>
                                <option value="6" ${param.minWarranty == '6' ? 'selected' : ''}>Từ 6 tháng trở lên</option>
                                <option value="12" ${param.minWarranty == '12' ? 'selected' : ''}>12 tháng (1 đổi 1)</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-4">
                            <label class="form-label small text-muted mb-1">Tình trạng ngoại hình</label>
                            <select name="cosmetic" class="form-select">
                                <option value="">Tất cả ngoại hình</option>
                                <option value="99%" ${param.cosmetic == '99%' ? 'selected' : ''}>Đẹp 99% (Như mới)</option>
                                <option value="97%" ${param.cosmetic == '97%' ? 'selected' : ''}>Đẹp 97% (Xước dăm nhẹ)</option>
                                <option value="95%" ${param.cosmetic == '95%' ? 'selected' : ''}>Trầy nhẹ 95%</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-danger fw-bold w-100 rounded-3 py-2">
                                <i class="bi bi-check2-circle me-1"></i>Áp dụng bộ lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </header>

    <!-- 3. BREADCRUMB ĐIỀU HƯỚNG (GIỐNG CELLPHONES) -->
    <div class="breadcrumb-strip">
        <div class="container d-flex align-items-center gap-2 text-muted">
            <a href="home"><i class="bi bi-house-door-fill text-danger me-1"></i>Trang chủ</a>
            <span>/</span>
            <c:choose>
                <c:when test="${not empty param.keyword}">
                    <span>Kết quả tìm kiếm cho: <strong class="text-dark">'${param.keyword}'</strong></span>
                </c:when>
                <c:otherwise>
                    <span class="text-dark fw-semibold">Danh mục iPhone kiểm định QC</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 4. NỘI DUNG TRANG KẾT QUẢ TÌM KIẾM & LỌC -->
    <main class="container pb-4">
        <!-- Dòng tiêu đề tổng số kết quả -->
        <h1 class="search-result-heading">
            <c:choose>
                <c:when test="${not empty param.keyword}">
                    Tìm thấy <strong>${products.size()}</strong> sản phẩm cho từ khoá <strong>'${param.keyword}'</strong>
                </c:when>
                <c:otherwise>
                    Tìm thấy <strong>${products.size()}</strong> thiết bị đạt chuẩn kiểm định QC
                </c:otherwise>
            </c:choose>
        </h1>

        <!-- Dải thẻ lọc nhanh theo dòng máy & tiêu chí QC -->
        <div class="tag-pills-bar">
            <a href="home?search=1" class="cps-tag-pill ${not hasAnyFilter ? 'active' : ''}">Tất cả</a>
            <a href="home?search=1&keyword=iPhone 17" class="cps-tag-pill ${param.keyword == 'iPhone 17' ? 'active' : ''}">iPhone 17 Series</a>
            <a href="home?search=1&keyword=iPhone 16" class="cps-tag-pill ${param.keyword == 'iPhone 16' ? 'active' : ''}">iPhone 16 Series</a>
            <a href="home?search=1&keyword=iPhone 15" class="cps-tag-pill ${param.keyword == 'iPhone 15' ? 'active' : ''}">iPhone 15 Series</a>
            <a href="home?search=1&keyword=iPhone 14" class="cps-tag-pill ${param.keyword == 'iPhone 14' ? 'active' : ''}">iPhone 14 Series</a>
            <a href="home?search=1&qualityTier=GRADE_A" class="cps-tag-pill ${param.qualityTier == 'GRADE_A' ? 'active' : ''}">Grade A (Xuất sắc)</a>
            <a href="home?search=1&minBattery=95" class="cps-tag-pill ${param.minBattery == '95' ? 'active' : ''}">Pin ≥ 95%</a>
            <a href="home?search=1&partStatus=ORIGINAL" class="cps-tag-pill ${param.partStatus == 'ORIGINAL' ? 'active' : ''}">Zin nguyên bản 100%</a>
            <a href="home?search=1&budget=23000000" class="cps-tag-pill ${param.budget == '23000000' ? 'active' : ''}">Dưới 23 triệu</a>
        </div>

        <!-- Hàng Sắp xếp theo (giữ nguyên toàn bộ tham số tìm kiếm/lọc hiện tại) -->
        <div class="mb-2 fw-bold text-dark" style="font-size: 0.92rem;">Sắp xếp theo</div>
        <div class="sort-pills-row">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <a href="javascript:void(0)" onclick="applySort('')" class="sort-pill-btn ${empty param.sort ? 'active' : ''}">
                    <i class="bi bi-stars"></i> Liên quan
                </a>
                <a href="javascript:void(0)" onclick="applySort('price_desc')" class="sort-pill-btn ${param.sort == 'price_desc' ? 'active' : ''}">
                    <i class="bi bi-sort-down"></i> Giá cao
                </a>
                <a href="javascript:void(0)" onclick="applySort('price_asc')" class="sort-pill-btn ${param.sort == 'price_asc' ? 'active' : ''}">
                    <i class="bi bi-sort-up"></i> Giá thấp
                </a>
                <a href="javascript:void(0)" onclick="applySort('score_desc')" class="sort-pill-btn ${param.sort == 'score_desc' ? 'active' : ''}">
                    <i class="bi bi-patch-check"></i> Điểm QC cao
                </a>
                <button type="button" class="sort-pill-btn" onclick="toggleCategoryDropdown()">
                    <i class="bi bi-funnel text-danger"></i> Lọc nâng cao
                </button>
            </div>

            <button type="submit" form="searchCompareForm" class="btn btn-dark btn-sm rounded-pill px-3 fw-semibold">
                <i class="bi bi-arrow-left-right me-1"></i>So sánh máy đã chọn
            </button>
        </div>

        <!-- BỐ CỤC 2 CỘT: TRÁI LÀ LƯỚI SẢN PHẨM, PHẢI LÀ THÔNG TIN LIÊN QUAN -->
        <div class="row g-3 g-lg-4 align-items-start">
            <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM KẾT QUẢ -->
            <div class="col-lg-9">
                <c:if test="${empty products}">
                    <div class="bg-white rounded-4 border p-5 text-center shadow-sm">
                        <i class="bi bi-search fs-1 text-muted"></i>
                        <h5 class="mt-3 fw-bold">Không tìm thấy thiết bị phù hợp</h5>
                        <p class="text-muted small">Thử tìm với từ khóa khác hoặc đăng ký nhận thông báo ngay khi máy về kho Lab.</p>
                        <div class="d-flex justify-content-center gap-2">
                            <a href="home?search=1" class="btn btn-outline-secondary rounded-pill px-4">Xem tất cả máy</a>
                            <a href="WishlistServlet#notify" class="btn btn-danger rounded-pill px-4">Đăng ký báo có hàng</a>
                        </div>
                    </div>
                </c:if>

                <form id="searchCompareForm" action="CompareServlet" method="get">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
                        <c:forEach var="p" items="${products}">
                            <c:set var="origPrice" value="${p.price + (p.savingsAmount > 0 ? p.savingsAmount : p.price * 0.15)}" />
                            <c:set var="discPct" value="${((origPrice - p.price) * 100) / origPrice}" />

                            <div class="col">
                                <article class="search-product-card">
                                    <!-- Ruy băng giảm giá đỏ góc trái -->
                                    <div class="discount-ribbon">
                                        Giảm <fmt:formatNumber value="${discPct}" maxFractionDigits="0"/>%
                                    </div>

                                    <!-- Nhãn hạng kiểm định góc phải -->
                                    <div class="qc-top-right-tag font-mono ${p.qualityTier == 'GRADE_A' ? 'grade-a' : ''}">
                                        ${p.qualityTier} • ${p.overallScore}/10
                                    </div>

                                    <!-- Ảnh máy -->
                                    <a href="DetailServlet?id=${p.deviceId}" class="card-img-stage">
                                        <img src="${p.coverImage}" alt="${p.modelName}" onerror="this.src='image/ip16pm.jpg'">
                                    </a>

                                    <div>
                                        <!-- Tên máy + dung lượng + màu -->
                                        <a href="DetailServlet?id=${p.deviceId}" class="card-device-title" title="${p.modelName} ${p.capacityValue} (${p.colorName})">
                                            ${p.modelName} ${p.capacityValue} (${p.colorName}) - ${p.originCountry}
                                        </a>

                                        <!-- Giá bán & giá gốc gạch ngang -->
                                        <div class="price-line">
                                            <span class="price-main-red"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</span>
                                            <span class="price-old-gray"><fmt:formatNumber value="${origPrice}" pattern="#,###"/>đ</span>
                                        </div>

                                        <!-- Khung thông số QC & ưu đãi xám nhạt -->
                                        <div class="qc-summary-box">
                                            Pin <strong>${p.batteryHealth}%</strong> (${p.chargeCycles} sạc) •
                                            <strong>${p.allOriginalParts ? 'Zin 100%' : 'Thay chính hãng'}</strong> •
                                            BH ${p.warrantyMonths}T (${p.cosmeticCondition})
                                        </div>

                                        <!-- Thanh dưới cùng: Giao 2 Giờ + So sánh + Yêu thích -->
                                        <div class="card-bottom-actions">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="badge-2h"><i class="bi bi-truck"></i> 2 Giờ</span>
                                                <label class="form-check m-0 d-flex align-items-center gap-1 small text-muted" style="cursor:pointer; font-size:0.74rem;" for="scmp_${p.deviceId}">
                                                    <input class="form-check-input m-0" type="checkbox" name="ids" value="${p.deviceId}" id="scmp_${p.deviceId}">
                                                    <span>So sánh</span>
                                                </label>
                                            </div>
                                            <a href="WishlistServlet?action=add&deviceId=${p.deviceId}" class="heart-btn-blue" title="Thêm vào yêu thích">
                                                <i class="bi bi-heart"></i>
                                            </a>
                                        </div>
                                    </div>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                </form>
            </div>

            <!-- CỘT PHẢI: THÔNG TIN LIÊN QUAN (GIỐNG CELLPHONES) -->
            <aside class="col-lg-3">
                <div class="related-sidebar-card mb-3">
                    <h6 class="fw-bold text-dark mb-3" style="font-size: 0.96rem;">Thông tin liên quan</h6>

                    <a href="SupportServlet" class="related-info-item">
                        <div>
                            <div class="related-info-title">TRỢ GIÁ ĐẾN 5 TRIỆU KHI THU CŨ LÊN ĐỜI IPHONE</div>
                            <div class="related-info-sub">Định giá minh bạch 32 bước Lab</div>
                        </div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>

                    <a href="home?search=1&qualityTier=GRADE_A" class="related-info-item">
                        <div>
                            <div class="related-info-title">GIẢM THÊM 500K CHO S-STUDENT KHI MUA GRADE A</div>
                            <div class="related-info-sub">Áp dụng cho học sinh, sinh viên</div>
                        </div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>

                    <a href="LookupServlet" class="related-info-item">
                        <div>
                            <div class="related-info-title">XÁC MINH CHỨNG NHẬN QC & BẢO HÀNH IMEI</div>
                            <div class="related-info-sub">Tra cứu lịch sử linh kiện từng máy</div>
                        </div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>

                    <a href="WishlistServlet#notify" class="related-info-item">
                        <div>
                            <div class="related-info-title">ĐĂNG KÝ NHẬN TIN KHI CÓ MÁY ĐÚNG CẤU HÌNH</div>
                            <div class="related-info-sub">Báo ngay qua hệ thống khi nhập kho</div>
                        </div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                </div>

                <!-- Tra cứu nhanh IMEI -->
                <div class="related-sidebar-card">
                    <div class="fw-bold small mb-2"><i class="bi bi-upc-scan text-danger me-1"></i>Tra cứu hồ sơ IMEI</div>
                    <form action="DetailServlet" method="get" class="d-flex gap-1">
                        <input type="text" name="imei" class="form-control form-control-sm font-mono" placeholder="VD: 359001122334401" required>
                        <button type="submit" class="btn btn-danger btn-sm fw-bold px-3">Check</button>
                    </form>
                </div>
            </aside>
        </div>
    </main>

    <!-- CỤM NÚT NỔI GÓC DƯỚI PHẢI -->
    <div class="floating-dock">
        <button type="button" class="btn-back-top" onclick="window.scrollTo({top: 0, behavior: 'smooth'})">
            <span>Lên đầu</span> <i class="bi bi-chevron-double-up"></i>
        </button>
        <a href="SupportServlet" class="btn-float-contact">
            <span>Liên hệ</span> <i class="bi bi-headset"></i>
        </a>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="container">
            <div class="pt-2 d-flex flex-wrap justify-content-between align-items-center small text-muted">
                <span>© 2026 iPhoneQCStore Lab. Hệ thống iPhone cũ chuẩn kiểm định 32 bước.</span>
                <a href="home" class="footer-link fw-semibold text-danger">← Quay lại Trang chủ</a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleCategoryDropdown() {
            const catPanel = document.getElementById('categoryDropdownPanel');
            const searchPanel = document.getElementById('searchDropdownPanel');
            const backdrop = document.getElementById('searchBackdrop');
            const willOpen = !catPanel.classList.contains('show');
            if (searchPanel) searchPanel.classList.remove('show');
            catPanel.classList.toggle('show', willOpen);
            backdrop.classList.toggle('show', willOpen);
        }

        function openSearchDropdown() {
            const catPanel = document.getElementById('categoryDropdownPanel');
            if (catPanel) catPanel.classList.remove('show');
            document.getElementById('searchDropdownPanel').classList.add('show');
            document.getElementById('searchBackdrop').classList.add('show');
        }

        function closeAllHeaderDropdowns() {
            const catPanel = document.getElementById('categoryDropdownPanel');
            const searchPanel = document.getElementById('searchDropdownPanel');
            const backdrop = document.getElementById('searchBackdrop');
            if (catPanel) catPanel.classList.remove('show');
            if (searchPanel) searchPanel.classList.remove('show');
            if (backdrop) backdrop.classList.remove('show');
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeAllHeaderDropdowns();
        });

        /* Giữ nguyên toàn bộ từ khóa & bộ lọc hiện tại khi bấm Sắp xếp */
        function applySort(sortVal) {
            const url = new URL(window.location.href);
            url.searchParams.set('search', '1');
            if (sortVal) {
                url.searchParams.set('sort', sortVal);
            } else {
                url.searchParams.delete('sort');
            }
            window.location.href = url.toString();
        }
    </script>
</body>
</html>