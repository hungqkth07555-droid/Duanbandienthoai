<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách yêu thích & Thông báo có hàng — iPhoneQCStore</title>
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

        /* ===== 3. BENTO CARD, BADGES & BUTTONS ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
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

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #d1d5db;
            font-size: 0.88rem;
            padding: 9px 12px;
        }

        .form-control:focus, .form-select:focus {
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
            font-size: 0.82rem;
            font-weight: 600;
            padding: 6px 14px;
            transition: all 0.2s ease;
        }

        .btn-cps-dark:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .btn-cps-outline {
            border: 1.5px solid var(--cps-red);
            color: var(--cps-red);
            background: #ffffff;
            border-radius: 10px;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 5px 13px;
            transition: all 0.2s;
        }

        .btn-cps-outline:hover {
            background: var(--cps-red);
            color: #ffffff;
        }

        /* ===== 4. BẢNG DỮ LIỆU LAB ===== */
        .table-lab thead th {
            background-color: #f8fafc;
            color: #475569;
            font-size: 0.76rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-weight: 700;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 12px 14px;
        }

        .table-lab tbody td {
            padding: 13px 14px;
            font-size: 0.88rem;
            border-color: #f1f5f9;
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

    <!-- 2. MAIN RED HEADER (ĐỒNG BỘ TOÀN HỆ THỐNG) -->
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
                    <a href="CompareServlet" class="header-pill-btn">
                        <i class="bi bi-bar-chart-line"></i>
                        <span class="d-none d-xl-inline">So sánh QC</span>
                    </a>
                    <a href="WishlistServlet" class="header-pill-btn active">
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
        <div class="container d-flex flex-wrap align-items-center justify-content-between gap-2">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 small">
                    <li class="breadcrumb-item"><a href="home" class="text-decoration-none text-muted"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active fw-semibold text-dark" aria-current="page">Yêu thích & Thông báo có hàng</li>
                </ol>
            </nav>
            <a href="home#catalog" class="btn btn-cps-outline">
                <i class="bi bi-plus-lg me-1"></i>Khám phá thêm máy
            </a>
        </div>
    </div>

    <!-- 4. NỘI DUNG CHÍNH -->
    <main class="container my-4">

        <!-- KHỐI 1: DANH SÁCH IPHONE YÊU THÍCH -->
        <div class="bento-card p-3 p-md-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <div class="d-flex align-items-center gap-2">
                    <span class="icon-badge-box bg-danger bg-opacity-10 text-danger">
                        <i class="bi bi-heart-fill"></i>
                    </span>
                    <div>
                        <h5 class="fw-bold mb-0">Danh sách iPhone yêu thích</h5>
                        <small class="text-muted">Lưu trữ các mã IMEI bạn đang theo dõi để tiện đối chiếu và đặt mua</small>
                    </div>
                </div>
                <span class="badge bg-dark rounded-pill font-mono px-3 py-2">${wishlist.size()} máy</span>
            </div>

            <div class="table-responsive rounded-3 border">
                <table class="table table-hover table-lab align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Thiết bị</th>
                            <th>Mã IMEI</th>
                            <th>Điểm QC & Pin thực tế</th>
                            <th class="text-end">Giá bán</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="w" items="${wishlist}">
                            <tr>
                                <td>
                                    <span class="fw-bold text-dark">${w.modelName} ${w.capacityValue}</span>
                                    <span class="badge bg-light text-secondary border ms-1">${w.colorName}</span>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border font-mono">${w.imei}</span>
                                </td>
                                <td>
                                    <div class="d-flex flex-wrap align-items-center gap-2">
                                        <span class="qc-badge-pill font-mono ${w.qualityTier == 'GRADE_A' ? 'qc-A' : (w.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                            <i class="bi bi-patch-check-fill"></i>${w.qualityTier} (${w.overallScore}/10)
                                        </span>
                                        <span class="small fw-semibold text-dark font-mono">
                                            <i class="bi bi-battery-charging text-success me-1"></i>Pin ${w.batteryHealth}%
                                        </span>
                                    </div>
                                </td>
                                <td class="text-end fw-bold fs-6" style="color: var(--cps-red);">
                                    <fmt:formatNumber value="${w.price}" pattern="#,###"/> đ
                                </td>
                                <td class="text-end text-nowrap">
                                    <a href="DetailServlet?id=${w.deviceId}" class="btn btn-cps-dark me-1">
                                        <i class="bi bi-file-earmark-medical me-1"></i>Xem hồ sơ QC
                                    </a>
                                    <a href="WishlistServlet?action=remove&deviceId=${w.deviceId}" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty wishlist}">
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <i class="bi bi-heart fs-2 text-muted d-block mb-2"></i>
                                    <div class="fw-semibold text-dark">Bạn chưa lưu chiếc iPhone nào vào danh sách yêu thích</div>
                                    <p class="text-muted small mb-3">Hãy chọn biểu tượng trái tim trên các sản phẩm tại kho máy để lưu lại tại đây.</p>
                                    <a href="home#catalog" class="btn btn-cps-primary btn-sm px-4">Xem danh sách máy</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- KHỐI 2: ĐĂNG KÝ NHẬN THÔNG BÁO KHI CÓ HÀNG -->
        <div class="bento-card p-3 p-md-4" id="notify">
            <div class="d-flex align-items-center gap-2 mb-3">
                <span class="icon-badge-box bg-primary bg-opacity-10 text-primary">
                    <i class="bi bi-bell-fill"></i>
                </span>
                <div>
                    <h5 class="fw-bold mb-0">Đăng ký nhận thông báo khi iPhone mong muốn có hàng</h5>
                    <small class="text-muted">Hệ thống tự động gửi cảnh báo ngay khi có thiết bị vượt qua kiểm định QC khớp với cấu hình bạn chọn</small>
                </div>
            </div>

            <form action="WishlistServlet" method="post" class="bg-light p-3 p-md-4 rounded-4 border mb-4">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold">Chọn phiên bản iPhone mong muốn</label>
                        <select name="variantId" class="form-select" required>
                            <c:forEach var="v" items="${variants}">
                                <option value="${v.variantId}">${v.label}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Cấp độ chất lượng</label>
                        <select name="preferredTier" class="form-select">
                            <option value="GRADE_A">Phân hạng Grade A</option>
                            <option value="GRADE_B">Phân hạng Grade B</option>
                            <option value="GRADE_C">Phân hạng Grade C</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-cps-primary w-100">
                            <i class="bi bi-bell-plus-fill me-1"></i>Đăng ký nhận tin
                        </button>
                    </div>
                </div>
            </form>

            <div class="d-flex justify-content-between align-items-center mb-2">
                <h6 class="fw-bold mb-0"><i class="bi bi-list-check text-danger me-1"></i>Danh sách phiên bản bạn đang theo dõi</h6>
                <span class="small text-muted font-mono">${notifications.size()} đăng ký</span>
            </div>

            <div class="table-responsive rounded-3 border">
                <table class="table table-hover table-lab align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Dòng máy</th>
                            <th>Dung lượng</th>
                            <th>Màu sắc</th>
                            <th>Hạng mong muốn</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="n" items="${notifications}">
                            <tr>
                                <td class="fw-bold text-dark">${n.modelName}</td>
                                <td class="font-mono">${n.capacity}</td>
                                <td><span class="badge bg-light text-dark border">${n.color}</span></td>
                                <td>
                                    <span class="qc-badge-pill font-mono ${n.tier == 'GRADE_A' ? 'qc-A' : (n.tier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                        ${n.tier}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge rounded-pill bg-warning bg-opacity-15 text-dark border border-warning">
                                        <i class="bi bi-hourglass-split me-1"></i>${n.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty notifications}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">Bạn chưa đăng ký theo dõi phiên bản iPhone nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
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