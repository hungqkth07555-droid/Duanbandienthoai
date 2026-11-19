<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cứu Chứng nhận QC & Bảo hành IMEI — iPhoneQCStore</title>
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

        /* ===== 1. TOP PROMO STRIP ===== */
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

        .header-search-wrap {
            position: relative;
            flex-grow: 1;
            max-width: 480px;
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

        /* ===== 3. BENTO CARD, SPEC GRID & BUTTONS ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
        }

        .icon-badge-box {
            width: 40px;
            height: 40px;
            border-radius: 11px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            flex-shrink: 0;
        }

        .qc-badge-pill {
            font-size: 0.74rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .qc-A { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .qc-B { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .qc-C { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }

        .spec-grid-2x2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            background: #f9fafb;
            border: 1px solid #f1f5f9;
            border-radius: 12px;
            padding: 10px;
        }

        .spec-cell {
            background: #ffffff;
            border: 1px solid #f3f4f6;
            border-radius: 8px;
            padding: 8px 10px;
        }

        .spec-lbl {
            font-size: 0.68rem;
            color: #6b7280;
            text-transform: uppercase;
            font-weight: 600;
            display: block;
            margin-bottom: 2px;
        }

        .spec-val {
            font-size: 0.84rem;
            font-weight: 700;
            color: #111827;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #d1d5db;
            font-size: 0.88rem;
            padding: 9px 12px;
        }

        .form-control:focus {
            border-color: var(--cps-red);
            box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.1);
        }

        .btn-cps-primary {
            background: var(--cps-red);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 0.86rem;
            font-weight: 600;
            padding: 9px 18px;
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
            border-radius: 10px;
            font-size: 0.86rem;
            font-weight: 600;
            padding: 9px 18px;
        }

        .btn-cps-dark:hover {
            background: #1e293b;
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

    <!-- 2. MAIN RED HEADER -->
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
                    <a href="LookupServlet" class="header-pill-btn active">
                        <i class="bi bi-patch-check"></i>
                        <span class="d-none d-xl-inline">Tra cứu QC</span>
                    </a>
                    <a href="CompareServlet" class="header-pill-btn">
                        <i class="bi bi-bar-chart-line"></i>
                        <span class="d-none d-xl-inline">So sánh</span>
                    </a>
                    <a href="WishlistServlet" class="header-pill-btn">
                        <i class="bi bi-heart"></i>
                        <span class="d-none d-xl-inline">Yêu thích</span>
                    </a>
                    <a href="SupportServlet" class="header-pill-btn">
                        <i class="bi bi-headset"></i>
                        <span class="d-none d-xl-inline">Hỗ trợ</span>
                    </a>
                    <a href="AuthServlet" class="header-pill-btn">
                        <i class="bi bi-person-circle"></i>
                        <span class="d-none d-lg-inline">Tài khoản</span>
                    </a>
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
                    <li class="breadcrumb-item active fw-semibold text-dark" aria-current="page">Tra cứu Chứng nhận QC & Bảo hành IMEI</li>
                </ol>
            </nav>
            <span class="small text-muted"><i class="bi bi-database-check text-success me-1"></i>Dữ liệu đối soát trực tiếp từ hệ thống Lab</span>
        </div>
    </div>

    <!-- 4. NỘI DUNG CHÍNH -->
    <main class="container my-4">
        <div class="row g-4 align-items-stretch">

            <!-- CỘT 1: TRA CỨU & XÁC MINH CHỨNG NHẬN KIỂM ĐỊNH -->
            <div class="col-lg-6">
                <div class="bento-card p-3 p-md-4 h-100 d-flex flex-column">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="icon-badge-box bg-success bg-opacity-10 text-success">
                            <i class="bi bi-patch-check-fill"></i>
                        </span>
                        <div>
                            <h5 class="fw-bold mb-0">Xác minh Chứng nhận kiểm định QC</h5>
                            <small class="text-muted">Nhập mã chứng nhận trên phiếu QC (VD: <span class="font-mono text-dark">QC-2026-4491</span>)</small>
                        </div>
                    </div>

                    <form action="LookupServlet" method="get" class="d-flex gap-2 mb-4">
                        <input type="text" name="certCode" class="form-control font-mono" value="${param.certCode}" required placeholder="Nhập mã chứng nhận QC...">
                        <button type="submit" class="btn btn-cps-primary px-4 text-nowrap">
                            <i class="bi bi-search me-1"></i>Xác minh
                        </button>
                    </form>

                    <c:if test="${not empty certError}">
                        <div class="alert alert-danger rounded-3 small py-2">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>${certError}
                        </div>
                    </c:if>

                    <c:if test="${not empty certResult}">
                        <div class="p-3 rounded-4 border bg-white shadow-sm mt-auto">
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2">
                                <span class="badge ${certResult.isValid ? 'bg-success' : 'bg-danger'} font-mono px-3 py-2 rounded-pill">
                                    <i class="bi ${certResult.isValid ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                                    ${certResult.isValid ? 'CHỨNG NHẬN HỢP LỆ' : 'CHỨNG NHẬN ĐÃ THU HỒI'}
                                </span>
                                <span class="qc-badge-pill font-mono ${certResult.qualityTier == 'GRADE_A' ? 'qc-A' : (certResult.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                    ${certResult.qualityTier} • ${certResult.overallScore}/10
                                </span>
                            </div>

                            <h6 class="fw-bold mb-1" style="font-size: 1.05rem;">
                                ${certResult.modelName} ${certResult.capacity}
                                <span class="badge bg-light text-secondary border fw-medium ms-1">${certResult.color}</span>
                            </h6>
                            <div class="small text-muted font-mono mb-3">
                                IMEI: ${certResult.imei} • Serial: ${certResult.serialNumber}
                            </div>

                            <div class="spec-grid-2x2 mb-3">
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-battery-charging text-success me-1"></i>Pin thực tế</span>
                                    <span class="spec-val font-mono">${certResult.batteryHealth}% (${certResult.chargeCycles} sạc)</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-award text-danger me-1"></i>Điểm tổng thể</span>
                                    <span class="spec-val font-mono text-danger">${certResult.overallScore} / 10 điểm</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-person-badge text-primary me-1"></i>KTV Kiểm định</span>
                                    <span class="spec-val text-truncate d-block">${certResult.inspectorName}</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-calendar-check text-info me-1"></i>Ngày phát hành</span>
                                    <span class="spec-val font-mono">${certResult.issuedAt}</span>
                                </div>
                            </div>

                            <a href="DetailServlet?id=${certResult.deviceId}" class="btn btn-cps-dark w-100">
                                <i class="bi bi-file-earmark-medical me-1"></i>Xem chi tiết 30+ hạng mục kiểm tra
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${empty certResult && empty certError}">
                        <div class="bg-light rounded-4 p-4 text-center text-muted border mt-auto">
                            <i class="bi bi-qr-code-scan fs-2 d-block mb-2 text-secondary"></i>
                            <div class="small fw-semibold text-dark">Đối soát tính xác thực của phiếu kiểm định</div>
                            <div style="font-size: 0.78rem;">Kiểm tra tình trạng hiệu lực, điểm QC và kỹ thuật viên phụ trách máy.</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- CỘT 2: TRA CỨU BẢO HÀNH & ĐIỀU KIỆN BẢO HÀNH BẰNG IMEI -->
            <div class="col-lg-6">
                <div class="bento-card p-3 p-md-4 h-100 d-flex flex-column">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="icon-badge-box bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-shield-check"></i>
                        </span>
                        <div>
                            <h5 class="fw-bold mb-0">Tra cứu Bảo hành & Điều kiện áp dụng</h5>
                            <small class="text-muted">Nhập 15 chữ số IMEI (VD: <span class="font-mono text-dark">359001122334491</span>)</small>
                        </div>
                    </div>

                    <form action="LookupServlet" method="get" class="d-flex gap-2 mb-4">
                        <input type="text" name="imei" class="form-control font-mono" value="${param.imei}" required placeholder="Nhập 15 số IMEI thiết bị...">
                        <button type="submit" class="btn btn-cps-dark px-4 text-nowrap">
                            <i class="bi bi-upc-scan me-1"></i>Tra cứu
                        </button>
                    </form>

                    <c:if test="${not empty warrantyError}">
                        <div class="alert alert-danger rounded-3 small py-2">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i>${warrantyError}
                        </div>
                    </c:if>

                    <c:if test="${not empty warrantyResult}">
                        <div class="p-3 rounded-4 border bg-white shadow-sm mt-auto">
                            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2">
                                <span class="badge bg-primary font-mono px-3 py-2 rounded-pill">
                                    <i class="bi bi-shield-fill-check me-1"></i>
                                    ${warrantyResult.warrantyCode != null ? warrantyResult.warrantyCode : 'CHƯA KÍCH HOẠT'}
                                </span>
                                <span class="qc-badge-pill font-mono ${warrantyResult.qualityTier == 'GRADE_A' ? 'qc-A' : (warrantyResult.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                    ${warrantyResult.qualityTier}
                                </span>
                            </div>

                            <h6 class="fw-bold mb-1" style="font-size: 1.05rem;">
                                ${warrantyResult.modelName} ${warrantyResult.capacity}
                                <span class="badge bg-light text-secondary border fw-medium ms-1">${warrantyResult.color}</span>
                            </h6>
                            <div class="small font-mono text-muted mb-3">
                                IMEI: ${warrantyResult.imei} • Serial: ${warrantyResult.serialNumber}
                            </div>

                            <div class="spec-grid-2x2 mb-3">
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-box-seam text-primary me-1"></i>Gói bảo hành</span>
                                    <span class="spec-val">${warrantyResult.packageName} (${warrantyResult.durationMonths}T)</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-activity text-success me-1"></i>Trạng thái</span>
                                    <span class="spec-val font-mono text-success">${warrantyResult.warrantyStatus != null ? warrantyResult.warrantyStatus : 'SẴN SÀNG'}</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-calendar-event text-dark me-1"></i>Ngày kích hoạt</span>
                                    <span class="spec-val font-mono">${warrantyResult.startDate != null ? warrantyResult.startDate : 'Theo ngày mua'}</span>
                                </div>
                                <div class="spec-cell">
                                    <span class="spec-lbl"><i class="bi bi-calendar-x text-danger me-1"></i>Hạn bảo hành</span>
                                    <span class="spec-val font-mono text-danger">${warrantyResult.endDate != null ? warrantyResult.endDate : 'Chưa kích hoạt'}</span>
                                </div>
                            </div>

                            <div class="bg-light rounded-3 p-2 px-3 border small text-secondary mb-3">
                                <strong class="text-dark"><i class="bi bi-file-text me-1"></i>Điều kiện bảo hành:</strong>
                                ${not empty warrantyResult.coverageTerms ? warrantyResult.coverageTerms : 'Bảo hành phần cứng 1 đổi 1 theo tiêu chuẩn phân hạng QC của hệ thống.'}
                            </div>

                            <a href="SupportServlet" class="btn btn-cps-primary w-100">
                                <i class="bi bi-tools me-1"></i>Gửi yêu cầu bảo hành / Hỗ trợ kỹ thuật
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${empty warrantyResult && empty warrantyError}">
                        <div class="bg-light rounded-4 p-4 text-center text-muted border mt-auto">
                            <i class="bi bi-phone-vibrate fs-2 d-block mb-2 text-secondary"></i>
                            <div class="small fw-semibold text-dark">Tra cứu phiếu bảo hành điện tử theo IMEI</div>
                            <div style="font-size: 0.78rem;">Bấm <span class="font-mono text-dark">*#06#</span> trên iPhone để lấy 15 chữ số IMEI cần kiểm tra.</div>
                        </div>
                    </c:if>
                </div>
            </div>

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