<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản & Phân quyền hệ thống — iPhoneQCStore LAB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cps-red: #d70018;
            --cps-red-dark: #b80014;
            --cps-red-soft: #fff0f1;
            --bg-body: #f4f6f8;
        }
        body {
            background-color: var(--bg-body);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #111827;
        }
        .font-mono { font-family: 'JetBrains Mono', monospace; }

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
        }
        .main-header {
            background: linear-gradient(180deg, #e0051e 0%, #d70018 100%);
            padding: 10px 0;
            box-shadow: 0 4px 16px rgba(215, 0, 24, 0.22);
        }
        .brand-box {
            color: #ffffff;
            text-decoration: none;
            font-weight: 800;
            font-size: 1.25rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 7px 12px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .header-pill-btn:hover {
            background: rgba(255, 255, 255, 0.28);
            color: #ffffff;
        }
        .header-search-form {
            background: #ffffff;
            border-radius: 10px;
            display: flex;
            align-items: center;
            padding: 2px 6px 2px 12px;
            flex-grow: 1;
            max-width: 440px;
        }
        .header-search-form input {
            border: none;
            outline: none;
            font-size: 0.86rem;
            padding: 7px 8px;
            width: 100%;
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
        .bento-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        }
        .role-info-item {
            background: #f9fafb;
            border: 1px solid #f1f5f9;
            border-radius: 14px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .role-icon-box {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            flex-shrink: 0;
        }
        .auth-tab-bar {
            background: #f3f4f6;
            border-radius: 14px;
            padding: 5px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 4px;
        }
        .auth-tab-btn {
            border: none;
            background: transparent;
            border-radius: 10px;
            padding: 9px 8px;
            font-size: 0.83rem;
            font-weight: 600;
            color: #4b5563;
            transition: all 0.2s;
        }
        .auth-tab-btn.active {
            background: var(--cps-red);
            color: #ffffff;
            box-shadow: 0 3px 10px rgba(215, 0, 24, 0.25);
        }
        .form-control, .form-select {
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 0.9rem;
            border: 1px solid #d1d5db;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--cps-red);
            box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.12);
        }
        .btn-cps-submit {
            background: var(--cps-red);
            color: #ffffff;
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-weight: 700;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .btn-cps-submit:hover {
            background: var(--cps-red-dark);
            color: #ffffff;
        }
    </style>
</head>
<body>

    <div class="top-promo-bar">
        <div class="container d-flex flex-wrap justify-content-between align-items-center">
            <div><span class="promo-dot"></span><strong>Kiểm định phần cứng 30+ hạng mục</strong> • Minh bạch lịch sử thay thế linh kiện & chu kỳ sạc pin thực tế</div>
            <div class="d-none d-md-flex gap-3 text-white-50">
                <span><i class="bi bi-shield-check text-info me-1"></i>Bảo hành 1 đổi 1 tới 12 tháng</span>
                <span><i class="bi bi-upc-scan text-warning me-1"></i>Tra cứu IMEI chuẩn Lab</span>
            </div>
        </div>
    </div>

    <header class="main-header">
        <div class="container d-flex align-items-center justify-content-between gap-2">
            <a href="home" class="brand-box">
                <i class="bi bi-apple fs-4"></i>
                <span>iPhoneQC</span>
                <span class="brand-badge-s">LAB</span>
            </a>
            <a href="home#catalog" class="header-pill-btn d-none d-lg-inline-flex"><i class="bi bi-grid-fill"></i> Danh mục</a>
            <form action="home" method="get" class="header-search-form">
                <i class="bi bi-search text-muted"></i>
                <input type="text" name="keyword" placeholder="Bạn muốn tìm dòng iPhone nào hôm nay?">
                <button type="submit">Tìm</button>
            </form>
            <div class="d-flex align-items-center gap-2">
                <a href="LookupServlet" class="header-pill-btn"><i class="bi bi-patch-check"></i> <span class="d-none d-xl-inline">Tra cứu QC</span></a>
                <a href="CompareServlet" class="header-pill-btn"><i class="bi bi-bar-chart-line"></i> <span class="d-none d-xl-inline">So sánh</span></a>
                <a href="WishlistServlet" class="header-pill-btn"><i class="bi bi-heart"></i> <span class="d-none d-xl-inline">Yêu thích</span></a>
                <a href="SupportServlet" class="header-pill-btn"><i class="bi bi-headset"></i> <span class="d-none d-xxl-inline">Hỗ trợ</span></a>
            </div>
        </div>
    </header>

    <div class="bg-white border-bottom py-2">
        <div class="container d-flex justify-content-between align-items-center small">
            <div>
                <a href="home" class="text-decoration-none text-muted"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a>
                <span class="mx-2 text-muted">/</span>
                <strong class="text-dark">Tài khoản & Phân quyền hệ thống</strong>
            </div>
            <a href="home#catalog" class="text-decoration-none text-danger fw-semibold">← Quay lại kho máy QC</a>
        </div>
    </div>

    <main class="container my-4 my-lg-5">
        <div class="row g-4 align-items-stretch">
            <!-- CỘT TRÁI: GIỚI THIỆU PHÂN QUYỀN -->
            <div class="col-lg-5">
                <div class="bento-card p-4 p-lg-5 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge rounded-pill px-3 py-2 mb-3" style="background: var(--cps-red-soft); color: var(--cps-red); font-size: 0.72rem;">
                            <i class="bi bi-shield-lock-fill me-1"></i>IPHONEQC MEMBER & STAFF PORTAL
                        </span>
                        <h3 class="fw-bold mb-2">Quản lý hồ sơ thiết bị & Đặc quyền thành viên</h3>
                        <p class="text-muted small mb-4">
                            Đăng nhập để theo dõi lịch sử mua hàng, đánh giá thiết bị, lưu danh sách iPhone yêu thích hoặc truy cập cổng quản trị kho & kiểm định QC.
                        </p>

                        <div class="d-flex flex-column gap-3">
                            <div class="role-info-item">
                                <div class="role-icon-box bg-danger bg-opacity-10 text-danger"><i class="bi bi-bag-check-fill"></i></div>
                                <div>
                                    <div class="fw-bold small">Khách hàng thành viên (CUSTOMER)</div>
                                    <div class="text-muted" style="font-size: 0.78rem;">Theo dõi đơn hàng, đánh giá chuẩn QC & phiếu bảo hành điện tử</div>
                                </div>
                            </div>
                            <div class="role-info-item">
                                <div class="role-icon-box bg-success bg-opacity-10 text-success"><i class="bi bi-clipboard2-check-fill"></i></div>
                                <div>
                                    <div class="fw-bold small">Quản trị & Kiểm định QC (ADMIN / INSPECTOR)</div>
                                    <div class="text-muted" style="font-size: 0.78rem;">Nhập kho IMEI, chấm điểm 30+ hạng mục & phát hành chứng nhận QC</div>
                                </div>
                            </div>
                            <div class="role-info-item">
                                <div class="role-icon-box bg-primary bg-opacity-10 text-primary"><i class="bi bi-arrow-repeat"></i></div>
                                <div>
                                    <div class="fw-bold small">Thu mua, Bán hàng & Bảo hành</div>
                                    <div class="text-muted" style="font-size: 0.78rem;">Định giá thu mua máy cũ, điều phối kho & tiếp nhận sửa chữa</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 p-3 rounded-3 bg-light border small text-secondary">
                        <i class="bi bi-info-circle-fill text-danger me-1"></i>
                        Mọi thao tác nghiệp vụ của tài khoản quản lý đều được ghi nhận vào nhật ký kiểm soát (<span class="font-mono">Audit Log</span>).
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: FORM ĐĂNG NHẬP / ĐĂNG KÝ / OTP / QUÊN MK -->
            <div class="col-lg-7">
                <div class="bento-card p-4 p-lg-5 h-100">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger rounded-3 small py-2 px-3 mb-3">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success rounded-3 small py-2 px-3 mb-3">
                            <i class="bi bi-check-circle-fill me-1"></i> ${success}
                        </div>
                    </c:if>

                    <div class="auth-tab-bar mb-4">
                        <button type="button" class="auth-tab-btn active" id="btn-tab-login" onclick="switchAuthTab('login')">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                        </button>
                        <button type="button" class="auth-tab-btn" id="btn-tab-register" onclick="switchAuthTab('register')">
                            <i class="bi bi-person-plus me-1"></i>Đăng ký
                        </button>
                        <button type="button" class="auth-tab-btn" id="btn-tab-verify" onclick="switchAuthTab('verify')">
                            <i class="bi bi-patch-check me-1"></i>Xác thực OTP
                        </button>
                        <button type="button" class="auth-tab-btn" id="btn-tab-recover" onclick="switchAuthTab('recover')">
                            <i class="bi bi-key me-1"></i>Quên MK
                        </button>
                    </div>

                    <!-- TAB 1: ĐĂNG NHẬP -->
                    <div id="pane-login">
                        <h4 class="fw-bold mb-1">Đăng nhập hệ thống</h4>
                        <p class="text-muted small mb-4">Sử dụng Email hoặc Số điện thoại đã đăng ký tài khoản</p>
                        <form action="AuthServlet" method="post">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Email hoặc Số điện thoại</label>
                                <input type="text" name="identity" class="form-control" required placeholder="VD: admin@iphoneqc.vn hoặc 0901234567">
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Mật khẩu</label>
                                <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu của bạn">
                            </div>
                            <button type="submit" class="btn btn-cps-submit w-100">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập ngay
                            </button>
                        </form>
                    </div>

                    <!-- TAB 2: ĐĂNG KÝ TÀI KHOẢN (CHỌN ĐƯỢC CẢ VAI TRÒ QUẢN LÝ) -->
                    <div id="pane-register" style="display: none;">
                        <h4 class="fw-bold mb-1">Tạo tài khoản mới</h4>
                        <p class="text-muted small mb-3">Tạo tài khoản khách hàng hoặc tài khoản quản lý/nhân viên lưu trực tiếp vào SQL Server</p>
                        <form action="AuthServlet" method="post">
                            <input type="hidden" name="action" value="register">
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Họ và tên</label>
                                    <input type="text" name="fullName" class="form-control" required placeholder="VD: Quách Khánh Hưng">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Loại tài khoản & Phân quyền</label>
                                    <select name="roleCode" class="form-select">
                                        <option value="CUSTOMER">Khách hàng thành viên (CUSTOMER)</option>
                                        <option value="ADMIN">Quản trị viên hệ thống (ADMIN - Toàn quyền)</option>
                                        <option value="INSPECTOR">Nhân viên Kiểm định QC (INSPECTOR)</option>
                                        <option value="SELLER">Nhân viên Bán hàng (SELLER)</option>
                                        <option value="BUYER_STAFF">Nhân viên Thu mua (BUYER_STAFF)</option>
                                        <option value="TECHNICIAN">Kỹ thuật viên Bảo hành (TECHNICIAN)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Email đăng nhập</label>
                                    <input type="email" name="email" class="form-control" required placeholder="name@gmail.com">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Số điện thoại</label>
                                    <input type="text" name="phone" class="form-control" required placeholder="0912345678">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Mật khẩu</label>
                                <input type="password" name="password" class="form-control" required placeholder="Tạo mật khẩu đăng nhập">
                            </div>
                            <button type="submit" class="btn btn-cps-submit w-100">
                                <i class="bi bi-person-plus-fill me-1"></i>Tạo tài khoản ngay
                            </button>
                        </form>
                    </div>

                    <!-- TAB 3: XÁC THỰC OTP -->
                    <div id="pane-verify" style="display: none;">
                        <h4 class="fw-bold mb-1">Xác thực tài khoản qua OTP</h4>
                        <p class="text-muted small mb-4">Nhập Email/SĐT và mã OTP 6 chữ số đã được cấp</p>
                        <form action="AuthServlet" method="post">
                            <input type="hidden" name="action" value="verify">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Email hoặc Số điện thoại</label>
                                <input type="text" name="identity" class="form-control" required placeholder="Nhập Email hoặc SĐT">
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Mã xác thực OTP</label>
                                <input type="text" name="otp" class="form-control font-mono" required placeholder="VD: 123456">
                            </div>
                            <button type="submit" class="btn btn-cps-submit w-100">Xác nhận OTP</button>
                        </form>
                    </div>

                    <!-- TAB 4: QUÊN MẬT KHẨU -->
                    <div id="pane-recover" style="display: none;">
                        <h4 class="fw-bold mb-1">Khôi phục mật khẩu</h4>
                        <p class="text-muted small mb-4">Hệ thống sẽ cấp mật khẩu tạm thời mới cho tài khoản của bạn</p>
                        <form action="AuthServlet" method="post">
                            <input type="hidden" name="action" value="recover">
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Email hoặc Số điện thoại đã đăng ký</label>
                                <input type="text" name="identity" class="form-control" required placeholder="Nhập Email hoặc SĐT">
                            </div>
                            <button type="submit" class="btn btn-cps-submit w-100">Cấp lại mật khẩu mới</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function switchAuthTab(tab) {
            ['login', 'register', 'verify', 'recover'].forEach(function (t) {
                document.getElementById('pane-' + t).style.display = (t === tab) ? 'block' : 'none';
                document.getElementById('btn-tab-' + t).classList.toggle('active', t === tab);
            });
        }
        <c:if test="${not empty activeTab}">
            switchAuthTab('${activeTab}');
        </c:if>
    </script>
</body>
</html>