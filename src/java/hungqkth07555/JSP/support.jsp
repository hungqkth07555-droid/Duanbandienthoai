<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tư vấn, Hỗ trợ kỹ thuật & Khiếu nại — iPhoneQCStore</title>
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

        /* ===== 3. BENTO CARD & FORM ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
            border: 1px solid #e5e7eb;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #d1d5db;
            font-size: 0.88rem;
            padding: 8px 12px;
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
            font-size: 0.86rem;
            font-weight: 600;
            padding: 9px 18px;
            transition: all 0.2s ease;
        }

        .btn-cps-dark:hover {
            background: #1e293b;
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
            padding: 12px 14px;
            font-size: 0.88rem;
            border-color: #f1f5f9;
        }

        .icon-badge-box {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
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
                    <a href="WishlistServlet" class="header-pill-btn">
                        <i class="bi bi-heart"></i>
                        <span class="d-none d-xl-inline">Yêu thích</span>
                    </a>
                    <a href="SupportServlet" class="header-pill-btn active">
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
                    <li class="breadcrumb-item active fw-semibold text-dark" aria-current="page">Tư vấn, Hỗ trợ kỹ thuật & Khiếu nại</li>
                </ol>
            </nav>
            <span class="small text-muted"><i class="bi bi-clock text-danger me-1"></i>Hỗ trợ kỹ thuật trực tuyến 08:00 – 22:00</span>
        </div>
    </div>

    <!-- 4. NỘI DUNG CHÍNH -->
    <main class="container my-4">

        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success rounded-4 border-0 shadow-sm d-flex align-items-center mb-4">
                <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                <div>Yêu cầu của bạn đã được cập nhật thành công!</div>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning rounded-4 border-0 shadow-sm d-flex align-items-center mb-4">
                <i class="bi bi-trash-fill fs-5 me-2"></i>
                <div>Đã xóa bản ghi khỏi cơ sở dữ liệu!</div>
            </div>
        </c:if>

        <!-- KHỐI 1: HAI FORM GỬI YÊU CẦU TƯ VẤN & KHIẾU NẠI -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="bento-card p-3 p-md-4 h-100 d-flex flex-column">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="icon-badge-box bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-headset"></i>
                        </span>
                        <div>
                            <h5 class="fw-bold mb-0">Gửi yêu cầu Tư vấn / Hỗ trợ kỹ thuật</h5>
                            <small class="text-muted">Đội ngũ kỹ thuật viên iPhoneQC Lab phản hồi trực tiếp</small>
                        </div>
                    </div>

                    <form action="SupportServlet" method="post" class="d-flex flex-column flex-grow-1">
                        <input type="hidden" name="action" value="createTicket">
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Loại yêu cầu</label>
                            <select name="supportType" class="form-select">
                                <option value="CONSULT">Tư vấn chọn mua sản phẩm</option>
                                <option value="TECHNICAL">Hỗ trợ kỹ thuật / Kiểm tra máy</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Tiêu đề</label>
                            <input type="text" name="subject" class="form-control" required placeholder="VD: Tư vấn chọn iPhone 16 Pro Max tầm 26 triệu...">
                        </div>
                        <div class="mb-3 flex-grow-1">
                            <label class="form-label small fw-semibold">Nội dung chi tiết</label>
                            <textarea name="message" rows="3" class="form-control" required placeholder="Mô tả nhu cầu sử dụng, ngân sách hoặc tình trạng thiết bị cần kiểm tra..."></textarea>
                        </div>
                        <div>
                            <button type="submit" class="btn btn-cps-dark px-4">
                                <i class="bi bi-send-fill me-1"></i>Gửi yêu cầu hỗ trợ
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="bento-card p-3 p-md-4 h-100 d-flex flex-column">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="icon-badge-box bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-megaphone-fill"></i>
                        </span>
                        <div>
                            <h5 class="fw-bold mb-0 text-danger">Tiếp nhận khiếu nại khách hàng</h5>
                            <small class="text-muted">Cam kết đối soát minh bạch hồ sơ QC & bảo hành</small>
                        </div>
                    </div>

                    <form action="SupportServlet" method="post" class="d-flex flex-column flex-grow-1">
                        <input type="hidden" name="action" value="createComplaint">
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Phân loại khiếu nại</label>
                            <select name="complaintType" class="form-select">
                                <option value="SERVICE">Khiếu nại dịch vụ / Bảo hành</option>
                                <option value="INACCURATE_SPEC">Thông tin sản phẩm không chính xác</option>
                                <option value="MISLEADING_QC">Sai lệch kết quả kiểm định QC</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">ID Thiết bị liên quan (không bắt buộc)</label>
                            <input type="number" name="deviceId" class="form-control font-mono" placeholder="VD: 1">
                        </div>
                        <div class="mb-3 flex-grow-1">
                            <label class="form-label small fw-semibold">Nội dung khiếu nại</label>
                            <textarea name="content" rows="3" class="form-control" required placeholder="Nêu rõ sự cố gặp phải hoặc thông số kiểm định chưa trùng khớp..."></textarea>
                        </div>
                        <div>
                            <button type="submit" class="btn btn-cps-primary px-4">
                                <i class="bi bi-exclamation-circle-fill me-1"></i>Gửi khiếu nại
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- KHỐI 2: LỊCH SỬ YÊU CẦU HỖ TRỢ -->
        <div class="bento-card p-3 p-md-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <div>
                    <h5 class="fw-bold mb-0"><i class="bi bi-clock-history text-primary me-2"></i>Tra cứu lịch sử yêu cầu hỗ trợ & tư vấn</h5>
                    <small class="text-muted">Danh sách ticket kỹ thuật và tư vấn mua hàng đã ghi nhận</small>
                </div>
                <span class="badge bg-dark rounded-pill font-mono px-3 py-2">${tickets.size()} ticket</span>
            </div>

            <div class="table-responsive rounded-3 border">
                <table class="table table-hover table-lab align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Mã Ticket</th>
                            <th>Phân loại</th>
                            <th>Tiêu đề</th>
                            <th>Nội dung</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-end">Quản lý</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${tickets}">
                            <tr>
                                <td class="font-mono fw-bold text-dark">#${t.ticketId}</td>
                                <td>
                                    <span class="badge rounded-pill ${t.supportType == 'CONSULT' ? 'bg-info bg-opacity-15 text-dark border border-info border-opacity-50' : 'bg-secondary bg-opacity-10 text-dark border'}">
                                        ${t.supportType == 'CONSULT' ? 'Tư vấn' : 'Kỹ thuật'}
                                    </span>
                                </td>
                                <td class="fw-semibold text-dark">${t.subject}</td>
                                <td class="small text-secondary">${t.message}</td>
                                <td>
                                    <span class="badge rounded-pill bg-warning bg-opacity-15 text-dark border border-warning">
                                        ${t.status}
                                    </span>
                                </td>
                                <td class="small text-muted font-mono">${t.createdAt}</td>
                                <td class="text-end">
                                    <a href="SupportServlet?action=deleteTicket&ticketId=${t.ticketId}"
                                       onclick="return confirm('Bạn có chắc muốn xóa Ticket #${t.ticketId} khỏi CSDL?');"
                                       class="btn btn-sm btn-outline-danger rounded-3">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty tickets}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có yêu cầu hỗ trợ nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- KHỐI 3: DANH SÁCH & PHẢN HỒI KHIẾU NẠI -->
        <div class="bento-card p-3 p-md-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <div>
                    <h5 class="fw-bold mb-0"><i class="bi bi-shield-exclamation text-danger me-2"></i>Danh sách khiếu nại & Phản hồi xử lý</h5>
                    <small class="text-muted">Theo dõi tiến độ xử lý và cập nhật phản hồi giải quyết khiếu nại</small>
                </div>
                <span class="badge bg-danger rounded-pill font-mono px-3 py-2">${complaints.size()} hồ sơ</span>
            </div>

            <div class="table-responsive rounded-3 border">
                <table class="table table-hover table-lab align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Mã KN</th>
                            <th>Loại</th>
                            <th>Nội dung khiếu nại</th>
                            <th>Trạng thái</th>
                            <th>Phản hồi giải quyết</th>
                            <th class="text-end">Quản lý</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${complaints}">
                            <tr>
                                <td class="font-mono fw-bold text-dark">#${c.complaintId}</td>
                                <td><span class="badge bg-light text-dark border font-mono">${c.complaintType}</span></td>
                                <td class="text-dark">${c.content}</td>
                                <td>
                                    <span class="badge rounded-pill ${c.status == 'RESOLVED' ? 'bg-success bg-opacity-10 text-success border border-success border-opacity-25' : 'bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25'}">
                                        ${c.status}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.resolutionNote}">
                                            <span class="text-success fw-semibold small"><i class="bi bi-check2-all me-1"></i>${c.resolutionNote}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="SupportServlet" method="post" class="d-flex gap-2">
                                                <input type="hidden" name="action" value="replyComplaint">
                                                <input type="hidden" name="complaintId" value="${c.complaintId}">
                                                <input type="text" name="resolutionNote" class="form-control form-control-sm" placeholder="Nhập phản hồi xử lý khiếu nại..." required>
                                                <button type="submit" class="btn btn-sm btn-cps-dark text-nowrap">Phản hồi</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <a href="SupportServlet?action=deleteComplaint&complaintId=${c.complaintId}"
                                       onclick="return confirm('Xóa khiếu nại #${c.complaintId} khỏi CSDL?');"
                                       class="btn btn-sm btn-outline-danger rounded-3">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty complaints}">
                            <tr><td colspan="6" class="text-center text-muted py-4">Chưa có khiếu nại nào.</td></tr>
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