package Controller;

import Model.ConnectSQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.UUID;

@WebServlet(name = "AuthServlet", urlPatterns = {"/AuthServlet"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Integer userId = (Integer) session.getAttribute("userId");
                String role = (String) session.getAttribute("role");
                if (userId != null && role != null && !"CUSTOMER".equalsIgnoreCase(role)) {
                    logStaffAudit(userId, "LOGOUT", "users", userId, "Đăng xuất khỏi hệ thống", request.getRemoteAddr());
                }
                session.invalidate();
            }
            response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("verify".equals(action)) {
            handleVerifyAccount(request, response);
        } else if ("recover".equals(action)) {
            handleRecoverPassword(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identity = request.getParameter("identity");
        String password = request.getParameter("password");

        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone_number, u.status, "
                   + "COALESCE(r.role_code, 'CUSTOMER') AS role_code "
                   + "FROM [users] u "
                   + "LEFT JOIN [user_roles] ur ON u.user_id = ur.user_id "
                   + "LEFT JOIN [roles] r ON ur.role_id = r.role_id "
                   + "WHERE (u.email = ? OR u.phone_number = ?) AND u.password_hash = ?";

        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identity != null ? identity.trim() : "");
            ps.setString(2, identity != null ? identity.trim() : "");
            ps.setString(3, password != null ? password.trim() : "");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    if (!"ACTIVE".equalsIgnoreCase(status)) {
                        request.setAttribute("error", "Tài khoản đang ở trạng thái " + status + ". Vui lòng liên hệ quản trị viên!");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    int userId = rs.getInt("user_id");
                    String role = rs.getString("role_code");

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    session.setAttribute("fullName", rs.getString("full_name"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("phone", rs.getString("phone_number"));
                    session.setAttribute("role", role);

                    if (!"CUSTOMER".equalsIgnoreCase(role)) {
                        logStaffAudit(userId, "LOGIN", "users", userId, "Đăng nhập vai trò " + role, request.getRemoteAddr());
                    }

                    response.sendRedirect("home");
                    return;
                }
            }
            request.setAttribute("error", "Sai Email/Số điện thoại hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi kết nối CSDL: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String password = request.getParameter("password").trim();
        String roleCode = request.getParameter("roleCode");
        if (roleCode == null || roleCode.trim().isEmpty()) {
            roleCode = "CUSTOMER";
        }

        String checkSql = "SELECT 1 FROM [users] WHERE [email] = ? OR [phone_number] = ?";
        String insertSql = "INSERT INTO [users] ([email], [phone_number], [password_hash], [full_name], [status]) VALUES (?, ?, ?, ?, 'ACTIVE')";
        String otpSql = "INSERT INTO [user_verifications] ([user_id], [type], [code], [expires_at], [is_verified]) "
                      + "VALUES (?, 'EMAIL', ?, DATEADD(MINUTE, 15, GETDATE()), 1)";

        try (Connection conn = new ConnectSQL().getConnection()) {
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, email);
                checkPs.setString(2, phone);
                if (checkPs.executeQuery().next()) {
                    request.setAttribute("error", "Email hoặc số điện thoại này đã được đăng ký!");
                    request.setAttribute("activeTab", "register");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }

            int newUserId = 0;
            try (PreparedStatement insPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insPs.setString(1, email);
                insPs.setString(2, phone);
                insPs.setString(3, password);
                insPs.setString(4, fullName);
                insPs.executeUpdate();
                try (ResultSet keys = insPs.getGeneratedKeys()) {
                    if (keys.next()) {
                        newUserId = keys.getInt(1);
                    }
                }
            }

            // Tự động tạo vai trò nếu chưa có trong bảng roles và gán quyền cho tài khoản quản lý/nhân viên
            if (newUserId > 0 && !"CUSTOMER".equalsIgnoreCase(roleCode)) {
                String ensureRoleSql = "IF NOT EXISTS (SELECT 1 FROM [roles] WHERE [role_code] = ?) "
                                     + "INSERT INTO [roles] ([role_code], [role_name]) VALUES (?, ?)";
                try (PreparedStatement rPs = conn.prepareStatement(ensureRoleSql)) {
                    rPs.setString(1, roleCode);
                    rPs.setString(2, roleCode);
                    rPs.setString(3, "Vai trò " + roleCode);
                    rPs.executeUpdate();
                }

                String assignSql = "INSERT INTO [user_roles] ([user_id], [role_id]) "
                                 + "SELECT ?, [role_id] FROM [roles] WHERE [role_code] = ?";
                try (PreparedStatement aPs = conn.prepareStatement(assignSql)) {
                    aPs.setInt(1, newUserId);
                    aPs.setString(2, roleCode);
                    aPs.executeUpdate();
                }
            }

            String otp = String.valueOf((int) (Math.random() * 900000) + 100000);
            if (newUserId > 0) {
                try (PreparedStatement otpPs = conn.prepareStatement(otpSql)) {
                    otpPs.setInt(1, newUserId);
                    otpPs.setString(2, otp);
                    otpPs.executeUpdate();
                }
            }

            request.setAttribute("success", "Tạo tài khoản <strong>" + fullName + "</strong> (" + roleCode + ") thành công! Bạn có thể đăng nhập ngay.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi đăng ký tài khoản: " + e.getMessage());
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void handleVerifyAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identity = request.getParameter("identity");
        String otpInput = request.getParameter("otp");

        String sql = "UPDATE uv SET uv.is_verified = 1 "
                   + "FROM [user_verifications] uv "
                   + "JOIN [users] u ON uv.user_id = u.user_id "
                   + "WHERE (u.email = ? OR u.phone_number = ?) AND uv.code = ? AND uv.expires_at >= GETDATE()";

        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identity);
            ps.setString(2, identity);
            ps.setString(3, otpInput);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                request.setAttribute("success", "Xác thực OTP thành công! Bạn có thể đăng nhập ngay.");
            } else {
                request.setAttribute("error", "Mã OTP không hợp lệ hoặc đã hết hạn!");
                request.setAttribute("activeTab", "verify");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xác thực: " + e.getMessage());
            request.setAttribute("activeTab", "verify");
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private void handleRecoverPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identity = request.getParameter("identity");
        String newPass = "QC@" + UUID.randomUUID().toString().substring(0, 6);

        String sql = "UPDATE [users] SET [password_hash] = ?, [updated_at] = GETDATE() WHERE [email] = ? OR [phone_number] = ?";
        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPass);
            ps.setString(2, identity);
            ps.setString(3, identity);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                request.setAttribute("success", "Mật khẩu tạm thời mới của bạn là: <strong>" + newPass + "</strong>. Hãy đăng nhập ngay!");
            } else {
                request.setAttribute("error", "Không tìm thấy tài khoản khớp với Email/SĐT đã nhập.");
                request.setAttribute("activeTab", "recover");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khôi phục mật khẩu: " + e.getMessage());
            request.setAttribute("activeTab", "recover");
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    public static void logStaffAudit(int staffId, String action, String targetTable, int targetId, String description, String ip) {
        String sql = "INSERT INTO [staff_audit_logs] ([staff_id], [action], [target_table], [target_id], [description], [ip_address]) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new ConnectSQL().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setString(2, action);
            ps.setString(3, targetTable);
            ps.setInt(4, targetId);
            ps.setString(5, description);
            ps.setString(6, ip);
            ps.executeUpdate();
        } catch (Exception ignored) {
        }
    }
}