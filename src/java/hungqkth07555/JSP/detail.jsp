<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${detail.modelName} — Hồ Sơ Kiểm Định QC</title>
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

        /* ===== 1. TOP PROMO STRIP (ĐỒNG BỘ TOÀN HỆ THỐNG) ===== */
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
            padding: 7px 11px;
            font-size: 0.79rem;
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
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .btn-header-login:hover {
            background: #fff5f5;
            color: var(--cps-red-dark);
            transform: translateY(-1px);
        }

        .header-search-wrap {
            position: relative;
            flex-grow: 1;
            max-width: 430px;
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

        /* ===== 3. BENTO CARD & SHOWCASE ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
            border: 1px solid #e5e7eb;
        }

        .device-gallery-stage {
            background: #ffffff;
            border: 1px solid #f1f5f9;
            border-radius: 16px;
            padding: 18px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }

        .gallery-img-wrap {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px;
        }

        .gallery-img-wrap img {
            max-height: 280px;
            max-width: 90%;
            object-fit: contain;
            mix-blend-mode: multiply;
            transition: transform 0.35s ease;
        }

        .gallery-img-wrap:hover img {
            transform: scale(1.04);
        }

        .qc-badge-pill {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .qc-A { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .qc-B { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .qc-C { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }

        .cert-lab-banner {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 14px;
            padding: 14px 18px;
            color: #ffffff;
        }

        .price-lg {
            color: var(--cps-red);
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.6px;
        }

        .save-cps {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
            font-size: 0.82rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
        }

        .spec-grid-2x2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 12px;
        }

        @media (max-width: 576px) {
            .spec-grid-2x2 {
                grid-template-columns: 1fr;
            }
        }

        .spec-cell {
            background: #ffffff;
            border: 1px solid #f1f5f9;
            border-radius: 10px;
            padding: 10px 12px;
        }

        .spec-lbl {
            font-size: 0.7rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            font-weight: 700;
            display: block;
            margin-bottom: 3px;
        }

        .spec-val {
            font-size: 0.86rem;
            font-weight: 700;
            color: #0f172a;
        }

        .btn-cps-primary {
            background: var(--cps-red);
            color: #ffffff;
            border: none;
            border-radius: 11px;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.2s ease;
        }

        .btn-cps-primary:hover {
            background: var(--cps-red-dark);
            color: #ffffff;
            box-shadow: 0 6px 16px rgba(215, 0, 24, 0.25);
        }

        .btn-cps-dark {
            background: #0f172a;
            color: #ffffff;
            border: none;
            border-radius: 11px;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.2s ease;
        }

        .btn-cps-dark:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .table-lab thead th {
            background-color: #f8fafc;
            color: #475569;
            font-size: 0.76rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-weight: 700;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 11px 14px;
        }

        .table-lab tbody td {
            padding: 12px 14px;
            font-size: 0.88rem;
            border-color: #f1f5f9;
        }

        .hw-spec-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 14px;
            height: 100%;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #d1d5db;
            font-size: 0.88rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--cps-red);
            box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.1);
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
            <div class="d-flex align-items-center justify-content-between gap-2">
                <!-- Logo -->
                <a href="home" class="brand-box">
                    <i class="bi bi-apple fs-4"></i>
                    <span>iPhoneQC</span>
                    <span class="brand-badge-s">LAB</span>
                </a>

                <!-- Nút Danh mục -->
                <a href="home#catalog" class="header-pill-btn d-none d-lg-inline-flex">
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

                <!-- Các nút chức năng bên phải + Đăng nhập / Tài khoản -->
                <div class="d-flex align-items-center gap-1 gap-xl-2">
                    <a href="LookupServlet" class="header-pill-btn" title="Xác minh Chứng nhận QC & Bảo hành IMEI">
                        <i class="bi bi-patch-check"></i>
                        <span class="d-none d-xl-inline">Tra cứu QC</span>
                    </a>
                    <a href="CompareServlet" class="header-pill-btn" title="So sánh giá & cấu hình QC">
                        <i class="bi bi-bar-chart-line"></i>
                        <span class="d-none d-xl-inline">So sánh</span>
                    </a>
                    <a href="WishlistServlet" class="header-pill-btn" title="Danh sách yêu thích">
                        <i class="bi bi-heart"></i>
                        <span class="d-none d-xl-inline">Yêu thích</span>
                    </a>
                    <a href="SupportServlet" class="header-pill-btn" title="Hỗ trợ & Khiếu nại">
                        <i class="bi bi-headset"></i>
                        <span class="d-none d-xxl-inline">Hỗ trợ</span>
                    </a>

                    <c:choose>
                        <c:when test="${empty sessionScope.userId}">
                            <a href="AuthServlet" class="btn-header-login ms-1">
                                <i class="bi bi-person-circle fs-6"></i>
                                <span>Đăng nhập</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown ms-1">
                                <button class="btn-header-login dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-person-check-fill"></i>
                                    <span class="d-none d-md-inline">${sessionScope.fullName}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 mt-2 p-2 small" style="min-width: 220px;">
                                    <li class="px-3 py-2 bg-light rounded-3 mb-1">
                                        <div class="fw-bold text-dark">${sessionScope.fullName}</div>
                                        <div class="text-muted font-mono" style="font-size: 0.72rem;">Vai trò: ${sessionScope.role}</div>
                                    </li>
                                    <c:if test="${sessionScope.role != 'CUSTOMER'}">
                                        <li>
                                            <a class="dropdown-item rounded-2 fw-semibold text-primary py-2" href="AdminServlet">
                                                <i class="bi bi-speedometer2 me-2"></i>Cổng quản trị nghiệp vụ
                                            </a>
                                        </li>
                                    </c:if>
                                    <li>
                                        <a class="dropdown-item rounded-2 py-2" href="WishlistServlet">
                                            <i class="bi bi-heart me-2 text-danger"></i>iPhone yêu thích & Báo hàng
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item rounded-2 py-2" href="LookupServlet">
                                            <i class="bi bi-shield-check me-2 text-success"></i>Tra cứu Bảo hành & QC
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li>
                                        <a class="dropdown-item rounded-2 text-danger fw-semibold py-2" href="AuthServlet?action=logout">
                                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <!-- 3. BREADCRUMB ĐIỀU HƯỚNG -->
    <div class="bg-white border-bottom py-2">
        <div class="container d-flex flex-wrap align-items-center justify-content-between gap-2">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item"><a href="home" class="text-decoration-none text-muted"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="home#catalog" class="text-decoration-none text-muted">Kho máy QC</a></li>
                    <li class="breadcrumb-item active fw-semibold text-dark" aria-current="page">
                        ${detail != null ? detail.modelName : 'Hồ sơ kiểm định'}
                    </li>
                </ol>
            </nav>
            <a href="home#catalog" class="btn btn-outline-secondary btn-sm rounded-pill px-3" style="font-size: 0.78rem;">
                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
            </a>
        </div>
    </div>

    <!-- 4. NỘI DUNG CHI TIẾT -->
    <main class="container my-4">

        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success rounded-4 border-0 shadow-sm d-flex align-items-center mb-4">
                <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                <div>Đã ghi nhận thông tin đánh giá / phản hồi của tài khoản <strong>${sessionScope.fullName}</strong> vào hệ thống!</div>
            </div>
        </c:if>

        <c:if test="${detail == null}">
            <div class="bento-card p-5 text-center">
                <i class="bi bi-upc-scan fs-1 text-muted"></i>
                <h5 class="mt-3 fw-bold">Không tìm thấy thiết bị với mã ID hoặc IMEI đã nhập</h5>
                <p class="text-muted small">Vui lòng kiểm tra lại 15 chữ số IMEI hoặc chọn trực tiếp thiết bị trong danh sách sẵn kho.</p>
                <a href="home" class="btn btn-cps-primary mt-2 px-4">Quay lại danh sách máy</a>
            </div>
        </c:if>

        <c:if test="${detail != null}">
            <!-- KHỐI 1: TỔNG QUAN THIẾT BỊ & CHỨNG NHẬN QC -->
            <div class="bento-card p-3 p-md-4 mb-4">
                <div class="row g-4 align-items-stretch">
                    <div class="col-lg-5">
                        <div class="device-gallery-stage">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="qc-badge-pill font-mono ${detail.qualityTier == 'GRADE_A' ? 'qc-A' : (detail.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                    <i class="bi bi-patch-check-fill"></i>${detail.qualityTier} • ${detail.overallScore}/10
                                </span>
                                <span class="badge bg-light text-dark border font-mono">${detail.originCountry}</span>
                            </div>

                            <div class="gallery-img-wrap">
                                <img src="${detail.coverImage}" alt="${detail.modelName}" onerror="this.src='image/ip16pm.jpg'">
                            </div>

                            <div class="bg-light rounded-3 p-2 text-center small text-secondary border">
                                <i class="bi bi-shield-fill-check text-success me-1"></i>
                                Cam kết máy quốc tế trọn đời • Sạch tài khoản iCloud
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7 d-flex flex-column justify-content-between">
                        <div>
                            <div class="cert-lab-banner mb-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                                <div>
                                    <span class="badge bg-info text-dark font-mono mb-1" style="font-size: 0.68rem;">
                                        <i class="bi bi-award-fill me-1"></i>CHỨNG NHẬN KIỂM ĐỊNH ĐỘC BẢN
                                    </span>
                                    <div class="fw-bold small">
                                        Mã hồ sơ: <span class="font-mono text-info">${detail.certCode}</span> • Phân hạng: <span class="text-warning">${detail.qualityTier}</span>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <span class="fs-3 fw-bolder text-info font-mono">${detail.overallScore}</span><span class="text-white-50 small">/10 điểm</span>
                                </div>
                            </div>

                            <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                                <h2 class="fw-bold mb-0" style="font-size: 1.65rem;">${detail.modelName} ${detail.capacityValue}</h2>
                                <span class="badge bg-light text-dark border fs-6 fw-semibold">${detail.colorName}</span>
                            </div>

                            <div class="d-flex flex-wrap align-items-baseline gap-3 my-2">
                                <span class="price-lg"><fmt:formatNumber value="${detail.price}" pattern="#,###"/> đ</span>
                                <c:if test="${detail.savingsAmount > 0}">
                                    <span class="text-muted text-decoration-line-through fs-6"><fmt:formatNumber value="${detail.baseNewPrice}" pattern="#,###"/> đ</span>
                                    <span class="save-cps">
                                        <i class="bi bi-piggy-bank-fill me-1"></i>Tiết kiệm <fmt:formatNumber value="${detail.savingsAmount}" pattern="#,###"/> đ
                                    </span>
                                </c:if>
                            </div>

                            <div class="spec-grid-2x2 my-3">
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-upc-scan text-danger me-1"></i>Mã IMEI độc bản</span>
                                    <span class="spec-val font-mono">${detail.imei}</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-cpu text-primary me-1"></i>Số Serial / Mã máy</span>
                                    <span class="spec-val font-mono">${detail.serialNumber} (${detail.modelNumber} - ${detail.originCountry})</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-battery-charging text-success me-1"></i>Pin thực tế (${detail.chargeCycles} lần sạc)</span>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="spec-val font-mono">${detail.batteryHealth}%</span>
                                        <div class="progress flex-grow-1" style="height: 5px; max-width: 80px;">
                                            <div class="progress-bar ${detail.batteryHealth >= 90 ? 'bg-success' : 'bg-warning'}" style="width: ${detail.batteryHealth}%"></div>
                                        </div>
                                        <span class="badge ${detail.originalBattery ? 'bg-success bg-opacity-10 text-success' : 'bg-warning bg-opacity-15 text-dark'}" style="font-size: 0.68rem;">
                                            ${detail.originalBattery ? 'Pin Zin Apple' : 'Pin đã thay'}
                                        </span>
                                    </div>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-shield-check text-info me-1"></i>Gói bảo hành áp dụng</span>
                                    <span class="spec-val">${detail.warrantyPackageName} (${detail.warrantyMonths} tháng)</span>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex flex-wrap gap-2 pt-2">
                            <a href="WishlistServlet?action=add&deviceId=${detail.deviceId}" class="btn btn-cps-primary flex-grow-1 flex-sm-grow-0">
                                <i class="bi bi-heart-fill me-1"></i> Lưu vào yêu thích
                            </a>
                            <a href="CompareServlet?ids=${detail.deviceId}" class="btn btn-cps-dark flex-grow-1 flex-sm-grow-0">
                                <i class="bi bi-arrow-left-right me-1"></i> So sánh máy này
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KHỐI 2: THÔNG SỐ KỸ THUẬT CHI TIẾT -->
            <div class="bento-card p-3 p-md-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-cpu-fill text-danger me-2"></i>Thông số kỹ thuật phần cứng</h5>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-phone text-primary me-1"></i>Màn hình hiển thị</div>
                            <div class="fw-bold text-dark">${detail.screenSize}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-motherboard text-danger me-1"></i>Vi xử lý (Chipset)</div>
                            <div class="fw-bold text-dark">${detail.chipset}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-memory text-success me-1"></i>RAM / Bộ nhớ trong</div>
                            <div class="fw-bold text-dark font-mono">${detail.ram} / ${detail.capacityValue}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-camera text-info me-1"></i>Hệ thống Camera</div>
                            <div class="fw-bold text-dark">${detail.cameraSpecs}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-battery-full text-success me-1"></i>Dung lượng Pin chuẩn</div>
                            <div class="fw-bold text-dark font-mono">${detail.batteryCapacityMah} mAh</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="hw-spec-box">
                            <div class="small text-muted fw-semibold mb-1"><i class="bi bi-lightning-charge text-warning me-1"></i>Công nghệ sạc & Bảo mật</div>
                            <div class="fw-bold text-dark">${detail.chargingTech} • ${detail.biometricsType}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KHỐI 3: LỊCH SỬ KIỂM ĐỊNH & LỊCH SỬ THAY THẾ LINH KIỆN -->
            <div class="row g-4 mb-4">
                <div class="col-lg-6">
                    <div class="bento-card p-3 p-md-4 h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-clipboard2-check-fill text-success me-2"></i>Chi tiết lịch sử kiểm định sản phẩm</h5>
                        <div class="table-responsive rounded-3 border">
                            <table class="table table-hover table-lab align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Hạng mục kiểm tra</th>
                                        <th>Kết quả</th>
                                        <th>Ghi chú kỹ thuật</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="chk" items="${detail.inspectionDetails}">
                                        <tr>
                                            <td class="fw-semibold text-dark">${chk.checkItem}</td>
                                            <td>
                                                <span class="badge rounded-pill ${chk.resultStatus == 'PASSED' ? 'bg-success bg-opacity-10 text-success border border-success border-opacity-25' : 'bg-warning bg-opacity-15 text-dark border border-warning'}">
                                                    ${chk.resultStatus}
                                                </span>
                                                <small class="d-block text-muted mt-1 font-mono">${chk.gradeValue}</small>
                                            </td>
                                            <td class="small text-secondary">${chk.notes}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="bento-card p-3 p-md-4 h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-tools text-primary me-2"></i>Lịch sử kiểm tra & thay thế linh kiện</h5>
                        <div class="table-responsive rounded-3 border">
                            <table class="table table-hover table-lab align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Linh kiện</th>
                                        <th>Trạng thái</th>
                                        <th>Khóa iCloud / SIM</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="part" items="${detail.componentChecks}">
                                        <tr>
                                            <td class="fw-semibold text-dark">${part.partName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${part.isOriginal}">
                                                        <span class="badge rounded-pill bg-success bg-opacity-10 text-success border border-success border-opacity-25">
                                                            <i class="bi bi-check-circle-fill me-1"></i>Zin nguyên bản
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge rounded-pill bg-warning bg-opacity-15 text-dark border border-warning">
                                                            Đã thay (${part.isGenuineReplaced ? 'Chính hãng' : 'Linh kiện'})
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="small">
                                                iCloud: <strong class="text-success">${part.icloudStatus}</strong><br>
                                                SIM: <strong>${part.simLockStatus}</strong>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KHỐI 4: LỊCH SỬ BIẾN ĐỘNG GIÁ -->
            <div class="bento-card p-3 p-md-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-graph-down-arrow text-danger me-2"></i>Lịch sử biến động giá thiết bị</h5>
                <div class="table-responsive rounded-3 border">
                    <table class="table table-hover table-lab align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Thời điểm cập nhật</th>
                                <th class="text-end">Giá niêm yết đề xuất</th>
                                <th class="text-end">Giá bán thực tế</th>
                                <th class="text-end">Điều chỉnh thị trường</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pl" items="${detail.priceHistory}">
                                <tr>
                                    <td class="font-mono text-secondary">${pl.changedAt}</td>
                                    <td class="text-end font-mono"><fmt:formatNumber value="${pl.suggestedSellingPrice}" pattern="#,###"/> đ</td>
                                    <td class="text-end font-mono fw-bold" style="color: var(--cps-red);"><fmt:formatNumber value="${pl.actualSellingPrice}" pattern="#,###"/> đ</td>
                                    <td class="text-end font-mono text-success fw-semibold"><fmt:formatNumber value="${pl.marketAdjustment}" pattern="#,###"/> đ</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- KHỐI 5: ĐÁNH GIÁ SẢN PHẨM & ĐỘ CHÍNH XÁC QC -->
            <div class="bento-card p-3 p-md-4 mb-4" id="reviews">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-star-fill text-warning me-2"></i>Đánh giá chất lượng sau mua & Độ chuẩn kiểm định</h5>
                    <c:if test="${not empty sessionScope.userId}">
                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2">
                            <i class="bi bi-person-check-fill me-1"></i>Đang đăng nhập: <strong>${sessionScope.fullName}</strong>
                        </span>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <form action="DetailServlet" method="post" class="bg-light p-3 p-md-4 rounded-4 border mb-4">
                            <input type="hidden" name="action" value="review">
                            <input type="hidden" name="deviceId" value="${detail.deviceId}">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Chất lượng iPhone sau khi mua</label>
                                    <select name="overallRating" class="form-select">
                                        <option value="5">5 ⭐ — Rất hài lòng</option>
                                        <option value="4">4 ⭐ — Tốt</option>
                                        <option value="3">3 ⭐ — Bình thường</option>
                                        <option value="2">2 ⭐ — Kém</option>
                                        <option value="1">1 ⭐ — Rất tệ</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Độ chính xác kết quả kiểm định QC</label>
                                    <select name="qcAccuracyRating" class="form-select">
                                        <option value="5">5 ⭐ — Chuẩn xác 100% mô tả</option>
                                        <option value="4">4 ⭐ — Khá chuẩn</option>
                                        <option value="3">3 ⭐ — Tạm ổn</option>
                                        <option value="2">2 ⭐ — Chưa khớp mô tả</option>
                                        <option value="1">1 ⭐ — Sai lệch nhiều</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Chất lượng Pin sau thời gian sử dụng</label>
                                    <select name="batteryPostUseRating" class="form-select">
                                        <option value="5">5 ⭐ — Pin cầm tốt, ổn định</option>
                                        <option value="4">4 ⭐ — Tốt</option>
                                        <option value="3">3 ⭐ — Bình thường</option>
                                        <option value="2">2 ⭐ — Hao nhanh</option>
                                        <option value="1">1 ⭐ — Chai nhanh / Sập nguồn</option>
                                    </select>
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label small fw-semibold">Nhận xét chi tiết về sản phẩm</label>
                                    <textarea name="comment" rows="2" class="form-control" required placeholder="Chia sẻ trải nghiệm thực tế của bạn dưới tên ${sessionScope.fullName}..."></textarea>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Link hình ảnh thực tế (nếu có)</label>
                                    <input type="text" name="reviewImageUrl" class="form-control mb-2" placeholder="https://...">
                                    <button type="submit" class="btn btn-cps-primary w-100 py-2">Gửi đánh giá</button>
                                </div>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-light border rounded-4 d-flex flex-wrap align-items-center justify-content-between gap-2 p-3 mb-4">
                            <div class="small text-secondary">
                                <i class="bi bi-lock-fill text-danger me-1"></i>
                                Vui lòng <strong>đăng nhập tài khoản thành viên</strong> để gửi đánh giá và hiển thị tên tài khoản của bạn.
                            </div>
                            <a href="AuthServlet" class="btn btn-cps-primary btn-sm px-3">Đăng nhập ngay</a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="rv" items="${detail.reviews}">
                    <div class="border-bottom py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <strong class="text-dark">
                                <i class="bi bi-person-circle text-danger me-1"></i>${empty rv.fullName ? 'Thành viên iPhoneQC' : rv.fullName}
                            </strong>
                            <small class="text-muted font-mono">${rv.createdAt}</small>
                        </div>
                        <div class="my-2 d-flex flex-wrap gap-1 small">
                            <span class="badge bg-warning text-dark">Máy: ${rv.overallRating}⭐</span>
                            <span class="badge bg-primary">Chuẩn QC: ${rv.qcAccuracyRating}⭐</span>
                            <span class="badge bg-success">Pin sau dùng: ${rv.batteryPostUseRating}⭐</span>
                        </div>
                        <p class="mb-2 text-dark">${rv.comment}</p>
                        <c:if test="${not empty rv.reviewImageUrl}">
                            <img src="${rv.reviewImageUrl}" class="rounded-3 border" style="max-width: 140px;">
                        </c:if>
                    </div>
                </c:forEach>
            </div>

            <!-- KHỐI 6: HỎI TÌNH TRẠNG MÁY & BÁO CÁO SAI THÔNG TIN -->
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="bento-card p-3 p-md-4 h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-chat-dots-fill text-primary me-2"></i>Gửi câu hỏi về tình trạng thiết bị</h5>
                        <c:choose>
                            <c:when test="${not empty sessionScope.userId}">
                                <form action="DetailServlet" method="post">
                                    <input type="hidden" name="action" value="question">
                                    <input type="hidden" name="deviceId" value="${detail.deviceId}">
                                    <textarea name="questionContent" rows="3" class="form-control mb-3" required placeholder="VD: Máy còn áp suất kháng nước không? Phụ kiện đi kèm gồm những gì?"></textarea>
                                    <button type="submit" class="btn btn-cps-dark">Gửi câu hỏi cho kỹ thuật viên</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="bg-light border rounded-3 p-3 small text-secondary mb-3">
                                    Bạn cần <a href="AuthServlet" class="fw-bold text-danger text-decoration-none">đăng nhập</a> để gửi câu hỏi trực tiếp cho kỹ thuật viên.
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="mt-3">
                            <c:forEach var="q" items="${detail.deviceQuestions}">
                                <div class="bg-light p-2 px-3 rounded-3 border mb-2 small d-flex justify-content-between align-items-center gap-2">
                                    <div>
                                        <strong>${empty q.fullName ? 'Khách hàng' : q.fullName}:</strong> ${q.message}
                                    </div>
                                    <span class="badge bg-secondary">${q.status}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="bento-card p-3 p-md-4 h-100">
                        <h5 class="fw-bold mb-3 text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Báo cáo thông tin sản phẩm không chính xác</h5>
                        <c:choose>
                            <c:when test="${not empty sessionScope.userId}">
                                <form action="DetailServlet" method="post">
                                    <input type="hidden" name="action" value="report">
                                    <input type="hidden" name="deviceId" value="${detail.deviceId}">
                                    <label class="form-label small fw-semibold">Loại sai lệch thông tin</label>
                                    <select name="complaintType" class="form-select mb-2">
                                        <option value="INACCURATE_SPEC">Sai thông số kỹ thuật / Mã IMEI</option>
                                        <option value="MISLEADING_QC">Kết quả kiểm định QC chưa chính xác</option>
                                    </select>
                                    <textarea name="reportContent" rows="2" class="form-control mb-3" required placeholder="Mô tả chi tiết thông tin sai lệch bạn phát hiện..."></textarea>
                                    <button type="submit" class="btn btn-cps-primary">Gửi báo cáo sai thông tin</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="bg-light border rounded-3 p-3 small text-secondary">
                                    Bạn cần <a href="AuthServlet" class="fw-bold text-danger text-decoration-none">đăng nhập</a> để gửi báo cáo kiểm chứng thông tin thiết bị.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>
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