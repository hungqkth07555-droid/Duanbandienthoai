<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>iPhoneQCStore — Hệ thống iPhone Cũ Chuẩn Kiểm Định Lab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cps-red: #d70018;
            --cps-red-dark: #b80014;
            --cps-red-soft: #fff0f1;
            --cps-blue: #1d4ed8;
            --cps-blue-border: #60a5fa;
            --bg-body: #f4f6f8;
            --text-main: #111827;
            --text-muted: #6b7280;
            --border-light: #e5e7eb;
        }

        html { scroll-behavior: smooth; }

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
            box-shadow: 0 0 8px #38bdf8;
        }

        /* ===== 2. MAIN RED HEADER & DROPDOWNS ===== */
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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .btn-header-login:hover {
            background: #fff5f5;
            color: var(--cps-red-dark);
            transform: translateY(-1px);
        }

        /* Ô tìm kiếm chính trên Header */
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

        /* Màn che mờ chung cho cả Danh mục & Tìm kiếm */
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

        /* Dropdown BỘ LỌC KHI BẤM VÀO NÚT "DANH MỤC" */
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
            animation: dropdownPop 0.2s ease;
        }

        @keyframes dropdownPop {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .category-dropdown-panel.show {
            display: block;
        }

        .category-dropdown-panel::before {
            content: "";
            position: absolute;
            top: -7px;
            left: 195px;
            width: 14px;
            height: 14px;
            background: #ffffff;
            transform: rotate(45deg);
            border-left: 1px solid #e5e7eb;
            border-top: 1px solid #e5e7eb;
        }

        @media (max-width: 767px) {
            .category-dropdown-panel::before { left: 165px; }
        }

        .category-dropdown-panel .form-control,
        .category-dropdown-panel .form-select {
            font-size: 0.82rem;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            padding: 7px 10px;
        }

        .category-dropdown-panel .form-control:focus,
        .category-dropdown-panel .form-select:focus {
            border-color: var(--cps-red);
            box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.1);
        }

        /* Dropdown gợi ý & lịch sử tìm kiếm */
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
            width: 30px;
            height: 30px;
            object-fit: contain;
            mix-blend-mode: multiply;
        }

        /* ===== 3. HERO BENTO 3 CỘT ===== */
        .bento-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
            border: 1px solid #e5e7eb;
        }

        .cat-menu-list {
            list-style: none;
            padding: 7px;
            margin: 0;
        }

        .cat-menu-link {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 7.5px 10px;
            border-radius: 9px;
            color: #374151;
            text-decoration: none;
            font-size: 0.81rem;
            font-weight: 600;
            transition: all 0.15s ease;
        }

        .cat-menu-link:hover {
            background: var(--cps-red-soft);
            color: var(--cps-red);
            transform: translateX(2px);
        }

        .cat-menu-link i.cat-icon {
            width: 20px;
            text-align: center;
            color: #4b5563;
            font-size: 0.95rem;
        }

        .cat-menu-link:hover i.cat-icon {
            color: var(--cps-red);
        }

        .center-slider-card {
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .center-slider-card .carousel-item img {
            width: 100%;
            height: 310px;
            object-fit: cover;
        }

        .slider-tabs-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            background: #ffffff;
            border-top: 1px solid #f1f5f9;
            flex-grow: 1;
        }

        .slider-tab-btn {
            border: none;
            background: transparent;
            padding: 10px 8px;
            font-size: 0.74rem;
            line-height: 1.3;
            color: #4b5563;
            text-align: center;
            border-bottom: 3px solid transparent;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .slider-tab-btn:hover {
            background: #f9fafb;
            color: #111827;
        }

        .slider-tab-btn.active {
            font-weight: 700;
            color: #111827;
            border-bottom-color: var(--cps-red);
            background: #fffafa;
        }

        .right-widget-card {
            padding: 14px 16px;
        }

        .imei-input-sm {
            font-size: 0.8rem;
            border-radius: 9px;
            border: 1.5px solid #e5e7eb;
            padding: 7px 10px;
        }

        .imei-input-sm:focus {
            border-color: var(--cps-red);
            box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.1);
        }

        .perk-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.78rem;
            color: #374151;
            padding: 4.5px 0;
            text-decoration: none;
        }

        .perk-row:hover {
            color: var(--cps-red);
        }

        /* ===== 3.5. KHỐI FOLDER TABS SHOWCASE (DEAL SỐC / HOT TREND / HÀNG MỚI VỀ) ===== */
        .folder-tabs-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            align-items: end;
            position: relative;
            z-index: 2;
        }

        .folder-tab {
            background: #f1f5f9;
            border: 1.5px solid #e2e8f0;
            border-bottom: none;
            border-radius: 18px 18px 0 0;
            padding: 12px 14px;
            text-align: center;
            font-weight: 800;
            font-size: 1rem;
            color: #2563eb;
            cursor: pointer;
            transition: all 0.2s ease;
            user-select: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .folder-tab:hover:not(.active) {
            background: #e2e8f0;
        }

        .folder-tab.active {
            background: linear-gradient(180deg, #ffffff 0%, #f3f8ff 100%);
            border: 2px solid var(--cps-blue-border);
            border-bottom: 3px solid #f3f8ff;
            margin-bottom: -2px;
            padding-top: 14px;
            padding-bottom: 14px;
            box-shadow: 0 -4px 14px rgba(59, 130, 246, 0.08);
        }

        .deal-badge-pill {
            background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 55%, #0284c7 100%);
            color: #fff;
            padding: 4px 14px;
            border-radius: 10px;
            font-size: 0.94rem;
            font-weight: 900;
            letter-spacing: 0.3px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 3px 10px rgba(29, 78, 216, 0.28);
        }

        .deal-badge-pill small {
            font-size: 0.7rem;
            font-weight: 800;
        }

        .showcase-body {
            background: linear-gradient(180deg, #f3f8ff 0%, #eef5ff 100%);
            border: 2px solid var(--cps-blue-border);
            border-radius: 0 0 20px 20px;
            padding: 16px 18px 20px;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.07);
            position: relative;
        }

        .series-pill-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 8px;
            margin-bottom: 12px;
        }

        .series-pill {
            background: #ffffff;
            border: 1.5px solid #dbeafe;
            color: #374151;
            border-radius: 999px;
            padding: 5px 15px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.18s;
        }

        .series-pill:hover {
            border-color: #3b82f6;
            color: #1d4ed8;
        }

        .series-pill.active {
            background: #dbeafe;
            border-color: #2563eb;
            color: #1d4ed8;
            font-weight: 700;
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.15);
        }

        .subchip-bar-wrap {
            position: relative;
            display: flex;
            align-items: center;
            margin-bottom: 14px;
        }

        .subchip-scroll {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            scroll-behavior: smooth;
            scrollbar-width: none;
            padding: 2px 28px;
            width: 100%;
        }

        .subchip-scroll::-webkit-scrollbar { display: none; }

        .subchip-item {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 6px 12px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 0.78rem;
            font-weight: 600;
            color: #1f2937;
            white-space: nowrap;
            cursor: pointer;
            transition: all 0.18s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }

        .subchip-item:hover {
            border-color: #3b82f6;
            transform: translateY(-1px);
        }

        .subchip-item.active {
            background: #eff6ff;
            border-color: #2563eb;
            color: #1d4ed8;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.16);
        }

        .subchip-icon {
            width: 22px;
            height: 22px;
            border-radius: 6px;
            background: #f1f5f9;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
        }

        .mini-scroll-btn {
            position: absolute;
            z-index: 5;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #fff;
            border: 1px solid #dbeafe;
            color: #374151;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            font-size: 0.78rem;
        }

        .mini-scroll-btn.left { left: 0; }
        .mini-scroll-btn.right { right: 0; }

        /* Carousel Track & Compact Retail Cards */
        .carousel-outer {
            position: relative;
        }

        .cards-track {
            display: grid;
            grid-auto-flow: column;
            grid-auto-columns: calc(20% - 9.6px);
            gap: 12px;
            overflow-x: auto;
            scroll-behavior: smooth;
            scrollbar-width: none;
            padding: 4px 2px 8px;
        }

        .cards-track::-webkit-scrollbar { display: none; }

        @media (max-width: 1199px) {
            .cards-track { grid-auto-columns: calc(25% - 9px); }
        }
        @media (max-width: 991px) {
            .cards-track { grid-auto-columns: calc(33.333% - 8px); }
            .folder-tab { font-size: 0.85rem; padding: 10px 6px; }
        }
        @media (max-width: 575px) {
            .cards-track { grid-auto-columns: calc(50% - 6px); }
            .folder-tab { font-size: 0.74rem; }
            .deal-badge-pill { font-size: 0.74rem; padding: 4px 8px; }
        }

        .carousel-nav-btn {
            position: absolute;
            top: 46%;
            transform: translateY(-50%);
            z-index: 10;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #e5e7eb;
            color: #111827;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.14);
            transition: all 0.2s;
        }

        .carousel-nav-btn:hover {
            color: var(--cps-red);
            transform: translateY(-50%) scale(1.08);
        }

        .carousel-nav-btn.prev { left: -12px; }
        .carousel-nav-btn.next { right: -12px; }

        .retail-card {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
            padding: 12px 12px 10px;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .retail-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.1);
            border-color: #93c5fd;
        }

        .discount-ribbon {
            position: absolute;
            top: 0;
            left: 0;
            background: linear-gradient(135deg, #d70018 0%, #ef4444 100%);
            color: #fff;
            font-size: 0.7rem;
            font-weight: 800;
            padding: 3px 10px 4px 9px;
            border-radius: 13px 0 11px 0;
            z-index: 3;
            box-shadow: 0 2px 6px rgba(215, 0, 24, 0.24);
        }

        .card-visual-stage {
            position: relative;
            height: 152px;
            margin-top: 12px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
            text-decoration: none;
        }

        .card-img-wrap {
            flex: 1;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .card-img-wrap img {
            max-width: 100%;
            max-height: 140px;
            object-fit: contain;
            transition: transform 0.28s ease;
        }

        .retail-card:hover .card-img-wrap img {
            transform: scale(1.05);
        }

        .card-side-specs {
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: center;
            min-width: 42px;
        }

        .side-spec-item {
            text-align: center;
            line-height: 1.15;
        }

        .side-spec-icon {
            width: 23px;
            height: 23px;
            border-radius: 7px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.72rem;
            margin-bottom: 1px;
        }

        .side-spec-label {
            display: block;
            font-size: 0.6rem;
            font-weight: 700;
            color: #475569;
        }

        .for-you-tag {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background: #e0f2fe;
            color: #0369a1;
            font-size: 0.65rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 999px;
            margin-bottom: 5px;
            width: fit-content;
        }

        .card-title-link {
            font-size: 0.82rem;
            font-weight: 700;
            color: #111827;
            text-decoration: none;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 2.2rem;
            margin-bottom: 5px;
        }

        .card-title-link:hover { color: var(--cps-red); }

        .price-row {
            display: flex;
            align-items: baseline;
            flex-wrap: wrap;
            gap: 5px;
            margin-bottom: 6px;
        }

        .price-sale {
            color: var(--cps-red);
            font-weight: 800;
            font-size: 0.94rem;
        }

        .price-orig {
            color: #9ca3af;
            text-decoration: line-through;
            font-size: 0.72rem;
            font-weight: 500;
        }

        .promo-strip {
            background: #f3f4f6;
            border-radius: 7px;
            padding: 4px 8px;
            font-size: 0.68rem;
            color: #374151;
            line-height: 1.3;
            margin-bottom: 8px;
            min-height: 30px;
            display: flex;
            align-items: center;
        }

        .promo-strip.student-purple {
            background: #f3e8ff;
            color: #6b21a8;
            font-weight: 600;
        }

        .card-footer-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 6px;
            border-top: 1px dashed #f1f5f9;
        }

        .fast-ship-badge {
            background: #3b82f6;
            color: #fff;
            font-size: 0.66rem;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .rating-badge {
            font-size: 0.72rem;
            font-weight: 700;
            color: #374151;
            display: inline-flex;
            align-items: center;
            gap: 2px;
        }

        .icon-heart-link {
            color: #2563eb;
            font-size: 0.98rem;
            text-decoration: none;
            transition: transform 0.18s, color 0.18s;
            line-height: 1;
        }

        .icon-heart-link:hover {
            color: var(--cps-red);
            transform: scale(1.18);
        }

        /* ===== 3.6. BANNER S-STUDENT & GỢI Ý CHO BẠN ===== */
        .student-banner {
            background: linear-gradient(90deg, #dcfce7 0%, #e0f2fe 45%, #fee2e2 100%);
            border-radius: 16px;
            padding: 12px 22px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
            border: 1px solid #bae6fd;
        }

        .student-banner-title {
            font-size: 1.25rem;
            font-weight: 900;
            letter-spacing: -0.4px;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        }

        .tradein-pill-red {
            background: linear-gradient(135deg, #d70018 0%, #b91c1c 100%);
            color: #fff;
            padding: 5px 14px;
            border-radius: 12px;
            font-size: 0.82rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 3px 10px rgba(215, 0, 24, 0.25);
        }

        .suggest-box {
            background: linear-gradient(125deg, #a7f3d0 0%, #bae6fd 35%, #e0f2fe 68%, #fed7aa 100%);
            border: 2px solid #60a5fa;
            border-radius: 20px;
            padding: 0 18px 20px;
            position: relative;
            box-shadow: 0 8px 26px rgba(14, 165, 233, 0.1);
        }

        .suggest-notch-wrap {
            display: flex;
            justify-content: center;
            margin-bottom: 14px;
        }

        .suggest-notch-header {
            background: linear-gradient(180deg, #3b82f6 0%, #2563eb 100%);
            color: #fff;
            font-weight: 900;
            font-size: 1rem;
            padding: 7px 38px;
            border-radius: 0 0 24px 24px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.28);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            letter-spacing: 0.4px;
        }

        /* ===== 4. THANH SẮP XẾP GỌN & PILL LỌC ===== */
        .filter-pill-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 6px 12px;
            font-size: 0.79rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.18s ease;
        }

        .filter-pill-btn:hover, .filter-pill-btn.active {
            background: var(--cps-red-soft);
            color: var(--cps-red);
            border-color: var(--cps-red);
        }

        .compact-sort-bar {
            background: #ffffff;
            border-radius: 14px;
            padding: 12px 16px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
        }

        /* ===== 5. THẺ SẢN PHẨM NỀN TRẮNG LIỀN MẠCH ===== */
        .product-card-cps {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.25s ease;
            overflow: hidden;
            position: relative;
        }

        .product-card-cps:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 28px rgba(15, 23, 42, 0.1);
            border-color: #cbd5e1;
        }

        .stage-white {
            background: #ffffff;
            padding: 14px 16px 4px;
        }

        .img-holder-clean {
            height: 195px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 6px 0;
        }

        .img-holder-clean img {
            max-height: 180px;
            max-width: 84%;
            object-fit: contain;
            mix-blend-mode: multiply;
            transition: transform 0.3s ease;
        }

        .product-card-cps:hover .img-holder-clean img {
            transform: scale(1.06);
        }

        .qc-badge-pill {
            font-size: 0.72rem;
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

        .origin-chip {
            position: absolute;
            bottom: 4px;
            right: 0;
            background: #f3f4f6;
            color: #4b5563;
            font-size: 0.68rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        .price-cps {
            color: var(--cps-red);
            font-size: 1.28rem;
            font-weight: 800;
            letter-spacing: -0.4px;
        }

        .save-cps {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
            font-size: 0.72rem;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 6px;
        }

        .spec-grid-2x2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 7px;
            background: #f9fafb;
            border: 1px solid #f1f5f9;
            border-radius: 12px;
            padding: 8px;
        }

        .spec-cell {
            background: #ffffff;
            border: 1px solid #f3f4f6;
            border-radius: 8px;
            padding: 6px 9px;
        }

        .spec-lbl {
            font-size: 0.65rem;
            color: #6b7280;
            text-transform: uppercase;
            font-weight: 600;
            display: block;
        }

        .spec-val {
            font-size: 0.79rem;
            font-weight: 700;
            color: #111827;
        }

        .btn-cps-primary {
            background: var(--cps-red);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 9px 14px;
            transition: all 0.2s;
        }

        .btn-cps-primary:hover {
            background: var(--cps-red-dark);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.25);
        }

        .btn-cps-fav {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            border: 1px solid #fecdd3;
            background: #fff1f2;
            color: var(--cps-red);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .btn-cps-fav:hover {
            background: var(--cps-red);
            color: #ffffff;
        }

        /* ===== FLOATING BOTTOM-RIGHT DOCK ===== */
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-back-top:hover { background: #111827; transform: translateY(-2px); }

        .btn-float-contact {
            background: var(--cps-red);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 8px 14px;
            font-size: 0.82rem;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 14px rgba(215, 0, 24, 0.35);
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-float-contact:hover { background: var(--cps-red-dark); color: #fff; transform: translateY(-2px); }

        /* ===== 6. FOOTER CHUYÊN NGHIỆP ===== */
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
            transition: color 0.15s;
        }

        .footer-link:hover {
            color: var(--cps-red);
        }
    </style>
</head>
<body>

    <c:set var="hasAnyFilter" value="${not empty param.keyword or not empty param.imei or not empty param.budget or not empty param.usageNeed or not empty param.minPrice or not empty param.maxPrice or not empty param.capacity or not empty param.color or not empty param.qualityTier or not empty param.minBattery or not empty param.partStatus or not empty param.minWarranty or not empty param.cosmetic}" />

    <!-- MÀN CHE CHUNG KHI BẤM VÀO "DANH MỤC" HOẶC THANH TÌM KIẾM -->
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
                <!-- Logo -->
                <a href="home" class="brand-box">
                    <i class="bi bi-apple fs-4"></i>
                    <span>iPhoneQC</span>
                    <span class="brand-badge-s">LAB</span>
                </a>

                <!-- NÚT DANH MỤC (BẤM ĐỂ MỞ BỘ LỌC) -->
                <button type="button" id="btnCategoryToggle" class="header-pill-btn ${hasAnyFilter ? 'active' : ''}" onclick="toggleCategoryDropdown()">
                    <i class="bi bi-grid-fill"></i>
                    <span>Danh mục</span>
                    <c:if test="${hasAnyFilter}">
                        <span class="filter-active-dot" title="Đang áp dụng bộ lọc"></span>
                    </c:if>
                    <i class="bi bi-chevron-down small"></i>
                </button>

                <!-- THANH TÌM KIẾM RIÊNG BIỆT TRÊN HEADER + DROPDOWN XU HƯỚNG & LỊCH SỬ -->
                <div class="header-search-wrap">
                    <form action="home" method="get" class="header-search-form">
                        <input type="hidden" name="search" value="1">
                        <i class="bi bi-search text-muted"></i>
                        <input type="text" id="headerSearchInput" name="keyword" value="${param.keyword}"
                               placeholder="Bạn muốn tìm dòng iPhone nào hôm nay?" autocomplete="off"
                               onfocus="openSearchDropdown()">
                        <button type="submit">Tìm</button>
                    </form>

                    <!-- Bảng thả xuống khi bấm vào ô tìm kiếm -->
                    <div class="search-dropdown-panel" id="searchDropdownPanel">
                        <c:if test="${not empty searchHistories}">
                            <div class="mb-3 pb-2 border-bottom">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="small fw-bold text-dark"><i class="bi bi-clock-history text-danger me-1"></i>Lịch sử tìm kiếm</span>
                                </div>
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="h" items="${searchHistories}">
                                        <a href="home?keyword=${h.keyword}" class="badge bg-light text-dark border text-decoration-none fw-medium px-2 py-1">
                                            ${empty h.keyword ? 'Lọc nâng cao' : h.keyword}
                                            <c:if test="${not empty h.filters}"> (${h.filters})</c:if>
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
                            <div class="col-6">
                                <a href="home?keyword=iPhone 14 Pro Max" class="trend-item">
                                    <img src="image/ip14pm.jpg" alt="14PM">
                                    <span>iPhone 14 Pro Max</span>
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="home?qualityTier=GRADE_A" class="trend-item">
                                    <i class="bi bi-patch-check-fill text-success fs-5 px-1"></i>
                                    <span>Máy Grade A Tuyển Chọn</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CÁC NÚT CHỨC NĂNG BÊN PHẢI + ĐĂNG NHẬP / TÀI KHOẢN -->
                <div class="d-flex align-items-center gap-1 gap-xl-2">
                    <a href="LookupServlet" class="header-pill-btn" title="Xác minh Chứng nhận QC & Bảo hành IMEI">
                        <i class="bi bi-patch-check"></i>
                        <span class="d-none d-xl-inline">Tra cứu QC</span>
                    </a>
                    <a href="CompareServlet" class="header-pill-btn" title="So sánh giá & cấu hình QC">
                        <i class="bi bi-bar-chart-line"></i>
                        <span class="d-none d-xl-inline">So sánh</span>
                    </a>
                    <a href="WishlistServlet" class="header-pill-btn" title="Danh sách yêu thích & Báo hàng">
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

            <!-- ========================================================================= -->
            <!-- BẢNG BỘ LỌC THẢ XUỐNG KHI ẤN VÀO Ô "DANH MỤC"                             -->
            <!-- ========================================================================= -->
            <div class="category-dropdown-panel" id="categoryDropdownPanel">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 pb-3 mb-3 border-bottom">
                    <div class="fw-bold text-dark d-flex align-items-center gap-2" style="font-size: 0.96rem;">
                        <span class="badge bg-danger bg-opacity-10 text-danger p-2 rounded-3">
                            <i class="bi bi-funnel-fill"></i>
                        </span>
                        <span>Danh mục & Bộ lọc kiểm định QC</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="home" class="filter-pill-btn text-decoration-none">
                            <i class="bi bi-arrow-counterclockwise"></i> Xóa lọc
                        </a>
                        <button type="button" class="btn-close" aria-label="Đóng" onclick="closeAllHeaderDropdowns()"></button>
                    </div>
                </div>

                <!-- Lọc nhanh 1 chạm -->
                <div class="mb-3">
                    <div class="small fw-bold text-muted text-uppercase mb-2" style="font-size: 0.7rem; letter-spacing: 0.5px;">
                        Chọn nhanh theo dòng máy & tiêu chuẩn Lab
                    </div>
                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <a href="home?keyword=iPhone 17" class="filter-pill-btn ${param.keyword == 'iPhone 17' ? 'active' : ''}">
                            <i class="bi bi-phone"></i> iPhone 17 Series
                        </a>
                        <a href="home?keyword=iPhone 16" class="filter-pill-btn ${param.keyword == 'iPhone 16' ? 'active' : ''}">
                            <i class="bi bi-phone"></i> iPhone 16 Series
                        </a>
                        <a href="home?keyword=iPhone 15" class="filter-pill-btn ${param.keyword == 'iPhone 15' ? 'active' : ''}">
                            <i class="bi bi-phone"></i> iPhone 15 Series
                        </a>
                        <a href="home?qualityTier=GRADE_A" class="filter-pill-btn ${param.qualityTier == 'GRADE_A' ? 'active' : ''}">
                            <i class="bi bi-patch-check"></i> Grade A (Xuất sắc)
                        </a>
                        <a href="home?qualityTier=GRADE_B" class="filter-pill-btn ${param.qualityTier == 'GRADE_B' ? 'active' : ''}">
                            <i class="bi bi-award"></i> Grade B (Tiết kiệm)
                        </a>
                        <a href="home?minBattery=95" class="filter-pill-btn ${param.minBattery == '95' ? 'active' : ''}">
                            <i class="bi bi-battery-full"></i> Pin ≥ 95%
                        </a>
                        <a href="home?partStatus=ORIGINAL" class="filter-pill-btn ${param.partStatus == 'ORIGINAL' ? 'active' : ''}">
                            <i class="bi bi-motherboard"></i> Zin nguyên bản 100%
                        </a>
                        <a href="home?capacity=256GB" class="filter-pill-btn ${param.capacity == '256GB' ? 'active' : ''}">
                            <i class="bi bi-device-ssd"></i> 256GB
                        </a>
                        <a href="home?capacity=512GB" class="filter-pill-btn ${param.capacity == '512GB' ? 'active' : ''}">
                            <i class="bi bi-device-ssd"></i> 512GB
                        </a>
                        <a href="home?budget=23000000" class="filter-pill-btn ${param.budget == '23000000' ? 'active' : ''}">
                            <i class="bi bi-wallet2"></i> Dưới 23 triệu
                        </a>
                    </div>
                </div>

                <!-- Form bộ lọc chi tiết đầy đủ -->
                <form action="home" method="get" class="pt-3 border-top">
                    <input type="hidden" name="search" value="1">
                    <input type="hidden" name="keyword" value="${param.keyword}">
                    <div class="row g-2">
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-muted mb-1">Lọc theo mã IMEI</label>
                            <input type="text" name="imei" value="${param.imei}" class="form-control font-mono" placeholder="Nhập số IMEI...">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label small text-danger fw-semibold mb-1">Ngân sách tối đa (VNĐ)</label>
                            <input type="number" name="budget" value="${param.budget}" class="form-control" placeholder="VD: 20000000">
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
                            <button type="submit" class="btn btn-cps-primary w-100">
                                <i class="bi bi-check2-circle me-1"></i>Áp dụng bộ lọc
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </header>

    <!-- 3. KHỐI HERO BENTO 3 CỘT -->
    <section class="container my-3">
        <div class="row g-3 align-items-stretch">
            <!-- CỘT TRÁI: MENU DANH MỤC NHANH -->
            <div class="col-lg-3 d-none d-lg-block">
                <div class="bento-card h-100">
                    <ul class="cat-menu-list">
                        <li>
                            <a href="home?keyword=iPhone 17" class="cat-menu-link">
                                <span><i class="bi bi-phone cat-icon me-2"></i>iPhone 17 Series</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?keyword=iPhone 16" class="cat-menu-link">
                                <span><i class="bi bi-phone cat-icon me-2"></i>iPhone 16 Series</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?keyword=iPhone 14" class="cat-menu-link">
                                <span><i class="bi bi-phone cat-icon me-2"></i>iPhone 13 / 14 / 15 Series</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?qualityTier=GRADE_A" class="cat-menu-link">
                                <span><i class="bi bi-patch-check cat-icon me-2"></i>Hàng Grade A Tuyển Chọn</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?minBattery=95" class="cat-menu-link">
                                <span><i class="bi bi-battery-charging cat-icon me-2"></i>Pin Cao ≥ 95%</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?partStatus=ORIGINAL" class="cat-menu-link">
                                <span><i class="bi bi-cpu cat-icon me-2"></i>Zin Nguyên Bản 100%</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="home?budget=23000000" class="cat-menu-link">
                                <span><i class="bi bi-tag cat-icon me-2"></i>Ngân Sách Dưới 23 Triệu</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="LookupServlet" class="cat-menu-link">
                                <span><i class="bi bi-qr-code-scan cat-icon me-2"></i>Xác Minh Chứng Nhận & BH</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                        <li>
                            <a href="WishlistServlet#notify" class="cat-menu-link">
                                <span><i class="bi bi-bell cat-icon me-2"></i>Đăng Ký Báo Có Hàng</span>
                                <i class="bi bi-chevron-right small text-muted"></i>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- CỘT GIỮA: BANNER CHẠY NGANG + 4 TAB ĐỒNG BỘ BÊN DƯỚI -->
            <div class="col-lg-6">
                <div class="bento-card center-slider-card">
                    <div id="cpsMainCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3800">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="image/banner1.jpg" alt="Banner 1">
                            </div>
                            <div class="carousel-item">
                                <img src="image/banner2.jpg" alt="Banner 2">
                            </div>
                            <div class="carousel-item">
                                <img src="image/banner3.jpg" alt="Banner 3">
                            </div>
                            <div class="carousel-item">
                                <img src="image/banner4.jpg" alt="Banner 4">
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#cpsMainCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon bg-dark bg-opacity-50 rounded-circle p-2"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#cpsMainCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon bg-dark bg-opacity-50 rounded-circle p-2"></span>
                        </button>
                    </div>

                    <div class="slider-tabs-grid" id="sliderTabs">
                        <button type="button" class="slider-tab-btn active" data-bs-target="#cpsMainCarousel" data-bs-slide-to="0">
                            KIỂM ĐỊNH 32 BƯỚC<br><span class="text-muted fw-normal">Chuẩn phần cứng Lab</span>
                        </button>
                        <button type="button" class="slider-tab-btn" data-bs-target="#cpsMainCarousel" data-bs-slide-to="1">
                            TRA CỨU IMEI<br><span class="text-muted fw-normal">Minh bạch linh kiện</span>
                        </button>
                        <button type="button" class="slider-tab-btn" data-bs-target="#cpsMainCarousel" data-bs-slide-to="2">
                            TIẾT KIỆM ĐẾN 11TR<br><span class="text-muted fw-normal">Định giá chuẩn Grade</span>
                        </button>
                        <button type="button" class="slider-tab-btn" data-bs-target="#cpsMainCarousel" data-bs-slide-to="3">
                            BẢO HÀNH 1 ĐỔI 1<br><span class="text-muted fw-normal">Hỗ trợ kỹ thuật 24/7</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: TRA CỨU IMEI & CAM KẾT QC -->
            <div class="col-lg-3 d-flex flex-column gap-3">
                <div class="bento-card right-widget-card">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <span class="badge bg-danger bg-opacity-10 text-danger p-2 rounded-3">
                            <i class="bi bi-upc-scan fs-6"></i>
                        </span>
                        <div>
                            <div class="fw-bold" style="font-size: 0.85rem;">Tra cứu hồ sơ IMEI</div>
                            <div class="text-muted" style="font-size: 0.72rem;">Xem lịch sử QC từng máy</div>
                        </div>
                    </div>
                    <form action="DetailServlet" method="get" class="d-flex gap-1">
                        <input type="text" name="imei" class="form-control imei-input-sm font-mono" placeholder="VD: 359001122334401" required>
                        <button type="submit" class="btn btn-cps-primary btn-sm px-3 text-nowrap">Check</button>
                    </form>
                </div>

                <div class="bento-card right-widget-card flex-grow-1">
                    <div class="fw-bold mb-2" style="font-size: 0.83rem; color: var(--cps-red);">
                        <i class="bi bi-shield-fill-check me-1"></i>Tiêu chuẩn iPhoneQC Lab
                    </div>
                    <div class="perk-row"><i class="bi bi-check-circle-fill text-success"></i><span>Test 30+ hạng mục phần cứng</span></div>
                    <div class="perk-row"><i class="bi bi-check-circle-fill text-success"></i><span>Đo chu kỳ sạc & độ chai pin thật</span></div>
                    <div class="perk-row"><i class="bi bi-check-circle-fill text-success"></i><span>Công khai linh kiện zin / đã thay</span></div>
                    <a href="LookupServlet" class="perk-row fw-semibold text-primary mt-1">
                        <i class="bi bi-patch-check-fill"></i><span>Xác minh mã chứng nhận QC →</span>
                    </a>
                </div>

                <div class="bento-card right-widget-card bg-dark text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold small">Cần tư vấn chọn máy?</div>
                            <div class="text-white-50" style="font-size: 0.72rem;">Kỹ thuật viên hỗ trợ trực tiếp</div>
                        </div>
                        <a href="SupportServlet" class="btn btn-light btn-sm fw-bold rounded-pill px-3" style="font-size: 0.75rem;">Gửi yêu cầu</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 3.5. KHU VỰC DEAL SỐC / HOT TREND / HÀNG MỚI VỀ + GỢI Ý CHO BẠN -->
    <c:if test="${not empty products}">
        <section class="container my-4">
            <!-- 3 Folder Tabs xếp chồng -->
            <div class="folder-tabs-row">
                <div class="folder-tab active" onclick="switchShowcaseTab(this, 'deal')">
                    <span class="deal-badge-pill">
                        <i class="bi bi-fire text-warning"></i> DEAL SỐC <small>MỖI NGÀY</small>
                    </span>
                </div>
                <div class="folder-tab" onclick="switchShowcaseTab(this, 'hot')">
                    <span>SẢN PHẨM HOT TREND</span>
                </div>
                <div class="folder-tab" onclick="switchShowcaseTab(this, 'new')">
                    <span>HÀNG MỚI VỀ</span>
                </div>
            </div>

            <div class="showcase-body">
                <!-- Hàng 1: Pill lọc theo dòng iPhone -->
                <div class="series-pill-row">
                    <button type="button" class="series-pill active" data-series="ALL" onclick="selectSeriesPill(this)">Tất cả iPhone</button>
                    <button type="button" class="series-pill" data-series="iPhone 17" onclick="selectSeriesPill(this)">iPhone 17</button>
                    <button type="button" class="series-pill" data-series="iPhone 16" onclick="selectSeriesPill(this)">iPhone 16</button>
                    <button type="button" class="series-pill" data-series="iPhone 15" onclick="selectSeriesPill(this)">iPhone 15</button>
                    <button type="button" class="series-pill" data-series="iPhone 14" onclick="selectSeriesPill(this)">iPhone 14</button>
                    <button type="button" class="series-pill" data-series="iPhone 13" onclick="selectSeriesPill(this)">iPhone 13</button>
                    <button type="button" class="series-pill" data-series="GRADE_A" onclick="selectSeriesPill(this)">Chuẩn Grade A</button>
                </div>

                <!-- Hàng 2: Thẻ lọc nhanh có icon & nút cuộn ngang -->
                <div class="subchip-bar-wrap">
                    <button type="button" class="mini-scroll-btn left" onclick="scrollTrack('subchipScroll', -240)">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <div class="subchip-scroll" id="subchipScroll">
                        <div class="subchip-item" data-spec="PIN95" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-battery-charging text-success"></i></span>
                            <span>Pin Zin ≥ 95%</span>
                        </div>
                        <div class="subchip-item" data-spec="UNDER23" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-tag-fill text-danger"></i></span>
                            <span>Giá dưới 23 triệu</span>
                        </div>
                        <div class="subchip-item" data-spec="PROMAX" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-phone-fill text-primary"></i></span>
                            <span>Bản Pro Max</span>
                        </div>
                        <div class="subchip-item" data-spec="CAP256" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-hdd-fill text-info"></i></span>
                            <span>Dung lượng ≥ 256GB</span>
                        </div>
                        <div class="subchip-item" data-spec="ZIN100" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-patch-check-fill text-warning"></i></span>
                            <span>Zin Nguyên Bản 100%</span>
                        </div>
                        <div class="subchip-item" data-spec="QC95" onclick="toggleSpecChip(this)">
                            <span class="subchip-icon"><i class="bi bi-shield-fill-check text-primary"></i></span>
                            <span>Điểm QC ≥ 9.5</span>
                        </div>
                    </div>
                    <button type="button" class="mini-scroll-btn right" onclick="scrollTrack('subchipScroll', 240)">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>

                <!-- Băng chuyền 5 sản phẩm -->
                <div class="carousel-outer">
                    <button type="button" class="carousel-nav-btn prev" onclick="scrollTrack('dealCarouselTrack', -660)">
                        <i class="bi bi-chevron-left"></i>
                    </button>

                    <div class="cards-track" id="dealCarouselTrack">
                        <c:forEach var="p" items="${products}" varStatus="st">
                            <c:set var="origPrice" value="${p.price + (p.savingsAmount > 0 ? p.savingsAmount : p.price * 0.15)}" />
                            <c:set var="discPct" value="${((origPrice - p.price) * 100) / origPrice}" />

                            <article class="retail-card deal-slide-card"
                                     data-id="${p.deviceId}"
                                     data-model="${p.modelName}"
                                     data-capacity="${p.capacityValue}"
                                     data-tier="${p.qualityTier}"
                                     data-battery="${p.batteryHealth}"
                                     data-score="${p.overallScore}"
                                     data-price="${p.price}"
                                     data-savings="${p.savingsAmount}"
                                     data-orig="${p.allOriginalParts ? '1' : '0'}">

                                <div class="discount-ribbon">
                                    Giảm <fmt:formatNumber value="${discPct}" maxFractionDigits="0"/>%
                                </div>

                                <a href="DetailServlet?id=${p.deviceId}" class="card-visual-stage">
                                    <div class="card-img-wrap">
                                        <img src="${p.coverImage}" alt="${p.modelName}" onerror="this.src='image/ip16pm.jpg'">
                                    </div>
                                    <div class="card-side-specs">
                                        <div class="side-spec-item">
                                            <span class="side-spec-icon"><i class="bi bi-battery-full text-success"></i></span>
                                            <span class="side-spec-label">Pin ${p.batteryHealth}%</span>
                                        </div>
                                        <div class="side-spec-item">
                                            <span class="side-spec-icon"><i class="bi bi-patch-check text-primary"></i></span>
                                            <span class="side-spec-label">${p.qualityTier == 'GRADE_A' ? 'Grade A' : (p.qualityTier == 'GRADE_B' ? 'Grade B' : 'Grade C')}</span>
                                        </div>
                                        <div class="side-spec-item">
                                            <span class="side-spec-icon"><i class="bi bi-cpu text-danger"></i></span>
                                            <span class="side-spec-label">${p.allOriginalParts ? 'Zin 100%' : 'Chính hãng'}</span>
                                        </div>
                                    </div>
                                </a>

                                <div>
                                    <div class="for-you-tag">
                                        <i class="bi bi-stars"></i> Đạt chuẩn QC Lab
                                    </div>

                                    <a href="DetailServlet?id=${p.deviceId}" class="card-title-link">
                                        ${p.modelName} ${p.capacityValue} (${p.colorName}) - ${p.originCountry}
                                    </a>

                                    <div class="price-row">
                                        <span class="price-sale"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</span>
                                        <span class="price-orig"><fmt:formatNumber value="${origPrice}" pattern="#,###"/>đ</span>
                                    </div>

                                    <div class="promo-strip ${st.index % 3 == 2 ? 'student-purple' : ''}">
                                        <c:choose>
                                            <c:when test="${st.index % 3 == 2}">
                                                S-Student giảm thêm 500.000đ • BH ${p.warrantyMonths}T
                                            </c:when>
                                            <c:otherwise>
                                                Điểm QC ${p.overallScore}/10 • ${p.cosmeticCondition}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="card-footer-bar">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fast-ship-badge"><i class="bi bi-truck"></i> 2 Giờ</span>
                                            <span class="rating-badge"><i class="bi bi-star-fill text-warning"></i> 5</span>
                                        </div>
                                        <a href="WishlistServlet?action=add&deviceId=${p.deviceId}" class="icon-heart-link" title="Thêm vào yêu thích">
                                            <i class="bi bi-heart"></i>
                                        </a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <button type="button" class="carousel-nav-btn next" onclick="scrollTrack('dealCarouselTrack', 660)">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>

                <div id="dealEmptyHint" class="text-center py-3 d-none">
                    <span class="small fw-semibold text-secondary me-2">Không có máy khớp bộ lọc nhanh này</span>
                    <button type="button" class="btn btn-primary btn-sm rounded-pill px-3" onclick="resetShowcaseFilters()">Đặt lại</button>
                </div>
            </div>

            <!-- BANNER ƯU ĐÃI S-STUDENT & THU CŨ LÊN ĐỜI -->
            <div class="student-banner my-4">
                <div class="student-banner-title">
                    <span class="badge bg-danger rounded-3 px-2 py-1 fs-6">QC</span>
                    <span style="color:#0d9488;">Say Hi!</span>
                    <span style="color:#dc2626;">S-STUDENT & THU CŨ LÊN ĐỜI</span>
                </div>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <div class="tradein-pill-red">
                        <span>Trợ giá lên đời đến</span>
                        <span class="fs-5 fw-bold">5 Triệu</span>
                    </div>
                    <button type="button" class="btn btn-outline-success fw-bold rounded-pill px-3 btn-sm"
                            data-bs-toggle="modal" data-bs-target="#promoStudentModal">
                        XEM CHI TIẾT
                    </button>
                </div>
            </div>

            <!-- KHỐI GỢI Ý CHO BẠN NỀN GRADIENT PASTEL -->
            <div class="suggest-box">
                <div class="suggest-notch-wrap">
                    <div class="suggest-notch-header">
                        <i class="bi bi-stars text-warning"></i> GỢI Ý CHO BẠN
                    </div>
                </div>

                <div class="carousel-outer">
                    <button type="button" class="carousel-nav-btn prev" onclick="scrollTrack('suggestCarouselTrack', -660)">
                        <i class="bi bi-chevron-left"></i>
                    </button>

                    <div class="cards-track" id="suggestCarouselTrack">
                        <c:forEach var="p" items="${products}">
                            <c:set var="origPrice" value="${p.price + (p.savingsAmount > 0 ? p.savingsAmount : p.price * 0.15)}" />
                            <c:set var="discPct" value="${((origPrice - p.price) * 100) / origPrice}" />

                            <article class="retail-card">
                                <div class="discount-ribbon">
                                    Giảm <fmt:formatNumber value="${discPct}" maxFractionDigits="0"/>%
                                </div>

                                <a href="DetailServlet?id=${p.deviceId}" class="card-visual-stage">
                                    <div class="card-img-wrap">
                                        <img src="${p.coverImage}" alt="${p.modelName}" onerror="this.src='image/ip16pm.jpg'">
                                    </div>
                                    <div class="card-side-specs">
                                        <div class="side-spec-item">
                                            <span class="side-spec-icon"><i class="bi bi-shield-check text-primary"></i></span>
                                            <span class="side-spec-label">${p.overallScore}/10</span>
                                        </div>
                                        <div class="side-spec-item">
                                            <span class="side-spec-icon"><i class="bi bi-battery-charging text-success"></i></span>
                                            <span class="side-spec-label">${p.batteryHealth}%</span>
                                        </div>
                                    </div>
                                </a>

                                <div>
                                    <a href="DetailServlet?id=${p.deviceId}" class="card-title-link">
                                        ${p.modelName} ${p.capacityValue} (${p.colorName}) Chuẩn Lab
                                    </a>

                                    <div class="price-row">
                                        <span class="price-sale"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</span>
                                        <span class="price-orig"><fmt:formatNumber value="${origPrice}" pattern="#,###"/>đ</span>
                                    </div>

                                    <div class="card-footer-bar mt-2">
                                        <span class="fast-ship-badge"><i class="bi bi-truck"></i> 2 Giờ</span>
                                        <a href="WishlistServlet?action=add&deviceId=${p.deviceId}" class="icon-heart-link" title="Thêm vào yêu thích">
                                            <i class="bi bi-heart"></i>
                                        </a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>

                    <button type="button" class="carousel-nav-btn next" onclick="scrollTrack('suggestCarouselTrack', 660)">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
            </div>
        </section>
    </c:if>

    <!-- 4. DANH SÁCH SẢN PHẨM ĐẦY ĐỦ (THANH SẮP XẾP GỌN GÀNG) -->
    <main class="container my-4" id="catalog">

        <!-- Thanh sắp xếp & mở nhanh bộ lọc Danh mục -->
        <div class="compact-sort-bar mb-4 d-flex flex-wrap align-items-center justify-content-between gap-2">
            <div class="d-flex flex-wrap align-items-center gap-2">
                <button type="button" class="filter-pill-btn ${hasAnyFilter ? 'active' : ''}" onclick="toggleCategoryDropdown()">
                    <i class="bi bi-funnel-fill text-danger"></i> Bộ lọc Danh mục
                </button>
                <span class="small fw-bold text-dark ms-1">Sắp xếp:</span>
                <a href="home?keyword=${param.keyword}&qualityTier=${param.qualityTier}&capacity=${param.capacity}" class="filter-pill-btn ${empty param.sort ? 'active' : ''}">
                    <i class="bi bi-stars"></i> Mới cập nhật
                </a>
                <a href="home?keyword=${param.keyword}&qualityTier=${param.qualityTier}&capacity=${param.capacity}&sort=price_asc" class="filter-pill-btn ${param.sort == 'price_asc' ? 'active' : ''}">
                    <i class="bi bi-sort-numeric-down"></i> Giá Thấp - Cao
                </a>
                <a href="home?keyword=${param.keyword}&qualityTier=${param.qualityTier}&capacity=${param.capacity}&sort=price_desc" class="filter-pill-btn ${param.sort == 'price_desc' ? 'active' : ''}">
                    <i class="bi bi-sort-numeric-up-alt"></i> Giá Cao - Thấp
                </a>
                <a href="home?keyword=${param.keyword}&qualityTier=${param.qualityTier}&capacity=${param.capacity}&sort=score_desc" class="filter-pill-btn ${param.sort == 'score_desc' ? 'active' : ''}">
                    <i class="bi bi-award"></i> Điểm QC Cao Nhất
                </a>
                <c:if test="${hasAnyFilter}">
                    <a href="home" class="filter-pill-btn text-danger border-danger-subtle">
                        <i class="bi bi-x-circle"></i> Xóa lọc
                    </a>
                </c:if>
            </div>
            <span class="small text-muted">Hiển thị <strong class="text-dark">${products.size()}</strong> thiết bị sẵn kho</span>
        </div>

        <!-- 5. DANH SÁCH SẢN PHẨM + SO SÁNH -->
        <form action="CompareServlet" method="get">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-danger rounded-pill px-2 py-1">LAB VERIFIED</span>
                    <h5 class="fw-bold mb-0">iPhone đã qua kiểm định QC</h5>
                </div>
                <button type="submit" class="btn btn-dark btn-sm rounded-pill px-4 fw-semibold">
                    <i class="bi bi-arrow-left-right me-1"></i>So sánh các máy đã chọn
                </button>
            </div>

            <c:if test="${empty products}">
                <div class="bento-card p-5 text-center">
                    <i class="bi bi-inbox fs-1 text-muted"></i>
                    <h5 class="mt-3 fw-bold">Không tìm thấy thiết bị phù hợp với bộ lọc</h5>
                    <p class="text-muted small">Bạn có thể đặt lại bộ lọc hoặc đăng ký nhận thông báo khi máy về kho.</p>
                    <div class="d-flex justify-content-center gap-2">
                        <a href="home" class="btn btn-outline-secondary rounded-pill px-4">Xem tất cả máy</a>
                        <a href="WishlistServlet#notify" class="btn btn-cps-primary px-4">Đăng ký nhận tin có hàng</a>
                    </div>
                </div>
            </c:if>

            <div class="row g-3 g-md-4">
                <c:forEach var="p" items="${products}">
                    <div class="col-md-6 col-lg-4">
                        <div class="product-card-cps h-100 d-flex flex-column">

                            <!-- Khu vực ảnh nền trắng liền mạch -->
                            <div class="stage-white">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="qc-badge-pill font-mono ${p.qualityTier == 'GRADE_A' ? 'qc-A' : (p.qualityTier == 'GRADE_B' ? 'qc-B' : 'qc-C')}">
                                        <i class="bi bi-patch-check-fill"></i>${p.qualityTier} • ${p.overallScore}/10
                                    </span>

                                    <label class="form-check m-0 d-flex align-items-center gap-1 small text-secondary fw-semibold" style="cursor:pointer;" for="cmp_${p.deviceId}">
                                        <input class="form-check-input m-0" type="checkbox" name="ids" value="${p.deviceId}" id="cmp_${p.deviceId}">
                                        <span>So sánh</span>
                                    </label>
                                </div>

                                <div class="img-holder-clean">
                                    <img src="${p.coverImage}" alt="${p.modelName}" onerror="this.src='image/ip16pm.jpg'">
                                    <span class="origin-chip font-mono">${p.originCountry}</span>
                                </div>
                            </div>

                            <!-- Thông tin chi tiết -->
                            <div class="p-3 p-xl-4 pt-2 d-flex flex-column flex-grow-1">
                                <div class="d-flex justify-content-between align-items-center gap-2 mb-1">
                                    <h6 class="fw-bold mb-0 text-truncate" style="font-size: 1.02rem;" title="${p.modelName} ${p.capacityValue}">
                                        ${p.modelName} ${p.capacityValue}
                                    </h6>
                                    <span class="badge bg-light text-secondary border fw-medium text-nowrap">${p.colorName}</span>
                                </div>

                                <div class="d-flex flex-wrap align-items-baseline gap-2 mb-3">
                                    <span class="price-cps">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                                    </span>
                                    <c:if test="${p.savingsAmount > 0}">
                                        <span class="save-cps">
                                            Tiết kiệm <fmt:formatNumber value="${p.savingsAmount}" pattern="#,###"/> đ
                                        </span>
                                    </c:if>
                                </div>

                                <!-- Bảng thông số kỹ thuật 2x2 -->
                                <div class="spec-grid-2x2 mb-3">
                                    <div class="spec-cell">
                                        <span class="spec-lbl"><i class="bi bi-battery-charging text-success me-1"></i>Pin (${p.chargeCycles} sạc)</span>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="spec-val font-mono">${p.batteryHealth}%</span>
                                            <div class="progress flex-grow-1" style="height: 4px;">
                                                <div class="progress-bar ${p.batteryHealth >= 90 ? 'bg-success' : 'bg-warning'}" style="width: ${p.batteryHealth}%"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="spec-cell">
                                        <span class="spec-lbl"><i class="bi bi-motherboard text-primary me-1"></i>Linh kiện</span>
                                        <span class="spec-val ${p.allOriginalParts ? 'text-success' : 'text-warning'}">
                                            ${p.allOriginalParts ? 'Zin 100%' : 'Thay chính hãng'}
                                        </span>
                                    </div>

                                    <div class="spec-cell">
                                        <span class="spec-lbl"><i class="bi bi-shield-check text-info me-1"></i>Ngoại hình & BH</span>
                                        <span class="spec-val text-truncate d-block" title="${p.cosmeticCondition} • BH ${p.warrantyMonths} tháng">
                                            ${p.cosmeticCondition} • ${p.warrantyMonths}T
                                        </span>
                                    </div>

                                    <div class="spec-cell">
                                        <span class="spec-lbl"><i class="bi bi-upc-scan text-dark me-1"></i>Mã IMEI</span>
                                        <span class="spec-val font-mono text-truncate d-block" title="${p.imei}">
                                            ${p.imei}
                                        </span>
                                    </div>
                                </div>

                                <!-- Nút hành động -->
                                <div class="mt-auto d-flex gap-2">
                                    <a href="DetailServlet?id=${p.deviceId}" class="btn btn-cps-primary flex-grow-1 text-center">
                                        <i class="bi bi-file-earmark-medical me-1"></i>Xem hồ sơ QC
                                    </a>
                                    <a href="WishlistServlet?action=add&deviceId=${p.deviceId}" class="btn-cps-fav" title="Thêm vào yêu thích">
                                        <i class="bi bi-heart-fill"></i>
                                    </a>
                                </div>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </form>
    </main>

    <!-- CỤM NÚT NỔI GÓC DƯỚI PHẢI: LÊN ĐẦU & LIÊN HỆ -->
    <div class="floating-dock">
        <button type="button" class="btn-back-top" onclick="window.scrollTo({top: 0, behavior: 'smooth'})">
            <span>Lên đầu</span> <i class="bi bi-chevron-double-up"></i>
        </button>
        <a href="SupportServlet" class="btn-float-contact">
            <span>Liên hệ</span> <i class="bi bi-headset"></i>
        </a>
    </div>

    <!-- MODAL CHI TIẾT ƯU ĐÃI S-STUDENT & THU CŨ LÊN ĐỜI -->
    <div class="modal fade" id="promoStudentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-danger text-white rounded-top-4">
                    <h6 class="modal-title fw-bold"><i class="bi bi-gift-fill me-2"></i>Đặc Quyền S-Student & Thu Cũ Lên Đời</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 small">
                    <div class="p-3 rounded-3 bg-light border mb-3">
                        <div class="fw-bold text-danger mb-1">1. Giảm thêm 500.000đ cho Học sinh - Sinh viên</div>
                        <div class="text-muted">Áp dụng trực tiếp khi xuất trình thẻ sinh viên hoặc email edu.vn tại quầy kiểm định iPhoneQCStore.</div>
                    </div>
                    <div class="p-3 rounded-3 bg-light border">
                        <div class="fw-bold text-primary mb-1">2. Thu cũ đổi mới trợ giá lên đến 5.000.000đ</div>
                        <div class="text-muted">Định giá minh bạch theo 32 bước QC Lab, thu máy cũ kể cả máy trầy xước hoặc pin dưới 80%.</div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4">
                    <a href="SupportServlet" class="btn btn-danger rounded-pill px-4 w-100 fw-bold">Đăng ký định giá thu cũ ngay</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 6. FOOTER HỆ THỐNG -->
    <footer class="site-footer">
        <div class="container">
            <div class="row g-4 pb-4 border-bottom">
                <div class="col-lg-4">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <i class="bi bi-apple fs-4 text-danger"></i>
                        <span class="fw-bold fs-5 text-dark">iPhoneQCStore</span>
                        <span class="badge bg-danger font-mono">LAB</span>
                    </div>
                    <p class="text-muted small mb-2">
                        Hệ thống phân phối iPhone qua sử dụng đạt chuẩn kiểm định 32 bước phần cứng, minh bạch lịch sử linh kiện và bảo hành điện tử theo từng mã IMEI.
                    </p>
                    <div class="font-mono small text-dark">
                        <i class="bi bi-headset text-danger me-1"></i>Hotline Lab: 1900 6868 (8:00 - 21:30)
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="fw-bold text-dark mb-2">Tiện ích tra cứu</div>
                    <a href="LookupServlet" class="footer-link">Xác minh Chứng nhận kiểm định QC</a>
                    <a href="LookupServlet" class="footer-link">Tra cứu Bảo hành điện tử theo IMEI</a>
                    <a href="CompareServlet" class="footer-link">So sánh điểm QC & giá bán</a>
                    <a href="WishlistServlet#notify" class="footer-link">Đăng ký thông báo có hàng</a>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="fw-bold text-dark mb-2">Tài khoản & Dịch vụ</div>
                    <a href="AuthServlet" class="footer-link">Đăng nhập / Đăng ký thành viên</a>
                    <a href="SupportServlet" class="footer-link">Gửi yêu cầu hỗ trợ & Khiếu nại</a>
                    <a href="home?qualityTier=GRADE_A" class="footer-link">Tiêu chuẩn phân hạng Grade A / B / C</a>
                </div>
                <div class="col-lg-2">
                    <div class="fw-bold text-dark mb-2">Cam kết Lab</div>
                    <div class="small text-muted">
- 100% IMEI sạch, không iCloud<br>
- Hoàn tiền 100% nếu sai cam kết linh kiện<br>
- Lỗi 1 đổi 1 tới 12 tháng
                    </div>
                </div>
            </div>
            <div class="pt-3 d-flex flex-wrap justify-content-between align-items-center small text-muted">
                <span>© 2026 iPhoneQCStore Lab. All rights reserved.</span>
                <span class="font-mono">Quality Control & Device Lifecycle Platform</span>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /* ===== ĐÓNG / MỞ BẢNG DANH MỤC (BỘ LỌC) & TÌM KIẾM TRÊN HEADER ===== */
        function toggleCategoryDropdown() {
            const catPanel = document.getElementById('categoryDropdownPanel');
            const searchPanel = document.getElementById('searchDropdownPanel');
            const backdrop = document.getElementById('searchBackdrop');
            const btn = document.getElementById('btnCategoryToggle');

            const willOpen = !catPanel.classList.contains('show');
            if (searchPanel) searchPanel.classList.remove('show');

            if (willOpen) {
                catPanel.classList.add('show');
                backdrop.classList.add('show');
                if (btn) btn.classList.add('active');
            } else {
                catPanel.classList.remove('show');
                backdrop.classList.remove('show');
            }
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

        const cpsCarousel = document.getElementById('cpsMainCarousel');
        if (cpsCarousel) {
            cpsCarousel.addEventListener('slid.bs.carousel', function (event) {
                const tabs = document.querySelectorAll('#sliderTabs .slider-tab-btn');
                tabs.forEach((btn, idx) => {
                    btn.classList.toggle('active', idx === event.to);
                });
            });
        }

        /* ===== TƯƠNG TÁC KHỐI DEAL SỐC / HOT TREND / HÀNG MỚI VỀ ===== */
        let activeSeriesFilter = 'ALL';
        let activeSpecFilter = null;

        function scrollTrack(trackId, offset) {
            const el = document.getElementById(trackId);
            if (el) el.scrollBy({ left: offset, behavior: 'smooth' });
        }

        function switchShowcaseTab(tabEl, mode) {
            document.querySelectorAll('.folder-tab').forEach(t => t.classList.remove('active'));
            tabEl.classList.add('active');

            const track = document.getElementById('dealCarouselTrack');
            if (!track) return;
            const cards = Array.from(track.querySelectorAll('.deal-slide-card'));

            cards.sort((a, b) => {
                if (mode === 'deal') {
                    return parseFloat(b.dataset.savings || 0) - parseFloat(a.dataset.savings || 0);
                } else if (mode === 'hot') {
                    return parseFloat(b.dataset.score || 0) - parseFloat(a.dataset.score || 0);
                } else {
                    return parseInt(b.dataset.id || 0) - parseInt(a.dataset.id || 0);
                }
            });

            cards.forEach(c => track.appendChild(c));
            track.scrollTo({ left: 0, behavior: 'smooth' });
        }

        function selectSeriesPill(pillEl) {
            document.querySelectorAll('.series-pill').forEach(p => p.classList.remove('active'));
            pillEl.classList.add('active');
            activeSeriesFilter = pillEl.dataset.series;
            filterShowcaseCards();
        }

        function toggleSpecChip(chipEl) {
            const spec = chipEl.dataset.spec;
            if (activeSpecFilter === spec) {
                chipEl.classList.remove('active');
                activeSpecFilter = null;
            } else {
                document.querySelectorAll('.subchip-item').forEach(c => c.classList.remove('active'));
                chipEl.classList.add('active');
                activeSpecFilter = spec;
            }
            filterShowcaseCards();
        }

        function filterShowcaseCards() {
            const cards = document.querySelectorAll('#dealCarouselTrack .deal-slide-card');
            let count = 0;

            cards.forEach(card => {
                const model = (card.dataset.model || '').toLowerCase();
                const cap = (card.dataset.capacity || '').toUpperCase();
                const tier = card.dataset.tier || '';
                const bat = parseInt(card.dataset.battery || '0');
                const score = parseFloat(card.dataset.score || '0');
                const price = parseFloat(card.dataset.price || '0');
                const orig = card.dataset.orig === '1';

                let okSeries = true;
                if (activeSeriesFilter === 'GRADE_A') {
                    okSeries = (tier === 'GRADE_A');
                } else if (activeSeriesFilter !== 'ALL') {
                    okSeries = model.includes(activeSeriesFilter.toLowerCase());
                }

                let okSpec = true;
                if (activeSpecFilter === 'PIN95') okSpec = bat >= 95;
                if (activeSpecFilter === 'UNDER23') okSpec = price <= 23000000;
                if (activeSpecFilter === 'PROMAX') okSpec = model.includes('pro max');
                if (activeSpecFilter === 'CAP256') okSpec = (cap.includes('256') || cap.includes('512') || cap.includes('1TB'));
                if (activeSpecFilter === 'ZIN100') okSpec = orig;
                if (activeSpecFilter === 'QC95') okSpec = score >= 9.5;

                if (okSeries && okSpec) {
                    card.classList.remove('d-none');
                    count++;
                } else {
                    card.classList.add('d-none');
                }
            });

            const emptyHint = document.getElementById('dealEmptyHint');
            if (emptyHint) emptyHint.classList.toggle('d-none', count > 0);
        }

        function resetShowcaseFilters() {
            activeSeriesFilter = 'ALL';
            activeSpecFilter = null;
            document.querySelectorAll('.series-pill').forEach((p, idx) => p.classList.toggle('active', idx === 0));
            document.querySelectorAll('.subchip-item').forEach(c => c.classList.remove('active'));
            filterShowcaseCards();
        }
    </script>
</body>
</html>