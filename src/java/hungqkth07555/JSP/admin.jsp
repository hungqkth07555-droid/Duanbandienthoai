<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng Quản Trị & Kiểm Định Lab — iPhoneQCStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cps-red: #d70018;
            --cps-red-dark: #b80014;
            --bg-body: #f4f6f8;
        }
        body {
            background-color: var(--bg-body);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #111827;
        }
        .font-mono { font-family: 'JetBrains Mono', monospace; }
        .admin-topbar {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #fff;
            padding: 12px 0;
            position: sticky;
            top: 0;
            z-index: 1050;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.2);
        }
        .nav-admin-pills .nav-link {
            color: #374151;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
            padding: 10px 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
        .nav-admin-pills .nav-link:hover {
            border-color: var(--cps-red);
            color: var(--cps-red);
        }
        .nav-admin-pills .nav-link.active {
            background: var(--cps-red);
            color: #ffffff;
            border-color: var(--cps-red);
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.25);
        }
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
        }
        .btn-cps-red {
            background: var(--cps-red);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 600;
        }
        .btn-cps-red:hover {
            background: var(--cps-red-dark);
            color: #fff;
        }
        .form-control, .form-select {
            border-radius: 10px;
            font-size: 0.86rem;
        }
        .table thead th {
            background: #f8fafc;
            font-size: 0.74rem;
            text-transform: uppercase;
            color: #475569;
            font-weight: 700;
        }
        .device-thumb {
            width: 44px;
            height: 44px;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            background: #fff;
            padding: 2px;
        }
    </style>
</head>
<body>

    <header class="admin-topbar">
        <div class="container d-flex flex-wrap justify-content-between align-items-center gap-2">
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-danger font-mono px-2 py-1">ADMIN & QC LAB</span>
                <span class="fw-bold fs-6">Hệ Thống Quản Trị Kho, Kiểm Định & Định Giá iPhone</span>
            </div>
            <div class="d-flex align-items-center gap-2 small">
                <span class="text-white-50">Xin chào, <strong class="text-white">${sessionScope.fullName}</strong> (${sessionScope.role})</span>
                <a href="home" class="btn btn-outline-light btn-sm rounded-pill px-3">
                    <i class="bi bi-shop me-1"></i>Xem Website
                </a>
                <a href="AuthServlet?action=logout" class="btn btn-danger btn-sm rounded-pill px-3">Đăng xuất</a>
            </div>
        </div>
    </header>

    <main class="container my-4">
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success rounded-4 border-0 shadow-sm d-flex align-items-center mb-3">
                <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                <div>Thao tác quản trị đã được thực thi và lưu vào SQL Server!</div>
            </div>
        </c:if>
        <c:if test="${not empty param.err}">
            <div class="alert alert-danger rounded-4 border-0 shadow-sm mb-3">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> Lỗi: ${param.err}
            </div>
        </c:if>

        <!-- THANH CHUYỂN 6 PHÂN HỆ NGHIỆP VỤ -->
        <div class="d-flex flex-wrap gap-2 mb-4 nav-admin-pills">
            <a href="AdminServlet?tab=devices" class="nav-link ${activeTab == 'devices' ? 'active' : ''}">
                <i class="bi bi-phone-fill"></i> 1. Kho Thiết Bị, IMEI & Media
            </a>
            <a href="AdminServlet?tab=catalog" class="nav-link ${activeTab == 'catalog' ? 'active' : ''}">
                <i class="bi bi-cpu-fill"></i> 2. Dòng Máy, Biến Thể & Thông Số
            </a>
            <a href="AdminServlet?tab=qc" class="nav-link ${activeTab == 'qc' ? 'active' : ''}">
                <i class="bi bi-patch-check-fill"></i> 3. Kiểm Định QC, Chấm Điểm & Chứng Nhận
            </a>
            <a href="AdminServlet?tab=pricing" class="nav-link ${activeTab == 'pricing' ? 'active' : ''}">
                <i class="bi bi-calculator-fill"></i> 4. Định Giá Tự Động & Khấu Hao
            </a>
            <a href="AdminServlet?tab=standards" class="nav-link ${activeTab == 'standards' ? 'active' : ''}">
                <i class="bi bi-sliders"></i> 5. Tiêu Chuẩn Lỗi, Linh Kiện & Trọng Số
            </a>
            <a href="AdminServlet?tab=warranty" class="nav-link ${activeTab == 'warranty' || activeTab == 'staff' ? 'active' : ''}">
                <i class="bi bi-shield-fill-check"></i> 6. Gói Bảo Hành & Tài Khoản QL
            </a>
        </div>

        <!-- ===================================================================== -->
        <!-- TAB 1: KHO THIẾT BỊ, IMEI, SERIAL, CHỈNH SỬA SẢN PHẨM & MEDIA         -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'devices'}">
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold text-danger mb-3"><i class="bi bi-plus-circle-fill me-1"></i>Nhập thiết bị mới theo IMEI & Serial</h6>
                        <form action="AdminServlet" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="add_device">
                            <input type="hidden" name="tab" value="devices">

                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Chọn phiên bản biến thể (SKU)</label>
                                <select name="variantId" class="form-select" required>
                                    <c:forEach var="v" items="${variants}">
                                        <option value="${v.variantId}">${v.modelName} ${v.capacityValue} - ${v.colorName} (${v.sku})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Mã định danh IMEI (15 số)</label>
                                    <input type="text" name="imei" class="form-control font-mono" required placeholder="359001122334499">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Serial Number</label>
                                    <input type="text" name="serialNumber" class="form-control font-mono" required placeholder="SN17PM999">
                                </div>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-4">
                                    <label class="form-label small fw-semibold">Mã thị trường</label>
                                    <input type="text" name="originCountry" class="form-control" value="VN/A" required>
                                </div>
                                <div class="col-4">
                                    <label class="form-label small fw-semibold">Trạng thái kho</label>
                                    <select name="status" class="form-select">
                                        <option value="IN_STOCK">IN_STOCK (Sẵn bán)</option>
                                        <option value="WAITING_INSPECT">WAITING_INSPECT</option>
                                        <option value="DRAFT">DRAFT (Nháp)</option>
                                    </select>
                                </div>
                                <div class="col-4">
                                    <label class="form-label small fw-semibold">Hiển thị Web</label>
                                    <select name="isVisible" class="form-select">
                                        <option value="1">Công khai ngay</option>
                                        <option value="0">Ẩn khỏi web</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Giá bán khởi điểm (VNĐ)</label>
                                <input type="number" name="sellingPrice" class="form-control" placeholder="VD: 25900000">
                            </div>

                            <div class="rounded-3 bg-light border mb-2 p-2">
                                <label class="form-label small fw-bold text-primary mb-1">
                                    <i class="bi bi-upload me-1"></i>Ảnh đại diện chính (Tải từ máy tính)
                                </label>
                                <input type="file" name="coverImageFile" accept="image/*" class="form-control form-control-sm mb-1">
                                <input type="text" name="coverImage" class="form-control form-control-sm" placeholder="Hoặc nhập đường dẫn dự phòng (VD: image/ip16pm.jpg)">
                            </div>

                            <div class="p-2 rounded-3 bg-light border mb-2">
                                <label class="form-label small fw-bold text-secondary mb-1">
                                    <i class="bi bi-image me-1"></i>Ảnh thực tế bổ sung (Tải từ máy tính - tùy chọn)
                                </label>
                                <input type="file" name="extraImageFile" accept="image/*" class="form-control form-control-sm mb-1">
                                <input type="text" name="extraImage" class="form-control form-control-sm" placeholder="Hoặc nhập URL ảnh bổ sung...">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Gắn Video mô tả tình trạng thiết bị</label>
                                <input type="text" name="videoUrl" class="form-control" placeholder="https://youtube.com/... hoặc link mp4">
                            </div>
                            <button type="submit" class="btn btn-cps-red w-100 py-2">Lưu thiết bị & Ảnh vào kho</button>
                        </form>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-images text-primary me-1"></i>Tải thêm ảnh từ máy / Gắn video cho thiết bị</h6>
                        <form action="AdminServlet" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="add_device_media">
                            <input type="hidden" name="tab" value="devices">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Chọn thiết bị theo IMEI</label>
                                <select name="deviceId" class="form-select" required>
                                    <c:forEach var="d" items="${devices}">
                                        <option value="${d.deviceId}">#${d.deviceId} — ${d.modelName} (${d.imei})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Loại Media</label>
                                    <select name="mediaType" class="form-select">
                                        <option value="IMAGE">Hình ảnh thực tế (IMAGE)</option>
                                        <option value="VIDEO">Video tình trạng (VIDEO)</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Đặt làm ảnh đại diện?</label>
                                    <select name="isCover" class="form-select">
                                        <option value="1">Có (Thay ảnh đại diện)</option>
                                        <option value="0">Không (Thêm vào thư viện)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-bold text-primary">Chọn ảnh từ máy tính</label>
                                <input type="file" name="mediaFile" accept="image/*" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Hoặc nhập đường dẫn ảnh / link Video</label>
                                <input type="text" name="mediaUrl" class="form-control" placeholder="Chỉ cần nhập nếu gắn link Video hoặc URL ngoài">
                            </div>
                            <button type="submit" class="btn btn-dark w-100 py-2">Cập nhật Media thiết bị</button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-box-seam-fill text-danger me-1"></i>Danh sách thiết bị trong kho (${devices.size()} máy)</h6>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle small">
                                <thead>
                                    <tr>
                                        <th>Ảnh & Thiết bị / IMEI</th>
                                        <th>QC & Giá bán</th>
                                        <th>Hiển thị & Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${devices}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <img src="${empty d.coverImg ? 'image/ip15pm.jpg' : d.coverImg}" alt="iPhone" class="device-thumb">
                                                    <div>
                                                        <div class="fw-bold text-dark">${d.modelName} ${d.capacityValue} (${d.colorName})</div>
                                                        <div class="font-mono text-muted">IMEI: ${d.imei}</div>
                                                        <div class="font-mono text-secondary" style="font-size: 0.72rem;">SN: ${d.serialNumber} • ${d.originCountry}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge ${d.qualityTier == 'GRADE_A' ? 'bg-success' : 'bg-primary'} font-mono">
                                                    ${empty d.qualityTier ? 'Chưa QC' : d.qualityTier}
                                                </span>
                                                <div class="fw-bold text-danger mt-1">
                                                    <fmt:formatNumber value="${d.actualPrice}" pattern="#,###"/> đ
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge ${d.status == 'IN_STOCK' ? 'bg-success bg-opacity-10 text-success border border-success' : (d.status == 'SOLD' ? 'bg-dark text-white' : 'bg-warning text-dark')}">
                                                    ${d.status}
                                                </span>
                                                <div class="mt-1">
                                                    <span class="badge ${d.isVisible ? 'bg-info text-dark' : 'bg-secondary'}">
                                                        ${d.isVisible ? 'Đang công khai' : 'Đang ẩn'}
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex flex-column gap-1">
                                                    <button type="button" class="btn btn-primary btn-sm w-100 py-0" style="font-size:0.74rem;"
                                                            data-id="${d.deviceId}"
                                                            data-variant="${d.variantId}"
                                                            data-imei="${d.imei}"
                                                            data-serial="${d.serialNumber}"
                                                            data-origin="${d.originCountry}"
                                                            data-status="${d.status}"
                                                            data-visible="${d.isVisible ? '1' : '0'}"
                                                            data-price="${d.actualPrice != null ? d.actualPrice.toBigInteger() : ''}"
                                                            onclick="openEditDeviceModal(this)">
                                                        <i class="bi bi-pencil-square me-1"></i>Chỉnh sửa
                                                    </button>
                                                    <form action="AdminServlet" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="change_device_status">
                                                        <input type="hidden" name="deviceId" value="${d.deviceId}">
                                                        <input type="hidden" name="mode" value="publish">
                                                        <button class="btn btn-outline-success btn-sm w-100 py-0" style="font-size:0.74rem;">Công khai Web</button>
                                                    </form>
                                                    <form action="AdminServlet" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="change_device_status">
                                                        <input type="hidden" name="deviceId" value="${d.deviceId}">
                                                        <input type="hidden" name="mode" value="hide">
                                                        <button class="btn btn-outline-secondary btn-sm w-100 py-0" style="font-size:0.74rem;">Ẩn khỏi bán</button>
                                                    </form>
                                                    <form action="AdminServlet" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="change_device_status">
                                                        <input type="hidden" name="deviceId" value="${d.deviceId}">
                                                        <input type="hidden" name="mode" value="sold">
                                                        <button class="btn btn-outline-danger btn-sm w-100 py-0" style="font-size:0.74rem;">Đánh dấu Đã bán</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- MODAL CHỈNH SỬA THÔNG TIN SẢN PHẨM -->
            <div class="modal fade" id="editDeviceModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content rounded-4 border-0 shadow">
                        <div class="modal-header bg-dark text-white rounded-top-4">
                            <h6 class="modal-title fw-bold">
                                <i class="bi bi-pencil-square me-2 text-warning"></i>Chỉnh sửa thông tin thiết bị <span id="editModalTitleId" class="font-mono text-warning"></span>
                            </h6>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="AdminServlet" method="post" enctype="multipart/form-data">
                            <div class="modal-body p-4">
                                <input type="hidden" name="action" value="update_device">
                                <input type="hidden" name="tab" value="devices">
                                <input type="hidden" name="deviceId" id="editDeviceId">

                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Phiên bản biến thể (Dòng máy / Dung lượng / Màu)</label>
                                    <select name="variantId" id="editVariantId" class="form-select" required>
                                        <c:forEach var="v" items="${variants}">
                                            <option value="${v.variantId}">${v.modelName} ${v.capacityValue} - ${v.colorName} (${v.sku})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="form-label small fw-semibold">Mã định danh IMEI</label>
                                        <input type="text" name="imei" id="editImei" class="form-control font-mono" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label small fw-semibold">Serial Number</label>
                                        <input type="text" name="serialNumber" id="editSerial" class="form-control font-mono" required>
                                    </div>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-4">
                                        <label class="form-label small fw-semibold">Mã thị trường</label>
                                        <input type="text" name="originCountry" id="editOrigin" class="form-control" required>
                                    </div>
                                    <div class="col-4">
                                        <label class="form-label small fw-semibold">Trạng thái kho</label>
                                        <select name="status" id="editStatus" class="form-select">
                                            <option value="IN_STOCK">IN_STOCK</option>
                                            <option value="WAITING_INSPECT">WAITING_INSPECT</option>
                                            <option value="DRAFT">DRAFT</option>
                                            <option value="SOLD">SOLD</option>
                                        </select>
                                    </div>
                                    <div class="col-4">
                                        <label class="form-label small fw-semibold">Hiển thị Web</label>
                                        <select name="isVisible" id="editVisible" class="form-select">
                                            <option value="1">Công khai</option>
                                            <option value="0">Ẩn khỏi web</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Giá bán thực tế (VNĐ)</label>
                                    <input type="number" name="sellingPrice" id="editPrice" class="form-control fw-bold text-danger" placeholder="Nhập giá bán mới...">
                                </div>

                                <div class="p-3 rounded-3 bg-light border">
                                    <label class="form-label small fw-bold text-primary mb-1">
                                        <i class="bi bi-image me-1"></i>Đổi ảnh đại diện mới (Bỏ trống nếu giữ ảnh cũ)
                                    </label>
                                    <input type="file" name="coverImageFile" accept="image/*" class="form-control form-control-sm mb-2">
                                    <input type="text" name="coverImage" class="form-control form-control-sm" placeholder="Hoặc nhập đường dẫn ảnh mới (VD: image/ip16pm.jpg)">
                                </div>
                            </div>
                            <div class="modal-footer border-0 pt-0 px-4 pb-4">
                                <button type="button" class="btn btn-light rounded-3 px-4" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-cps-red px-4">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===================================================================== -->
        <!-- TAB 2: DÒNG IPHONE, DUNG LƯỢNG, MÀU SẮC, BIẾN THỂ & THÔNG SỐ KỸ THUẬT -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'catalog'}">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold text-danger mb-3"><i class="bi bi-phone me-1"></i>Thêm thông tin dòng iPhone mới</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="add_model">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Tên dòng máy</label>
                                <input type="text" name="modelName" class="form-control" required placeholder="VD: iPhone 17 Air">
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Thế hệ</label>
                                    <input type="text" name="generation" class="form-control" placeholder="17 Series">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Năm ra mắt</label>
                                    <input type="number" name="releaseYear" class="form-control" value="2025" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Giá niêm yết máy mới (MSRP)</label>
                                <input type="number" name="originalMsrp" class="form-control" value="26990000" required>
                            </div>
                            <button type="submit" class="btn btn-cps-red w-100">Thêm dòng iPhone</button>
                        </form>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-palette-fill text-primary me-1"></i>Thêm Dung lượng & Màu sắc</h6>
                        <form action="AdminServlet" method="post" class="d-flex gap-2 mb-3">
                            <input type="hidden" name="action" value="add_capacity">
                            <input type="text" name="capacityValue" class="form-control" required placeholder="VD: 1TB">
                            <button type="submit" class="btn btn-dark text-nowrap">+ Dung lượng</button>
                        </form>
                        <form action="AdminServlet" method="post" class="row g-2">
                            <input type="hidden" name="action" value="add_color">
                            <div class="col-7">
                                <input type="text" name="colorName" class="form-control" required placeholder="Tên màu: Hồng Phấn">
                            </div>
                            <div class="col-2">
                                <input type="color" name="hexCode" class="form-control form-control-color w-100" value="#f4c2c2">
                            </div>
                            <div class="col-3">
                                <button type="submit" class="btn btn-dark w-100">+ Màu</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-diagram-3-fill text-success me-1"></i>Tạo biến thể sản phẩm (SKU)</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="add_variant">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Dòng iPhone</label>
                                <select name="modelId" class="form-select">
                                    <c:forEach var="m" items="${models}">
                                        <option value="${m.modelId}">${m.modelName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Dung lượng</label>
                                    <select name="capacityId" class="form-select">
                                        <c:forEach var="c" items="${capacities}">
                                            <option value="${c.capacityId}">${c.capacityValue}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Màu sắc</label>
                                    <select name="colorId" class="form-select">
                                        <c:forEach var="col" items="${colors}">
                                            <option value="${col.colorId}">${col.colorName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-5">
                                    <label class="form-label small fw-semibold">Model Number</label>
                                    <input type="text" name="modelNumber" class="form-control" placeholder="A3526">
                                </div>
                                <div class="col-7">
                                    <label class="form-label small fw-semibold">Mã SKU duy nhất</label>
                                    <input type="text" name="sku" class="form-control font-mono" required placeholder="IP17AIR-256-PNK">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Tạo biến thể SKU</button>
                        </form>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-cpu text-danger me-1"></i>Cập nhật thông số kỹ thuật iPhone</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="save_spec">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Chọn dòng máy</label>
                                <select name="modelId" class="form-select">
                                    <c:forEach var="m" items="${models}">
                                        <option value="${m.modelId}">${m.modelName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-2">
                                <input type="text" name="screenSize" class="form-control" required placeholder="Màn hình: 6.9 inch OLED 120Hz">
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-7"><input type="text" name="chipset" class="form-control" required placeholder="Chip: Apple A19 Pro"></div>
                                <div class="col-5"><input type="text" name="ram" class="form-control" required placeholder="RAM: 12GB"></div>
                            </div>
                            <div class="mb-2">
                                <input type="text" name="cameraSpecs" class="form-control" required placeholder="Camera: 48MP + 48MP + Tele 5x">
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-5"><input type="number" name="batteryCapacityMah" class="form-control" required placeholder="Pin mAh: 4850"></div>
                                <div class="col-7"><input type="text" name="biometricsType" class="form-control" value="Face ID"></div>
                            </div>
                            <div class="mb-3">
                                <input type="text" name="chargingTech" class="form-control" required placeholder="Sạc: USB-C 35W, MagSafe 25W">
                            </div>
                            <button type="submit" class="btn btn-dark w-100">Lưu thông số kỹ thuật</button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3">Danh sách dòng iPhone (Cập nhật nhanh)</h6>
                        <c:forEach var="m" items="${models}">
                            <form action="AdminServlet" method="post" class="border rounded-3 p-3 mb-2 bg-light">
                                <input type="hidden" name="action" value="update_model">
                                <input type="hidden" name="modelId" value="${m.modelId}">
                                <div class="d-flex gap-2 mb-2">
                                    <input type="text" name="modelName" value="${m.modelName}" class="form-control form-control-sm fw-bold">
                                    <select name="status" class="form-select form-select-sm" style="width: 110px;">
                                        <option value="ACTIVE" ${m.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                        <option value="HIDDEN" ${m.status == 'HIDDEN' ? 'selected' : ''}>HIDDEN</option>
                                    </select>
                                </div>
                                <div class="row g-1 mb-2">
                                    <div class="col-4"><input type="text" name="generation" value="${m.generation}" class="form-control form-control-sm" placeholder="Thế hệ"></div>
                                    <div class="col-3"><input type="number" name="releaseYear" value="${m.releaseYear}" class="form-control form-control-sm" placeholder="Năm"></div>
                                    <div class="col-5"><input type="number" name="originalMsrp" value="${m.originalMsrp}" class="form-control form-control-sm" placeholder="MSRP"></div>
                                </div>
                                <div class="small text-muted mb-2">
                                    Chip: <strong>${empty m.chipset ? 'Chưa cập nhật' : m.chipset}</strong> • RAM: <strong>${m.ram}</strong>
                                </div>
                                <button type="submit" class="btn btn-outline-danger btn-sm w-100">Cập nhật dòng máy</button>
                            </form>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===================================================================== -->
        <!-- TAB 3: KIỂM ĐỊNH QC, TÍNH ĐIỂM TỔNG THỂ, XẾP HẠNG A/B/C & CHỨNG NHẬN  -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'qc'}">
            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold text-danger mb-3"><i class="bi bi-clipboard2-check-fill me-1"></i>Lập phiếu kiểm định / Tái kiểm tra & Phát hành chứng nhận QC</h6>
                        <form action="AdminServlet" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="submit_qc">
                            <div class="row g-3 mb-3">
                                <div class="col-md-8">
                                    <label class="form-label small fw-semibold">Chọn thiết bị kiểm định</label>
                                    <select name="deviceId" class="form-select" required>
                                        <c:forEach var="d" items="${devices}">
                                            <option value="${d.deviceId}">#${d.deviceId} — ${d.modelName} ${d.capacityValue} (${d.imei})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Loại phiếu kiểm định</label>
                                    <select name="ticketType" class="form-select">
                                        <option value="COMPLETED">Kiểm định mới (COMPLETED)</option>
                                        <option value="RE_INSPECTED">Tái kiểm tra (RE_INSPECTED)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-3">
                                    <label class="form-label small fw-semibold">Điểm ngoại hình (0-10)</label>
                                    <input type="number" step="0.1" min="0" max="10" name="cosmeticScore" class="form-control" value="9.6" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-semibold">Phân loại ngoại hình</label>
                                    <select name="cosmeticLabel" class="form-select">
                                        <option value="Đẹp 99%">Đẹp 99% (Như mới)</option>
                                        <option value="Đẹp 97%">Đẹp 97% (Xước nhẹ)</option>
                                        <option value="Trầy nhẹ 95%">Trầy nhẹ 95%</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-semibold">% Pin thực tế</label>
                                    <input type="number" min="0" max="100" name="batteryHealth" class="form-control" value="96" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-semibold">Số lần sạc (Cycles)</label>
                                    <input type="number" min="0" name="chargeCycles" class="form-control" value="85" required>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Điểm linh kiện (0-10)</label>
                                    <input type="number" step="0.1" min="0" max="10" name="componentScore" class="form-control" value="9.8" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Điểm chức năng (0-10)</label>
                                    <input type="number" step="0.1" min="0" max="10" name="functionScore" class="form-control" value="10.0" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Tình trạng Pin</label>
                                    <select name="isOriginalBattery" class="form-select">
                                        <option value="1">Pin Zin nguyên bản Apple</option>
                                        <option value="0">Pin đã thay thế</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Linh kiện kiểm tra chính</label>
                                    <select name="partId" class="form-select">
                                        <c:forEach var="p" items="${parts}">
                                            <option value="${p.part_id}">${p.part_name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Độ nguyên bản linh kiện</label>
                                    <select name="isOriginalPart" class="form-select">
                                        <option value="1">Zin nguyên bản 100%</option>
                                        <option value="0">Đã thay thế linh kiện</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Loại linh kiện thay (nếu có)</label>
                                    <select name="isGenuineReplaced" class="form-select">
                                        <option value="0">Không thay / Zin</option>
                                        <option value="1">Thay linh kiện chính hãng</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Ảnh chụp kết quả kiểm định (Tải từ máy)</label>
                                    <input type="file" name="proofImageFile" accept="image/*" class="form-control mb-1">
                                    <input type="text" name="proofImageUrl" class="form-control form-control-sm" placeholder="Hoặc nhập URL ảnh kiểm định...">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Link báo cáo PDF kiểm định (tùy chọn)</label>
                                    <input type="text" name="pdfReportUrl" class="form-control" placeholder="https://.../report-qc.pdf">
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Xếp hạng cấp độ chất lượng (A / B / C)</label>
                                    <select name="confirmedTier" class="form-select">
                                        <option value="AUTO">Tự động đề xuất từ điểm tổng thể (A ≥ 9.0 | B ≥ 8.0 | C)</option>
                                        <option value="GRADE_A">Xác nhận hạng GRADE_A (Xuất sắc)</option>
                                        <option value="GRADE_B">Xác nhận hạng GRADE_B (Tốt)</option>
                                        <option value="GRADE_C">Xác nhận hạng GRADE_C (Khá)</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Ghi chú kỹ thuật viên</label>
                                    <input type="text" name="notes" class="form-control" value="Đạt chuẩn 32 bước kiểm định phần cứng Lab">
                                </div>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" name="issueCert" value="1" id="issueCertChk" checked>
                                <label class="form-check-label fw-semibold small" for="issueCertChk">
                                    Xác nhận cấp độ chất lượng & Phát hành / Cập nhật Chứng nhận kiểm định thiết bị
                                </label>
                            </div>

                            <button type="submit" class="btn btn-cps-red w-100 py-2">
                                <i class="bi bi-patch-check-fill me-1"></i>Tính điểm tổng thể, Lưu báo cáo & Phát hành Chứng nhận QC
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-qr-code-scan text-primary me-1"></i>Tra cứu & Xác minh tính hợp lệ Chứng nhận QC</h6>
                        <form action="AdminServlet" method="get" class="d-flex gap-2 mb-3">
                            <input type="hidden" name="tab" value="qc">
                            <input type="text" name="verifyCert" value="${param.verifyCert}" class="form-control font-mono" placeholder="VD: QC-2026-0101" required>
                            <button type="submit" class="btn btn-dark text-nowrap">Xác minh</button>
                        </form>

                        <c:if test="${not empty verifyError}">
                            <div class="alert alert-danger small mb-0">${verifyError}</div>
                        </c:if>
                        <c:if test="${not empty verifiedCert}">
                            <div class="border rounded-4 p-3 bg-light small">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-success"><i class="bi bi-check-circle-fill me-1"></i>CHỨNG NHẬN HỢP LỆ</span>
                                    <span class="font-mono fw-bold text-primary">${verifiedCert.certCode}</span>
                                </div>
                                <div>Thiết bị: <strong>${verifiedCert.modelName} ${verifiedCert.capacity} (${verifiedCert.color})</strong></div>
                                <div class="font-mono">IMEI: ${verifiedCert.imei} | SN: ${verifiedCert.serialNumber}</div>
                                <div>Điểm tổng thể: <strong class="text-danger">${verifiedCert.overallScore}/10</strong> — Phân hạng: <strong>${verifiedCert.qualityTier}</strong></div>
                                <div>Ngày cấp: <span class="font-mono">${verifiedCert.issuedAt}</span></div>
                            </div>
                        </c:if>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-2">Trọng số chấm điểm hiện hành</h6>
                        <ul class="list-group list-group-flush small">
                            <c:forEach var="cr" items="${criteria}">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span>${cr.criterion_name} <span class="badge bg-light text-dark border">${cr.category}</span></span>
                                    <strong class="font-mono text-danger">${cr.weight}</strong>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===================================================================== -->
        <!-- TAB 4: ĐỊNH GIÁ TỰ ĐỘNG, BẢNG GIÁ THAM CHIẾU & KHẤU HAO               -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'pricing'}">
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold text-danger mb-3"><i class="bi bi-cpu-fill me-1"></i>Tính giá trị thiết bị từ kết quả QC & Đề xuất giá Thu mua / Bán</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="calculate_and_save_price">
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Chọn thiết bị cần định giá</label>
                                <select name="deviceId" class="form-select" required>
                                    <c:forEach var="d" items="${devices}">
                                        <option value="${d.deviceId}">#${d.deviceId} — ${d.modelName} ${d.capacityValue} (${d.qualityTier}) — Hiện tại: ${d.actualPrice}đ</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Điều chỉnh theo thị trường (VNĐ)</label>
                                    <input type="number" name="marketAdjustment" class="form-control" value="-500000" placeholder="VD: -500000 hoặc 300000">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Giá bán chốt cuối (để trống = lấy giá đề xuất)</label>
                                    <input type="number" name="customSellingPrice" class="form-control" placeholder="Tự động tính nếu để trống">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-cps-red w-100 py-2">
                                Tự động tính giá Thu mua, Giá bán đề xuất & Lưu bảng giá
                            </button>
                        </form>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-tag-fill text-primary me-1"></i>Thiết lập bảng giá tham chiếu theo biến thể</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="save_price_matrix">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Chọn biến thể iPhone</label>
                                <select name="variantId" class="form-select">
                                    <c:forEach var="v" items="${variants}">
                                        <option value="${v.variantId}">${v.modelName} ${v.capacityValue} - ${v.colorName} (Cũ chuẩn: ${v.baseUsedPrice})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Giá tham chiếu máy mới (VNĐ)</label>
                                    <input type="number" name="baseNewPrice" class="form-control" required placeholder="31990000">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Giá chuẩn máy cũ Grade A (VNĐ)</label>
                                    <input type="number" name="baseUsedPrice" class="form-control" required placeholder="25500000">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-dark w-100">Lưu giá tham chiếu</button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-percent text-warning me-1"></i>Thiết lập mức khấu hao & Giảm giá</h6>
                        <form action="AdminServlet" method="post" class="row g-2 mb-3">
                            <input type="hidden" name="action" value="save_depreciation_rule">
                            <div class="col-md-4">
                                <select name="ruleType" class="form-select">
                                    <option value="AGE">Tuổi đời máy (Năm)</option>
                                    <option value="COSMETIC_GRADE">Ngoại hình (%)</option>
                                    <option value="BATTERY_LEVEL">Mức Pin (%)</option>
                                    <option value="REPLACED_PART">Linh kiện thay thế</option>
                                </select>
                            </div>
                            <div class="col-md-2"><input type="number" step="0.1" name="minVal" class="form-control" placeholder="Từ" required></div>
                            <div class="col-md-2"><input type="number" step="0.1" name="maxVal" class="form-control" placeholder="Đến" required></div>
                            <div class="col-md-2"><input type="number" name="deductionAmount" class="form-control" value="500000" placeholder="Trừ VNĐ"></div>
                            <div class="col-md-2"><input type="number" step="0.1" name="deductionPercentage" class="form-control" value="0" placeholder="Trừ %"></div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-outline-danger btn-sm w-100">+ Thêm quy tắc giảm giá</button>
                            </div>
                        </form>

                        <div class="table-responsive">
                            <table class="table table-sm small mb-0">
                                <thead>
                                    <tr>
                                        <th>Loại quy tắc</th>
                                        <th>Khoảng giá trị</th>
                                        <th>Trừ tiền</th>
                                        <th>Trừ %</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${depreciationRules}">
                                        <tr>
                                            <td class="fw-bold">${r.rule_type}</td>
                                            <td class="font-mono">${r.min_val} - ${r.max_val}</td>
                                            <td class="font-mono text-danger"><fmt:formatNumber value="${r.deduction_amount}" pattern="#,###"/> đ</td>
                                            <td class="font-mono">${r.deduction_percentage}%</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="bento-card p-4">
                        <h6 class="fw-bold mb-2">Bảng giá Thu mua & Giá bán đề xuất từng thiết bị</h6>
                        <div class="table-responsive">
                            <table class="table table-sm small mb-0">
                                <thead>
                                    <tr>
                                        <th>Thiết bị</th>
                                        <th>Giá thu mua đề xuất</th>
                                        <th>Giá bán thực tế</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${devices}">
                                        <tr>
                                            <td><strong>${d.modelName}</strong> <span class="text-muted">(${d.imei})</span></td>
                                            <td class="font-mono text-primary fw-semibold"><fmt:formatNumber value="${d.buyinPrice}" pattern="#,###"/> đ</td>
                                            <td class="font-mono text-danger fw-bold"><fmt:formatNumber value="${d.actualPrice}" pattern="#,###"/> đ</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===================================================================== -->
        <!-- TAB 5: DANH MỤC LỖI PHẦN CỨNG, LINH KIỆN & TRỌNG SỐ CHẤM ĐIỂM         -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'standards'}">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold text-danger mb-3">1. Danh mục lỗi phần cứng</h6>
                        <form action="AdminServlet" method="post" class="mb-3">
                            <input type="hidden" name="action" value="add_fault">
                            <input type="text" name="faultCode" class="form-control mb-2" required placeholder="Mã lỗi: ERR_FACEID">
                            <input type="text" name="faultName" class="form-control mb-2" required placeholder="Tên lỗi: Mất nhận diện FaceID">
                            <input type="text" name="category" class="form-control mb-2" required placeholder="Nhóm: Cảm biến / Màn hình / Nguồn">
                            <button type="submit" class="btn btn-cps-red w-100 btn-sm">Thêm lỗi phần cứng</button>
                        </form>
                        <ul class="list-group list-group-flush small">
                            <c:forEach var="f" items="${faults}">
                                <li class="list-group-item px-0">
                                    <strong class="font-mono text-danger">${f.fault_code}</strong>: ${f.fault_name} <span class="text-muted">(${f.category})</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold text-primary mb-3">2. Danh mục linh kiện iPhone</h6>
                        <form action="AdminServlet" method="post" class="d-flex gap-2 mb-3">
                            <input type="hidden" name="action" value="add_part">
                            <input type="text" name="partName" class="form-control" required placeholder="VD: Cổng sạc USB-C / Loa trong">
                            <button type="submit" class="btn btn-dark text-nowrap">+ Thêm</button>
                        </form>
                        <ul class="list-group list-group-flush small">
                            <c:forEach var="p" items="${parts}">
                                <li class="list-group-item px-0"><i class="bi bi-cpu me-2 text-primary"></i>${p.part_name}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold text-success mb-3">3. Tiêu chí & Trọng số chấm điểm</h6>
                        <form action="AdminServlet" method="post" class="mb-3">
                            <input type="hidden" name="action" value="add_criterion">
                            <input type="text" name="criterionName" class="form-control mb-2" required placeholder="Tên tiêu chí đánh giá">
                            <div class="row g-2 mb-2">
                                <div class="col-7">
                                    <select name="category" class="form-select">
                                        <option value="COSMETIC">Trọng số Ngoại hình</option>
                                        <option value="BATTERY">Trọng số Pin</option>
                                        <option value="COMPONENT">Trọng số Linh kiện</option>
                                        <option value="FUNCTION">Trọng số Chức năng</option>
                                    </select>
                                </div>
                                <div class="col-5">
                                    <input type="number" step="0.05" name="weight" class="form-control" value="0.25" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success w-100 btn-sm">Lưu tiêu chí & trọng số</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ===================================================================== -->
        <!-- TAB 6: GÓI BẢO HÀNH THEO CẤP ĐỘ & QUẢN LÝ TÀI KHOẢN (TẠO / SỬA / XÓA) -->
        <!-- ===================================================================== -->
        <c:if test="${activeTab == 'warranty' || activeTab == 'staff'}">
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="bento-card p-4 mb-4">
                        <h6 class="fw-bold text-danger mb-3"><i class="bi bi-shield-check me-1"></i>Thiết lập gói bảo hành theo cấp độ iPhone</h6>
                        <form action="AdminServlet" method="post" class="mb-3">
                            <input type="hidden" name="action" value="add_warranty_package">
                            <div class="row g-2 mb-2">
                                <div class="col-6"><input type="text" name="packageName" class="form-control" required placeholder="Tên gói: Bảo hành VIP 12T"></div>
                                <div class="col-3"><input type="number" name="durationMonths" class="form-control" value="12" required placeholder="Số tháng"></div>
                                <div class="col-3">
                                    <select name="qualityTierApplied" class="form-select">
                                        <option value="GRADE_A">GRADE_A</option>
                                        <option value="GRADE_B">GRADE_B</option>
                                        <option value="GRADE_C">GRADE_C</option>
                                    </select>
                                </div>
                            </div>
                            <input type="text" name="coverageTerms" class="form-control mb-2" required placeholder="Điều khoản bảo hành: 1 đổi 1 nguồn, màn hình, FaceID...">
                            <button type="submit" class="btn btn-cps-red btn-sm w-100">Thêm gói bảo hành</button>
                        </form>

                        <h6 class="fw-bold mt-4 mb-2">Thiết lập thời hạn bảo hành cho từng thiết bị</h6>
                        <form action="AdminServlet" method="post">
                            <input type="hidden" name="action" value="assign_device_warranty">
                            <div class="mb-2">
                                <select name="deviceId" class="form-select">
                                    <c:forEach var="d" items="${devices}">
                                        <option value="${d.deviceId}">#${d.deviceId} — ${d.modelName} (${d.imei})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-8">
                                    <select name="packageId" class="form-select">
                                        <c:forEach var="wp" items="${warrantyPackages}">
                                            <option value="${wp.package_id}">${wp.package_name} (${wp.quality_tier_applied})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-4">
                                    <input type="number" name="durationMonths" class="form-control" value="12" placeholder="Số tháng">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-dark btn-sm w-100">Cấp phiếu bảo hành điện tử</button>
                        </form>
                    </div>
                </div>

                <!-- Tạo, Đổi quyền & Xóa tài khoản trực tiếp trên Web -->
                <div class="col-lg-7">
                    <div class="bento-card p-4">
                        <h6 class="fw-bold text-primary mb-3"><i class="bi bi-person-plus-fill me-1"></i>Tạo tài khoản Quản lý / Nhân viên hệ thống</h6>
                        <form action="AdminServlet" method="post" class="mb-4">
                            <input type="hidden" name="action" value="create_staff_account">
                            <div class="row g-2 mb-2">
                                <div class="col-6"><input type="text" name="fullName" class="form-control" required placeholder="Họ và tên nhân viên"></div>
                                <div class="col-6">
                                    <select name="roleCode" class="form-select">
                                        <option value="ADMIN">ADMIN (Quản trị viên)</option>
                                        <option value="INSPECTOR">INSPECTOR (Kiểm định QC)</option>
                                        <option value="SELLER">SELLER (Bán hàng)</option>
                                        <option value="BUYER_STAFF">BUYER_STAFF (Thu mua)</option>
                                        <option value="TECHNICIAN">TECHNICIAN (Kỹ thuật bảo hành)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6"><input type="email" name="email" class="form-control" required placeholder="Email đăng nhập"></div>
                                <div class="col-6"><input type="text" name="phone" class="form-control" required placeholder="Số điện thoại"></div>
                            </div>
                            <div class="mb-2">
                                <input type="text" name="password" class="form-control" value="123456" required placeholder="Mật khẩu">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Tạo tài khoản & Lưu vào CSDL</button>
                        </form>

                        <h6 class="fw-bold mb-2">Danh sách tài khoản hệ thống (Cập nhật quyền & Xóa)</h6>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle small mb-0">
                                <thead>
                                    <tr>
                                        <th>Tài khoản</th>
                                        <th>Vai trò & Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${staffList}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${u.full_name}</div>
                                                <div class="text-muted">${u.email}</div>
                                                <div class="text-secondary font-mono" style="font-size:0.72rem;">${u.phone_number}</div>
                                            </td>
                                            <td>
                                                <form action="AdminServlet" method="post" class="d-flex flex-wrap gap-1 align-items-center m-0">
                                                    <input type="hidden" name="action" value="update_staff_role">
                                                    <input type="hidden" name="targetUserId" value="${u.user_id}">
                                                    <select name="roleCode" class="form-select form-select-sm" style="width: 125px;">
                                                        <option value="ADMIN" ${u.role_code == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                                        <option value="INSPECTOR" ${u.role_code == 'INSPECTOR' ? 'selected' : ''}>INSPECTOR</option>
                                                        <option value="SELLER" ${u.role_code == 'SELLER' ? 'selected' : ''}>SELLER</option>
                                                        <option value="BUYER_STAFF" ${u.role_code == 'BUYER_STAFF' ? 'selected' : ''}>BUYER_STAFF</option>
                                                        <option value="TECHNICIAN" ${u.role_code == 'TECHNICIAN' ? 'selected' : ''}>TECHNICIAN</option>
                                                        <option value="CUSTOMER" ${u.role_code == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
                                                    </select>
                                                    <select name="status" class="form-select form-select-sm" style="width: 95px;">
                                                        <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                                        <option value="LOCKED" ${u.status == 'LOCKED' ? 'selected' : ''}>LOCKED</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-outline-primary btn-sm px-2" title="Lưu thay đổi">
                                                        <i class="bi bi-check-lg"></i>
                                                    </button>
                                                </form>
                                            </td>
                                            <td class="text-end">
                                                <c:if test="${u.user_id != sessionScope.userId}">
                                                    <form action="AdminServlet" method="post" class="m-0 d-inline"
                                                          onsubmit="return confirm('Xóa vĩnh viễn tài khoản ${u.email} khỏi SQL Server?');">
                                                        <input type="hidden" name="action" value="delete_staff_account">
                                                        <input type="hidden" name="targetUserId" value="${u.user_id}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm px-2" title="Xóa tài khoản">
                                                            <i class="bi bi-trash3-fill"></i> Xóa
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${u.user_id == sessionScope.userId}">
                                                    <span class="badge bg-success bg-opacity-10 text-success">Đang dùng</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditDeviceModal(btn) {
            const id = btn.getAttribute('data-id');
            document.getElementById('editModalTitleId').textContent = '#' + id;
            document.getElementById('editDeviceId').value = id;
            document.getElementById('editVariantId').value = btn.getAttribute('data-variant');
            document.getElementById('editImei').value = btn.getAttribute('data-imei');
            document.getElementById('editSerial').value = btn.getAttribute('data-serial');
            document.getElementById('editOrigin').value = btn.getAttribute('data-origin');
            document.getElementById('editStatus').value = btn.getAttribute('data-status');
            document.getElementById('editVisible').value = btn.getAttribute('data-visible');
            document.getElementById('editPrice').value = btn.getAttribute('data-price') || '';

            const modalEl = document.getElementById('editDeviceModal');
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }
    </script>
</body>
</html>